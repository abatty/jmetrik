jMetrik for Apple Silicon
=========================

If you already know what you want and why you’re here, and want to get to using jMetrik on your computer quickly, you can skip straight down to the [Installation Instructions](#installation-instructions) to download the release and install it normally.

If you want to examine or build the project from source, skip down to the [Technical Details](#technical-details) below that.

If you *don’t* know what this is or why you’d want it or what problem it solves, *keep reading.*

## Background
jMetrik is a free and open source computer program for psychometric analysis. It is a pure Java application that runs on any platform that can run a Java Runtime Environment (JRE). It was developed by J. Patrick Meyer while an associate professor in the School of Education and Human Development at the University of Virginia. Version 4.1.1 was released in 2018, after which development ceased. However, it still functions well and puts considerable psychometric analytical power into the hands of both students and practitioners *for free.*

## The Problem

Because of changes in macOS’s security policies in recent years, the installer originally bundled with jMetrik required root access to install, requiring Mac users to enable the root account to install, and then disable it again. Beyond the security implications of this process, it was troublesome.

Furthermore, the jMetrik .app used the Intel-only install4j JavaApplicationStub launcher. On Apple Silicon Macs, it required Rosetta 2 to launch. Recent versions of macOS therefore identify jMetrik as an Intel application, even though jMetrik itself is written in Java and only the launcher is Intel-only. As Rosetta 2 will be discontinued entirely in macOS 28 (to be released in 2027), some users may erroneously conclude that the application itself can no longer be used, losing access to an important part of their psychometrics toolkit.

## The Solution

This project replaces the install4j launcher with a standard macOS application bundle (.app) that launches jMetrik using an ARM64 Java 8 JRE (installed separately). It behaves like any other normal macOS application, allowing it to appear quickly in searches and app launchers. This addresses both the root access problem, as well as the impending Rosetta 2 problem, and greatly simplifies installation.

Installation Instructions
=========================

## Install from a .dmg or .zip

1) **CRITICAL: Ensure that you have a Java 8 JRE for macOS ARM64 installed.**  
   Download it from here: https://www.java.com/en/download/

2) Download the current [release](https://github.com/abatty/jmetrik-apple-silicon/releases) (`.dmg` or `.zip`) of *jMetrik for Apple Silicon.*

3) **For `.dmg`:** Open the .dmg and drag the jMetrik icon to the Applications folder icon.  
   **For `.zip`:** Decompress and drag the jMetrik icon to your Applications folder.

4) See [First Launch](#first-launch) below if macOS’s Gatekeeper refuses to launch the app.

## Build from Source

If you’d like to build from source, clone the repository and see [Technical Details](#technical-details) below for build requirements and instructions.

## First Launch

Because this version of jMetrik is not signed with an Apple Developer ID or notarized by Apple (as I don’t want to pay $100 a year to notarize one little app I didn’t even write), macOS may prevent it from opening the first time.

If this happens, try to open jMetrik once, then open:

**System Settings → Privacy & Security**

Scroll down to the “Security” section and click “Open Anyway” next to the message about jMetrik. Confirm by clicking “Open” when prompted.

You should only need to do this once. Afterward, jMetrik can be opened normally.

Using jMetrik
=============

I have written a short guide on getting started with jMetrik, as the initial steps are usually where new users get lost or give up. It’s available here:

> Batty, A. O. (2023). jMetrik guide. *Shiken, 27*(1), 15–29. https://teval.jalt.org/sites/default/files/27_01_15_Batty_jMetrik.pdf

**Disregard the Mac installation section.** This project obviates the many steps listed there.


Technical Details
=================

The information below is for those who wish to build from source. It also includes some description of the process of reconstructing the 4.1.1 release from the original repository.

## jMetrik

*[The following description is retained from the original jMetrik README.]*

jMetrik is a free and open source computer program for psychometric analysis. It is a pure Java application that features a user-friendly interface, integrated database, and a variety of statistical procedures and charts. The interface is intuitive and easy to learn. It also scales to the experience of the user. New users can quickly learn to implement psychometric procedures through point-and-click menus. Experienced users can take advantage of the jMetrik command structure and write command files for executing an analysis.

jMetrik’s embedded database increases productivity by providing a common data format for all of its methods. There is no need to reformat or reshape data for each procedure. The database is the primary mechanism for data management. There is virtually no limit to the sample size or number of tables that can be stored in the database. Users are only limited by the amount of storage on their computer. After importing data into jMetrik, users can create subsets of data by selecting examinees or variables. Users can also create new tables by saving the results of an analysis in the database for further processing.

The compiled application can be downloaded from <a href="http://www.ItemAnalysis.com">http://www.ItemAnalysis.com</a>.

*[NOTE: the Mac version available there requires root access to install and will no longer launch from macOS 28 (to be released in 2027). —AoB]*

jMetrik involves a variety of dependencies including Apache Derby, Apache Commons Math, jFreeChart, and the psychometrics library.

## Building the Reconstructed 4.1.1 Release

Reconstructing jMetrik 4.1.1 was complicated by inconsistent dependency information. The repository documentation identified psychometrics 1.3, while the Maven configuration and the released jMetrik 4.1.1 JAR identified psychometrics 1.4. Further examination of the compiled classes showed that the release used a later revision of the psychometrics 1.4 source than its initial 1.4 release. The corresponding source revision was identified by comparing the historical source with the bytecode contained in the official jMetrik 4.1.1 JAR.

The source corresponding to the published jMetrik 4.1.1 binary has now been reconstructed from the project's Git history and verified against the official release JAR. See `RECONSTRUCTION.md` for details.

To build the reconstructed release, JDK 8 and Maven are required.

First set `JAVA_HOME` to a JDK 8 installation. Then run:

    ./scripts/build-dependencies.sh

This script clones the original psychometrics repository, checks out commit `4329698`, builds psychometrics 1.4 using its original Java 7 source/target settings, runs its tests, and installs it in the local Maven repository.

With `JAVA_HOME` still set to JDK 8, jMetrik can then be built with:

    mvn clean package

The resulting JAR with dependencies is created in the `target` directory.

## Apple Silicon macOS Packaging

Files for creating the Apple Silicon macOS application bundle are provided in the `macos` directory. See `macos/README.md` for details.