# QuickView-2.8-modified
Modification of [QuickView-2.8 by Jundai](https://www.deviantart.com/jundai/art/QuickView-129693435) to support transparent PNG files and more.

I have no idea how and why half of this works but it kinda works i guess. Titlebar is fucked i still have to fix that but main idea is to use it with HideCaption=1 aka no Titlebar (see init file options below).

Example for Transparent PNG with HideCaption=1:

![Screenshot](/screenshot.png)


  This is a tiny picture viewer application.
  Easy to use.
  Supported .bmp, .jpg, .gif, .png picture format.
  Unsupported animation gif.

Usage
```
  1. Picture file (.bmp, .jpg, .gif, .png) drag and drop to this program.
  2. Select the [Open...] menu item from right click pulldown menu.
  3. Give picture file name from command line argument.
     e.g.  > QuickView.exe E:\pic\foo.png
```
Right click pulldown menu
```
  1. [New Window...]   (ctrl+N)
     Open picture file to new window.
  2. [Open...]         (ctrl+O)
     Open picture file to current window.
  3. [View as]
     To select zoom percentage.
  4. [Resize...]
     Zoom percentage.
  4. [Transparent...]
     Transparent mode. (0-255)
  5. [Exit]            (Esc)
     Quit the program.
```
Initialize file (QuickView.ini)
```
  Background - Set default background picture.(only BMP file)
  Icon - Set application icon.
  Title - Set window title.
  HideCaption - set '1' to hide window caption.
  NoTitle - Set '1' to hide window title text on titlebar.
  NoPictureName - Set '1' to only show Title on titlebar.
  NoTaskbarTitle - Set '1' to hide taskbar button.
  DisableMinimize - Set '1' to disable minimize button on titlebar.
```
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
