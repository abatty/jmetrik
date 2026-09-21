#!/bin/sh

set -e

VERSION="4.1.1"
APP_NAME="jMetrik"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/dist"
APP="$OUTPUT_DIR/$APP_NAME.app"
ICON_SOURCE="$PROJECT_DIR/src/main/resources/images/jmetrik-256.png"
ICONSET="$OUTPUT_DIR/jMetrik.iconset"

# Check for JAR argument.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/jmetrik-$VERSION.jar"
    exit 1
fi

JAR="$1"

if [ ! -f "$JAR" ]; then
    echo "Error: JAR not found: $JAR"
    exit 1
fi

# Start with a clean application bundle.
rm -rf "$APP"
rm -rf "$ICONSET"

mkdir -p "$APP/Contents/MacOS"
mkdir -p "$APP/Contents/Resources"

# Install application files.
cp "$JAR" "$APP/Contents/Resources/jmetrik-$VERSION.jar"
cp "$SCRIPT_DIR/jMetrik-launcher" "$APP/Contents/MacOS/jMetrik"
cp "$SCRIPT_DIR/Info.plist" "$APP/Contents/Info.plist"

# Include licensing and third-party notices with the application.
cp "$PROJECT_DIR/THIRD_PARTY_NOTICES.md" \
   "$APP/Contents/Resources/THIRD_PARTY_NOTICES.md"

cp -R "$PROJECT_DIR/licenses" \
   "$APP/Contents/Resources/licenses"

find "$APP/Contents/Resources/licenses" \
     -name '.DS_Store' \
     -delete

chmod +x "$APP/Contents/MacOS/jMetrik"

# Build a macOS icon from the jMetrik source artwork.
if [ -f "$ICON_SOURCE" ]; then
    mkdir -p "$ICONSET"

    sips -z 16 16     "$ICON_SOURCE" --out "$ICONSET/icon_16x16.png" >/dev/null
    sips -z 32 32     "$ICON_SOURCE" --out "$ICONSET/icon_16x16@2x.png" >/dev/null
    sips -z 32 32     "$ICON_SOURCE" --out "$ICONSET/icon_32x32.png" >/dev/null
    sips -z 64 64     "$ICON_SOURCE" --out "$ICONSET/icon_32x32@2x.png" >/dev/null
    sips -z 128 128   "$ICON_SOURCE" --out "$ICONSET/icon_128x128.png" >/dev/null
    sips -z 256 256   "$ICON_SOURCE" --out "$ICONSET/icon_128x128@2x.png" >/dev/null
    sips -z 256 256   "$ICON_SOURCE" --out "$ICONSET/icon_256x256.png" >/dev/null

    iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/app.icns"

    rm -rf "$ICONSET"
fi

# Ad-hoc sign the finished application.
codesign --force --deep --sign - "$APP"

echo
echo "Built successfully:"
echo "$APP"
