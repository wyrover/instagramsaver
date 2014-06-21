object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Settings'
  ClientHeight = 165
  ClientWidth = 295
  Color = 5066061
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    295
    165)
  PixelsPerInch = 96
  TextHeight = 13
  object CheckUpdateBtn: TsCheckBox
    Left = 8
    Top = 8
    Width = 140
    Height = 19
    Caption = 'Check updates on start'
    Checked = True
    State = cbChecked
    TabOrder = 0
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object OpenOutBtn: TsCheckBox
    Left = 8
    Top = 33
    Width = 201
    Height = 19
    Caption = 'Open output after downloading files'
    Checked = True
    State = cbChecked
    TabOrder = 1
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object sButton1: TsButton
    Left = 212
    Top = 132
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 2
    OnClick = sButton1Click
    SkinData.SkinSection = 'BUTTON'
  end
  object DontDoubleDownloadBtn: TsCheckBox
    Left = 8
    Top = 58
    Width = 224
    Height = 19
    Caption = 'Don'#39't download already downloaded files'
    Checked = True
    State = cbChecked
    TabOrder = 3
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object DownloadVideoBtn: TsCheckBox
    Left = 8
    Top = 83
    Width = 274
    Height = 19
    Caption = 'Download videos too (May increase download time)'
    Checked = True
    State = cbChecked
    TabOrder = 4
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object SkinList: TsComboBox
    Left = 48
    Top = 108
    Width = 81
    Height = 21
    Alignment = taLeftJustify
    BoundLabel.Active = True
    BoundLabel.Caption = 'Look:'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'Tahoma'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'COMBOBOX'
    VerticalAlignment = taAlignTop
    Style = csDropDownList
    Color = 15917239
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 0
    ParentFont = False
    TabOrder = 5
    Text = 'Dark'
    OnChange = SkinListChange
    Items.Strings = (
      'Dark'
      'Light')
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'PANEL'
    TitleButtons = <>
    Left = 152
    Top = 104
  end
end
