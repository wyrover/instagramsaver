object LogForm: TLogForm
  Left = 0
  Top = 0
  Caption = 'Logs (ESC to close)'
  ClientHeight = 300
  ClientWidth = 635
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
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object sPageControl1: TsPageControl
    Left = 0
    Top = 0
    Width = 635
    Height = 259
    ActivePage = sTabSheet1
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'PAGECONTROL'
    object sTabSheet1: TsTabSheet
      Caption = 'General log'
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      object LogList: TsMemo
        Left = 0
        Top = 0
        Width = 627
        Height = 231
        Align = alClient
        BorderStyle = bsNone
        Color = 15917239
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
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
    end
    object sTabSheet2: TsTabSheet
      Caption = 'Downloader Errors'
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      object ThreadsList: TsMemo
        Left = 0
        Top = 0
        Width = 627
        Height = 231
        Align = alClient
        BorderStyle = bsNone
        Color = 15917239
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
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
    end
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 259
    Width = 635
    Height = 41
    Align = alBottom
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    DesignSize = (
      635
      41)
    object sButton1: TsButton
      Left = 556
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Close'
      TabOrder = 0
      OnClick = sButton1Click
      SkinData.SkinSection = 'BUTTON'
    end
    object sButton2: TsButton
      Left = 4
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Clear'
      TabOrder = 1
      OnClick = sButton2Click
      SkinData.SkinSection = 'BUTTON'
    end
    object sButton3: TsButton
      Left = 85
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Save'
      TabOrder = 2
      OnClick = sButton3Click
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 312
    Top = 152
  end
  object sSaveDialog1: TsSaveDialog
    Filter = 'Text Files|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 432
    Top = 144
  end
end
