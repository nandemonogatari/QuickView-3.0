//
// QuickView - simple picture viewer.
//
// version 3.0 2020/04/23 nandemonogatari(https://github.com/nandemonogatari)
//
// from version 2.8  2012/12/25 Jundai(http://jundai.deviantart.com)
//

//
// Licence: CC0
//

unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Jpeg,
  ExtCtrls, Menus, ExtDlgs, IniFiles, ShellApi, Shlobj, ActiveX, StdCtrls,
  PNGImage, GIFImg;

const
  WS_EX_LAYERED = $80000;
  LWA_COLORKEY  = 1;
  LWA_ALPHA     = 2;

type
  TFMain = class(TForm)
    RMenu: TPopupMenu;
    FileMenu: TMenuItem;
    ExitMenu: TMenuItem;
    OpenBmpDlg: TOpenPictureDialog;
    TransMenu: TMenuItem;
    VFlip: TMenuItem;
    HFlip: TMenuItem;
    Pin: TMenuITem;
    PercentMenu: TMenuItem;
    NewWinItem: TMenuItem;
    ViewMenu: TMenuItem;
    View200: TMenuItem;
    View100: TMenuItem;
    View050: TMenuItem;
    View075: TMenuItem;
    View025: TMenuItem;
    View010: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure TransMenuClick(Sender: TObject);
    procedure PercentMenuClick(Sender: TObject);
    procedure VFlipClick(Sender: TObject);
    procedure HFlipClick(Sender: TObject);
    procedure PinClick(Sender: TObject);
    procedure PercentUpdate();
    procedure NewWinItemClick(Sender: TObject);
    procedure PercentClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    //ドラッグ＆ドロップ処理
    procedure WMDropFiles(var Msg : TWMDROPFILES);  message WM_DROPFILES;
  private
    { Private 宣言 }
    fSS_Dir           : String;
    fSS_Handle        : THandle;

    ImgView           : TBitmap;

    fIniFileName      : String;
    fBackGround       : String;
    fIcon             : String;
    fTitle            : String;

    fHideCaption      : Boolean;
    fXPos             : Integer;
    fYPos             : Integer;
    fMouseDown        : Boolean;
    fHideTitle        : Boolean;
    fHideFileName     : Boolean;
    fHideTaskbar      : Boolean;
    fDisableMinimize  : Boolean;

    procedure ReadProperties;
    function LoadFile(FileName: String): Boolean;
  public
    { Public 宣言 }
  end;

{フォルダの参照ダイアログ用コールバック関数}
function BrowseCallback(hWnd: HWND; uMsg: UINT; lParam: LPARAM; lpData: LPARAM): integer; stdcall; export;
function OpenFolderDialog(var FolderPath: string):Boolean;

var
  FMain: TFMain;

  po      : TFarProc;
  DLLWnd  : THandle;
  SetLayeredWindowAttributes :function(hwnd:HWND;crKey:DWORD;bAlpha:Byte;dwFlags:DWORD):Integer;stdcall;
  PercentSize: integer;
  VFlip_act: Bool;
  HFlip_act: Bool;
  NoDragging: Bool;

implementation

{$R *.DFM}

 {フォルダの参照ダイアログ用コールバック関数}
function BrowseCallback(hWnd: HWND; uMsg: UINT; lParam, lpData: LPARAM):integer;
var
  PathName: array[0..MAX_PATH] of Char;
begin
  Result := 0;
  case uMsg of
    {最初に表示するフォルダ}
    BFFM_INITIALIZED:begin
      SendMessage(hWnd, BFFM_SETSELECTION,1,LongInt(lpData));
    end;
    {フォルダ参照時にパスを表示}
    BFFM_SELCHANGED:begin
      SHGetPathFromIDList(PItemIDList(lParam), PathName);
      SendMessage(hWnd, BFFM_SETSTATUSTEXT, 0, LongInt(@PathName));
    end;
  end;
end;


