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

   Self.AddImageToImageList('batch');
   Self.AddImageToImageList('notepad');
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
    .Caption(TMyOTAWizardConsts.MyMenuItemNotepadCaption)
    .Name(TMyOTAWizardConsts.MyMenuItemNotepadName)
    .ImageResource('notepad')
    .OnClick(TMyOTAWizardOnClicks.Notepad)
    .CreateMenuItem;

   Self.CreateSubMenuBatch(LMyMenu);
   Self.CreateSubMenuExtras(LMyMenu);

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenu)
    .ImageList(FImages)
    .Caption('-')
    .Name('miSeparator1')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenu)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MyMenuItemTestesCaption)
    .Name(TMyOTAWizardConsts.MyMenuItemTestesName)
    .OnClick(TMyOTAWizardOnClicks.Testes)
    .ImageResource('info')
    .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateSubMenuBatch(AParent: TMenuItem);
var
  LMyMenuBatch: TMenuItem;
begin
   LMyMenuBatch := TMyOTAWizardMenuItem.New
                     .Parent(AParent)
                     .ImageList(FImages)
                     .Caption(TMyOTAWizardConsts.MyMenuItemBatchCaption)
                     .Name(TMyOTAWizardConsts.MyMenuItemBatchName)
                     .ImageResource('batch')
                     .CreateMenuItem;

   TMyOTAWizardMenuItem.New
     .Parent(LMyMenuBatch)
     .ImageList(FImages)
     .Caption(TMyOTAWizardConsts.MyMenuItemBatchCompactarMyERPCaption)
     .Name(TMyOTAWizardConsts.MyMenuItemBatchCompactarMyERPName)
     .ImageResource('batch')
     .OnClick(TMyOTAWizardOnClicks.BatchCompactarMyERP)
     .CreateMenuItem;
end;

procedure TMyOTAWizardMainMenu.CreateSubMenuExtras(AParent: TMenuItem);
var
  LMyMenuExtra: TMenuItem;
begin
   LMyMenuExtra := TMyOTAWizardMenuItem.New
                     .Parent(AParent)
                     .ImageList(FImages)
                     .Caption(TMyOTAWizardConsts.MyMenuItemExtrasCaption)
                     .Name(TMyOTAWizardConsts.MyMenuItemExtrasName)
                     .ImageResource('')
                     .Visible(False)
                     .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MyMenuItemExtrasListaProjetosCaption)
    .Name(TMyOTAWizardConsts.MyMenuItemExtrasListaProjetosName)
    .ImageResource('')
    .ShortCut(TMyOTAWizardShortCuts.ListarProjetos)
    .OnClick(TMyOTAWizardOnClicks.ListarProjetos)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MyMenuItemExtrasListaAddProjetosCaption)
    .Name(TMyOTAWizardConsts.MyMenuItemExtrasListaAddProjetosName)
    .ImageResource('')
    .ShortCut(TMyOTAWizardShortCuts.AdicionarProjetos)
    .OnClick(TMyOTAWizardOnClicks.AdicionarProjetosLista)
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExtra)
    .ImageList(FImages)
    .Caption(TMyOTAWizardConsts.MyMenuItemExtrasOrganizarUsesCaption)
    .Name(TMyOTAWizardConsts.MyMenuItemExtrasOrganizarUsesName)
    .ImageResource('')
    .ShortCut(TMyOTAWizardShortCuts.OrganizarUses)
    .OnClick(TMyOTAWizardOnClicks.OrganizarUses)
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
