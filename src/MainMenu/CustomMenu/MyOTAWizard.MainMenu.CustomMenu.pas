unit MyOTAWizard.MainMenu.CustomMenu;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Menus;

type
  TMyOTAWizardMainMenuCustomMenu = class
  public
    class procedure CustomMenuClick(Sender: TObject);
    class procedure CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
  end;

implementation

uses
  MyOTAWizard.MenuItem,
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks,
  MyOTAWizard.Utils,
  MyOTAWizard.MainMenu.CustomMenu.Ini,
  MyOTAWizard.MainMenu.CustomMenu.DM,
  MyOTAWizard.MainMenu.CustomMenu.Types;

procedure LoadMenus(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
var
  LImg: string;
begin
   if(CustomMenuDM = nil)then CustomMenuDM := TCustomMenuDM.Create(nil);
   CustomMenuDM.LoadConfiguration;
   while(not CustomMenuDM.TB_Files.Eof)do
   begin
      LImg := 'external';
      if(CustomMenuDM.TB_Files.FieldByName('type').AsString.Equals(TCustomMenuType.ExternalFile.ToString))then
        LImg := 'file';
      if(CustomMenuDM.TB_Files.FieldByName('type').AsString.Equals(TCustomMenuType.Link.ToString))then
        LImg := 'link';
      if(CustomMenuDM.TB_Files.FieldByName('type').AsString.Equals(TCustomMenuType.CMDCommand.ToString))then
        LImg := 'cmd';

      TMyOTAWizardMenuItem.New
         .Parent(AParent)
         .ImageList(AImages)
         .Caption(CustomMenuDM.TB_Files.FieldByName('Caption').AsString)
         .Name('externalconf' + IntToStr(CustomMenuDM.TB_Files.RecNo))
         .ImageResource(LImg)
         .OnClick(TMyOTAWizardMainMenuCustomMenu.CustomMenuClick)
         .ShortCut(CustomMenuDM.TB_Files.FieldByName('Shortcut').AsString)
         .Tag(CustomMenuDM.TB_Files.FieldByName('Id').AsInteger)
         .CreateMenuItem;

      CustomMenuDM.TB_Files.Next;
   end;
end;

class procedure TMyOTAWizardMainMenuCustomMenu.CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
var
  LMyCustomMenu: TMenuItem;
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .Caption('-')
    .Name('miSeparatorExternal')
    .CreateMenuItem;

   LMyCustomMenu := TMyOTAWizardMenuItem.New.Parent(AParent)
                       .ImageList(AImages)
                       .Caption(TMyOTAWizardConsts.MenuItemCustomCaption)
                       .Name(TMyOTAWizardConsts.MenuItemCustomName)
                       .ImageResource('external')
                       .CreateMenuItem;

   LoadMenus(LMyCustomMenu, AImages);

   TMyOTAWizardMenuItem.New
    .Parent(LMyCustomMenu)
    .Caption('-')
    .Name('miSeparatorExternalsConf')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyCustomMenu)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemCustomConfCaption)
    .Name(TMyOTAWizardConsts.MenuItemCustomConfName)
    .ImageResource('externalconf')
    .OnClick(TMyOTAWizardOnClicks.CustomMenuConf)
    .CreateMenuItem;
end;

class procedure TMyOTAWizardMainMenuCustomMenu.CustomMenuClick(Sender: TObject);
var
  LType: string;
  LAction: string;
  LParam: string;
begin
   if(not CustomMenuDM.TB_Files.Locate('Id', TMenuItem(Sender).Tag, []))then
     Exit;

   LType   := CustomMenuDM.TB_Files.FieldByName('type').AsString;
   LAction := CustomMenuDM.TB_Files.FieldByName('Action').AsString;
   LParam  := CustomMenuDM.TB_Files.FieldByName('Parameter').AsString;

   if((LType.Equals(TCustomMenuType.ExternalFile.ToString))or
     (LType.Equals(TCustomMenuType.Folder.ToString))or
     (LType.Equals(TCustomMenuType.Link.ToString))
   )then
     TMyOTAWizardUtils.Open(LAction, LParam);

   if(LType.Equals(TCustomMenuType.CMDCommand.ToString))then
     TMyOTAWizardUtils.Exec(LAction);
end;

end.
