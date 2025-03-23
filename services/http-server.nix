{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    services.http-server = {
      enable = lib.mkEnableOption "Enable HTTP Server";
      port = lib.mkOption {
        type = lib.types.int;
        default = 8080;
      };
      root = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config =
    let
      cfg = config.services.http-server;
    in
    lib.mkIf cfg.enable {
      settings.processes.http-server = {
        command = "${lib.getExe pkgs.python3} -m http.server ${builtins.toString cfg.port} -d ${cfg.root}";
      };
    };
}
