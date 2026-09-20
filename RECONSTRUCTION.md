# Reconstruction of the jMetrik 4.1.1 Release Source

The source tree for jMetrik 4.1.1 was reconstructed from the project's
Git history and compared with the official jMetrik 4.1.1 binary
distribution.

The original repository did not contain a commit corresponding exactly
to the source used to build the published 4.1.1 JAR. The final commits
in the repository contain changes made after the 4.1.1 release.
Evidence from the official JAR indicates that the release was built
from an intermediate working tree whose changes were committed later.

This document records the reconstruction so that the provenance of the
source in this repository is clear.

## jMetrik source

The reconstruction uses the following commit as its base:

    598877d
    Bug fixes for SPSS import. Updated analyses that use new reliability
    and covariance classes. Also added new logo to the about dialog.

This commit was made on February 24, 2018, shortly before the timestamp
recorded in the Maven metadata of the official jMetrik 4.1.1 JAR.

Three source files contain changes that were not committed until the
later commit `3b20326`, but comparison with the official 4.1.1 bytecode
shows that these changes were already present when the release JAR was
built:

    src/main/java/com/itemanalysis/jmetrik/stats/correlation/CorrelationAnalysis.java
    src/main/java/com/itemanalysis/jmetrik/stats/ranking/RankingDialog.java
    src/main/java/com/itemanalysis/jmetrik/stats/scaling/TestScalingAnalysis.java

The versions of these three files from commit `3b20326` were therefore
applied to the `598877d` source tree.

The project version in `pom.xml` was changed from 4.1.0 to 4.1.1,
matching the Maven metadata embedded in the official release JAR.

These changes are recorded in this repository in commit:

    e991d320b638e0497c54458ad7cd86b27d496629
    Reconstruct jMetrik 4.1.1 release source

Later changes from the original repository, including subsequent IRT
and distribution API migrations, are not included because their
bytecode does not match the official 4.1.1 release.

## psychometrics dependency

jMetrik 4.1.1 depends on:

    com.itemanalysis:psychometrics:1.4

This artifact is not currently available from Maven Central.

Comparison of the source history and the classes embedded in the
official jMetrik 4.1.1 JAR indicates that the corresponding
psychometrics source is commit:

    4329698

The original `psychometrics` POM at this commit specifies:

    <source>1.7</source>
    <target>1.7</target>

The dependency was successfully built using JDK 8 while retaining
these original Java 7 source and target settings. Its test suite
completed successfully:

    Tests run: 213, Failures: 0, Errors: 0, Skipped: 0

Compiling the same source with a Java 8 target changes compiler-generated
bytecode, including the synthetic `QNMinimizer$1.class`. Compiling with
the original Java 7 target produces this class and matches the structure
of the dependency contained in the official jMetrik JAR.

## Verification against the official 4.1.1 JAR

The reconstructed jMetrik source was built with JDK 8 and the
reconstructed psychometrics 1.4 dependency.

The resulting fat JAR was compared with the official:

    jmetrik-4.1.1.jar

The complete class inventories are identical:

    Official JAR:       5592 .class files
    Reconstructed JAR:  5592 .class files

There are no differences in the sorted class-name inventories.

For the jMetrik application itself, all 776 application classes were
compared using:

    javap -c -p

No bytecode differences were found.

The previously identified difference in
`com.itemanalysis.psychometrics.optimization.QNMinimizer` was also
resolved after rebuilding psychometrics with its original Java 7 target.
The `javap -c -p` output for `QNMinimizer` from the reconstructed and
official JARs is identical.

These comparisons provide strong evidence that this reconstruction
corresponds to the source and dependency versions used to build the
official jMetrik 4.1.1 release. They should not be interpreted as proof
that every aspect of the original build environment has been reproduced
exactly.

## macOS packaging

The Apple Silicon macOS application wrapper is a packaging addition and
does not modify the reconstructed jMetrik statistical application code.

It is recorded separately in commit:

    0323c589d2edb635413a3a7ed56dc2fc765ab3ff
    Add Apple Silicon macOS packaging

Additional information about the wrapper is in `macos/README.md`.