{フォルダ参照ダイアログを開く}
function OpenFolderDialog(var FolderPath: string): Boolean;
var
  Malloc: IMalloc;
  BrowseInfo: TBrowseInfo;
  DisplayPath: array[0..MAX_PATH] of Char;
  IDList: PItemIdList;
  Buffer,pFolderPath: PChar;
begin
  Result := False;
  if Succeeded(SHGetMalloc(Malloc)) then
  begin //IMallocのポインタを取得できたら
    pFolderPath := pChar(FolderPath); //初期フォルダ指定用

    {BrowseInfo構造体を初期化}
    with BrowseInfo do
    begin
      hwndOwner := GetForegroundWindow();
      pidlRoot := nil;
      pszDisplayName := DisplayPath;  //表示名用バッファ
      lpszTitle := 'フォルダを選択して下さい。';
      //通常のフォルダのみ参照可能（特殊フォルダは参照できない）
      ulFlags := BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT;
      lpfn := @BrowseCallback; //コールバック関数指定
      lParam := LongInt(pFolderPath); //初期フォルダ指定
      iImage := 0;
    end;

    IDList := SHBrowseForFolder(BrowseInfo);//フォルダ参照ダイアログを表示
    if IDList<>nil then begin //値が返ってきたら
      Buffer := Malloc.Alloc(MAX_PATH); //フォルダパス取得用バッファ
      try
        SHGetPathFromIDList(IDList, Buffer);//フォルダパスを取得
        FolderPath := String(Buffer);
      finally
        Malloc.Free(Buffer);
      end;
      Malloc.Free(IDList);
      Result := True;
    end;
  end;
end;

procedure TFMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //ドラッグ＆ドロップ可能にする
  Params.ExStyle := Params.EXStyle + WS_EX_ACCEPTFILES;
  //半透明化可能にする
  //Params.ExStyle := Params.EXStyle + WS_EX_LAYERED;
end;

procedure TFMain.WMDropFiles(var Msg : TWMDROPFILES);
var
  DropFileName  : array[0..MAX_PATH] of Char;         //ドロップされたファイル名
  FileCnt       : Integer;                            //ドロップされたファイル数
  FullName      : array[0..MAX_PATH] of Char;
  F             : PChar;
  ErrMsg        : String;
begin
  //ドロップされたファイル数を得る
  FileCnt := DragQueryFile(Msg.Drop, $FFFFFFFF, DropFileName, SizeOf(DropFileName));
  //ドロップされた最後のファイル名を得る
  DragQueryFile(Msg.Drop, (FileCnt - 1), DropFileName, SizeOf(DropFileName));
  //ドラッグ＆ドロップのクエリを閉じる
  DragFinish(Msg.Drop);

  GetFullPathName(DropFileName, MAX_PATH, FullName, F);
  if not(FileExists(FullName)) then begin
    ErrMsg := FullName + ' が見つかりません';
    Application.MessageBox(PChar(ErrMsg), 'エラー', (MB_OK or MB_APPLMODAL or MB_ICONSTOP));
    Exit;
  end;
  LoadFile(FullName);
  //FormPaint(nil);
  PercentUpdate();
end;

procedure TFMain.ReadProperties;
var
  Profile: TIniFile;
begin
  Profile := TIniFile.Create(fIniFileName);
  with Profile do begin
    fBackGround := ReadString('Main', 'Background', 'sample.bmp');
    fIcon := ReadString('Main', 'Icon', 'QuickView.ico');
    fTitle := ReadString('Main', 'Title', 'QuickView');
    fHideCaption := ReadBool('Main', 'HideCaption', False);
    if fHideCaption then begin
      Self.BorderStyle := bsNone;
    end;
    fHideTitle := ReadBool('Main', 'NoTitle', False);
    fHideFileName := ReadBool('Main', 'NoPictureName', False);
    Application.MainFormOnTaskbar := ReadBool('Main', 'NoTaskbarTitle', False);
    fDisableMinimize := ReadBool('Main', 'DisableMinimize', False);
    Self.TransparentColor := ReadBool('Main', 'Transparency', False);
    if fDisableMinimize then begin
      Self.BorderIcons := Self.BorderIcons - [biMinimize];
    end;
  end;
  Profile.Free;
  if not(FileExists(fBackGround)) then begin
    fBackGround := '';
  end;
  if not(FileExists(fIcon)) then begin
    fIcon := '';
  end;
