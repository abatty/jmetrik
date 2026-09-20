#!/bin/sh
set -e

PSYCHOMETRICS_REPO="https://github.com/meyerjp3/psychometrics.git"
PSYCHOMETRICS_COMMIT="4329698"

# This build requires JDK 8 because the historical psychometrics POM
# targets Java 7 bytecode.
if [ -z "$JAVA_HOME" ]; then
    echo "Error: JAVA_HOME is not set."
    echo "Set JAVA_HOME to a JDK 8 installation and try again."
    exit 1
fi

JAVA_VERSION=$("$JAVA_HOME/bin/java" -version 2>&1 | head -1)

case "$JAVA_VERSION" in
    *\"1.8.*)
        ;;
    *)
        echo "Error: JDK 8 is required."
        echo "JAVA_HOME currently reports:"
        echo "  $JAVA_VERSION"
        exit 1
        ;;
esac

WORK_DIR="${TMPDIR:-/tmp}/jmetrik-psychometrics-build"

echo "Using:"
echo "  JAVA_HOME=$JAVA_HOME"
echo "  $JAVA_VERSION"
echo

rm -rf "$WORK_DIR"

echo "Cloning psychometrics..."
git clone "$PSYCHOMETRICS_REPO" "$WORK_DIR"

cd "$WORK_DIR"

echo "Checking out psychometrics commit $PSYCHOMETRICS_COMMIT..."
git checkout "$PSYCHOMETRICS_COMMIT"

echo
echo "Building and installing psychometrics 1.4..."
mvn clean install

echo
echo "psychometrics 1.4 installed successfully."
echo "jMetrik can now be built with Maven."
