object FavForm: TFavForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Favourites'
  ClientHeight = 456
  ClientWidth = 654
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FavList: TCheckListBox
    Left = 0
    Top = 65
    Width = 654
    Height = 391
    Hint = 
      'List of your favourite Instagram accounts. Check ones will be do' +
      'wnloaded'
    OnClickCheck = FavListClickCheck
    Align = alClient
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 654
    Height = 65
    Align = alTop
    TabOrder = 1
    object AddBtn: TBitBtn
      Left = 1
      Top = 1
      Width = 75
      Height = 63
      Hint = 'Add this as a new account'
      Align = alLeft
      Caption = 'Add'
      TabOrder = 0
      OnClick = AddBtnClick
    end
    object CancelBtn: TButton
      Left = 576
      Top = 1
      Width = 75
      Height = 63
      Align = alLeft
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object ClearBtn: TButton
      Left = 76
      Top = 1
      Width = 75
      Height = 63
      Hint = 'Remove all favourites'
      Align = alLeft
      Caption = 'Clear Favs'
      TabOrder = 2
      OnClick = ClearBtnClick
    end
    object DownBtn: TButton
      Left = 301
      Top = 1
      Width = 75
      Height = 63
      Align = alLeft
      Caption = 'Move Down'
      TabOrder = 3
      OnClick = DownBtnClick
    end
    object DownloadBtn: TButton
      Left = 376
      Top = 1
      Width = 125
      Height = 63
      Align = alLeft
      Caption = 'Download Selected'
      TabOrder = 4
      OnClick = DownloadBtnClick
    end
    object RemoveBtn: TButton
      Left = 151
      Top = 1
      Width = 75
      Height = 63
      Hint = 'Remove selected favourites'
      Align = alLeft
      Caption = 'Remove'
      TabOrder = 5
      OnClick = RemoveBtnClick
    end
    object SaveBtn: TButton
      Left = 501
      Top = 1
      Width = 75
      Height = 63
      Align = alLeft
      Caption = 'Save'
      TabOrder = 6
      OnClick = SaveBtnClick
    end
    object UpBtn: TButton
      Left = 226
      Top = 1
      Width = 75
      Height = 63
      Align = alLeft
      Caption = 'Move Up'
      TabOrder = 7
      OnClick = UpBtnClick
    end
  end
end
