{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  itstool,
  python3,
  libxml2,
  desktop-file-utils,
  wrapGAppsHook3,
  gst_all_1,
  pulseaudio,
  gtk3,
  glib,
  glibmm,
  gtkmm3,
  lilv,
  lv2,
  serd,
  sord,
  sratom,
  libbs2b,
  libsamplerate,
  libsndfile,
  libebur128,
  rnnoise,
  boost,
  dbus,
  fftwFloat,
  calf,
  zita-convolver,
  zam-plugins,
  rubberband,
  lsp-plugins,
}:

let
  lv2Plugins = [
    calf # limiter, compressor exciter, bass enhancer and others
    lsp-plugins # delay
  ];
  ladspaPlugins = [
    rubberband # pitch shifting
    zam-plugins # maximizer
  ];
in
stdenv.mkDerivation {
  pname = "pulseeffects";
  version = "4.8.7-unstable-2024-09-17";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "pulseeffects";
    rev = "fbe0a724c1405cee624802f381476cf003dfcfa";
    hash = "sha256-tyVUWc8w08WUnJRTjJVTIiG/YBWTETNYG+4amwEYezY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxml2
    itstool
    python3
    desktop-file-utils
    wrapGAppsHook3
  ];

  buildInputs = [
    pulseaudio
    glib
    glibmm
    gtk3
    gtkmm3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base # gst-fft
    gst_all_1.gst-plugins-good # pulsesrc
    gst_all_1.gst-plugins-bad
    lilv
    lv2
    serd
    sord
    sratom
    libbs2b
    libebur128
    libsamplerate
    libsndfile
    rnnoise
    boost
    dbus
    fftwFloat
    zita-convolver
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
      --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
    )
  '';

  meta = with lib; {
    description = "Limiter, compressor, reverberation, equalizer and auto volume effects for Pulseaudio applications";
    mainProgram = "pulseeffects";
    homepage = "https://github.com/wwmm/pulseeffects";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
