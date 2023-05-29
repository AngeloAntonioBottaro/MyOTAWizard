unit View.MainMenu.ExternalFiles.List;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls;

type
  TViewMainMenuExternalFilesList = class(TForm)
    ListView: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FColIndex: Integer;
    FOrdAsc: Boolean;
    procedure LoadList;
  public
  end;

var
  ViewMainMenuExternalFilesList: TViewMainMenuExternalFilesList;

implementation

{$R *.dfm}

uses
  MyOTAWizard.Utils,
  MyOTAWizard.MainMenu.External.Ini,
  MyOTAWizard.MainMenu;

procedure TViewMainMenuExternalFilesList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   TMyOTAWizardMainMenu.New;
end;

procedure TViewMainMenuExternalFilesList.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
   end;
end;

procedure TViewMainMenuExternalFilesList.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewMainMenuExternalFilesList.FormShow(Sender: TObject);
begin
   TMyOTAWizardUtils.ApplyTheme(TViewMainMenuExternalFilesList, Self);
   Self.LoadList;
end;

procedure TViewMainMenuExternalFilesList.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
   if(FColIndex = Column.Index)then
   begin
     FOrdAsc := not(FOrdAsc);
     ListView.AlphaSort;
   end
   else
   begin
     FOrdAsc   := True;
     FColIndex := Column.Index;
     ListView.AlphaSort;
   end;
end;

procedure TViewMainMenuExternalFilesList.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
   //CAPTION
   if(FColIndex = 0)then
   begin
     if(FOrdAsc)then
       Compare := CompareText(Item1.Caption, Item2.Caption)
     else
       Compare := CompareText(Item2.Caption, Item1.Caption);
   end
   else //SUB ITEM
   begin
     if(FOrdAsc)then
       Compare := CompareText(Item1.SubItems[FColIndex - 1],
                              Item2.SubItems[FColIndex - 1])
     else
       Compare := CompareText(Item2.SubItems[FColIndex - 1],
                              Item1.SubItems[FColIndex - 1]);

   end;
end;

procedure TViewMainMenuExternalFilesList.LoadList;
var
  LSections: TStringList;
  I: Integer;
  LItem: TListItem;
begin
   FColIndex := 0;
   FOrdAsc   := True;
   ListView.Items.Clear;

   LSections := TStringList.Create;
   try
     TExternalIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
     begin
        LItem         := ListView.Items.Add;
        LItem.Caption := I.ToString;

        LItem.SubItems.Add(TExternalIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_CAPTION, ''));
        LItem.SubItems.Add(TExternalIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_FILE, ''));
        LItem.SubItems.Add(TExternalIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_COMMAND, ''));
     end;
   finally
     LSections.Free;
   end;
end;

end.
