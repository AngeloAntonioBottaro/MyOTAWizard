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
  System.IniFiles,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.Menus;

type
  TViewProjectsList = class(TForm)
    DBGrid: TDBGrid;
    DSLista: TDataSource;
    PopupMenu: TPopupMenu;
    ExcluirRegistro1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure ExcluirRegistro1Click(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridTitleClick(Column: TColumn);
  private
    FIniFile: TIniFile;
    FTabela: TClientDataSet;
    procedure CriarTabSheet;
    procedure CriarTabela;
    procedure ListarProjetos;
    procedure AddToList(ASection: string);
  public
  end;

var
  ViewProjectsList: TViewProjectsList;

implementation

{$R *.dfm}

uses
  ProjectsList.IniFileUtils,
  View.AddProject;

procedure TViewProjectsList.FormCreate(Sender: TObject);
begin
   FIniFile := TIniFile.Create(TProjectsListIniFileUtils.IniFile);
   Self.CriarTabela;
end;

procedure TViewProjectsList.FormDestroy(Sender: TObject);
begin
   FIniFile.Free;
   FTabela.Free;
end;

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

procedure TViewProjectsList.CriarTabSheet;
begin

end;

procedure TViewProjectsList.CriarTabela;
begin
   FreeAndNil(FTabela);
   FTabela := TClientDataSet.Create(nil);
   FTabela.Close;
   FTabela.FieldDefs.Clear;
   FTabela.FieldDefs.Add('ProjectName', ftString, 50);
   FTabela.FieldDefs.Add('ProjectDirectory', ftString, 200);
   FTabela.CreateDataSet;
   DSLista.DataSet := FTabela;

   DBGrid.Columns[0].FieldName := 'ProjectName';
   DBGrid.Columns[0].Width     := 150;
   DBGrid.Columns[0].Title.Font.Style:= [fsBold];
   DBGrid.Columns[1].FieldName := 'ProjectDirectory';
   DBGrid.Columns[1].Width     := 440;
   DBGrid.Columns[1].Title.Font.Style:= [fsBold];
end;

procedure TViewProjectsList.ListarProjetos;
var
  LSections: TStringList;
  I: Integer;
begin
   Self.CriarTabela;

   LSections := TStringList.Create;
   try
     FIniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
       Self.AddToList(LSections[I]);
   finally
     LSections.Free;
   end;

   FTabela.First;
end;

procedure TViewProjectsList.AddToList(ASection: string);
begin
   FTabela.Append;
   FTabela.FieldByName('ProjectName').AsString      := ASection;
   FTabela.FieldByName('ProjectDirectory').AsString := FIniFile.ReadString(ASection, IdentifierDirectory, '');
   FTabela.Post;
end;

procedure TViewProjectsList.DBGridDblClick(Sender: TObject);
begin
   if(not FileExists(FTabela.FieldByName('ProjectDirectory').AsString))then
     Exit;

   ShellExecute(HInstance, 'open', Pchar(FTabela.FieldByName('ProjectDirectory').AsString), nil, nil, SW_SHOWNORMAL);
   Self.Close;
end;

procedure TViewProjectsList.ExcluirRegistro1Click(Sender: TObject);
begin
   if(FTabela.IsEmpty)then
     Exit;

   TProjectsListIniFileUtils.ExcluirSection(FTabela.FieldByName('ProjectName').AsString);
   Self.ListarProjetos;
end;

procedure TViewProjectsList.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
   if(Odd(TDBGrid(Sender).DataSource.DataSet.RecNo))then
   begin
      if not (gdSelected in State) then
      begin
         DBGrid.Canvas.Brush.Color := clBtnFace;
         DBGrid.Canvas.FillRect(Rect);
         DBGrid.DefaultDrawDataCell(rect,Column.Field,state);
      end;
   end;
end;

procedure TViewProjectsList.DBGridTitleClick(Column: TColumn);
var
  LIndice: string;
begin
  if(not (FTabela.IndexFieldNames = Column.FieldName))then
  begin
     FTabela.IndexFieldNames := Column.FieldName;
     Exit;
  end;

  FTabela.IndexDefs.Clear;
  with FTabela.IndexDefs.AddIndexDef do
  begin
     Name    := Column.FieldName + '_INV';
     Fields  := Column.FieldName;
     Options := [ixDescending];
  end;

  FTabela.IndexName := Column.FieldName + '_INV';
end;

end.
