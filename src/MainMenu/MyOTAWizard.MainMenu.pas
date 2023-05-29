unit MyOTAWizard.MainMenu;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Menus,
  Vcl.Graphics;

type
  TMyOTAWizardMainMenu = class(TNotifierObject, IOTAWizard)
  private
    FDeplhiMainMenu: TMainMenu;
    FImages: TDictionary<string, Integer>;

    procedure AddImageToImageList(AResourceName: String);
    procedure CreateMainMenu;
    procedure MyMenuDestroyIfExists;
    procedure CreateMyMenu;
    procedure CreateMenus(AParent: TMenuItem);
    procedure CreateMenuExternals(AParent: TMenuItem);
    procedure CreateMenuGit(AParent: TMenuItem);
    procedure CreateMenuTools(AParent: TMenuItem);
    procedure CreateMenuSettings(AParent: TMenuItem);
    procedure CreateMenuInfo(AParent: TMenuItem);
  protected
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
  public
    class function New: IOTAWizard;
    constructor Create;
    destructor Destroy; override;
  end;

procedure RegisterMainMenuWizard;

implementation

uses
  MyOTAWizard.MenuItem,
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks;

procedure RegisterMainMenuWizard;
begin
   RegisterPackageWizard(TMyOTAWizardMainMenu.New);
end;

class function TMyOTAWizardMainMenu.New: IOTAWizard;
begin
   Result := Self.Create;
end;

constructor TMyOTAWizardMainMenu.Create;
begin
   FImages := TDictionary<string, Integer>.create;

   Self.AddImageToImageList('notepad');
   Self.AddImageToImageList('github');
   Self.AddImageToImageList('batch');
   Self.AddImageToImageList('info');
   Self.AddImageToImageList('tools');
   Self.AddImageToImageList('external');
   Self.AddImageToImageList('externalconf');
   Self.AddImageToImageList('settings');

   Self.CreateMainMenu;
end;

destructor TMyOTAWizardMainMenu.Destroy;
begin
   FImages.Free;
   inherited;
end;

procedure TMyOTAWizardMainMenu.AddImageToImageList(AResourceName: String);
var
  LBitmap: TBitmap;
  LImageIndex: Integer;
begin
  LBitmap := TBitmap.Create;
  try
    LBitmap.LoadFromResourceName(HInstance, AResourceName);
    LImageIndex := (BorlandIDEServices as INTAServices)
                     .AddMasked(LBitmap, LBitmap.TransparentColor, TMyOTAWizardConsts.ImagesPrefix + AResourceName);

    FImages.Add(AResourceName, LImageIndex);
  finally
    LBitmap.Free;
  end;
end;

procedure TMyOTAWizardMainMenu.CreateMainMenu;
begin
   FDeplhiMainMenu := (BorlandIDEServices as INTAServices).MainMenu;
   Self.CreateMyMenu;
end;

procedure TMyOTAWizardMainMenu.MyMenuDestroyIfExists;
begin
   if(FDeplhiMainMenu.FindComponent(TMyOTAWizardConsts.MenuName) <> nil)then
     FDeplhiMainMenu.FindComponent(TMyOTAWizardConsts.MenuName).Free;
end;

procedure TMyOTAWizardMainMenu.CreateMyMenu;
var
  LMyMenu: TMenuItem;
begin
   Self.MyMenuDestroyIfExists;

   LMyMenu         := TMenuItem.create(FDeplhiMainMenu);
   LMyMenu.Name    := TMyOTAWizardConsts.MenuName;
   LMyMenu.Caption := TMyOTAWizardConsts.MenuCaption;
   FDeplhiMainMenu.Items.Add(LMyMenu);

   Self.CreateMenus(LMyMenu);
end;

