{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gnome,
  libgtop,
  gtk4,
  libadwaita,
  pango,
  pcre2,
  vte-gtk4,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "gnome-console";
  version = "48.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-console/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-AY6Qjk2uvPyxUNTxuyjZgnKqnRTWgV6vjaRfiJ2wXEk=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libgtop
    gtk4
    libadwaita
    pango
    pcre2
    vte-gtk4
  ];

  preFixup = ''
    # FIXME: properly address https://github.com/NixOS/nixpkgs/pull/333911#issuecomment-2362710334
    # and https://gitlab.gnome.org/GNOME/console/-/commit/c81801c82f186f20
    gappsWrapperArgs+=(--set "TERM" "xterm-256color")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-console";
    };
  };

  passthru.tests.test = nixosTests.terminal-emulators.kgx;

  meta = with lib; {
    description = "Simple user-friendly terminal emulator for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/console";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zhaofengli ];
    teams = [ teams.gnome ];
    platforms = platforms.unix;
    mainProgram = "kgx";
  };
}
