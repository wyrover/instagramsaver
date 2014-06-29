object FavForm: TFavForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Favourites'
  ClientHeight = 240
  ClientWidth = 429
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
  OnShow = FormShow
  DesignSize = (
    429
    240)
  PixelsPerInch = 96
  TextHeight = 13
  object FavList: TsCheckListBox
    Left = 8
    Top = 35
    Width = 413
    Height = 166
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
  end
  object NewFavEdit: TsEdit
    Left = 128
    Top = 8
    Width = 212
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
    Left = 346
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
    Left = 346
    Top = 207
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 3
    OnClick = SaveBtnClick
    SkinData.SkinSection = 'BUTTON'
    ExplicitTop = 329
  end
  object CancelBtn: TsButton
    Left = 265
    Top = 207
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = CancelBtnClick
    SkinData.SkinSection = 'BUTTON'
    ExplicitTop = 329
  end
  object ClearBtn: TsButton
    Left = 8
    Top = 207
    Width = 75
    Height = 25
    Hint = 'Remove all favourites'
    Anchors = [akLeft, akBottom]
    Caption = 'Clear Favs'
    TabOrder = 5
    SkinData.SkinSection = 'BUTTON'
    ExplicitTop = 333
  end
  object RemoveBtn: TsButton
    Left = 89
    Top = 207
    Width = 75
    Height = 25
    Hint = 'Remove selected favourites'
    Anchors = [akLeft, akBottom]
    Caption = 'Remove'
    TabOrder = 6
    OnClick = RemoveBtnClick
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
    Left = 184
    Top = 96
  end
end