end;

function TFMain.LoadFile(FileName: String): Boolean;
var
  ExtName     : String;
  PngImg      : TPngImage;
  JpegImg     : TJpegImage;
  GifImg      : TGIFImage;
begin
  try
    ImgView.FreeImage;
    ExtName := ExtractFileExt(FileName);
    ExtName := LowerCase(ExtName);
    if (Pos('png', ExtName) <> 0) then begin
      PngImg := TPngImage.Create;
      PngImg.LoadFromFile(FileName);
      ImgView.Assign(PngImg);
      PngImg.Free;
    end
    else if (Pos('jpg', ExtName) <> 0) or
       (Pos('jpeg', ExtName) <> 0) then begin
      JpegImg := TJpegImage.Create;
      JpegImg.LoadFromFile(FileName);
      ImgView.Assign(JpegImg);
      JpegImg.Free;
    end
    else if (Pos('gif', ExtName) <> 0) then begin
      GifImg := TGifImage.Create;
      GifImg.LoadFromFile(FileName);
      ImgView.Assign(GifImg);
      GifImg.Free;
    end
    else begin
      ImgView.LoadFromFile(FileName);
    end;
    if (Length(fTitle) = 0) then begin
      if (fHideFileName) then begin
        Application.Title := '';
      end
      else begin
        Application.Title := ExtractFileName(FileName);
      end;
      Self.Caption := Application.Title;
    end
    else begin
      if (fHideFileName) then begin
        Application.Title := fTitle;
      end
      else begin
        Application.Title := ExtractFileName(FileName) + ' - ' + fTitle;
      end;
      Self.Caption := Application.Title;
    end;
    if (fHideTitle = True) then begin
      Self.Caption := '';
    end;
    result := True;
  except
    result := False;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
const
  WS_EX_LAYERED = $80000;
  LWA_COLORKEY  = 1;
  LWA_ALPHA     = 2;
var
  Idx         : Integer;
  CmdLineLen  : Integer;
  CmdLineStr  : PChar;
  QuoteStart  : PChar;
  QuoteEnd    : Pchar;
  FullName    : String;
  CurrentDir  : String;
