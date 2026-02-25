#!/bin/bash
# Run this before flutter build apk:  source set_android_home.sh
# Or:  . set_android_home.sh

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"

if [ ! -d "$ANDROID_HOME" ]; then
  echo "⚠️  Android SDK not found at $ANDROID_HOME"
  echo "   Install Android Studio from https://developer.android.com/studio"
  echo "   After install, open it once so SDK is installed to the path above."
  return 1 2>/dev/null || exit 1
fi
echo "✓ ANDROID_HOME=$ANDROID_HOME"
echo "  You can now run: flutter build apk --debug"
