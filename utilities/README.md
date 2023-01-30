# Utilities

Scripts to help identify de-identification issues.

## deid_check.py

`deid_check.py` reads a project's file metadata to look for identifiers and records of
de-identification. It is somewhat slow and may take many minutes to hours for very large
projects.

Output columns:

```
subject_id
subject_label
session_id
session_label
acquisition_id
acquisition_label
file_name
```

Flywheel info about the subject / session / acquisition containing the file

```
file_user
```

The user who created the file. This might be a UID for a device - files created by gears
or by dicom connectors. If it was a manual upload via web or CLI, the username will be
shown.

```
file_created
```

File creation date - when the file was created, which is not necessarily the scan date.

```
file_has_info
```

TRUE if the file has an info dictionary, FALSE otherwise. This will be FALSE if the file
was not successfully run through the dicom classifier gear for some reason. This can
happen for several reasons, including bad data, non-imaging data that is intentionally not
classified, or othet failures with the dicom classifier process.


```
file_deidentification_method
```

The string found in the info dictionary under `DeidentificationMethod`. This is derived
from the DICOM tag (0012,0063), keyword DeidentificationMethod. It should ordinarily be
set to "Penn_BSC_profile_v1.0" or "Penn_BSC_profile_v3.0". If it is "NA", no
deidentification method was recorded in the data.

```
file_has_patient_identifiers
```

TRUE if the file has any of the direct patient identifiers tested in the script. See
script for details. If your project deliberately contains any values in these fields, this
column will not be useful, and you will need to modify the script to check fields that
shouldn't exist, and to check fields that do exist conform to expectations (eg the format
of a coded value in PatientID).