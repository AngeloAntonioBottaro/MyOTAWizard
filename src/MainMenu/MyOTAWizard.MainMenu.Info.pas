unit MyOTAWizard.MainMenu.Info;

interface

uses
  System.Generics.Collections,
  Vcl.Menus;

type
  TMyOTAWizardMainMenuInfo = class
  public
    class procedure CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
  end;

implementation

uses
  MyOTAWizard.MenuItem,
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks;

class procedure TMyOTAWizardMainMenuInfo.CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .Caption('-')
    .Name('miSeparatorInfo')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemTestesCaption)
    .Name(TMyOTAWizardConsts.MenuItemTestesName)
    .OnClick(TMyOTAWizardOnClicks.Info)
    .ImageResource('info')
    .CreateMenuItem;
end;

end.
