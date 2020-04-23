QuickView v2.8

  This is a tiny picture viewer application.
  Easy to use.
  Supported .bmp,.jpg,.gif,.png picture format.
  Unsupported animation gif.

Usage

  1. Picture file (.bmp,.jpg,.gif,.png) drag and drop to this program.
  2. Select the [Open...] menu item from right click pulldown menu.
  3. Give picture file name from command line argument.
     e.g.  > QuickView.exe E:\pic\foo.png

Right click pulldown menu

  1. [New Window...]   (ctrl+N)
     Open picture file to new window.
  2. [Open...]         (ctrl+O)
     Open picture file to current window.
  3. [View as]
     To select zoom percentage.
  4. [Transparent...]
     Transparent mode. (0-255)
  5. [Exit]            (Esc)
     Quit the program.

Initialize file (QuickView.ini)

  Background - Set default background picture.(only BMP file)
  Icon - Set application icon.
  Title - Set window title.
  HideCaption - set '1' to hide window caption.
  NoTitle - Set '1' to hide window title text on titlebar.
  NoPictureName - Set '1' to only show Title on titlebar.
  NoTaskbarTitle - Set '1' to hide taskbar button.
  DisableMinimize - Set '1' to disable minimize button on titlebar.

Download

  See this site.
     http://jundai.deviantart.com/art/QuickView-129693435

  Get executable package from this link.
     https://www.dropbox.com/s/3kl7nufyns89ain/QuickView-2.8.zip?dl=0

  Get source code from this link.
     https://www.dropbox.com/s/yarwl4uj7fg6vym/QuickView-2.8-src.zip?dl=0

License

  Creative Commons Zero(CC0)
     http://creativecommons.org/publicdomain/zero/1.0/

Copyright

  TPNGImage Copyright (c) Gustavo Huffenbacher Daud
     http://pngdelphi.sourceforge.net/

  TGIFImage Copyright (c) Finn Tolderlund
     http://finn.mobilixnet.dk/delphi/

ChangeLog

  1.0 - 16.07.2009
     Initial Release.

  2.0 - 08.01.2010
     Bug Fix: The window flickers fixed.
     Bug Fix: Minimize to taskbar fixed.
     Feature: Set window title in configuration file.

  2.1 - 28.01.2010
     Bug Fix: The window flickers fixed. (again)
     Bug Fix: 'New Window' file select dialog fixed.
     Bug Fix: 'New Window' could not load .ini file fixed.

  2.2 - 09.12.2010
     Feature: Show/Hide window caption in configuration file.

  2.3 - 06.02.2012
     Feature: Add some shortcut keys.
     Feature: Show/Hide window title text in configuration file.

  2.4 - 10.04.2012
     Bug Fix: Problem load PNG picutre after another picture type.
     Feature: Enable/Disable minimize button on titlebar.

  2.5 - 31.05.2012
     Bug Fix: Problem load images, when file name extention has
              upper case / lower case combination.

  2.6 - 19.12.2012
     Feature: Show/Hide picture file name on title text
              in configuration file.

  2.7 - 21.12.2012
     Bug Fix: Problem load image has space in filename on startup.
     Feature: Add 'readme_jp.txt' and 'QuickView_jp.ini'.
              (Translated to Japanese)

  2.8 - 21.01.2013
     Bug Fix: Problem load configuration file has space in filename.
     Feature: Show/Hide taskbar button.

