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
      package = lib.mkPackageOption pkgs "caddy" { };
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
      };
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
        command = "${lib.getExe cfg.package} file-server --listen ${cfg.host}:${builtins.toString cfg.port} --root ${cfg.root}";
      };
    };
}
