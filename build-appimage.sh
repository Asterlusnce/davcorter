#!/usr/bin/env bash
set -euo pipefail

VERSION="0.1.2"
APP_NAME="DavCorter"
APP_DIR="AppDir"
OUT_APPIMAGE="${APP_NAME}-${VERSION}-x86_64.AppImage"

rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/usr/lib/davcorter"

cp -r davinci_converter "$APP_DIR/usr/lib/davcorter/"

cat > "$APP_DIR/AppRun" <<'EOF'
#!/usr/bin/env bash
HERE="$(dirname "$(readlink -f "${0}")")"
export PYTHONPATH="${HERE}/usr/lib/davcorter:${PYTHONPATH:-}"
exec python3 -m davinci_converter "$@"
EOF
chmod +x "$APP_DIR/AppRun"

cat > "$APP_DIR/sh.asterlusnce.davcorter.desktop" <<'EOF'
[Desktop Entry]
Name=DavCorter
Comment=Video and audio converter for DaVinci Resolve
Exec=davcorter
Icon=davcorter
Terminal=false
Type=Application
Categories=AudioVideo;Video;
EOF

cat > "$APP_DIR/davcorter.svg" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <rect width="128" height="128" rx="24" fill="#1e1e2e"/>
  <polygon points="48,36 96,64 48,92" fill="#89b4fa"/>
</svg>
EOF

if ! command -v appimagetool >/dev/null 2>&1; then
  if [ ! -x "./appimagetool-x86_64.AppImage" ]; then
    echo "Downloading appimagetool..."
    curl -L -o appimagetool-x86_64.AppImage \
      "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool-x86_64.AppImage
  fi
  TOOL="./appimagetool-x86_64.AppImage"
else
  TOOL="appimagetool"
fi

ARCH=x86_64 "$TOOL" "$APP_DIR" "$OUT_APPIMAGE"
echo "Built $OUT_APPIMAGE"
