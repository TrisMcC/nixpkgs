{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions = if stdenv.isLinux then {
    stable = "0.0.27";
    ptb = "0.0.42";
    canary = "0.0.161";
    development = "0.0.216";
  } else {
    stable = "0.0.273";
    ptb = "0.0.59";
    canary = "0.0.283";
    development = "0.0.8778";
  };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        sha256 = "sha256-6fHaiPBcv7TQVh+TatIEYXZ/LwPmnCmU/QWXKFgUR7U=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        sha256 = "ZAMyAqyFEBJeTUqQzr5wK+BOFGURqhoHL8w2hJvL0vI=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        sha256 = "sha256-jX7+tDACTzDqDIzL2VuQPHcdMBth6wbHJ4zfVJJmJ68=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        sha256 = "sha256-lQnIQC7Wek7OYDzZvLIJfb8I4oATD8pSB+mjQMPyqYQ=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        sha256 = "1vz2g83gz9ks9mxwx7gl7kys2xaw8ksnywwadrpsbj999fzlyyal";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        sha256 = "sha256-LS7KExVXkOv8O/GrisPMbBxg/pwoDXIOo1dK9wk1yB8=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        sha256 = "0mqpk1szp46mih95x42ld32rrspc6jx1j7qdaxf01whzb3d4pi9l";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        sha256 = "sha256-K4rlShYhmsjT2QHjb6+IbCXJFK+9REIx/gW68bcVSVc=";
      };
    };
    aarch64-darwin = x86_64-darwin;
  };
  src = srcs.${stdenv.hostPlatform.system}.${branch};

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discordapp.com/";
    downloadPage = "https://discordapp.com/download";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ MP2E Scrumplex artturin infinidoge jopejoe1 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
  package =
    if stdenv.isLinux
    then ./linux.nix
    else ./darwin.nix;

  openasar = callPackage ./openasar.nix { };

  packages = (
    builtins.mapAttrs
      (_: value:
        callPackage package (value
          // {
          inherit src version openasar branch;
          meta = meta // { mainProgram = value.binaryName; };
        }))
      {
        stable = rec {
          pname = "discord";
          binaryName = "Discord";
          desktopName = "Discord";
        };
        ptb = rec {
          pname = "discord-ptb";
          binaryName = if stdenv.isLinux then "DiscordPTB" else desktopName;
          desktopName = "Discord PTB";
        };
        canary = rec {
          pname = "discord-canary";
          binaryName = if stdenv.isLinux then "DiscordCanary" else desktopName;
          desktopName = "Discord Canary";
        };
        development = rec {
          pname = "discord-development";
          binaryName = if stdenv.isLinux then "DiscordDevelopment" else desktopName;
          desktopName = "Discord Development";
        };
      }
  );
in
packages.${branch}
