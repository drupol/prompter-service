{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
}:

buildNpmPackage {
  pname = "prompter";
  version = "unstable-2025-03-20";

  src = fetchFromGitHub {
    owner = "netlooker";
    repo = "prompter";
    rev = "a6ed59b9a2c875d5eab29447dcf11a656b53e12a";
    hash = "sha256-y6e9Ibg2HnTjtlOQvfSxcCv8Zl1C41vZrKS6cCQLSlY=";
  };

  # Upstream lock file is incorrect (to fix: npm i --package-lock-only)
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-p5XmtgMENGeuSLDuOFmDrrjmFTpNGU5F+ABX2kEyGXA=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/prompter

    runHook postInstall
  '';
}
