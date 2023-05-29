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
  MyOTAWizard.OnClicks,
  MyOTAWizard.MainMenu.Git,
  MyOTAWizard.MainMenu.External,
  MyOTAWizard.MainMenu.Tools,
  MyOTAWizard.MainMenu.Info;

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

   TMyOTAWizardMainMenuGit.CreateMenu(AParent, FImages);
   TMyOTAWizardMainMenuExternal.CreateMenu(AParent, FImages);
   TMyOTAWizardMainMenuTools.CreateMenu(AParent, FImages);
   TMyOTAWizardMainMenuInfo.CreateMenu(AParent, FImages);
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
