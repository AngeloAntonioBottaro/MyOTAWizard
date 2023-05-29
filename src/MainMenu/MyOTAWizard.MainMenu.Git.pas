unit MyOTAWizard.MainMenu.Git;

interface

uses
  System.Generics.Collections,
  Vcl.Menus;

type
  TMyOTAWizardMainMenuGit = class
  public
    class procedure CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
  end;

implementation

uses
  MyOTAWizard.MenuItem,
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks;

class procedure TMyOTAWizardMainMenuGit.CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemGitWebCaption)
    .Name(TMyOTAWizardConsts.MenuItemGitWebName)
    .ImageResource('github')
    .ShortCut(TMyOTAWizardShortCuts.OpenGitWeb)
    .OnClick(TMyOTAWizardOnClicks.OpenGitWeb)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemGitDesktopCaption)
    .Name(TMyOTAWizardConsts.MenuItemGitDesktopName)
    .ImageResource('github')
    .ShortCut(TMyOTAWizardShortCuts.OpenGitDesktop)
    .OnClick(TMyOTAWizardOnClicks.OpenGitDesktop)
    .CreateMenuItem;
end;

end.
