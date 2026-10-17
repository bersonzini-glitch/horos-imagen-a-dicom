#!/bin/zsh
# Builds JPEGToDICOMArm.horosplugin (arm64) and the jpg2dcm_test CLI.
set -euo pipefail
cd "${0:A:h}"

HOROS=/Applications/Horos.app/Contents/MacOS/Horos
OUT=build/JPEGToDICOMArm.horosplugin
FLAGS=(-arch arm64 -fobjc-arc -O2 -mmacosx-version-min=11.0 -Wall)

rm -rf build
mkdir -p "$OUT/Contents/MacOS"
cp Info.plist "$OUT/Contents/Info.plist"

clang "${FLAGS[@]}" -bundle -bundle_loader "$HOROS" \
  -framework Cocoa -framework ImageIO -framework UniformTypeIdentifiers \
  JPEGToDICOMArm.m DicomWriter.m DicomHeaderReader.m -o "$OUT/Contents/MacOS/JPEGToDICOMArm"

codesign --force --sign - "$OUT"

clang "${FLAGS[@]}" -framework Foundation -framework ImageIO -framework CoreGraphics \
  test_main.m DicomWriter.m DicomHeaderReader.m -o build/jpg2dcm_test

(cd build && ditto -c -k --keepParent JPEGToDICOMArm.horosplugin JPEGToDICOMArm.horosplugin.zip)

# Installer package: files installed by Installer are not quarantined, so it works
# for people downloading the plugin without needing Terminal.
mkdir -p "build/pkgroot/Library/Application Support/Horos/Plugins"
cp -R "$OUT" "build/pkgroot/Library/Application Support/Horos/Plugins/"
pkgbuild --analyze --root build/pkgroot build/component.plist >/dev/null
plutil -replace 0.BundleIsRelocatable -bool NO build/component.plist
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" Info.plist)
pkgbuild --root build/pkgroot --component-plist build/component.plist --install-location / \
  --identifier com.columnaspine.horos.JPEGToDICOMArm --version "$VERSION" build/plugin.pkg >/dev/null
productbuild --distribution distribution.xml --resources installer --package-path build \
  "build/Instalar Imagen a DICOM.pkg" >/dev/null

echo "Built $OUT"
