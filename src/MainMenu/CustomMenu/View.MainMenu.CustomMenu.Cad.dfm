object ViewMainMenuCustomMenuCad: TViewMainMenuCustomMenuCad
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Adding menus'
  ClientHeight = 258
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnButtons: TPanel
    Left = 0
    Top = 226
    Width = 384
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    Padding.Top = 2
    Padding.Right = 5
    Padding.Bottom = 2
    TabOrder = 4
    object btnSave: TButton
      Left = 304
      Top = 2
      Width = 75
      Height = 28
      Align = alRight
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
  end
  object pnFile: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 100
    Width = 378
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    Padding.Top = 2
    Padding.Right = 5
    Padding.Bottom = 2
    TabOrder = 1
    object lbFile: TLabel
      Left = 8
      Top = 0
      Width = 44
      Height = 13
      Caption = 'File / Link'
    end
    object edtFile: TEdit
      Left = 8
      Top = 14
      Width = 329
      Height = 21
      MaxLength = 50
      TabOrder = 0
    end
    object btnSelectFile: TButton
      Left = 343
      Top = 14
      Width = 28
      Height = 21
      Hint = 'Select file'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnSelectFileClick
    end
  end
  object pnMenuInfo: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 378
    Height = 91
    Align = alTop
    BevelOuter = bvNone
    Padding.Top = 2
    Padding.Right = 5
    Padding.Bottom = 2
    TabOrder = 0
    object lbCaption: TLabel
      Left = 142
      Top = 4
      Width = 37
      Height = 13
      Caption = 'Caption'
    end
    object lbType: TLabel
      Left = 8
      Top = 2
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object lbOrder: TLabel
      Left = 8
      Top = 42
      Width = 28
      Height = 13
      Caption = 'Order'
    end
    object lbShortcut: TLabel
      Left = 83
      Top = 42
      Width = 41
      Height = 13
      Caption = 'Shortcut'
    end
    object edtCaption: TEdit
      Left = 142
      Top = 18
      Width = 229
      Height = 21
      MaxLength = 50
      TabOrder = 1
    end
    object cbType: TComboBox
      Left = 8
      Top = 18
      Width = 133
      Height = 21
      Style = csDropDownList
      ParentColor = True
      TabOrder = 0
      OnChange = cbTypeChange
      Items.Strings = (
        'Separator'
        'File'
        'Link'
        'CMD Command')
    end
    object UpDownOrder: TUpDown
      Left = 57
      Top = 57
      Width = 16
      Height = 21
      Associate = edtOrder
      TabOrder = 4
    end
    object edtOrder: TEdit
      Left = 8
      Top = 57
      Width = 49
      Height = 21
      MaxLength = 50
      NumbersOnly = True
      TabOrder = 2
      Text = '0'
    end
    object edtShortcut: THotKey
      Left = 83
      Top = 57
      Width = 121
      Height = 19
      HotKey = 0
      Modifiers = []
      TabOrder = 3
    end
  end
  object pnCmdCommand: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 142
    Width = 378
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    Padding.Top = 2
    Padding.Right = 5
    Padding.Bottom = 2
    TabOrder = 2
    object lbCMDCommand: TLabel
      Left = 8
      Top = 0
      Width = 72
      Height = 13
      Caption = 'CMD Command'
    end
    object edtCmdCommand: TEdit
      Left = 8
      Top = 14
      Width = 363
      Height = 21
      MaxLength = 50
      TabOrder = 0
    end
  end
  object pnParameter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 184
    Width = 378
    Height = 36
    Align = alTop
    BevelOuter = bvNone
    Padding.Top = 2
    Padding.Right = 5
    Padding.Bottom = 2
    TabOrder = 3
    object lbParameter: TLabel
      Left = 8
      Top = 0
      Width = 50
      Height = 13
      Caption = 'Parameter'
    end
    object edtParameter: TEdit
      Left = 8
      Top = 14
      Width = 363
      Height = 21
      MaxLength = 50
      TabOrder = 0
    end
  end
end
