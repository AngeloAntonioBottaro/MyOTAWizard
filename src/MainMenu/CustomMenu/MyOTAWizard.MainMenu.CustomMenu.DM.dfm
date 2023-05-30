object CustomMenuDM: TCustomMenuDM
  OldCreateOrder = False
  Height = 150
  Width = 215
  object TB_Files: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 23
    Top = 24
    object TB_FilesId: TIntegerField
      FieldName = 'Id'
    end
    object TB_FilesCaption: TStringField
      FieldName = 'Caption'
      Size = 30
    end
    object TB_FilesType: TStringField
      FieldName = 'Type'
    end
    object TB_FilesOrder: TIntegerField
      FieldName = 'Order'
    end
    object TB_FilesAction: TStringField
      FieldName = 'Action'
      Size = 500
    end
    object TB_FilesParameter: TStringField
      FieldName = 'Parameter'
      Size = 500
    end
    object TB_FilesSection: TStringField
      FieldName = 'Section'
      Size = 50
    end
    object TB_FilesShortcut: TStringField
      FieldName = 'Shortcut'
      Size = 30
    end
  end
  object DSFiles: TDataSource
    DataSet = TB_Files
    Left = 24
    Top = 72
  end
end
