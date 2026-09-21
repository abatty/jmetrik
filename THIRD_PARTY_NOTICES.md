# Third-Party Notices

jMetrik 4.1.1 incorporates or includes material from third-party projects.
This file records the licensing and attribution information identified for
the reconstructed jMetrik 4.1.1 distribution.

## Apache License 2.0 components

The following bundled libraries are distributed under the Apache License,
Version 2.0:

- Apache Commons Math 3.3
- Apache Commons IO 2.4
- Apache Commons Codec 1.7
- Apache Log4j 1.2.17
- Apache Derby 10.10.2.0
- OpenCSV 2.3
- Apache Commons CSV 1.0
- psychometrics 1.4 (subject to the separately identified third-party
  material contained within that library)

The jMetrik source tree also contains files by J. Patrick Meyer that are
individually marked as licensed under the Apache License, Version 2.0.

The Apache License text is provided in:

    licenses/common/Apache-2.0.txt

Original LICENSE and NOTICE files supplied with several of the exact
dependency artifacts are preserved under:

    licenses/apache/

## JFreeChart and JCommon

jMetrik includes:

- JFreeChart 1.0.17
- JCommon 1.0.21

These libraries are distributed under the GNU Lesser General Public
License. The Maven metadata for these versions identifies the license as
the GNU Lesser General Public License. JFreeChart-derived source included
directly in jMetrik explicitly identifies its terms as LGPL version 2.1
or, at the recipient's option, any later version.

The LGPL 2.1 text is provided in:

    licenses/common/LGPL-2.1.txt

The jMetrik source tree also contains HistogramBin.java derived from
JFreeChart and carrying the same LGPL 2.1-or-later terms and its original
copyright and attribution notices.

## Tango Icon Theme 0.8.0

jMetrik includes artwork from Tango Icon Theme 0.8.0.

The Maven metadata for the exact 0.8.0 artifact identifies the license as:

    Creative Commons Attribution-ShareAlike 2.5

License:
https://creativecommons.org/licenses/by-sa/2.5/

The original Tango contributors listed in the artifact metadata retain
their respective attribution.

## XML APIs 1.3.04

jMetrik includes XML APIs 1.3.04 as a transitive dependency of
JFreeChart.

The complete license and notice directory included in the exact 1.3.04
artifact is preserved under:

    licenses/xml-apis/

This includes the separate DOM and SAX licensing material supplied by
that distribution.

## Sun Microsystems Swing code

The jMetrik source tree contains the following files carrying copyright
notices from Sun Microsystems, Inc. and BSD-style redistribution terms:

- SwingSetUtils.java
- GradientPanel.java
- RoundedTitleBorder.java
- RoundedBorder.java

The copyright notices, redistribution conditions, and warranty
disclaimers contained in those source files must be retained. Their
binary-redistribution terms are reproduced separately with this
distribution.

## Bivariate normal distribution code

psychometrics 1.4 contains BivariateNormalDistribution.java, credited to
John Burkardt. The source file states that the code is distributed under
the GNU LGPL license.

The historical source notice does not identify a specific LGPL version.
Accordingly, this distribution preserves that notice without assigning a
license version not stated in the incorporated source.

## Squiggle SQL-builder source

The jMetrik source tree contains source under:

    com.itemanalysis.squiggle

These files identify original authors including Nat Pryce, Joe Walnes,
and Derek Mahar.

The historical files incorporated into jMetrik do not contain an explicit
license notice, and an authoritative license for this particular
historical copy has not yet been established. Their provenance and
authorship are therefore recorded here without assigning an unsupported
license.

## jMetrik licensing note

The reconstructed jMetrik 4.1.1 source contains inconsistent historical
project-level licensing metadata.

Most source files carrying a GNU license header state GNU General Public
License version 3 or, at the recipient's option, any later version, and
the Maven POM identifies GNU GPL version 3.0. The repository's historical
top-level LICENSE file, however, contains the GNU GPL version 2 text.

The historical files have been preserved rather than silently altering
this inconsistency. Individual files carrying different or third-party
license notices remain subject to their respective notices.

## Source availability

The source code and reconstruction/build documentation for this
distribution are provided in the jMetrik source repository. See
RECONSTRUCTION.md for the provenance of the reconstructed 4.1.1 release
source and its psychometrics dependency.
