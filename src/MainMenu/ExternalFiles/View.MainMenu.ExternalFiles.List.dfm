object ViewMainMenuExternalFilesList: TViewMainMenuExternalFilesList
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'External files'
  ClientHeight = 540
  ClientWidth = 652
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 652
    Height = 540
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 20
      end
      item
        Caption = 'Caption'
        Width = 200
      end
      item
        Caption = 'File'
        Width = 200
      end
      item
        Caption = 'Command'
        Width = 200
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListViewColumnClick
    OnCompare = ListViewCompare
  end
end
