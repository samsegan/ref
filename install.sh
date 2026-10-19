#!/bin/bash
# Installs (or updates) REF:
#     curl -fsSL https://samsegan.github.io/ref/install.sh | bash
# Downloads the newest REF.dmg from https://github.com/samsegan/ref, copies
# REF.app into /Applications (~/Applications if that isn't writable) and opens
# it. A download made by curl isn't quarantined, so macOS doesn't ask you to
# approve REF the way it does for one from a browser.
set -euo pipefail

URL="${REF_DMG_URL:-https://github.com/samsegan/ref/releases/latest/download/REF.dmg}"
APP_DIR="${REF_APP_DIR:-/Applications}"
[[ -w "$APP_DIR" ]] || APP_DIR="$HOME/Applications"

if [[ "$(uname -m)" != arm64 ]]; then
    echo "REF needs a Mac with Apple silicon (M1 or newer)." >&2
    exit 1
fi
MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
if [[ "$MAJOR" -lt 14 ]]; then
    echo "REF needs macOS 14 Sonoma or later (this Mac has $(sw_vers -productVersion))." >&2
    exit 1
fi

TMP="$(mktemp -d)"
MOUNT="$TMP/mount"
cleanup() {
    hdiutil detach "$MOUNT" -quiet 2>/dev/null || true
    rm -rf "$TMP"
}
trap cleanup EXIT

echo "Downloading REF…"
curl -fL --progress-bar -o "$TMP/REF.dmg" "$URL"
mkdir -p "$MOUNT" "$APP_DIR"
hdiutil attach "$TMP/REF.dmg" -nobrowse -readonly -quiet -mountpoint "$MOUNT"

# The REF being replaced quits first.
RUNNING="$APP_DIR/REF.app/Contents/MacOS/REF"
if pgrep -f "$RUNNING" >/dev/null; then
    osascript -e 'tell application id "com.samsegan.ref" to quit' 2>/dev/null || true
    for _ in 1 2 3 4 5 6 7 8 9 10; do pgrep -f "$RUNNING" >/dev/null || break; sleep 1; done
fi
rm -rf "$APP_DIR/REF.app"
ditto "$MOUNT/REF.app" "$APP_DIR/REF.app"

VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP_DIR/REF.app/Contents/Info.plist")"
echo "Installed REF $VERSION in $APP_DIR. Opening it."
open "$APP_DIR/REF.app"
