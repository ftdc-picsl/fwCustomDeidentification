# fwCustomDeidentification
Script to import data to Flywheel with custom de-identification profile

## Example usage 

If dicom data for a single scan is in `/path/to/dicomDir`, then it can be de-identified during import with: 

```
fw import dicom /path/to/dicomDir pennftdcenter aProject \
  --subject subjectID \
  --session sessionID \
  --output-folder /path/to/testOutput \
  --profile profiles/global/globalDeIdConfig.yaml
```

This does a dry run, outputing data to a local file system. Without the `--output-folder` option, the data will be imported to Flywheel. See the [Flywheel documentation](https://docs.flywheel.io/hc/en-us/articles/360008548134-CLI-Command-import-dicom-) for more information.


## Custom de-identification profiles

The example profiles here use some basic features of the Flywheel CLI. We remove, hash or replace a bunch of standard DICOM fields. For more background and examples of other capabilities, [Custom de-Identification of dicom field through the CLI](https://docs.flywheel.io/hc/en-us/articles/360008972493-Custom-de-Identification-of-dicom-field-through-the-CLI).


## Generating a profile

First define CSV files containing tags to remove, replace, or hash, following the format shown in the `profiles/` directory. A dictionary of keywords is included under the `dicom/` directory. There's also an example there showing how to access the dictionary in `pydicom`.

When you have the tags you want to process, run `config/generateDeidConfig.pl`.

Always test the profile first before sending data to Flywheel.
