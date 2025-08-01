{
  lib,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  gtk3,
  libsoup_2_4,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "desktop-postflop";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "b-inary";
    repo = "desktop-postflop";
    rev = "v${version}";
    hash = "sha256-pOPxNHM4mseIuyyWNoU0l+dGvfURH0+9+rmzRIF0I5s=";
  };

  npmDist = buildNpmPackage {
    name = "${pname}-${version}-dist";
    inherit src;

    npmDepsHash = "sha256-HWZLicyKL2FHDjZQj9/CRwVi+uc/jHmVNxtlDuclf7s=";

    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out
    '';
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-pMvh2Rr+rMe0nMB9yRDrGatrS36+VM7os0eeBR31oCM=";

  postPatch = ''
    substituteInPlace tauri.conf.json \
        --replace "../dist" "${npmDist}"
  '';

  # postflop-solver requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    gtk3
    libsoup_2_4
    webkitgtk_4_0
  ];

  postInstall = ''
    install -Dm644 ${src}/public/favicon.png $out/share/icons/hicolor/128x128/apps/desktop-postflop.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "desktop-postflop";
      exec = "desktop-postflop";
      icon = "desktop-postflop";
      desktopName = "Desktop Postflop";
      comment = meta.description;
      categories = [ "Utility" ];
      terminal = false;
    })
  ];

  meta = {
    changelog = "https://github.com/b-inary/desktop-postflop/releases/tag/${src.rev}";
    description = "Free, open-source GTO solver for Texas hold'em poker";
    homepage = "https://github.com/b-inary/desktop-postflop";
    license = lib.licenses.agpl3Plus;
    mainProgram = "desktop-postflop";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
