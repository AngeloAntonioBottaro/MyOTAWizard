object ViewProjectsList: TViewProjectsList
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Projetos'
  ClientHeight = 309
  ClientWidth = 706
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 290
    Width = 706
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 706
    Height = 290
    Align = alClient
    Columns = <
      item
        Caption = 'Id'
        Width = 30
      end
      item
        Caption = 'Nome'
        Width = 150
      end
      item
        Caption = 'Diretorio'
        Width = 350
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
    OnCustomDrawSubItem = ListViewCustomDrawSubItem
    OnDblClick = ListViewDblClick
  end
  object PopupMenu: TPopupMenu
    Left = 32
    Top = 40
    object AbrirDiretorio1: TMenuItem
      Caption = 'Abrir diret'#243'rio'
      OnClick = AbrirDiretorio1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ExcluirRegistro1: TMenuItem
      Caption = 'Excluir registro'
      OnClick = ExcluirRegistro1Click
    end
  end
end
