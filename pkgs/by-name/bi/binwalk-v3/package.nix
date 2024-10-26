{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "binwalk-v3";
  version = "10d233d4cddce8419789bd35740bde6684ffa9f0";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    rev = "${version}";
    sha256 = "sha256-5YkJ8aWFMcf77+DccMHjdX9S+OgLY5p/HOTZL3YHUVI=";
  };

  cargoHash = "sha256-rU89YxsK/gyTLVgCNt9tErtfmYUMxHRYV2wjTFG1FAE=";

  meta = {
    description = "Firmware Analysis Tool";
    homepage = "https://github.com/ReFirmLabs/binwalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexandru0-dev ];
  };
}
