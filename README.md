# fwCustomDeidentification

Script to generate a custom profile for de-identification of data by the Flywheel CLI.
The profiles here are designed for uploading data to the UPenn Flywheel only,
and to provide a record of previously used profiles on legacy data. The data
should be kept confidential and accessible only by approved personnel.

Note that **private tags** are **NOT** modified by these profiles. Data from new
sources, whether inside or outside of Penn, should be checked carefully for
identifiers in private tags. Flywheel can [de-identify private
tags](https://docs.flywheel.io/hc/en-us/articles/360024577194-How-to-de-identify-private-DICOM-tags)
but requires extra steps to do so.

The profiles here are **NOT** suitable for any kind of public data sharing.

## Example usage

The CLI user interface has changed and the command `fw import dicom` is now
deprecated. The profile has to be incorporated into a **config** file for use
with the new command `fw ingest dicom`. A config file containing the BSC de-id
fields is in `profiles/PennBrainScienceCenter/`. An example call:

```
fw ingest dicom --jobs 1 \
  --subject subjectLabel --session sessionLabel \
  --config ingest-config-de-id_upenn_Penn_BSC_profile_v3.0_20201111A.yaml \
  /path/to/dicomDir AGroup AProject
```

Unfortunately, `fw ingest dicom` does not have the `--output-folder` command, so
there's no easy way to test de-id settings before uploading data. This will be
addressed in future versions of `fw`, but for now the only solution is to test a
single upload and vet the results. This should be done with dummy data,
de-identified by hand with something like
[DCMTK](https://support.dcmtk.org/docs/index.html).

## Included profiles

Most users should use the official profile at
`profiles/PennBrainScienceCenter/`. This is the same profile used for data
reaped from HUP6. See the README there for some examples on how to test the
output for successful de-identification.

The Penn BSC profile is also included in config file format. Other profiles will
need to be converted to the config format to work with `fw ingest dicom`.


## Custom de-identification profiles

For more background and examples of other capabilities, see [Custom
de-Identification of dicom field through the CLI](https://docs.flywheel.io/hc/en-us/articles/360008972493-Custom-de-Identification-of-dicom-field-through-the-CLI).


## Generating a profile

First define CSV files containing tags to remove or replace, following the format shown in
the `profiles/` directory. A dictionary of keywords is included under the `dicom/`
directory. There's also an example there showing how to access the dictionary in
`pydicom`.

When you have the tags you want to process, run
`config/generateDeidConfig.pl`.

Always test the profile first before sending data to Flywheel.


## Further reading on de-identification

[DICOM standard de-identification
profiles](http://dicom.nema.org/medical/dicom/current/output/html/part15.html#chapter_E). Description of official de-identification profiles.

[Free DICOM de-identification tools in clinical research: functioning and safety of
patient privacy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4636522/). Testing some
popular DICOM tools, and showing the difficulty in successfully de-identifying DICOM data.

[De-identification of Medical Images with Retention of Scientific Research
Value](https://pubs.rsna.org/doi/full/10.1148/rg.2015140244). From the Cancer Imaging
Archive team. "It is extremely difficult to eradicate all PHI from DICOM images with
automated software while at the same time retaining all useful information." A more
detailed discussion of their de-identification routines can be found on the [Cancer Imaging
Archive Wiki](https://wiki.cancerimagingarchive.net/display/Public/Submission+and+De-identification+Overview).


