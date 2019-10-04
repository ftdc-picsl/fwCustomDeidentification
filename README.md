# fwCustomDeidentification
Script to import data to Flywheel with custom de-identification profile

## Example usage 

If dicom data for a single scan is in `/path/to/dicomDir`, then it can
be de-identified during import with:

```
fw import dicom /path/to/dicomDir pennftdcenter aProject \
  --subject subjectID \
  --session sessionID \
  --output-folder /path/to/testOutput \
  --profile globalDeIdConfig.yaml
```

This does a dry run, outputing data to a local file system. Without
the `--output-folder` option, the data will be imported to
Flywheel. See the [Flywheel documentation](https://docs.flywheel.io/hc/en-us/articles/360008548134-CLI-Command-import-dicom-)
for more information.


## Included profiles

Most users should use the official profile at
`profiles/PennBrainScienceCenter/de-id_upenn_Penn_BSC_profile_v1.0_20190906A.yaml`. This
is the same profile used for data reaped from HUP6. See the README
there for some examples on how to test the output for successful
de-identification.


## Custom de-identification profiles

For more background and examples of other capabilities, see [Custom
de-Identification of dicom field through the CLI](https://docs.flywheel.io/hc/en-us/articles/360008972493-Custom-de-Identification-of-dicom-field-through-the-CLI). 


## Generating a profile

First define CSV files containing tags to remove, replace, or hash,
following the format shown in the `profiles/` directory. A dictionary
of keywords is included under the `dicom/` directory. There's also an
example there showing how to access the dictionary in `pydicom`.

When you have the tags you want to process, run
`config/generateDeidConfig.pl`.

Always test the profile first before sending data to Flywheel.
