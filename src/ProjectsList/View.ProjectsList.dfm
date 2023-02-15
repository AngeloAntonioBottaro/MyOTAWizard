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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 639
    Height = 303
    Align = alClient
    DataSource = DSLista
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    PopupMenu = PopupMenu
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGridDrawColumnCell
    OnDblClick = DBGridDblClick
    OnTitleClick = DBGridTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'ProjectName'
        Title.Caption = 'Nome'
        Width = 155
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ProjectDirectory'
        Title.Caption = 'Diret'#243'rio'
        Width = 441
        Visible = True
      end>
  end
  object DSLista: TDataSource
    Left = 16
    Top = 248
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
