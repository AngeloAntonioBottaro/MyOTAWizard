unit View.ProjectsList;

interface

uses
  ToolsAPI,
  DockForm,
  DeskUtil,
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Menus,
  Vcl.ComCtrls,
  Vcl.ImgList,
  Vcl.ExtCtrls;

type
  TViewProjectsList = class(TDockableForm)
    PopupMenu: TPopupMenu;
    ExcluirRegistro1: TMenuItem;
    ListView: TListView;
    N1: TMenuItem;
    AbrirDiretorio1: TMenuItem;
    ImageListDark: TImageList;
    AbrirNovaJanela1: TMenuItem;
    ImageListLight: TImageList;
    TimerSearch: TTimer;
    StatusBar: TStatusBar;
    pnPaletaGrupos: TPanel;
    Splitter1: TSplitter;
    ListViewPaletaGrupos: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ExcluirRegistro1Click(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure AbrirDiretorio1Click(Sender: TObject);
    procedure ListViewCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure AbrirNovaJanela1Click(Sender: TObject);
    procedure TimerSearchTimer(Sender: TObject);
    procedure ListViewKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewPaletaGruposResize(Sender: TObject);
    procedure ListViewPaletaGruposCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewPaletaGruposClick(Sender: TObject);
  private
    FColIndex: Integer;
    FOrdAsc: Boolean;
    FSelectedGroup: string;
    FSearch: string;
    procedure CriarPaletaGrupos;
    procedure ListarGrupo(AGroup: string);
    procedure ListarProjetos;
    procedure AddToList(ASection: string);
    procedure SaveLastOpenedDate;

    procedure AddSearch(AChar: string = '');
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  ViewProjectsList: TViewProjectsList;

procedure RegisterModeloDockForm;
procedure UnRegister;

procedure ShowGeradorModelo;

implementation

{$R *.dfm}

uses
  MyOTAWizard.Utils,
  ProjectsList.IniFile,
  ProjectsList.Types;

procedure RegisterModeloDockForm;
begin
   if(not Assigned(ViewProjectsList))then
     ViewProjectsList := TViewProjectsList.Create(nil);

   if(@RegisterFieldAddress <> nil)then
     RegisterFieldAddress(ViewProjectsList.Name, @ViewProjectsList);

   RegisterDesktopFormClass(TViewProjectsList,
                            ViewProjectsList.Name,
                            ViewProjectsList.Name);
end;

procedure UnRegister;
begin
  if(not Assigned(ViewProjectsList))then
    Exit;

  if(@UnregisterFieldAddress <> nil)then
    UnregisterFieldAddress(@ViewProjectsList);

  FreeAndNil(ViewProjectsList);
end;

procedure ShowGeradorModelo;
begin
  if(not Assigned(ViewProjectsList))then
    Exit;

  ShowDockableForm(ViewProjectsList);
  FocusWindow(ViewProjectsList);
  ViewProjectsList.ListView.SetFocus;
end;

constructor TViewProjectsList.Create(AOwner: TComponent);
begin
   inherited;
   DeskSection        := Name;
   AutoSave           := True;
   SaveStateNecessary := True;
end;

procedure TViewProjectsList.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_BACK: if(Shift = [])then Self.AddSearch;
     VK_ESCAPE: if(Shift = [])then Self.Close;
     VK_DELETE: if(Shift = [])then Self.ExcluirRegistro1.Click;
     VK_RETURN:
     begin
        if(Shift = [ssCtrl])then
          Self.AbrirNovaJanela1.Click
        else
          Self.ListViewDblClick(nil);
     end;
     VK_NUMPAD0: if(Shift = [ssCtrl])then Self.ListarGrupo(TPLGroup.Tudo.ToString);
     VK_NUMPAD1: if(Shift = [ssCtrl])then Self.ListarGrupo(TPLGroup.Executaveis.ToString);
     VK_NUMPAD2: if(Shift = [ssCtrl])then Self.ListarGrupo(TPLGroup.Trabalho.ToString);
     VK_NUMPAD3: if(Shift = [ssCtrl])then Self.ListarGrupo(TPLGroup.Pessoal.ToString);
     VK_NUMPAD4: if(Shift = [ssCtrl])then Self.ListarGrupo(TPLGroup.Packets.ToString);
     VK_NUMPAD5: if(Shift = [ssCtrl])then Self.ListarGrupo(TPLGroup.Outros.ToString);
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
   Self.CriarPaletaGrupos;

   ListView.SmallImages := ImageListLight;
   if(TMyOTAWizardUtils.ActiveTheme = 'Dark')then
     ListView.SmallImages := ImageListDark;

   ListViewPaletaGrupos.SmallImages := ListView.SmallImages;

   TMyOTAWizardUtils.ApplyTheme(TViewProjectsList, Self);

   if(not FSelectedGroup.IsEmpty)then
     Self.ListarGrupo(FSelectedGroup)
   else
     Self.ListarGrupo(TPLGroup.Tudo.ToString);
end;

procedure TViewProjectsList.CriarPaletaGrupos;
var
  LItem: TListItem;
  LGroup: TPLGroup;
begin
   ListViewPaletaGrupos.Items.Clear;
   for LGroup := Low(TPLGroup) to High(TPLGroup) do
   begin
      LItem := ListViewPaletaGrupos.Items.Add;
      LItem.Caption    := '  ' + LGroup.ToString;
      LItem.ImageIndex := Integer(LGroup);
   end;
end;

procedure TViewProjectsList.AddSearch(AChar: string);
begin
   TimerSearch.Enabled := False;

   if(AChar.IsEmpty)then
     FSearch := ''
   else
     FSearch := LowerCase(FSearch + TMyOTAWizardUtils.ReturnEdtValidChar(AChar));

   StatusBar.Panels[0].Text := FSearch;
   TimerSearch.Enabled := True;
end;

procedure TViewProjectsList.TimerSearchTimer(Sender: TObject);
begin
   TimerSearch.Enabled := False;
   Self.ListarProjetos;
end;

procedure TViewProjectsList.ListarGrupo(AGroup: string);
begin
   FSelectedGroup := AGroup;
   if(FSelectedGroup.IsEmpty)then
     FSelectedGroup := TPLGroup.Tudo.ToString;

   Self.ListarProjetos;
end;

procedure TViewProjectsList.ListarProjetos;
var
  LSections: TStringList;
  I: Integer;
begin
   FColIndex := 0;
   FOrdAsc   := True;
   ListView.Items.Clear;
   LSections := TStringList.Create;
   try
     TProjectsListIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
       Self.AddToList(LSections[I]);
   finally
     LSections.Free;
   end;

   if(ViewProjectsList.Visible)then
     ListView.SetFocus;
end;

procedure TViewProjectsList.AddToList(ASection: string);
var
  LItem: TListItem;
  LGroup: string;
  LDirectory: string;
  LLastOpened: string;
begin
   LDirectory  := TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierDirectory, '');
   LLastOpened := TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierDateLastOpened, '');
   LGroup      := TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierGroup, TPLGroup.Tudo.ToString);

   if(FSelectedGroup <> TPLGroup.Tudo.ToString)then
     if(LGroup <> FSelectedGroup)then
      Exit;

   if(not FSearch.IsEmpty)then
     if(not (LowerCase(ASection).Contains(FSearch) or
             LowerCase(LDirectory).Contains(FSearch) or
             LowerCase(LLastOpened).Contains(FSearch))
     )then
       Exit;

   LItem := ListView.Items.Add;
   LItem.Caption    := LGroup;
   LItem.ImageIndex := Integer(TPLGroup(StrToProjectsListGroup(LGroup)));
   LItem.SubItems.Add(ASection);
   LItem.SubItems.Add(LDirectory);
   LItem.SubItems.Add(LLastOpened);
