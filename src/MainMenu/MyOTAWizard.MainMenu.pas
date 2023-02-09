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
  MyOTAWizard.Consts,
  MyOTAWizard.MenuItem,
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

   Self.AddImageToImageList('icone');

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
                     .AddMasked(LBitmap, LBitmap.TransparentColor, TMyOTAWizardConsts.MyImagesPrefix + AResourceName);

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
   if(FDeplhiMainMenu.FindComponent(TMyOTAWizardConsts.MyMenuName) <> nil)then
     FDeplhiMainMenu.FindComponent(TMyOTAWizardConsts.MyMenuName).Free;
end;

procedure TMyOTAWizardMainMenu.CreateMyMenu;
var
  LMyMenu: TMenuItem;
begin
   Self.MyMenuDestroyIfExists;

   LMyMenu         := TMenuItem.create(FDeplhiMainMenu);
   LMyMenu.Name    := TMyOTAWizardConsts.MyMenuName;
   LMyMenu.Caption := TMyOTAWizardConsts.MyMenuCaption;
   FDeplhiMainMenu.Items.Add(LMyMenu);

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenu)
    .ImageList(FImages)
    .Caption('Notepad++')
    .Name(TMyOTAWizardConsts.MyMenuItemNameNotepad)
    .ImageResource('icone')
    .ShortCut(TMyOTAWizardShortCuts.Notepad)
    .OnClick(TMyOTAWizardOnClicks.Notepad)
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
