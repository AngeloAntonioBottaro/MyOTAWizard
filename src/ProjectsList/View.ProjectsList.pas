unit View.ProjectsList;

interface

uses
  ToolsAPI,
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Data.DB,
  Datasnap.DBClient,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.Menus,
  Vcl.ComCtrls;

type
  TViewProjectsList = class(TForm)
    PopupMenu: TPopupMenu;
    ExcluirRegistro1: TMenuItem;
    ListView: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ExcluirRegistro1Click(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
  private
    procedure ListarProjetos;
    procedure AddToList(ASection: string);
  public
  end;

var
  ViewProjectsList: TViewProjectsList;

implementation

{$R *.dfm}

uses
  ProjectsList.IniFile,
  View.AddProject;

procedure TViewProjectsList.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
     VK_DELETE: if(Shift = [])then Self.ExcluirRegistro1.Click;
   end;
end;

procedure TViewProjectsList.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewProjectsList.FormShow(Sender: TObject);
begin
   {$IF CompilerVersion >= 32.0}
   (BorlandIDEServices as IOTAIDEThemingServices250).RegisterFormClass(TViewProjectsList);
   {$ENDIF}
   Self.ListarProjetos;
end;

procedure TViewProjectsList.ListarProjetos;
var
  LSections: TStringList;
  I: Integer;
begin
   ListView.Items.Clear;
   LSections := TStringList.Create;
   try
     TProjectsListIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
       Self.AddToList(LSections[I]);
   finally
     LSections.Free;
   end;
end;

procedure TViewProjectsList.ListViewDblClick(Sender: TObject);
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   ShellExecute(HInstance, 'open', Pchar(ListView.ItemFocused.SubItems[1]), nil, nil, SW_SHOWNORMAL);
   Self.Close;
end;

procedure TViewProjectsList.AddToList(ASection: string);
var
  LItem: TListItem;
begin
   LItem := ListView.Items.Add;
   LItem.Caption := IntToStr(ListView.Items.Count);
   LItem.SubItems.Add(ASection);
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierDirectory, ''));
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierGroup, ''));
end;

procedure TViewProjectsList.ExcluirRegistro1Click(Sender: TObject);
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   TProjectsListIniFile.New.IniFile.EraseSection(ListView.ItemFocused.SubItems[0]);
   Self.ListarProjetos;
end;

end.
