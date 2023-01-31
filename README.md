# fwCustomDeidentification

Scripts to generate a custom profile for de-identification of data in Flywheel.
The profiles here are designed for uploading data to the UPenn Flywheel only,
and to provide a record of previously used profiles on legacy data. The data
should be kept confidential and accessible only by approved personnel.

Note that **private tags** are **NOT** modified by these profiles. Data from new
sources, whether inside or outside of Penn, should be checked carefully for
identifiers in private tags. Flywheel can [de-identify private
tags](https://docs.flywheel.io/hc/en-us/articles/360024577194-How-to-de-identify-private-DICOM-tags)
but requires extra steps to do so.

The profiles here are **NOT** suitable for any kind of public data sharing.

**Update 2023-01-31**: The CLI user interface has changed, and the site de-identification
profile is applied automatically on import. Attempting to de-identify the data by any
other means will raise an error. Ingest dicom data with the `fw ingest dicom` command,
without `--de-identify` or any profiles in config file.

If you require a different de-identification profile than the site default, please contact
the site admin Gaylord Holder to discuss options.


## Penn site profile

The [site
profile](https://github.com/ftdc-picsl/fwCustomDeidentification/blob/master/profiles/PennBrainScienceCenter/de-id_upenn_Penn_BSC_profile_v3.0_20201111A.yaml)
removes direct identifiers and several indirect identifiers not normally required for
research use. Certain indirect identifiers important for research (such as PatientWeight)
are retained.

Data received from the scanner connectors is automatically de-identified using this
protocol.

Data imported via the web "DICOM Upload" interface also has this profile applied, unless a
project-level profile is present. Contact the admins if you need customized de-identification.


## Generating a profile

First define CSV files containing tags to remove or replace, following the format shown in
the `profiles/` directory. A dictionary of keywords (possibly outdated) is included under
the `dicom/` directory. There's also an example there showing how to access the dictionary
in `pydicom`.

When you have the tags you want to process, run `config/generateDeidConfig.pl`.


## Testing a profile


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


