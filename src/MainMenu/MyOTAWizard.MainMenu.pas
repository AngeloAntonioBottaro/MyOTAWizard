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
    procedure CreateSubMenuBatch(AParent: TMenuItem);
    procedure CreateMenuGit(AParent: TMenuItem);
    procedure CreateMenuInfo(AParent: TMenuItem);
    procedure CreateSubMenuExtras(AParent: TMenuItem);
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

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenu)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemNotepadCaption)
    .Name(TMyOTAWizardConsts.MenuItemNotepadName)
    .ImageResource('notepad')
    .OnClick(TMyOTAWizardOnClicks.Notepad)
    .CreateMenuItem;

   Self.CreateMenuGit(LMyMenu);
   Self.CreateSubMenuBatch(LMyMenu);
   Self.CreateMenuInfo(LMyMenu);

   //INVISIBLE - FOR SHORTCUTS
   Self.CreateSubMenuExtras(LMyMenu);
end;

procedure TMyOTAWizardMainMenu.CreateMenuGit(AParent: TMenuItem);
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .Caption('-')
    .Name('miSeparatorGit')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemGitWebCaption)
    .Name(TMyOTAWizardConsts.MenuItemGitWebName)
    .ImageResource('github')
    .ShortCut(TMyOTAWizardShortCuts.OpenGitWeb)
    .OnClick(TMyOTAWizardOnClicks.GitWeb)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemGitDesktopCaption)
    .Name(TMyOTAWizardConsts.MenuItemGitDesktopName)
    .ImageResource('github')
    .ShortCut(TMyOTAWizardShortCuts.OpenGitDesktop)
    .OnClick(TMyOTAWizardOnClicks.GitDesktop)
    .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateSubMenuBatch(AParent: TMenuItem);
var
  LMyMenuBatch: TMenuItem;
begin
   LMyMenuBatch := TMyOTAWizardMenuItem.New.Parent(AParent)
                    .ImageList(FImages)
                    .Caption(TMyOTAWizardConsts.MenuItemBatchCaption)
                    .Name(TMyOTAWizardConsts.MenuItemBatchName)
                    .ImageResource('batch')
                    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuBatch)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MenuItemBatchCompactarMyERPCaption)
    .Name(TMyOTAWizardConsts.MenuItemBatchCompactarMyERPName)
    .ImageResource('batch')
    .OnClick(TMyOTAWizardOnClicks.BatchCompactMyERP)
    .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateSubMenuExtras(AParent: TMenuItem);
var
  LMyMenuExtra: TMenuItem;
begin
   LMyMenuExtra := TMyOTAWizardMenuItem.New
                    .Parent(AParent)
                    .Caption(TMyOTAWizardConsts.MenuItemExtrasCaption)
                    .Name(TMyOTAWizardConsts.MenuItemExtrasName)
                    .Visible(False)
                    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .Caption(TMyOTAWizardConsts.MenuItemExtrasListaProjetosCaption)
    .Name(TMyOTAWizardConsts.MenuItemExtrasListaProjetosName)
    .ShortCut(TMyOTAWizardShortCuts.ListProjects)
    .OnClick(TMyOTAWizardOnClicks.ListProjects)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .Caption(TMyOTAWizardConsts.MenuItemExtrasListaAddProjetosCaption)
    .Name(TMyOTAWizardConsts.MenuItemExtrasListaAddProjetosName)
    .ShortCut(TMyOTAWizardShortCuts.AddProjects)
    .OnClick(TMyOTAWizardOnClicks.AddProjectsToList)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .Caption(TMyOTAWizardConsts.MenuItemExtrasOrganizarUsesCaption)
    .Name(TMyOTAWizardConsts.MenuItemExtrasOrganizarUsesName)
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
