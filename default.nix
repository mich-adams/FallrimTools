{
  lib,
  maven_4,
  nix-update-script,
  jdk,
  jre,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  description = "A powerful savegame editor/cleaner for Skyrim Legendary Edition, Skyrim Special Edition, and Fallout 4.";
in
maven_4.buildMavenPackage (finalAttrs: {
  pname = "resaver";
  version = "7.0.000";
  __structuredAttrs = true;
  strictDeps = true;

  src = ./.;
  mvnHash = "sha256-1hRVHt86cFiPWbsf4sg2qeO4SgH1KKBmVr/GxGFydJk=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [ jdk ];

  passthru.updateScript = nix-update-script { };

  desktopItems = makeDesktopItem {
    name = "ReSaver";
    desktopName = "ReSaver";
    comment = description;
    genericName = "Save Game Cleaner";
    exec = "resaver";
    icon = "computerjanitor";
    categories = [
      "Game"
      "Utility"
    ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/resaver
    install -Dm644 target/ReSaver.jar $out/share/resaver/resaver.jar

    makeWrapper ${lib.getExe jre} $out/bin/resaver --add-flags "-jar $out/share/resaver/resaver.jar"

    runHook postInstall
  '';

  meta = {
    inherit description;
    homepage = "https://www.nexusmods.com/skyrimspecialedition/mods/5031";
    license = lib.licenses.asl20;
    mainProgram = "resaver";
    platforms = lib.platforms.all;
  };
})
