unit View.MainMenu.CustomMenu.List;

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
  Vcl.ComCtrls,
  Vcl.Menus,
  Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids;

type
  TViewMainMenuCustomMenuList = class(TForm)
    ListView: TListView;
    PopupMenu: TPopupMenu;
    Newfile1: TMenuItem;
    N1: TMenuItem;
    Deletefile1: TMenuItem;
    Changeregistry1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Deletefile1Click(Sender: TObject);
    procedure Newfile1Click(Sender: TObject);
    procedure Changeregistry1Click(Sender: TObject);
  private
    procedure UpdateList;
    procedure CallCustomMenuCad(ASection: string = '');
  public
  end;

var
  ViewMainMenuCustomMenuList: TViewMainMenuCustomMenuList;

implementation

{$R *.dfm}

uses
  MyOTAWizard.Utils,
  MyOTAWizard.MainMenu,
  MyOTAWizard.MainMenu.CustomMenu.Ini,
  MyOTAWizard.MainMenu.CustomMenu.DM,
  View.MainMenu.CustomMenu.Cad;

procedure TViewMainMenuCustomMenuList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   TMyOTAWizardMainMenu.New;
end;

procedure TViewMainMenuCustomMenuList.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
   end;
end;

procedure TViewMainMenuCustomMenuList.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewMainMenuCustomMenuList.FormShow(Sender: TObject);
begin
   TMyOTAWizardUtils.ApplyTheme(TViewMainMenuCustomMenuList, Self);
   Self.UpdateList;
end;

procedure TViewMainMenuCustomMenuList.CallCustomMenuCad(ASection: string);
begin
   ViewMainMenuCustomMenuCad := TViewMainMenuCustomMenuCad.Create(nil);
   try
     ViewMainMenuCustomMenuCad.SectionToUpdate := ASection;
     ViewMainMenuCustomMenuCad.ShowModal;
   finally
     ViewMainMenuCustomMenuCad.Free;
   end;
   Self.UpdateList;
end;

procedure TViewMainMenuCustomMenuList.Changeregistry1Click(Sender: TObject);
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   Self.CallCustomMenuCad(ListView.ItemFocused.SubItems[4]);
end;

procedure TViewMainMenuCustomMenuList.Deletefile1Click(Sender: TObject);
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   TCustomMenuIniFile.New.IniFile.EraseSection(ListView.ItemFocused.SubItems[4]);
   Self.UpdateList;
end;

procedure TViewMainMenuCustomMenuList.Newfile1Click(Sender: TObject);
begin
   Self.CallCustomMenuCad;
end;

procedure TViewMainMenuCustomMenuList.UpdateList;
var
  LItem: TListItem;
begin
   ListView.Items.Clear;
   CustomMenuDM.LoadConfiguration;
   while(not CustomMenuDM.TB_Files.Eof)do
   begin
      LItem         := ListView.Items.Add;
      LItem.Caption := CustomMenuDM.TB_Files.FieldByName('Order').AsString;

      LItem.SubItems.Add(CustomMenuDM.TB_Files.FieldByName('Caption').AsString);
      LItem.SubItems.Add(CustomMenuDM.TB_Files.FieldByName('Action').AsString);
      LItem.SubItems.Add(CustomMenuDM.TB_Files.FieldByName('Parameter').AsString);
      LItem.SubItems.Add(CustomMenuDM.TB_Files.FieldByName('Shortcut').AsString);
      LItem.SubItems.Add(CustomMenuDM.TB_Files.FieldByName('Section').AsString);

      CustomMenuDM.TB_Files.Next;
   end;
end;

end.
