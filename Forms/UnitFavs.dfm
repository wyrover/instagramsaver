object FavForm: TFavForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Favourites'
  ClientHeight = 197
  ClientWidth = 646
  Color = 5066061
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
  DesignSize = (
    646
    197)
  PixelsPerInch = 96
  TextHeight = 13
  object FavList: TsCheckListBox
    Left = 8
    Top = 35
    Width = 630
    Height = 123
    Hint = 
      'List of your favourite Instagram accounts. Check ones will be do' +
      'wnloaded'
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsSingle
    Color = 15917239
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MultiSelect = True
    ParentFont = False
    TabOrder = 0
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'Tahoma'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    OnClickCheck = FavListClickCheck
  end
  object NewFavEdit: TsEdit
    Left = 128
    Top = 8
    Width = 429
    Height = 21
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    Color = 15917239
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TextHint = 'New favourite account'
    OnKeyDown = NewFavEditKeyDown
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'New favourite account:'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'Tahoma'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
  end
  object AddBtn: TsBitBtn
    Left = 563
    Top = 8
    Width = 75
    Height = 21
    Hint = 'Add this as a new account'
    Anchors = [akTop, akRight]
    Caption = 'Add'
    TabOrder = 2
    OnClick = AddBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object SaveBtn: TsButton
    Left = 563
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 3
    OnClick = SaveBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object CancelBtn: TsButton
    Left = 482
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = CancelBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object ClearBtn: TsButton
    Left = 8
    Top = 164
    Width = 75
    Height = 25
    Hint = 'Remove all favourites'
    Anchors = [akLeft, akBottom]
    Caption = 'Clear Favs'
    TabOrder = 5
    OnClick = ClearBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object RemoveBtn: TsButton
    Left = 89
    Top = 164
    Width = 75
    Height = 25
    Hint = 'Remove selected favourites'
    Anchors = [akLeft, akBottom]
    Caption = 'Remove'
    TabOrder = 6
    OnClick = RemoveBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object UpBtn: TsButton
    Left = 170
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Move Up'
    TabOrder = 7
    OnClick = UpBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object DownBtn: TsButton
    Left = 251
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Move Down'
    TabOrder = 8
    OnClick = DownBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object DownloadBtn: TsButton
    Left = 351
    Top = 164
    Width = 125
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Download Selected'
    TabOrder = 9
    OnClick = DownloadBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 240
    Top = 64
  end
end