begin
  CurrentDir := ExtractFilePath(Application.ExeName);
  SetCurrentDirectory(PChar(CurrentDir));

  fIniFileName := ChangeFileExt(PChar(Application.ExeName), '.ini');

  ReadProperties;

  fSS_Dir  := '';
  fSS_Handle := INVALID_HANDLE_VALUE;
  ImgView := TBitmap.Create;

  if (Length(fIcon) <> 0) then begin
    Application.Icon.LoadFromFile(fIcon);
    Self.Icon := Application.Icon;
  end;

  if (Length(fTitle) = 0) then begin
    Application.Title := '';
    Self.Caption := Application.Title;
  end
  else begin
    Application.Title := fTitle;
    Self.Caption := Application.Title;
  end;
  if (fHideTitle = True) then begin
    Self.Caption := '';
  end;

  PercentSize:= 100;
  VFlip_act:=False;
  HFlip_act:=False;
  NoDragging:=False;
  GIFImageDefaultAnimate := True;
  GIFImageDefaultTransparent := True;

  CmdLineStr := GetCommandLine;
  if (CmdLineStr = nil) then begin
    if (Length(fBackground) = 0) then begin
      Exit;
    end;
    if (LoadFile(fBackground)) then begin
      if (Length(fTitle) > 0) then begin
        Application.Title := fTitle;
        Self.Caption := Application.Title;
      end;
      if (fHideTitle = True) then begin
        Self.Caption := '';
      end;
      Exit;
    end;
  end;

  QuoteStart := StrScan(CmdLineStr, Char('"'));
  if (QuoteStart = nil) then begin
    CmdLineStr := StrPos(CmdLineStr, ' ');
  end
  else begin
    QuoteEnd := StrScan(QuoteStart+1, Char('"'));
    CmdLineStr := StrPos(QuoteEnd+1, ' ');
  end;

  if (CmdLineStr = nil) then begin
    if (Length(fBackground) = 0) then begin
      Exit;
    end;
    if (LoadFile(fBackground)) then begin
      if (Length(fTitle) > 0) then begin
        Application.Title := fTitle;
        Self.Caption := Application.Title;
      end;
      if (fHideTitle = True) then begin
        Self.Caption := '';
      end;
      Exit;
    end;
  end;

  CmdLineLen := Length(TrimRight(TrimLeft(CmdLineStr)));
  if (CmdLineLen < 1) then begin
    if (Length(fBackground) = 0) then begin
      Exit;
    end;
    if (LoadFile(fBackground)) then begin
      if (Length(fTitle) > 0) then begin
        Application.Title := fTitle;
        Self.Caption := Application.Title;
      end;
      if (fHideTitle = True) then begin
        Self.Caption := '';
      end;
      Exit;
    end;
  end;

  FullName := '';
  for Idx := 1 to CmdLineLen do begin
    if (CmdLineStr[Idx] = '"') then Continue;
    FullName := FullName + Char(CmdLineStr[Idx]);
  end;
  LoadFile(FullName);
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  if po <> nil then begin
    FreeLibrary(DLLWnd);
  end;
  if (fSS_Handle <> INVALID_HANDLE_VALUE) then begin
    Windows.FindClose(fSS_Handle);
  end;
  ImgView.Free;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  if (ImgView.Empty) then begin
    ClientHeight := 105;
    ClientWidth  := 105;
    Exit;
  end;
  ClientHeight := ImgView.Height;
  ClientWidth  := ImgView.Width;
  PercentSize:= 100;
  PercentUpdate();
end;

//Unused tbh
procedure TFMain.FormPaint(Sender: TObject);
var
//  Rect  : TRect;
  wView : TMenuItem;
begin
  wView := View100;
  if (View200.Checked) then begin
    wView := View200;
  end
  else if (View075.Checked) then begin
    wView := View075;
  end
  else if (View050.Checked) then begin
    wView := View050;
  end
  else if (View025.Checked) then begin
    wView := View025;
  end
  else if (View010.Checked) then begin
    wView := View010;
  end;
  PercentUpdate();
end;

procedure TFMain.ExitMenuClick(Sender: TObject);
begin
  Close;
end;

procedure TFMain.FileMenuClick(Sender: TObject);
var
  FullName    : String;
begin
  OpenBmpDlg.DefaultExt := '';
  OpenBmpDlg.Filter     := 'Picture Files|*.bmp;*.jpg;*.jpeg;*.png;*.gif';
  OpenBmpDlg.Execute;
  if (Length(OpenBmpDlg.FileName) = 0) then begin
    Exit;
  end;

  FullName := TrimRight(TrimLeft(OpenBmpDlg.FileName));
  LoadFile(FullName);
  //FormShow(nil);
  //FormPaint(nil);
  PercentUpdate();
end;

procedure TFMain.TransMenuClick(Sender: TObject);
var
  InputStr    : String;
  InputDigit  : Integer;
begin
  InputStr := InputBox(Self.Caption, '25 to 255', IntToStr(Self.AlphaBlendValue));
  InputDigit := StrToInt(InputStr);
  if (InputDigit < 25) then begin
    InputDigit := 25;
  end
  else if (InputDigit > 255) then begin
    InputDigit := 255;
  end;
  if (InputDigit < 255) then begin
    Self.AlphaBlend := True;
  end;
  Self.AlphaBlendValue := InputDigit;
