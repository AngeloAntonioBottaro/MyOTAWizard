unit MyOTAWizard.MainMenu.External;

interface

uses
  System.Generics.Collections,
  Vcl.Menus;

type
  TMyOTAWizardMainMenuExternal = class
  public
    class procedure CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
  end;

implementation

uses
  MyOTAWizard.MenuItem,
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks;

class procedure TMyOTAWizardMainMenuExternal.CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
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
                       .Caption(TMyOTAWizardConsts.MenuItemExternalCaption)
                       .Name(TMyOTAWizardConsts.MenuItemExternalName)
                       .ImageResource('external')
                       .CreateMenuItem;

   //Self.LoadMenus;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .Caption('-')
    .Name('miSeparatorExternalsConf')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemExternalConfCaption)
    .Name(TMyOTAWizardConsts.MenuItemExternalConfName)
    .ImageResource('externalconf')
    .OnClick(TMyOTAWizardOnClicks.ExternalFilesConf)
    .CreateMenuItem;
end;

end.
