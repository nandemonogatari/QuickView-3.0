QuickView v2.8

  画像を表示するだけの画像ビューアです。
  BMP, JPEG, GIF, PNGの画像フォーマットに対応しています。
  (アニメーションGIFは未対応です)

使い方

  1. 画像ファイルをこのプログラムにドラッグ＆ドロップします。
  2. 「Open...」メニューからのダイアログでファイルを指定します。
  3. コマンドライン引数で画像を指定します。
     例: > QuickView.exe E:\pic\hoge.jpg

右クリックメニューについて

  1. [New Window...]   (ctrl+N)
     画像をダイアログで指定して新しいウィンドウで開きます。
  2. [Open...]         (ctrl+O)
     Open picture file to current window.
     画像をダイアログで指定して開きます。
  3. [View as]
     画像の表示比率をパーセントで指定します。
  4. [Transparent...]
     ウィンドウを透過します。(0～255で透過具合を指定します)
  5. [Exit]            (Esc)
     プログラムを終了します。

設定ファイルについて (QuickView.ini)

  QuickView_jp.iniをQuickView.iniにリネームして使ってください。

  項目の説明:
    Background      プログラム起動時の背景として使用する画像を指定します。
                    (BMP画像のみ指定可能)
    Icon            プログラムのアイコンとして使用するアイコンファイルを指定します。
    Title           プログラムのタイトルをしてします。
    HideCaption     「1」を指定するとウィンドウ枠のない画像のみのウィンドウになります。
                    (「0」は普通のウィンドウになります)
    NoTitle         「1」を指定するとタイトルバーに何も表示しません。
                    (「0」はタイトルバーにファイル名とTitleで指定したタイトルが表示されます)
    NoPictureName   「1」を指定するとタイトルバーにはTitleで指定したタイトルのみ表示されます
                    (「0」はタイトルバーにファイル名とTitleで指定したタイトルが表示されます)
    NoTaskbarTitle  「1」を指定するとタスクバーボタンを表示しません。
                    (「0」はタスクバーボタンを表示します)
    DisableMinimize 「1」を指定するとタイトルバーの最小化ボタンを無効にします。
                    タイトルバーには閉じるボタンのみ表示されます。
                    (「0」は最小化ボタンが有効で最大化ボタンが無効の状態です)

ダウンロード方法

  私のHPからダウロード可能です。(英語) 
     http://jundai.deviantart.com/art/QuickView-129693435

  実行ファイルはこちらのリンクにあります。
     https://www.dropbox.com/s/3kl7nufyns89ain/QuickView-2.8.zip?dl=0

  ソースファイルはこちらのリンクからダウンロード可能です。
     https://www.dropbox.com/s/yarwl4uj7fg6vym/QuickView-2.8-src.zip?dl=0

ライセンスについて

  Creative Commons Zero(CC0)にて公開しています。
  詳しくはこちらのリンクをご覧ください。(英語)
     http://creativecommons.org/publicdomain/zero/1.0/

著作権

  TPNGImage Copyright (c) Gustavo Huffenbacher Daud
     http://pngdelphi.sourceforge.net/

  TGIFImage Copyright (c) Finn Tolderlund
     http://finn.mobilixnet.dk/delphi/

改版履歴

  1.0 - 2009/07/16
     最初のリリース

  2.0 - 2010/01/08
     Bug Fix: ウィンドウのちらつきを改善した。
     Bug Fix: 最小化時の不具合を改善した。
     Feature: プログラムのタイトルを設定ファイルで指定出来るようにした。

  2.1 - 2010/01/28
     Bug Fix: ウィンドウのちらつきを改善した。
     Bug Fix: 「New Window」時のファイル指定ダイアログの不具合を改善した。
     Bug Fix: 「New Window」時にウィンドウを開く際に設定ファイルを読込まないことがある不具合を改善した。

  2.2 - 2010/12/09
     Feature: ウィンドウ枠の表示/非表示を設定ファイルで指定出来るようにした。

  2.3 - 2012/02/06
     Feature: 右クリックメニューのいくつかの項目にキーを割当てた。
     Feature: タイトルバーのタイトルの表示/非表示を設定ファイルでして出来るようにした。

  2.4 - 2012/04/10
     Bug Fix: PNG画像を開くときに上手く開けなかった不具合を改善した。
     Feature: 最小化ボタンの有効/無効を設定ファイルで指定出来るようにした。

  2.5 - 2012/05/31
     Bug Fix: ファイルの拡張子が大文字・小文字が混じっているときに画材が表示出来ない不具合を改善した。

  2.6 - 2012/12/19
     Feature: タイトルバーの画像ファイル名を表示/非表示を設定ファイルで指定出来るようにした。

  2.7 - 2012/12/21
     Bug Fix: 起動時にファイル指定でファイル名にスペースがあるときに画像が表示されない不具合を改善した。
     Feature: 日本語のreadme.txtと設定ファイルを用意した。

  2.8 - 2013/01/21
     Bug Fix: 起動時に設定ファイル名にスペースがあると読込まない不具合を改善した。
     Feature: タスクバーボタンの表示/非表示を設定ファイルで指定出来るようにした。

