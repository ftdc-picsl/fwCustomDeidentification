#!/usr/bin/perl -w
#

use strict;

# Nicer implementation than File::Path
use Cwd 'abs_path';
use FindBin qw($Bin);
use File::Path;
use File::Spec;
use File::Basename;
use Getopt::Long;
use Text::CSV;

my $usage = qq{

  $0 
    --output-config-dir
    --output-log-dir
    --output-project-name
    [options]

    Takes as input CSV files containing DICOM fields to be removed, replaced, or hashed. 
    Only UIDs can be hashed.
    
    See the options below for details of the required CSV format.

    Flywheel uses DICOM keywords, rather than numeric tags. But we include the numeric tags
    for reference.


  Required args:
    
   --output-config-dir
     Directory to place output config files. The main output is config.yaml, which is passed to fw
     to do the de-identification. 

   --output-log-dir
     A directory in which to place the de-identification log. If this directory does not exist, it is created 
     with permissions only for the user who is running this script. 
 
     The log file is written by the fw tool and will show the state of each field before and after processing.
 
     The log file will contain PHI. CONTAIN PHI. *** CONTAIN PHI ***. 

   --output-project-name
     Used to name output files within the respective directories


  Options:

   --hash-uid-list
     UID fields to be hashed, in a CSV file. This uses a special hashing function that preserves 
     the prefix and suffix of the UID. The CSV file should be in the format

       Tag,Keyword
       (0000,0000),TagKeyword
    
   --remove-list
     List of tags to remove, in a CSV file. The CSV file should be in the format

       Tag,Keyword
       (0000,0000),TagKeyword

   --replace-list
     List of tags to replace with a constant string, in a CSV file. The CSV file should be in the format

       Tag,Keyword,Replacement
       (0000,0000),TagKeyword,"This field replaced by my string"
    
 
  Output:

    Config files and a directory to place the de-identification log. Unless the data is already 
    de-identified, the log will CONTAIN PHI.


  Dependencies:

   Requires the Perl Text::CSV module.

};


if ($#ARGV < 0) {
    print $usage;
    exit 1;
}

my $hashUIDCSV = "";
my $removeCSV = "";
my $replaceCSV = "";

my ($outputConfigDir, $outputLogDir, $outputProjectName);


GetOptions ("hash-uid-list=s" => \$hashUIDCSV,
	    "remove-list=s" => \$removeCSV,
            "replace-list=s" => \$replaceCSV,  
	    "output-config-dir=s" => \$outputConfigDir,
            "output-log-dir=s" => \$outputLogDir,
            "output-project-name=s" => \$outputProjectName
    )
    or die("Error in command line arguments\n");


# Hard code some defaults

my $configPreamble = qq{#
# Start with the empty profile
profile: none

# Log de-identification actions that were taken (before/after values)
deid-log: ${outputLogDir}/${outputProjectName}DeIdLog.csv

# Configuration for dicom de-identification
dicom:

  # Set patient age from date of birth
  patient-age-from-birthdate: true

  # Set patient age units as Years
  patient-age-units: Y

  # Entries under here are generated from a script
  fields:

};

# Make output directories
if (! -d $outputLogDir ) {
    mkpath($outputLogDir, { verbose => 0, mode => 0700 }) or die("Cannot create output directory $outputLogDir");
}

if (! -d $outputConfigDir ) {
    mkpath($outputConfigDir, { verbose => 0 }) or die("Cannot create output directory $outputConfigDir");
}

my $configFile = "${outputConfigDir}/${outputProjectName}DeIdConfig.yaml";

open(my $configFH, ">", "$configFile");

print $configFH $configPreamble;

my $indentNumber = 4;

my $indentWS = join("", " " x $indentNumber);

if (-f $hashUIDCSV) {
    my $hashRef = getHashUIDTags($hashUIDCSV);
        
    # tag => keyword
    my %hashUIDs = %$hashRef;

    foreach my $tag ( sort(keys(%hashUIDs)) ) {
        my $keyword = $hashUIDs{$tag};

        # Add a comment
        print $configFH $indentWS . "# $tag \n";
        print $configFH $indentWS . "- name: ${keyword}\n";
        print $configFH $indentWS . "  hashuid: true\n";
    }
}

