{...}:
let
  # === Archive / Compressed files ===
  archiveMimes = [
    "application/zip"             # .zip
    "application/x-tar"           # .tar
    "application/x-bzip2"         # .bz2, .tbz
    "application/x-gzip"          # .gz, .tgz
    "application/x-7z-compressed" # .7z
    "application/x-rar"           # .rar
    "application/x-lzma"          # .lzma
    "application/x-lz4"           # .lz4
    "application/x-xz"            # .xz
  ];

  # === Audio MIME types ===
  audioMimes = [
    # Common formats
    "audio/mpeg"              # .mp3
    "audio/mp4"               # .mp4 audio
    "audio/aac"               # .aac
    "audio/ac3"               # .ac3
    "audio/x-mp3"             # .mp3
    "audio/x-m4a"             # .m4a
    "audio/x-ms-wma"          # .wma
    "audio/flac"              # .flac
    "audio/x-flac"            # .flac
    "audio/x-ape"             # .ape
    "audio/x-aiff"            # .aiff
    "audio/x-wav"             # .wav
    "audio/vnd.wave"          # .wav
    "audio/mod"               # .mod
    "audio/x-it"              # .it
    "audio/x-s3m"             # .s3m
    "audio/x-stm"             # .stm
    "audio/xm"                # .xm
    "audio/basic"             # .au
    "audio/midi"              # .midi
    "audio/x-midi"            # .midi
    "audio/ogg"               # .ogg
    "audio/opus"              # .opus
    "audio/vorbis"            # .vorbis
    "audio/x-vorbis+ogg"      # .ogg
    "audio/vnd.rn-realaudio"  # .ra
    "audio/webm"              # .webm

    # Less common formats
    "audio/x-8svx"            # .8svx
    "audio/x-ape"             # .ape
    "audio/x-mod"             # .mod
    "audio/x-s3m"             # .s3m
    "audio/x-stm"             # .stm
    "audio/xm"                # .xm
    "audio/x-ms-wax"          # .wax
    "audio/x-ms-wma"          # .wma
    "audio/x-ogg"             # .ogg
    "audio/x-scpls"           # .pls
    "audio/x-mpegurl"         # .m3u
    "audio/3gpp"              # .3gp
    "audio/3gpp2"             # .3g2
    "audio/x-matroska"        # .mka
    "audio/x-flac"            # .flac
    "audio/x-ape"             # .ape
    "audio/x-m4a"             # .m4a
    "audio/x-ogg"             # .ogg
    "audio/x-scpls"           # .pls
    "audio/x-mpegurl"         # .m3u
    "audio/opus"              # .opus
    "audio/3gpp"              # .3gp
    "audio/3gpp2"             # .3g2
  ];

  # === Video MIME types ===
  videoMimes = [
    # Common formats
    "video/mp4"               # .mp4
    "video/x-matroska"        # .mkv
    "video/x-msvideo"         # .avi
    "video/quicktime"         # .mov
    "video/webm"              # .webm
    "video/x-flv"             # .flv
    "video/x-m4v"             # .m4v
    "video/x-vob"             # .vob

    # Less common formats
    "video/3gpp"                        # .3gp
    "video/3gpp2"                       # .3g2
    "video/ogg"                         # .ogv
    "video/x-ms-wmv"                    # .wmv
    "video/x-ms-asf"                    # .asf
    "video/x-ms-wmx"                    # .wmx
    "video/x-ms-vwx"                    # .vwx
    "video/x-sgi-movie"                 # .movie
    "video/x-mng"                       # .mng
    "video/x-fli"                       # .fli
    "video/vnd.mpegurl"                 # .m3u8
    "video/vnd.ms-playready.media.pyv"  # .pyv
    "video/vnd.dece.video"              # .uvv, .uvvi
    "video/vnd.dece.sd"                 # .uvs, .uvvs
    "video/vnd.dece.hd"                 # .uvh, .uvvh
    "video/vnd.uvvu.mp4"                # .uvu
    "video/vnd.vivo"                    # .viv
    "video/x-f4v"                       # .f4v
    "video/x-jpeg"                      # .jpgv
    "video/x-dv"                        # .dv
    "video/vnd.radgamettools.smacker"   # .smk
    "video/vnd.radgamettools.bink"      # .bik
  ];

  # === Image MIME types ===
  imageMimes = [
    # Common formats
    "image/png"                 # .png
    "image/jpeg"                # .jpeg, .jpg
    "image/jpg"                 # .jpg
    "image/gif"                 # .gif
    "image/bmp"                 # .bmp
    "image/tiff"                # .tiff, .tif
    "image/webp"                # .webp
    "image/svg+xml"             # .svg
    "image/x-icon"              # .ico

    # Less common formats
    "image/cgm"               # .cgm
    "image/heif"              # .heif
    "image/heic"              # .heic
    "image/jxr"               # .jxr
    "image/avif"              # .avif
    "image/apng"              # .apng
    "image/x-icns"            # .icns
    "image/x-pcx"             # .pcx
    "image/x-png"             # .png
    "image/x-tiff"            # .tiff, .tif
    "image/x-xbitmap"         # .xbm
  ];

  # === Text ===
  textMimes = [
    "text/plain"            # .txt
    "text/x-python"         # .py
    "text/x-shellscript"    # .sh
    "text/x-c"              # .c
    "text/x-c++src"         # .cpp
    "text/x-java-source"    # .java
    "text/css"              # .css
    "text/javascript"       # .js
    "application/json"      # .json
    "application/xml"       # .xml
    "application/x-yaml"    # .yaml
    "text/markdown"         # .md
    "text/csv"              # .csv
  ];

  # === LibreOffice MIME types ===
  excelMimes = [
    "application/vnd.ms-excel"                                          # .xls
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" # .xlsx
    "application/vnd.oasis.opendocument.spreadsheet"                    # .ods
    "application/x-msexcel"                                             # legacy
  ];

  wordMimes = [
    "application/msword"                                                      # .doc
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" # .docx
    "application/vnd.oasis.opendocument.text"                                 # .odt
    "application/rtf"                                                         # .rtf
  ];

  powerpointMimes = [
    "application/vnd.ms-powerpoint"                                             # .ppt
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" # .pptx
    "application/vnd.oasis.opendocument.presentation"                           # .odp
  ];

  # === Godot Game engine ===
  godotMimes = [
    "application/x-godot-scene"        # .tscn
    "application/x-godot-packed-scene" # .scn
    "application/x-godot-resource"     # .tres
  ];

  # Helper function to map MIME types to a desktop app
  makeDefaults =
    mimeList: app:
    builtins.listToAttrs (
      map (mime: {
        name = mime;
        value = [ app ];
      }) mimeList
    );

  # Generate defaults
  archiveDefauls     = makeDefaults archiveMimes    "org.kde.ark.desktop";
  audioDefaults      = makeDefaults audioMimes      "amberol.desktop";
  videoDefaults      = makeDefaults videoMimes      "mpv.desktop";
  imageDefaults      = makeDefaults imageMimes      "gwenview.desktop";
  textDefaults       = makeDefaults textMimes       "org.kde.kate.desktop";
  excelDefaults      = makeDefaults excelMimes      "libreoffice-calc.desktop";
  wordDefaults       = makeDefaults wordMimes       "libreoffice-writer.desktop";
  powerpointDefaults = makeDefaults powerpointMimes "libreoffice-impress.desktop";
  godotDefaults      = makeDefaults godotMimes      "godot.desktop";

  # Established Defaults list
  defaults = {
    "inode/directory"       = [ "dolphin.desktop" ];
    "text/html"             = [ "vivaldi-stable.desktop" ];       # .html
    "application/pdf"       = [ "vivaldi-stable.desktop" ];       # .pdf
    "application/vnd.unity" = [ "unity.desktop" ];                # .unity, .unitypackage
    "image/x-krita"         = [ "krita.desktop" ];                # .kra
    "image/x-xcf"           = [ "gimp.desktop" ];                 # .xcf
    "image/x-inkscape-svg"  = [ "inkscape.desktop" ];             # inkscape .svg
    # Adobe Format Mimes
    "image/vnd.adobe.photoshop"         = [ "gimp.desktop" ];      # .psd
    "application/vnd.adobe.illustrator" = [ "inkscape.desktop" ];  # .ai
    # Drawio
    "application/vnd.jgraph.mxfile" = [ "drawio.desktop" ];
    "application/x-drawio"          = [ "drawio.desktop" ];
    "text/drawio"                   = [ "drawio.desktop" ];
  }
  // audioDefaults
  // videoDefaults
  // imageDefaults
  // textDefaults
  // excelDefaults
  // wordDefaults
  // powerpointDefaults
  // godotDefaults;
in
{
  xdg.mime = {
    enable = true;
    defaultApplications = defaults;
  };
}
