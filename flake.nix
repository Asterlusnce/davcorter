{
  description = "DaVinci Resolve Video Audio Converter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      python = pkgs.python3.withPackages (ps: [
        ps.pygobject3
      ]);
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "davcorter";
        version = "0.1.2";

        src = ./.;

        nativeBuildInputs = [
          pkgs.wrapGAppsHook4
          pkgs.gobject-introspection
          pkgs.makeWrapper
        ];

        buildInputs = [
          pkgs.gtk4
          pkgs.libadwaita
          pkgs.ffmpeg-full
          python
        ];

        dontBuild = true;

        installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib/davinci-converter
        mkdir -p $out/share/applications

        cp -r davinci_converter $out/lib/davinci-converter/

        cat > $out/bin/davinci-converter <<EOF
        #!${python}/bin/python3
        import os, sys
        sys.path.insert(0, "$out/lib/davinci-converter")
        from davinci_converter.__main__ import main
        sys.exit(main())
        EOF
        chmod +x $out/bin/davinci-converter

        cat > $out/share/applications/sh.asterlusnce.davinciconverter.desktop <<EOF
        [Desktop Entry]
        Name=DaVinci Converter
        Comment=Video and audio converter for DaVinci Resolve
        Exec=davinci-converter
        Icon=video-x-generic
        Terminal=false
        Type=Application
        Categories=AudioVideo;Video;
        EOF
        '';

        postFixup = ''
          wrapProgram $out/bin/davinci-converter \
            --prefix PATH : ${pkgs.lib.makeBinPath [
              pkgs.ffmpeg-full
              pkgs.xdg-utils
            ]}
        '';
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/davinci-converter";
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          python
          pkgs.gobject-introspection
          pkgs.gtk4
          pkgs.libadwaita
          pkgs.ffmpeg-full
        ];
      };
    };
}
