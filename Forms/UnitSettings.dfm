object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Settings'
  ClientHeight = 224
  ClientWidth = 312
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
    312
    224)
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
    Width = 277
    Height = 19
    Caption = 'Open output folder after the download is completed'
    Checked = True
    State = cbChecked
    TabOrder = 1
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object sButton1: TsButton
    Left = 223
    Top = 191
    Width = 81
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
    Left = 223
    Top = 164
    Width = 81
    Height = 21
    Anchors = [akRight, akBottom]
    Alignment = taLeftJustify
    BoundLabel.Active = True
    BoundLabel.Caption = 'Look:'
    SkinData.SkinSection = 'COMBOBOX'
    VerticalAlignment = taAlignTop
    Style = csDropDownList
    Color = 16768656
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
      'Light'
      'None')
  end
  object ThreadList: TsComboBox
    Left = 134
    Top = 164
    Width = 51
    Height = 21
    Anchors = [akRight, akBottom]
    Alignment = taCenter
    BoundLabel.Active = True
    BoundLabel.Caption = 'Parallel download count:'
    SkinData.SkinSection = 'COMBOBOX'
    VerticalAlignment = taAlignTop
    Style = csDropDownList
    Color = 16768656
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 0
    ParentFont = False
    TabOrder = 6
    Text = '1'
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
  end
  object DontCheckBtn: TsCheckBox
    Left = 8
    Top = 108
    Width = 237
    Height = 19
    Caption = 'Don'#39't check files after downlod is completed'
    TabOrder = 7
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object WaitEdit: TsSpinEdit
    Left = 234
    Top = 133
    Width = 70
    Height = 21
    Alignment = taCenter
    Color = 16768656
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    NumbersOnly = True
    ParentFont = False
    TabOrder = 8
    Text = '0'
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Wait between downloads to prevent ban (ms):'
    MaxValue = 0
    MinValue = 0
    Value = 0
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    FormHeader.AdditionalHeight = 0
    SkinData.SkinSection = 'PANEL'
    TitleButtons = <>
    Left = 208
    Top = 32
  end
end
