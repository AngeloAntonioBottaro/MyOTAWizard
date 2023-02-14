object ViewAddProject: TViewAddProject
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Adicionar projeto'
  ClientHeight = 143
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
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbNomeProjeto: TLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Nome projeto'
  end
  object lbDiretorioProjeto: TLabel
    Left = 8
    Top = 54
    Width = 79
    Height = 13
    Caption = 'Diret'#243'rio projeto'
  end
  object btnAdicionar: TButton
    Left = 354
    Top = 108
    Width = 75
    Height = 25
    Caption = 'Adicionar'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = btnAdicionarClick
  end
  object btnSelecionarProjeto: TButton
    Left = 401
    Top = 73
    Width = 28
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = btnSelecionarProjetoClick
  end
  object edtDiretorioProjeto: TEdit
    Left = 8
    Top = 73
    Width = 390
    Height = 21
    TabStop = False
    ReadOnly = True
    TabOrder = 1
  end
  object edtNomeProjeto: TEdit
    Left = 8
    Top = 25
    Width = 421
    Height = 21
    MaxLength = 50
    TabOrder = 0
  end
  object pnIniFilePath: TPanel
    Left = 8
    Top = 115
    Width = 20
    Height = 20
    Cursor = crHelp
    BevelOuter = bvNone
    TabOrder = 4
    OnClick = pnIniFilePathClick
  end
end
