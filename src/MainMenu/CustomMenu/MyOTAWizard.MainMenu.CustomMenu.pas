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
    class procedure ExternalFilesClick(Sender: TObject);
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
         .OnClick(TMyOTAWizardMainMenuCustomMenu.ExternalFilesClick)
         .ShortCut(CustomMenuDM.TB_Files.FieldByName('Shortcut').AsString)
         .CreateMenuItem;

      CustomMenuDM.TB_Files.Next;
   end;
end;

class procedure TMyOTAWizardMainMenuCustomMenu.CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
var
  LMyMenuExternal: TMenuItem;
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .Caption('-')
    .Name('miSeparatorExternal')
    .CreateMenuItem;

   LMyMenuExternal := TMyOTAWizardMenuItem.New.Parent(AParent)
                       .ImageList(AImages)
                       .Caption(TMyOTAWizardConsts.MenuItemCustomCaption)
                       .Name(TMyOTAWizardConsts.MenuItemCustomName)
                       .ImageResource('external')
                       .CreateMenuItem;

   LoadMenus(LMyMenuExternal, AImages);

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .Caption('-')
    .Name('miSeparatorExternalsConf')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemCustomConfCaption)
    .Name(TMyOTAWizardConsts.MenuItemCustomConfName)
    .ImageResource('externalconf')
    .OnClick(TMyOTAWizardOnClicks.ExternalFilesConf)
    .CreateMenuItem;
end;

class procedure TMyOTAWizardMainMenuCustomMenu.ExternalFilesClick(Sender: TObject);
var
  LSection: string;
begin
   LSection := TMenuItem(Sender).Name;
   MessageLog(LSection);
end;

end.
