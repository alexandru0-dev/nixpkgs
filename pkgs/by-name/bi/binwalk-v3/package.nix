{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  pkg-config,
  fontconfig,
}:

rustPlatform.buildRustPackage rec {
  pname = "binwalk-v3";
  version = "5ef95bf9b40409a8ea6a9b0c85f52b249a3ef861";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    rev = "${version}";
    sha256 = "sha256-XBFo0g4ZJZBWdEr7LwjEq3KHz1wceOCvBE5pt8V+fBg=";
  };

  cargoHash = "sha256-3DCwnthZEF7DAo5unhQ9WlHcToGUtJDfJrVPxvvmxWc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fontconfig ];

  # skip broken tests
  checkFlags = [
    "--skip=binwalk::Binwalk"
    "--skip=binwalk::Binwalk::analyze"
    "--skip=binwalk::Binwalk::extract"
    "--skip=binwalk::Binwalk::scan"
  ];

  passthru.tests.can-print-version = [ versionCheckHook ];

  meta = {
    description = "Firmware Analysis Tool";
    homepage = "https://github.com/ReFirmLabs/binwalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexandru0-dev ];
  };
}