end;

procedure TViewProjectsList.ListViewColumnClick(Sender: TObject; Column: TListColumn);
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
  LTypeColor: string;
begin
   LTypeColor := TProjectsListIniFile.New.IniFile.ReadString(Item.SubItems[0], IdentifierColor, TPLColors.Texto.ToString);
   Sender.Canvas.Font.Color := StrToProjectsListColors(LTypeColor).ToColor;
end;

procedure TViewProjectsList.ListViewDblClick(Sender: TObject);
var
  LFile: string;
  LFileExt: string;
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   LFile    := ListView.ItemFocused.SubItems[1];
   LFileExt := ExtractFileExt(LFile);

   if(LFileExt.Equals('.dproj') or LFileExt.Equals('.groupproj'))then
     (BorlandIDEServices as IOTAActionServices).OpenProject(ListView.ItemFocused.SubItems[1], True)
   else
     TMyOTAWizardUtils.Open(LFile);

   Self.SaveLastOpenedDate;
   Self.Close;
end;

procedure TViewProjectsList.ListViewKeyPress(Sender: TObject; var Key: Char);
begin
   Self.AddSearch(Key);
end;

procedure TViewProjectsList.ListViewPaletaGruposClick(Sender: TObject);
begin
   if(ListViewPaletaGrupos.ItemIndex < 0)then
     Exit;

   Self.ListarGrupo(ListViewPaletaGrupos.ItemFocused.Caption.Trim);
end;

procedure TViewProjectsList.ListViewPaletaGruposCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  LColor: Integer;
begin
   LColor := TPLColors.Texto.ToColor;
   if(Item.Caption.Trim.Equals(TPLGroup.Executaveis.ToString))then
     LColor := TPLColors.Vermelho.ToColor
   else if(Item.Caption.Trim.Equals(TPLGroup.Trabalho.ToString))then
     LColor := TPLColors.Amarelo.ToColor
   else if(Item.Caption.Trim.Equals(TPLGroup.Pessoal.ToString))then
     LColor := TPLColors.Azul.ToColor
   else if(Item.Caption.Trim.Equals(TPLGroup.Packets.ToString))then
     LColor := TPLColors.Verde.ToColor;

   Sender.Canvas.Font.Color := LColor;
end;

procedure TViewProjectsList.ListViewPaletaGruposResize(Sender: TObject);
begin
   ListViewPaletaGrupos.Column[0].Width := ListViewPaletaGrupos.Width - 10;
end;

procedure TViewProjectsList.AbrirNovaJanela1Click(Sender: TObject);
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   TMyOTAWizardUtils.Open(ListView.ItemFocused.SubItems[1]);
   Self.SaveLastOpenedDate;
   Self.Close;
end;

procedure TViewProjectsList.SaveLastOpenedDate;
begin
   try
     TProjectsListIniFile.New.IniFile.WriteString(ListView.ItemFocused.SubItems[0], IdentifierDateLastOpened, DateTimeToStr(Now));
   except
   end;
end;

procedure TViewProjectsList.AbrirDiretorio1Click(Sender: TObject);
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   TMyOTAWizardUtils.Open(ExtractFileDir(ListView.ItemFocused.SubItems[1]));
   Self.Close;
end;

procedure TViewProjectsList.ExcluirRegistro1Click(Sender: TObject);
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   TProjectsListIniFile.New.IniFile.EraseSection(ListView.ItemFocused.SubItems[0]);
   Self.ListarProjetos;
end;

initialization

finalization
  UnRegister;

end.
