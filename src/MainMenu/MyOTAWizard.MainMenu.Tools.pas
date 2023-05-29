unit MyOTAWizard.MainMenu.Tools;

interface

uses
  System.Generics.Collections,
  Vcl.Menus;

type
  TMyOTAWizardMainMenuTools = class
  public
    class procedure CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
  end;

implementation

uses
  MyOTAWizard.MenuItem,
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks;

class procedure TMyOTAWizardMainMenuTools.CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
var
  LMyMenuExtra: TMenuItem;
begin
   LMyMenuExtra := TMyOTAWizardMenuItem.New
                    .Parent(AParent)
                    .ImageList(AImages)
                    .Caption(TMyOTAWizardConsts.MenuItemToolsCaption)
                    .Name(TMyOTAWizardConsts.MenuItemToolsName)
                    .ImageResource('tools')
                    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemToolsListaProjetosCaption)
    .Name(TMyOTAWizardConsts.MenuItemToolsListaProjetosName)
    .ImageResource('tools')
    .ShortCut(TMyOTAWizardShortCuts.ListProjects)
    .OnClick(TMyOTAWizardOnClicks.ListProjects)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemToolsListaAddProjetosCaption)
    .Name(TMyOTAWizardConsts.MenuItemToolsListaAddProjetosName)
    .ImageResource('tools')
    .ShortCut(TMyOTAWizardShortCuts.AddProjects)
    .OnClick(TMyOTAWizardOnClicks.AddProjectsToList)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemToolsOrganizarUsesCaption)
    .Name(TMyOTAWizardConsts.MenuItemToolsOrganizarUsesName)
    .ImageResource('tools')
    .ShortCut(TMyOTAWizardShortCuts.ArrangeUses)
    .OnClick(TMyOTAWizardOnClicks.ArrangeUses)
    .CreateMenuItem;
end;

end.
