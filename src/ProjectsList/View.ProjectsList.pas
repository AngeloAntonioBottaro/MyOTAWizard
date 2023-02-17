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
  Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TViewProjectsList = class(TForm)
    PopupMenu: TPopupMenu;
    ExcluirRegistro1: TMenuItem;
    StatusBar1: TStatusBar;
    ListView: TListView;
    N1: TMenuItem;
    AbrirDiretorio1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ExcluirRegistro1Click(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSheetShow(Sender: TObject);
    procedure AbrirDiretorio1Click(Sender: TObject);
    procedure ListViewCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    FLista: TListView;
    FAbaShowing: string;
    procedure CriarPageControl;
    procedure CriarAbasPageControl(APgControl: TPageControl);
    procedure ShowTabSheet(ATabSheetName: string);
    procedure ListarProjetos;
    procedure AddToList(ASection: string);
  public
  end;

var
  ViewProjectsList: TViewProjectsList;

implementation

{$R *.dfm}

uses
  MyOTAWizard.Utils,
  ProjectsList.IniFile,
  ProjectsList.Types;

procedure TViewProjectsList.FormCreate(Sender: TObject);
begin
   FLista := ListView;
   Self.CriarPageControl;
end;

procedure TViewProjectsList.CriarPageControl;
var
  LPgControl: TPageControl;
begin
   LPgControl := TPageControl(Self.FindComponent('pgControlGroups'));
   if(Assigned(FLista))then
     LPgControl.Free;

   LPgControl             := TPageControl.Create(Self);
   LPgControl.Parent      := Self;
   LPgControl.Name        := 'pgControlGroups';
   LPgControl.Align       := alLeft;
   LPgControl.TabPosition := tpLeft;
   LPgControl.Width       := 22;

   Self.CriarAbasPageControl(LPgControl);
end;

procedure TViewProjectsList.CriarAbasPageControl(APgControl: TPageControl);
var
  LAba: TProjectsListGroup;
  LTab: TTabSheet;
begin
   for LAba := Low(TProjectsListGroup) to High(TProjectsListGroup) do
   begin
      LTab             := TTabSheet.Create(Self);
      LTab.Parent      := APgControl;
      LTab.PageControl := APgControl;
      LTab.Name        := LAba.ToString;
      LTab.Caption     := LAba.ToString;
      LTab.OnShow      := Self.TabSheetShow;
      LTab.OnEnter     := Self.TabSheetShow;
      LTab.OnExit      := Self.TabSheetShow;
   end;
end;

procedure TViewProjectsList.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
     VK_DELETE: if(Shift = [])then Self.ExcluirRegistro1.Click;
     VK_RETURN: Self.ListViewDblClick(nil);
     VK_NUMPAD0: Self.ShowTabSheet(TProjectsListGroup.Tudo.ToString);
     VK_NUMPAD1: Self.ShowTabSheet(TProjectsListGroup.Executaveis.ToString);
     VK_NUMPAD2: Self.ShowTabSheet(TProjectsListGroup.Trabalho.ToString);
     VK_NUMPAD3: Self.ShowTabSheet(TProjectsListGroup.Pessoal.ToString);
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
   TMyOTAWizardUtils.ApplyTheme(TViewProjectsList, Self);
   Self.ListarProjetos;
end;

procedure TViewProjectsList.ListarProjetos;
var
  LSections: TStringList;
  I: Integer;
begin
   FLista.Items.Clear;
   LSections := TStringList.Create;
   try
     TProjectsListIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
       Self.AddToList(LSections[I]);
   finally
     LSections.Free;
   end;
end;

procedure TViewProjectsList.AbrirDiretorio1Click(Sender: TObject);
var
  LDirectory: string;
begin
   if(FLista.ItemIndex < 0)then
     Exit;

   LDirectory := ExtractFileDir(FLista.ItemFocused.SubItems[1]);
   ShellExecute(HInstance, 'open', Pchar(LDirectory), nil, nil, SW_SHOWNORMAL);
   Self.Close;
end;

procedure TViewProjectsList.AddToList(ASection: string);
var
  LItem: TListItem;
  LGroup: string;
begin
   if(FAbaShowing <> TProjectsListGroup.Tudo.ToString)then
   begin
      LGroup := TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierGroup, TProjectsListGroup.Tudo.ToString);

      if(LGroup <> FAbaShowing)then
       Exit;
   end;

   LItem := FLista.Items.Add;
   LItem.Caption := IntToStr(FLista.Items.Count);
   LItem.SubItems.Add(ASection);
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierDirectory, ''));
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierGroup, TProjectsListGroup.Tudo.ToString));
end;

procedure TViewProjectsList.ListViewCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  LColor: TColor;
begin
   LColor := TProjectsListColors.Texto.ToColor;
   if(FAbaShowing.Equals(TProjectsListGroup.Trabalho.ToString))then
     LColor := TProjectsListColors.Amarelo.ToColor
   else if(FAbaShowing.Equals(TProjectsListGroup.Pessoal.ToString))then
     LColor := TProjectsListColors.Azul.ToColor
   else if(FAbaShowing.Equals(TProjectsListGroup.Executaveis.ToString))then
     LColor := TProjectsListColors.Vermelho.ToColor;

   Sender.Canvas.Font.Color := LColor;
end;

procedure TViewProjectsList.ListViewDblClick(Sender: TObject);
begin
   if(FLista.ItemIndex < 0)then
     Exit;

   ShellExecute(HInstance, 'open', Pchar(FLista.ItemFocused.SubItems[1]), nil, nil, SW_SHOWNORMAL);
   Self.Close;
end;

procedure TViewProjectsList.ExcluirRegistro1Click(Sender: TObject);
begin
   if(FLista.ItemIndex < 0)then
     Exit;

   TProjectsListIniFile.New.IniFile.EraseSection(FLista.ItemFocused.SubItems[0]);
   Self.ListarProjetos;
end;

procedure TViewProjectsList.TabSheetShow(Sender: TObject);
begin
   FAbaShowing := TTabSheet(Sender).Name;
   Self.ShowTabSheet(TTabSheet(Sender).Name);
end;

procedure TViewProjectsList.ShowTabSheet(ATabSheetName: string);
var
  LTabSheet: TTabSheet;
begin
   LTabSheet := TTabSheet(Self.FindComponent(ATabSheetName));
   if(not Assigned(LTabSheet))then
     Exit;

   if(not LTabSheet.Showing)then
     LTabSheet.Show;

   Self.ListarProjetos;
end;

end.
