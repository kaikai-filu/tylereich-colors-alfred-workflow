#!/bin/bash
# Build script for Colors Alfred Workflow
# Produces universal binaries (x86_64 + arm64)

set -e
cd "$(dirname "$0")"

OUTDIR="output"
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR/Colors.app/Contents/MacOS"
mkdir -p "$OUTDIR/Colors.app/Contents/Resources/Base.lproj"
mkdir -p "$OUTDIR/Colors.app/Contents/Resources/en.lproj"

SRC="src"

echo "=== Compiling colors CLI ==="
clang -fobjc-arc \
      -framework Foundation \
      -framework AppKit \
      -arch x86_64 \
      -arch arm64 \
      -o "$OUTDIR/colors" \
      "$SRC/colors/Alfred/implementation/Alfred.m" \
      "$SRC/colors/Alfred/implementation/AWArgs.m" \
      "$SRC/colors/Alfred/implementation/AWFeedbackItem.m" \
      "$SRC/colors/Alfred/implementation/AWPreferences.m" \
      "$SRC/colors/Alfred/implementation/AWWorkflow.m" \
      "$SRC/colors/Alfred/implementation/NSArray+FuzzySearching.m" \
      "$SRC/colors/Alfred/implementation/NSFileManager+AWFindOrCreate.m" \
      "$SRC/colors/Alfred/implementation/NSString+XMLEscaping.m" \
      "$SRC/colors/colors/colors.m" \
      "$SRC/colors/colors/main.m" \
      -I "$SRC/colors/Alfred/headers" \
      -I "$SRC/colors/colors" \
      -mmacosx-version-min=10.13

echo "=== Compiling Colors.app ==="
clang -fobjc-arc \
      -framework Cocoa \
      -arch x86_64 \
      -arch arm64 \
      -o "$OUTDIR/Colors.app/Contents/MacOS/Colors" \
      "$SRC/ColorsApp/Colors/main.m" \
      "$SRC/ColorsApp/Colors/AppController.m" \
      "$SRC/ColorsApp/Colors/AppDelegate.m" \
      -I "$SRC/ColorsApp/Colors" \
      -mmacosx-version-min=10.13

echo "=== Copying resources ==="
# Try from existing extracted directory first, then from original workflow
if [ -d "extracted" ]; then
    RESDIR="extracted"
elif [ -f "Colors.alfredworkflow.orig" ]; then
    echo "Extracting original workflow for resources..."
    rm -rf extracted
    unzip -q Colors.alfredworkflow.orig -d extracted
    RESDIR="extracted"
elif [ -f "Colors.alfredworkflow" ]; then
    echo "Extracting existing workflow for resources..."
    rm -rf extracted
    unzip -q Colors.alfredworkflow -d extracted
    RESDIR="extracted"
else
    echo "WARNING: No resource source found. Colors.app bundle may be incomplete."
    RESDIR=""
fi

if [ -n "$RESDIR" ]; then
    cp "$RESDIR/Colors.app/Contents/Info.plist" "$OUTDIR/Colors.app/Contents/" 2>/dev/null || true
    cp "$RESDIR/Colors.app/Contents/PkgInfo" "$OUTDIR/Colors.app/Contents/" 2>/dev/null || true
    cp "$RESDIR/Colors.app/Contents/Resources/Base.lproj/"*.nib "$OUTDIR/Colors.app/Contents/Resources/Base.lproj/" 2>/dev/null || true
    cp "$RESDIR/Colors.app/Contents/Resources/en.lproj/"* "$OUTDIR/Colors.app/Contents/Resources/en.lproj/" 2>/dev/null || true
    cp "$RESDIR/icon.png" "$RESDIR/contrast.png" "$RESDIR/pick-color.png" "$OUTDIR/" 2>/dev/null || true
    cp "$RESDIR/info.plist" "$OUTDIR/" 2>/dev/null || true
    cp "$RESDIR/update.json" "$OUTDIR/" 2>/dev/null || true
    cp -r "$RESDIR/packal" "$OUTDIR/" 2>/dev/null || true
fi

echo "=== Verification ==="
file "$OUTDIR/colors"
lipo -info "$OUTDIR/colors"
echo "---"
file "$OUTDIR/Colors.app/Contents/MacOS/Colors"
lipo -info "$OUTDIR/Colors.app/Contents/MacOS/Colors"

echo ""
echo "=== Packaging ==="
rm -f Colors.alfredworkflow
cd "$OUTDIR"
zip -r ../Colors.alfredworkflow . -x ".*"
cd ..
echo ""
echo "Done! Colors.alfredworkflow is ready."
ls -la Colors.alfredworkflow
