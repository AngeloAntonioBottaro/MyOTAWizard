unit View.ProjectsList;

interface

uses
  ToolsAPI,
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
  Vcl.ImgList;

type
  TViewProjectsList = class(TForm)
    PopupMenu: TPopupMenu;
    ExcluirRegistro1: TMenuItem;
    ListView: TListView;
    N1: TMenuItem;
    AbrirDiretorio1: TMenuItem;
    ImageList: TImageList;
    AbrirNovaJanela1: TMenuItem;
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
    procedure AbrirNovaJanela1Click(Sender: TObject);
  private
    FColIndex: Integer;
    FOrdAsc: Boolean;
    FAbaShowing: string;
    procedure CriarPageControl;
    procedure CriarAbasPageControl(APgControl: TPageControl);
    procedure ShowTabSheet(ATabSheetName: string);
    procedure ListarProjetos;
    procedure AddToList(ASection: string);
    procedure SaveLastOpenedDate;
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
   Self.CriarPageControl;
end;

procedure TViewProjectsList.CriarPageControl;
var
  LPgControl: TPageControl;
begin
   LPgControl := TPageControl(Self.FindComponent('pgControlGroups'));
   if(Assigned(LPgControl))then
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
  LAba: TPLGroup;
  LTab: TTabSheet;
begin
   for LAba := Low(TPLGroup) to High(TPLGroup) do
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
     VK_RETURN:
     begin
        if(Shift = [ssCtrl])then
          Self.AbrirNovaJanela1.Click
        else
          Self.ListViewDblClick(nil);
     end;
     VK_NUMPAD0: Self.ShowTabSheet(TPLGroup.Tudo.ToString);
     VK_NUMPAD1: Self.ShowTabSheet(TPLGroup.Executaveis.ToString);
     VK_NUMPAD2: Self.ShowTabSheet(TPLGroup.Trabalho.ToString);
     VK_NUMPAD3: Self.ShowTabSheet(TPLGroup.Pessoal.ToString);
     VK_NUMPAD4: Self.ShowTabSheet(TPLGroup.Packets.ToString);
     VK_NUMPAD5: Self.ShowTabSheet(TPLGroup.Outros.ToString);
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

procedure TViewProjectsList.AddToList(ASection: string);
var
  LItem: TListItem;
  LGroup: string;
begin
   LGroup := TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierGroup, TPLGroup.Tudo.ToString);

   if(FAbaShowing <> TPLGroup.Tudo.ToString)then
     if(LGroup <> FAbaShowing)then
      Exit;

   LItem := ListView.Items.Add;
   LItem.Caption    := LGroup;
   LItem.ImageIndex := Integer(TPLGroup(StrToProjectsListGroup(LGroup)));
   LItem.SubItems.Add(ASection);
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierDirectory, ''));
   LItem.SubItems.Add(TProjectsListIniFile.New.IniFile.ReadString(ASection, IdentifierDateLastOpened, ''));
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
  LColor: TColor;
  LTypeColor: string;
begin
   LTypeColor := TProjectsListIniFile.New.IniFile.ReadString(Item.SubItems[0], IdentifierColor, TPLColors.Texto.ToString);
   LColor     := StrToProjectsListColors(LTypeColor).ToColor;
   Sender.Canvas.Font.Color := LColor;
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
   TProjectsListIniFile.New.IniFile.WriteString(ListView.ItemFocused.SubItems[0], IdentifierDateLastOpened, DateTimeToStr(Now));
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

end.
