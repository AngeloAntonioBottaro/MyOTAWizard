unit MyOTAWizard.MainMenu.CustomMenu.DM;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient;

type
  TCustomMenuDM = class(TDataModule)
    TB_Files: TClientDataSet;
    TB_FilesCaption: TStringField;
    TB_FilesType: TStringField;
    TB_FilesOrder: TIntegerField;
    TB_FilesAction: TStringField;
    TB_FilesParameter: TStringField;
    TB_FilesSection: TStringField;
    TB_FilesShortcut: TStringField;
    DSFiles: TDataSource;
    TB_FilesId: TIntegerField;
  private
  public
    procedure LoadConfiguration;
  end;

var
  CustomMenuDM: TCustomMenuDM;

implementation

{$R *.dfm}

uses
  MyOTAWizard.MainMenu.CustomMenu.Ini;

procedure ClientDataSetClear(ATabela: TClientDataSet);
begin
   ATabela.Close;
   ATabela.CreateDataSet;
   ATabela.Open;
   ATabela.EmptyDataSet;
   ATabela.Close;
   ATabela.Open;
end;

procedure TCustomMenuDM.LoadConfiguration;
var
  LSections: TStringList;
  I: Integer;
begin
   ClientDataSetClear(TB_Files);
   LSections := TStringList.Create;
   try
     TCustomMenuIniFile.New.IniFile.ReadSections(LSections);
     for I := 0 to Pred(LSections.Count) do
     begin
        TB_Files.Append;
        TB_Files.FieldByName('Id').AsInteger       := I + 1;
        TB_Files.FieldByName('Section').AsString   := LSections[I];
        TB_Files.FieldByName('Order').AsInteger    := TCustomMenuIniFile.New.IniFile.ReadInteger(LSections[I], INI_IDENTIFIER_ORDER, 0);
        TB_Files.FieldByName('Type').AsString      := TCustomMenuIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_TYPE, '');
        TB_Files.FieldByName('Caption').AsString   := TCustomMenuIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_CAPTION, '');
        TB_Files.FieldByName('Shortcut').AsString  := TCustomMenuIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_SHORTCUT, '');
        TB_Files.FieldByName('Action').AsString    := TCustomMenuIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_ACTION, '');
        TB_Files.FieldByName('Parameter').AsString := TCustomMenuIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_PARAM, '');
        TB_Files.Post;
     end;
   finally
     LSections.Free;
   end;

   TB_Files.IndexFieldNames := 'Order';
   TB_Files.First;
end;

initialization

finalization
  CustomMenuDM.Free;

end.
