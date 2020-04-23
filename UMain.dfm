object FMain: TFMain
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'QuickView'
  ClientHeight = 106
  ClientWidth = 135
  Color = clBlack
  TransparentColorValue = 1
  ParentFont = True
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = RMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RMenu: TPopupMenu
    Top = 1
    object NewWinItem: TMenuItem
      Caption = '&New Window...'
      ShortCut = 16462
      OnClick = NewWinItemClick
    end
    object FileMenu: TMenuItem
      Caption = '&Open...'
      ShortCut = 16463
      OnClick = FileMenuClick
    end
    object ViewMenu: TMenuItem
      Caption = '&View as'
      object View200: TMenuItem
        Tag = 200
        Caption = '200%'
        RadioItem = True
        OnClick = PercentClick
      end
      object View100: TMenuItem
        Tag = 100
        Caption = '100%'
        Checked = True
        RadioItem = True
        OnClick = PercentClick
      end
      object View075: TMenuItem
        Tag = 75
        Caption = '75%'
        RadioItem = True
        OnClick = PercentClick
      end
      object View050: TMenuItem
        Tag = 50
        Caption = '50%'
        RadioItem = True
        OnClick = PercentClick
      end
      object View025: TMenuItem
        Tag = 25
        Caption = '25%'
        RadioItem = True
        OnClick = PercentClick
      end
      object View010: TMenuItem
        Tag = 10
        Caption = '10%'
        RadioItem = True
        OnClick = PercentClick
      end
    end
    object PercentMenu: TMenuItem
      Caption = '&Resize...'
      OnClick = PercentMenuClick
    end
    object TransMenu: TMenuItem
      Caption = '&Transparent...'
      OnClick = TransMenuClick
    end
    object VFlip: TMenuItem
      Caption = '&Vertical Flip'
      OnClick = VFlipClick
    end
    object HFlip: TMenuItem
      Caption = '&Horizontal Flip'
      OnClick = HFlipClick
    end
    object Pin: TMenuItem
      Caption = '&Pin'
      OnClick = PinClick
    end
    object ExitMenu: TMenuItem
      Caption = 'E&xit'
      ShortCut = 27
      OnClick = ExitMenuClick
    end
  end
  object OpenBmpDlg: TOpenPictureDialog
    FileName = 'sample.bmp'
    Left = 30
    Top = 1
  end
end
