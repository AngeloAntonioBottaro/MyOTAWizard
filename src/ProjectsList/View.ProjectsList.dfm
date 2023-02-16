object ViewProjectsList: TViewProjectsList
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Projetos'
  ClientHeight = 309
  ClientWidth = 645
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
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 645
    Height = 309
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
      end
      item
        Caption = 'Grupo'
        Width = 100
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
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListViewDblClick
  end
  object PopupMenu: TPopupMenu
    Left = 72
    Top = 248
    object ExcluirRegistro1: TMenuItem
      Caption = 'Excluir registro'
      OnClick = ExcluirRegistro1Click
    end
  end
end