procedure TMyOTAWizardMainMenu.CreateMenus(AParent: TMenuItem);
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemNotepadCaption)
    .Name(TMyOTAWizardConsts.MenuItemNotepadName)
    .ImageResource('notepad')
    .OnClick(TMyOTAWizardOnClicks.Notepad)
    .CreateMenuItem;

   Self.CreateMenuGit(AParent);
   Self.CreateMenuExternals(AParent);
   Self.CreateMenuTools(AParent);
   Self.CreateMenuSettings(AParent);
   Self.CreateMenuInfo(AParent);
end;

procedure TMyOTAWizardMainMenu.CreateMenuExternals(AParent: TMenuItem);
var
  LMyMenuExternal: TMenuItem;
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .Caption('-')
    .Name('miSeparatorExternal')
    .CreateMenuItem;

   LMyMenuExternal := TMyOTAWizardMenuItem.New.Parent(AParent)
                       .ImageList(FImages)
                       .Caption(TMyOTAWizardConsts.MenuItemExternalCaption)
                       .Name(TMyOTAWizardConsts.MenuItemExternalName)
                       .ImageResource('external')
                       .CreateMenuItem;




   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .Caption('-')
    .Name('miSeparatorExternalsConf')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemExternalConfCaption)
    .Name(TMyOTAWizardConsts.MenuItemExternalConfName)
    .ImageResource('externalconf')
    .OnClick(TMyOTAWizardOnClicks.ExternalFilesConf)
    .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateMenuGit(AParent: TMenuItem);
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemGitWebCaption)
    .Name(TMyOTAWizardConsts.MenuItemGitWebName)
    .ImageResource('github')
    .ShortCut(TMyOTAWizardShortCuts.OpenGitWeb)
    .OnClick(TMyOTAWizardOnClicks.OpenGitWeb)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemGitDesktopCaption)
    .Name(TMyOTAWizardConsts.MenuItemGitDesktopName)
    .ImageResource('github')
    .ShortCut(TMyOTAWizardShortCuts.OpenGitDesktop)
    .OnClick(TMyOTAWizardOnClicks.OpenGitDesktop)
    .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateMenuTools(AParent: TMenuItem);
var
  LMyMenuExtra: TMenuItem;
begin
   LMyMenuExtra := TMyOTAWizardMenuItem.New
                    .Parent(AParent)
                    .ImageList(FImages)
                    .Caption(TMyOTAWizardConsts.MenuItemToolsCaption)
                    .Name(TMyOTAWizardConsts.MenuItemToolsName)
                    .ImageResource('tools')
                    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemToolsListaProjetosCaption)
    .Name(TMyOTAWizardConsts.MenuItemToolsListaProjetosName)
    .ImageResource('tools')
    .ShortCut(TMyOTAWizardShortCuts.ListProjects)
    .OnClick(TMyOTAWizardOnClicks.ListProjects)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemToolsListaAddProjetosCaption)
    .Name(TMyOTAWizardConsts.MenuItemToolsListaAddProjetosName)
    .ImageResource('tools')
    .ShortCut(TMyOTAWizardShortCuts.AddProjects)
    .OnClick(TMyOTAWizardOnClicks.AddProjectsToList)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemToolsOrganizarUsesCaption)
    .Name(TMyOTAWizardConsts.MenuItemToolsOrganizarUsesName)
    .ImageResource('tools')
    .ShortCut(TMyOTAWizardShortCuts.ArrangeUses)
    .OnClick(TMyOTAWizardOnClicks.ArrangeUses)
    .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateMenuInfo(AParent: TMenuItem);
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .Caption('-')
    .Name('miSeparatorInfo')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemTestesCaption)
    .Name(TMyOTAWizardConsts.MenuItemTestesName)
    .OnClick(TMyOTAWizardOnClicks.Info)
    .ImageResource('info')
    .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateMenuSettings(AParent: TMenuItem);
begin

end;

procedure TMyOTAWizardMainMenu.Execute;
begin
   //
end;

function TMyOTAWizardMainMenu.GetIDString: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardMainMenu.GetName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardMainMenu.GetState: TWizardState;
begin
   Result := [wsEnabled];
end;

end.
