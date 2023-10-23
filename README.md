# fwCustomDeidentification - archive only

**Update 2023-10-23**: This repository will no longer be updated, please see [the new
repository](https://github.com/brainsciencecenter/flywheel-deidentification).
Customization of the Penn site profile by users is no longer allowed, contact the site
admin if you need this capability.


# Old README contents

## How the de-identification works

The [site
profile](profiles/PennBrainScienceCenter/de-id_upenn_Penn_BSC_profile_v3.0_20201111A.yaml)
removes direct identifiers and several indirect identifiers not normally required for
research use. Certain indirect identifiers important for research (such as PatientWeight)
are retained.

Data received from the scanner connectors is automatically de-identified using this
protocol.

Data imported via the web "DICOM Upload" interface also has this profile applied, unless a
project-level profile is present. Contact the site admin if you need customized
de-identification.

Data ingested via the `fw ingest dicom` command also applies the site profile.

Older versions of the `fw` program allow the use of `fw import dicom`, which require a
profile on the command line. **Do not use `fw import dicom` to import data to Flywheel**. It
will not de-identify data sufficiently without a custom profile.


## Limitations of automated de-identification

The [site
profile](profiles/PennBrainScienceCenter/de-id_upenn_Penn_BSC_profile_v3.0_20201111A.yaml)
removes standard dicom tags that are designed to contain direct identifiers. It also
removes some indirect identifiers that might give clues to the patient's identity or other
sensitive information like menstruation or pregnancy status. However, there are some
limitations to automated de-identification. Investigators must share responsibility for
protecting participant privacy.

Potential compromises of patient information may occur through

* Private DICOM tags. Private tags are **NOT** modified by the site profile. Data from new
  sources, whether inside or outside of Penn, should be checked carefully for
  identifiers in private tags. Flywheel can [de-identify private
  tags](https://docs.flywheel.io/hc/en-us/articles/360024577194-How-to-de-identify-private-DICOM-tags)
  but requires extra steps to do so.

* Identifiers included in text fields such as ImageComments or StudyComments. The
  PatientComments tag is removed by the profile, others are not because they are often
  used to store image information or to route data to the correct location in Flywheel.
  Investigators should ensure that text fields are never used to store identifiers.

* Burned-in annotations. Clinical data may have patient information present in the pixel
  data. This needs special handling.

* Identifiers in non-DICOM imaging data. It is theoretically possible, though rare, for
  identifiers to be present in NIFTI image data. Headers and images for data from any new
  source should be checked manually.


## Further de-identification for data sharing

The site profiles do remove all potential indirect identifiers. Information that
identifies the study date, scanner, or internal study identifiers can remain present in
the header.

Custom secondary de-identification is available through the [deid-export
](https://gitlab.com/flywheel-io/flywheel-apps/deid-export) gear.


## Repository contents

* Scripts to generate a custom profile for de-identification of data in Flywheel.
  The profiles here are designed for uploading data to the UPenn Flywheel only,
  and to provide a record of previously used profiles on legacy data. The data
  should be kept confidential and accessible only by approved personnel. The profiles here
  are **NOT** suitable for any kind of public data sharing.

* Example data containing synthesized PHI, that can be used to test import procedures.
  This data is derived from a publicly available de-identification test data set. If used
  in research, please include the citations in the README.

* A script to check dicom files within a project and report the presence of common
  identifiers and the tag (0012,0063) DeidentificationMethod.


## Generating a new profile

First define CSV files containing tags to remove or replace, following the format shown in
the `profiles/` directory. A dictionary of keywords (possibly outdated) is included under
the `dicom/` directory. There's also an example there showing how to access the dictionary
in `pydicom`.

When you have the tags you want to process, run `config/generateDeidConfig.pl`. Test with
the example data before use.


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

[Report of the Medical Image De-Identification (MIDI) Task Group -- Best
Practices and Recommendations](http://arxiv.org/abs/2303.10473). Preprint
discussing the complex issues surrounding de-identification for public
data sharing.

