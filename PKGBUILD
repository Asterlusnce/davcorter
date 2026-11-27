# Maintainer: asterlusnce
pkgname=davcorter
pkgver=0.1.2
pkgrel=1
pkgdesc="GTK4/Libadwaita video and audio converter for DaVinci Resolve on Linux"
arch=('any')
url="https://github.com/asterlusnce/Davinci-Resolve-Video-Audio-Converter"
license=('MIT')
depends=(
  'python'
  'python-gobject'
  'gtk4'
  'libadwaita'
  'ffmpeg'
)
source=("${pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
  cd "${srcdir}/Davinci-Resolve-Video-Audio-Converter-${pkgver}"

  install -dm755 "${pkgdir}/usr/lib/${pkgname}"
  cp -r davinci_converter "${pkgdir}/usr/lib/${pkgname}/"

  install -dm755 "${pkgdir}/usr/bin"
  cat > "${pkgdir}/usr/bin/${pkgname}" <<'EOF'
#!/usr/bin/env python3
import sys
sys.path.insert(0, "/usr/lib/davcorter")
from davinci_converter.__main__ import main
sys.exit(main())
EOF
  chmod 755 "${pkgdir}/usr/bin/${pkgname}"

  install -Dm644 /dev/stdin "${pkgdir}/usr/share/applications/sh.asterlusnce.davcorter.desktop" <<'EOF'
[Desktop Entry]
Name=DavCorter
Comment=Video and audio converter for DaVinci Resolve
Exec=davcorter
Icon=video-x-generic
Terminal=false
Type=Application
Categories=AudioVideo;Video;
EOF

  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
