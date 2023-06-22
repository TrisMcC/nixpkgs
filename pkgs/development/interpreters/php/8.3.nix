{ callPackage, fetchurl, fetchpatch, ... }@_args:

let
  base = (callPackage ./generic.nix (_args // {
    version = "8.3.0-alpha2";
    hash = null;
  })).overrideAttrs (oldAttrs: {
    src = fetchurl {
      url = "https://downloads.php.net/~eric/php-8.3.0alpha2.tar.xz";
      hash = "sha256-YLCxgiDcsBisOmAodf0h8HyaCIh+4i1Q7QZw/h4KR5I=";
    };

    patches = oldAttrs.patches ++ [
      # Fix GH-11529: Crash after dealing with an Apache request
      # To be removed in next alpha
      # See https://github.com/php/php-src/issues/11529
      (fetchpatch {
        url = "https://github.com/php/php-src/commit/8d4370954ec610164a4503431bb0c52da6954aa7.patch";
        sha256 = "sha256-w1uF9lRdfhz9I0gux0J4cvMzNS93uSHL1fYG23VLDPc=";
      })
    ];
  });
in
base.withExtensions ({ all, ... }: with all; ([
  bcmath
  calendar
  curl
  ctype
  dom
  exif
  fileinfo
  filter
  ftp
  gd
  gettext
  gmp
  iconv
  imap
  intl
  ldap
  mbstring
  mysqli
  mysqlnd
  opcache
  openssl
  pcntl
  pdo
  pdo_mysql
  pdo_odbc
  pdo_pgsql
  pdo_sqlite
  pgsql
  posix
  readline
  session
  simplexml
  sockets
  soap
  sodium
  sysvsem
  sqlite3
  tokenizer
  xmlreader
  xmlwriter
  zip
  zlib
]))