end;

procedure TFMain.PercentMenuClick(Sender: TObject);
var
  InputStr    : String;
  InputDigit  : Integer;
begin
  PercentSize := (clientHeight div ImgView.Height) * 100;
  InputStr := InputBox(Self.Caption, 'size in %', IntToStr(PercentSize));
  InputDigit := StrToInt(InputStr);
  PercentSize := InputDigit;
  PercentUpdate();
end;

procedure TFMain.NewWinItemClick(Sender: TObject);
var
  FullName    : String;
begin
  OpenBmpDlg.DefaultExt := '';
  OpenBmpDlg.Filter     := 'Picture Files|*.bmp;*.jpg;*.jpeg;*.png;*.gif';
  OpenBmpDlg.Execute;
  if (Length(OpenBmpDlg.FileName) = 0) then begin
    Exit;
  end;

  FullName := TrimRight(TrimLeft(OpenBmpDlg.FileName));

  ShellExecute(GetDesktopWindow(), nil, PChar(Application.ExeName), PChar(FullName), PChar(ExtractFileDir(Application.ExeName)), SW_SHOWNORMAL);
end;

procedure TFMain.VFlipClick(Sender: TObject);
begin
  VFlip_act:= not VFlip_act;
  PercentUpdate();
end;

procedure TFMain.HFlipClick(Sender: TObject);
begin
  HFlip_act:= not HFlip_act;
  PercentUpdate();
end;

procedure TFMain.PercentUpdate();
var
  //Rect  : TRect;
  mRect, nRect: TRect;
begin
  if (ImgView.Empty) then begin
    ClientHeight := 105;
    ClientWidth  := 105;
  end
  else begin
    ClientHeight := (ImgView.Height * PercentSize) div 100;
    ClientWidth  := (ImgView.Width  * PercentSize) div 100;
  end;
  //Rect := GetClientRect;
  mRect := GetClientRect;
  nRect := GetClientRect;
  if (ImgView.Empty) then begin
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(mRect);
  end
  else begin
    canvas.brush.color:=$00000001;
    Canvas.fillrect(Canvas.ClipRect);
    mRect:= rect(0, 0, ClientWidth, ClientHeight);
    Canvas.StretchDraw(mRect, ImgView);
    if VFlip_act and not HFlip_act then begin
      nRect:=rect(0, ClientHeight-1, ClientWidth-1, 0); // Vertical flip
      Canvas.CopyRect(mRect, Canvas, nRect);
    end
    else if HFlip_act and not VFlip_act then begin
      nRect:=rect(ClientWidth-1, 0, 0, ClientHeight-1); // Horizontal flip
      Canvas.CopyRect(mRect, Canvas, nRect);
    end
    else if Hflip_act and VFlip_act then begin
      nRect:=rect(ClientWidth-1, ClientHeight-1, 0, 0); // Both flip
      Canvas.CopyRect(mRect, Canvas, nRect);
    end;
  end;
end;

//Unused, using PercentUpdate^^
procedure TFMain.PercentClick(Sender: TObject);
var
  Rect  : TRect;
begin
  if (Sender = nil) then Exit;
  PercentSize := TMenuItem(Sender).Tag;
  PercentUpdate();
  TMenuItem(Sender).Checked := True;
end;

procedure TFMain.PinClick(Sender: TObject);
begin
  NoDragging:= not NoDragging;
end;

procedure TFMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if NoDragging then Exit;
  fXPos := X;
  fYPos := Y;
  fMouseDown := True;
end;

procedure TFMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if NoDragging then Exit;
  if (ssLeft in Shift) and ((fXPos <> X) or (fYPos <> Y)) and fMouseDown then begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, SC_MOVE or 2, MakeLong(X, Y));
    fMouseDown := False;
  end;
end;

end.
