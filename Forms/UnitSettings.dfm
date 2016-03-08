object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Settings'
  ClientHeight = 201
  ClientWidth = 312
  Color = clBtnFace
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
    201)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 100
    Top = 141
    Width = 117
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Parallel download count:'
    ExplicitTop = 164
  end
  object CheckUpdateBtn: TCheckBox
    Left = 8
    Top = 8
    Width = 140
    Height = 19
    Caption = 'Check updates on start'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object OpenOutBtn: TCheckBox
    Left = 8
    Top = 33
    Width = 277
    Height = 19
    Caption = 'Open output folder after the download is completed'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object sButton1: TButton
    Left = 223
    Top = 168
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 2
    OnClick = sButton1Click
  end
  object DontDoubleDownloadBtn: TCheckBox
    Left = 8
    Top = 58
    Width = 224
    Height = 19
    Caption = 'Don'#39't download already downloaded files'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object DownloadVideoBtn: TCheckBox
    Left = 8
    Top = 83
    Width = 274
    Height = 19
    Caption = 'Download videos too (May increase download time)'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object ThreadList: TComboBox
    Left = 223
    Top = 138
    Width = 81
    Height = 21
    Style = csDropDownList
    Anchors = [akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
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
  object DontCheckBtn: TCheckBox
    Left = 8
    Top = 108
    Width = 237
    Height = 19
    Caption = 'Don'#39't check files after download is completed'
    TabOrder = 6
  end
end
