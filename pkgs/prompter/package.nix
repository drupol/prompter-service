{
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "prompter";
  version = "unstable-2025-03-20";

  src = fetchFromGitHub {
    owner = "netlooker";
    repo = "prompter";
    rev = "24167cf949ff5d4cb9437d3984b1a21464931116";
    hash = "sha256-7xq78cBonsrZL/sTFVvmkh639jeMUJZ9YIowAi7L6Lg=";
  };

  npmDepsHash = "sha256-pZ+AMxcuZe7Ic++52rhidzMnA4w+aOFB9guwUrjtDNE=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/prompter

    runHook postInstall
  '';
}
