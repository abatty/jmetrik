# jMetrik for macOS on Apple Silicon

This directory contains packaging files for running jMetrik 4.1.1 as a
native macOS application on Apple Silicon.

The original jMetrik 4.1.1 macOS application uses an Intel-only
install4j launcher. The jMetrik application itself is written in Java
and does not require Intel emulation when run with an ARM64 Java
runtime.

This packaging replaces the old Intel launcher with a small shell
launcher that runs the original jMetrik 4.1.1 JAR using an ARM64
Java 8 runtime.

## What this changes

The macOS package:

- replaces the Intel-only application launcher;
- locates an installed ARM64 Java 8 runtime;
- launches the original jMetrik 4.1.1 JAR;
- preserves the original Java memory settings (`-Xms128m` and
  `-Xmx768m`);
- uses the jMetrik icon included in the source repository.

## What this does not change

The jMetrik Java source code and statistical procedures are not
modified by this packaging.

The application JAR is not modified by the macOS launcher.

## Requirements

- A Mac with Apple Silicon
- macOS
- An ARM64 Java 8 runtime

The launcher searches standard macOS Java installation locations,
including Oracle's standalone Java 8 JRE location.

## Building the application

From the root of the jMetrik repository, run:

    ./macos/build-app.sh /path/to/jmetrik-4.1.1.jar

The resulting application will be created at:

    dist/jMetrik.app

The build script creates the macOS application bundle, generates an
`.icns` file from the jMetrik artwork in the source repository, and
ad-hoc signs the resulting application.

The `dist` directory is excluded from Git.

## Files

- `Info.plist` — macOS application bundle metadata
- `jMetrik-launcher` — launcher that locates ARM64 Java 8 and starts jMetrik
- `build-app.sh` — script for constructing the macOS application bundle
