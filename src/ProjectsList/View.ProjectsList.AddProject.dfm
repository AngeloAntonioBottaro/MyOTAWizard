object ViewProjectsListAddProject: TViewProjectsListAddProject
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add projetcs'
  ClientHeight = 183
  ClientWidth = 448
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
  DesignSize = (
    448
    183)
  PixelsPerInch = 96
  TextHeight = 13
  object lbNomeProjeto: TLabel
    Left = 8
    Top = 52
    Width = 63
    Height = 13
    Caption = 'Project name'
  end
  object lbDiretorioProjeto: TLabel
    Left = 8
    Top = 12
    Width = 80
    Height = 13
    Caption = 'Project directory'
  end
  object lbGrupo: TLabel
    Left = 8
    Top = 130
    Width = 29
    Height = 13
    Caption = 'Grupo'
  end
  object lbCor: TLabel
    Left = 174
    Top = 130
    Width = 17
    Height = 13
    Caption = 'Cor'
  end
  object lbGitURL: TLabel
    Left = 8
    Top = 92
    Width = 107
    Height = 13
    Caption = 'Project ".git" directory'
  end
  object btnSalvar: TButton
    Left = 354
    Top = 142
    Width = 75
    Height = 25
    Caption = 'Save'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = btnSalvarClick
  end
  object btnSelecionarProjeto: TButton
    Left = 401
    Top = 26
    Width = 28
    Height = 21
    Hint = 'Select file'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btnSelecionarProjetoClick
  end
  object edtDiretorioProjeto: TEdit
    Left = 8
    Top = 26
    Width = 391
    Height = 21
    TabStop = False
    ReadOnly = True
    TabOrder = 0
  end
  object edtNomeProjeto: TEdit
    Left = 8
    Top = 65
    Width = 421
    Height = 21
    MaxLength = 50
    TabOrder = 2
  end
  object pnIniFilePath: TPanel
    Left = 425
    Top = 3
    Width = 20
    Height = 20
    Cursor = crHelp
    Anchors = [akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 6
    OnClick = pnIniFilePathClick
    OnDblClick = pnIniFilePathDblClick
  end
  object cbGrupo: TComboBox
    Left = 8
    Top = 144
    Width = 161
    Height = 21
    Style = csDropDownList
    ParentColor = True
    TabOrder = 3
  end
  object cbCor: TComboBox
    Left = 174
    Top = 144
    Width = 161
    Height = 21
    Style = csDropDownList
    ParentColor = True
    TabOrder = 4
  end
  object edtGitDirectory: TEdit
    Left = 8
    Top = 105
    Width = 391
    Height = 21
    MaxLength = 50
    TabOrder = 7
  end
  object btnSelectGitDirectory: TButton
    Left = 401
    Top = 105
    Width = 28
    Height = 21
    Hint = 'Select file'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = btnSelectGitDirectoryClick
  end
end