print $configFH "\n";

if (-f $removeCSV) {
    my $hashRef = getRemoveTags($removeCSV);
        
    # tag => keyword
    my %removeTags = %$hashRef;

    foreach my $tag ( sort(keys(%removeTags)) ) {
        my $keyword = $removeTags{$tag};

        # Add a comment
        print $configFH $indentWS . "# $tag \n";
        print $configFH $indentWS . "- name: ${keyword}\n";
        print $configFH $indentWS . "  remove: true\n";
    }
}

print $configFH "\n";

if (-f $replaceCSV) {

    my $hashRef = getReplaceTags($replaceCSV);

    # tag => (keyword, replacement)
    my %replaceTags = %$hashRef;
    
    foreach my $tag ( sort(keys(%replaceTags)) ) {
        my ($keyword, $replacementText) = @{$replaceTags{$tag}};

        # Add a comment
        print $configFH $indentWS . "# $tag \n";
        print $configFH $indentWS . "- name: ${keyword}\n";
        print $configFH $indentWS . "  replace-with: ${replacementText}\n";
    }
}

close($configFH);



sub getHashUIDTags {

    my $hashUIDFile = $_[0];

    my $csv = Text::CSV->new({ sep_char => ',' });

    open(my $fh, "<", $hashUIDFile) or die("Could not open '$hashUIDFile' $!\n");

    my %uidsToHash;

    my $header = <$fh>;

    chomp($header);

    if (! $header eq "Tag,Keyword") {
        die("Required column names \"Tag,Keyword\" in $hashUIDFile\n");
    }
    
    while (my $line = <$fh>) {
        chomp $line;
 
        if ($csv->parse($line)) {
 
            my @fields = $csv->fields();

            if (scalar(@fields) != 2) {
                die("Wrong format in file $hashUIDFile\n");
            }

            $uidsToHash{$fields[0]} = $fields[1];
            
        } else {
            die("Line could not be parsed: $line\n");
        }
    }

    close($fh);

    return \%uidsToHash;
}

sub getRemoveTags {

    my $removeFile = $_[0];

    my $csv = Text::CSV->new({ sep_char => ',' });

    open(my $fh, "<", $removeFile) or die("Could not open '$removeFile' $!\n");

    my %tagsToRemove;

    my $header = <$fh>;

    chomp($header);

    if (! $header eq "Tag,Keyword") {
        die("Required column names \"Tag,Keyword\" in $removeFile\n");
    }

    
    while (my $line = <$fh>) {
        chomp $line;
 
        if ($csv->parse($line)) {
 
            my @fields = $csv->fields();

            if (scalar(@fields) != 2) {
                die("Wrong format in file $removeFile\n");
            }

            $tagsToRemove{$fields[0]} = $fields[1];
            
        } else {
            die("Line could not be parsed: $line\n");
        }
    }

    close($fh);

    return \%tagsToRemove;
}

sub getReplaceTags {

    my $replaceFile = $_[0];

    my $csv = Text::CSV->new({ sep_char => ',' });

    open(my $fh, "<", $replaceFile) or die("Could not open '$replaceFile' $!\n");

    my %tagsToReplace;

    my $header = <$fh>;
    
    chomp($header);

    if (! $header eq "Tag,Keyword,Replacement") {
        die("Required column names \"Tag,Keyword\" in $replaceFile\n");
    }

    while (my $line = <$fh>) {
        chomp $line;
 
        if ($csv->parse($line)) {
 
            my @fields = $csv->fields();

            if (scalar(@fields) != 3) {
                die("Wrong format in file $replaceFile\n");
            }

            # Keyword plus the replacement text
            my @keywordReplace = ($fields[1], $fields[2]);

            $tagsToReplace{$fields[0]} = \@keywordReplace;
            
        } else {
            die("Line could not be parsed: $line\n");
        }
    }

    close($fh);

    return \%tagsToReplace;
}
