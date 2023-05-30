object ViewMainMenuCustomMenuList: TViewMainMenuCustomMenuList
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Custom menus list'
  ClientHeight = 346
  ClientWidth = 948
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
    Width = 948
    Height = 346
    Align = alClient
    Columns = <
      item
        Caption = 'Order'
      end
      item
        Caption = 'Caption'
        Width = 200
      end
      item
        Caption = 'Action'
        Width = 320
      end
      item
        Caption = 'Param'
        Width = 200
      end
      item
        Caption = 'Shortcut'
        Width = 150
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
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitWidth = 898
  end
  object PopupMenu: TPopupMenu
    Left = 480
    Top = 88
    object Newfile1: TMenuItem
      Caption = 'New file'
      OnClick = Newfile1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Changeregistry1: TMenuItem
      Caption = 'Change registry'
      OnClick = Changeregistry1Click
    end
    object Deletefile1: TMenuItem
      Caption = 'Delete registry'
      OnClick = Deletefile1Click
    end
  end
end
