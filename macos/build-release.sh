#!/bin/sh
set -e

VERSION="4.1.1"
RELEASE_NAME="jMetrik-$VERSION-Apple-Silicon"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$PROJECT_DIR/dist"
APP="$DIST_DIR/jMetrik.app"
BACKGROUND="$SCRIPT_DIR/dmg-background.png"

STAGING="$DIST_DIR/dmg-staging"
TEMP_DMG="$DIST_DIR/jMetrik-temp.dmg"
FINAL_DMG="$DIST_DIR/$RELEASE_NAME.dmg"
ZIP="$DIST_DIR/$RELEASE_NAME.zip"
CHECKSUM="$DIST_DIR/$RELEASE_NAME-SHA256.txt"

if [ ! -d "$APP" ]; then
    echo "Error: jMetrik.app not found."
    echo "Build it first with macos/build-app.sh."
    exit 1
fi

if [ ! -f "$BACKGROUND" ]; then
    echo "Error: DMG background not found:"
    echo "$BACKGROUND"
    exit 1
fi

# Make sure the application signature is valid before packaging it.
codesign --verify --deep --strict "$APP"

# Remove artifacts from any previous release build.
rm -rf "$STAGING"
rm -f "$TEMP_DMG" "$FINAL_DMG" "$ZIP" "$CHECKSUM"

# Create the ZIP while preserving macOS resource information.
ditto -c -k --sequesterRsrc --keepParent \
    "$APP" \
    "$ZIP"

# Prepare the contents of the disk image.
mkdir -p "$STAGING/.background"
cp -R "$APP" "$STAGING/jMetrik.app"
cp "$BACKGROUND" "$STAGING/.background/background.png"
ln -s /Applications "$STAGING/Applications"

# Create a writable temporary disk image.
hdiutil create \
    -volname "jMetrik $VERSION" \
    -srcfolder "$STAGING" \
    -ov \
    -format UDRW \
    "$TEMP_DMG"

rm -rf "$STAGING"

# Mount the temporary disk image.
MOUNT_DIR=$(hdiutil attach \
    -readwrite \
    -noverify \
    -noautoopen \
    "$TEMP_DMG" |
    awk '/\/Volumes\// {
        sub(/^.*\/Volumes\//, "/Volumes/")
        print
        exit
    }')

if [ -z "$MOUNT_DIR" ]; then
    echo "Error: Could not determine DMG mount point."
    exit 1
fi

# Configure the Finder window.
osascript <<APPLESCRIPT
tell application "Finder"
    tell disk "jMetrik $VERSION"
        open

        tell container window
            set current view to icon view
            set toolbar visible to false
            set statusbar visible to false
            set pathbar visible to false
            set sidebar width to 0
            set bounds to {100, 100, 700, 500}
        end tell

        set backgroundFile to POSIX file "$MOUNT_DIR/.background/background.png" as alias

        set opts to the icon view options of container window
		tell opts
    		set arrangement to not arranged
    		set icon size to 112
    		set text size to 12
    		set background picture to backgroundFile
		end tell
        
        set position of item "jMetrik.app" to {160, 140}
        set position of item "Applications" to {440, 140}

        update without registering applications
        delay 2

        close
    end tell
end tell
APPLESCRIPT

# Give Finder a moment to finish writing .DS_Store.
sleep 2

# Unmount the writable image.
hdiutil detach "$MOUNT_DIR"

# Convert it to the final compressed, read-only DMG.
hdiutil convert \
    "$TEMP_DMG" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$FINAL_DMG"

rm -f "$TEMP_DMG"

# Generate SHA-256 checksums for the release files.
cd "$DIST_DIR"
shasum -a 256 \
    "$(basename "$FINAL_DMG")" \
    "$(basename "$ZIP")" \
    > "$(basename "$CHECKSUM")"

echo
echo "Release files created:"
echo "  $FINAL_DMG"
echo "  $ZIP"
echo "  $CHECKSUM"
