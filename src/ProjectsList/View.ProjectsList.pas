unit View.ProjectsList;

interface

uses
  ToolsAPI,
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Menus,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TViewProjectsList = class(TForm)
    PopupMenu: TPopupMenu;
    ExcluirRegistro1: TMenuItem;
    ListView: TListView;
    N1: TMenuItem;
    AbrirDiretorio1: TMenuItem;
    ImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ExcluirRegistro1Click(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSheetShow(Sender: TObject);
    procedure AbrirDiretorio1Click(Sender: TObject);
    procedure ListViewCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  private
    FColIndex: Integer;
    FOrdAsc: Boolean;
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
   Constraints.MinHeight := Self.Height;

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
     VK_NUMPAD4: Self.ShowTabSheet(TProjectsListGroup.Packets.ToString);
     VK_NUMPAD5: Self.ShowTabSheet(TProjectsListGroup.Outros.ToString);
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

procedure TViewProjectsList.TabSheetShow(Sender: TObject);
begin
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

   FAbaShowing := LTabSheet.Name;
   Self.ListarProjetos;
end;

procedure TViewProjectsList.ListarProjetos;
var
  LSections: TStringList;
  I: Integer;
begin
   FColIndex := 0;
   FOrdAsc   := True;
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

procedure TViewProjectsList.AddToList(ASection: string);
var
  LItem: TListItem;
  LGroup: string;
begin
   LGroup := TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierGroup, TProjectsListGroup.Tudo.ToString);

   if(FAbaShowing <> TProjectsListGroup.Tudo.ToString)then
     if(LGroup <> FAbaShowing)then
      Exit;

   LItem := FLista.Items.Add;
   LItem.Caption    := LGroup;
   LItem.ImageIndex := Integer(TProjectsListGroup(StrToProjectsListGroup(LGroup)));
   LItem.SubItems.Add(ASection);
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierDirectory, ''));
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierGroup, TProjectsListGroup.Tudo.ToString));
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierColor, TProjectsListColors.Texto.ToString));
end;

procedure TViewProjectsList.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
   if(FColIndex = Column.Index)then
   begin
     FOrdAsc := not(FOrdAsc);
     FLista.AlphaSort;
   end
   else
   begin
     FOrdAsc   := True;
     FColIndex := Column.Index;
     FLista.AlphaSort;
   end;
end;

procedure TViewProjectsList.ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
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

procedure TViewProjectsList.ListViewCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  LColor: TColor;
begin
   LColor := StrToProjectsListColors(Item.SubItems[3]).ToColor;
   if(LColor = TProjectsListColors.Texto.ToColor)then
   begin
      if(FAbaShowing.Equals(TProjectsListGroup.Trabalho.ToString))then
        LColor := TProjectsListColors.Amarelo.ToColor
      else if(FAbaShowing.Equals(TProjectsListGroup.Pessoal.ToString))then
        LColor := TProjectsListColors.Azul.ToColor
      else if(FAbaShowing.Equals(TProjectsListGroup.Executaveis.ToString))then
        LColor := TProjectsListColors.Vermelho.ToColor
      else if(FAbaShowing.Equals(TProjectsListGroup.Packets.ToString))then
        LColor := TProjectsListColors.Verde.ToColor
      else if(FAbaShowing.Equals(TProjectsListGroup.Outros.ToString))then
        LColor := TProjectsListColors.Texto.ToColor;
   end;

   Sender.Canvas.Font.Color := LColor;
end;

procedure TViewProjectsList.ListViewDblClick(Sender: TObject);
begin
   if(FLista.ItemIndex < 0)then
     Exit;

   TMyOTAWizardUtils.Open(FLista.ItemFocused.SubItems[1]);
   Self.Close;
end;

procedure TViewProjectsList.AbrirDiretorio1Click(Sender: TObject);
begin
   if(FLista.ItemIndex < 0)then
     Exit;

   TMyOTAWizardUtils.Open(ExtractFileDir(FLista.ItemFocused.SubItems[1]));
   Self.Close;
end;

procedure TViewProjectsList.ExcluirRegistro1Click(Sender: TObject);
begin
   if(FLista.ItemIndex < 0)then
     Exit;

   TProjectsListIniFile.New.IniFile.EraseSection(FLista.ItemFocused.SubItems[0]);
   Self.ListarProjetos;
end;

end.
