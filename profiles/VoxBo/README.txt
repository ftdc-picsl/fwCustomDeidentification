This profile attempts to reproduce the behavior of vbrename.

The profile contains the public tags that are in groups 0010, 0012, 
0032, and 0038, or have a VR of PN. 

I cannot verify that vbrename actually gets all these tags, but these
are what the usage says it will remove.

From the usage for vbrename:

  By default, vbrename de-identifies each file in the process, using
  the default behavior of dcmsplit, removing:

    all of groups 0010, 0012, 0032, and 0038
    any element with value representation of PN (person name)

  Note that elements embedded inside SQ (sequence) elements are not
  stripped, unless the SQ itself is stripped.


