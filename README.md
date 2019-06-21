# fwCustomDeidentification
Script to import data to Flywheel with custom de-identification profile

## Example usage 

If dicom data for a single scan is in `/path/to/dicomDir`, then

```
fw import dicom /path/to/dicomDir pennftdcenter aProject \
  --subject subjectID \
  --session sessionID \
  --output-folder /path/to/testOutput \
  --profile profiles/global/globalDeIdConfig.yaml
```

This does a dry run, outputing data to a local file system. Without the `--output-folder` option, this imports to Flywheel.


## Custom de-identification profiles

The example profiles here use some basic features of the Flywheel CLI. We remove, hash or replace a bunch of standard DICOM fields. For more background and examples of other capabilities, [Custom de-Identification of dicom field through the CLI](https://docs.flywheel.io/hc/en-us/articles/360008972493-Custom-de-Identification-of-dicom-field-through-the-CLI).

## Generating a profile

