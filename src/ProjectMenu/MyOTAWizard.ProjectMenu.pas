unit MyOTAWizard.ProjectMenu;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  MyOTAWizard.Types;

type
  TMyOTAWizardProjectMenu = class(TNotifierObject, IOTAProjectMenuItemCreatorNotifier)
  private
    FProject: IOTAProject;
    procedure OnExecuteAddProjectToList(const MenuContextList: IInterfaceList);
    procedure OnExecuteOpenGithubWeb(const MenuContextList: IInterfaceList);
    procedure OnExecuteOpenGithubDesktop(const MenuContextList: IInterfaceList);
    procedure OnExecuteBossIntall(const MenuContextList: IInterfaceList);
    function BossInitCaption: string;
    function BossInitialized: Boolean;

    function AddMenu(ACaption: String;
                     APosition: Integer;
                     AParent: string = '';
                     AOnExecute: TMYOnContextMenuClick = nil;
                     AChecked: Boolean = False): IOTAProjectManagerMenu; overload;
  protected
    procedure AddMenu(const Project: IOTAProject; const IdentList: TStrings; const ProjectManagerMenuList: IInterfaceList; IsMultiSelect: Boolean); overload;
  public
    class function New: IOTAProjectMenuItemCreatorNotifier;
  end;

var
  IndexContextMenu: Integer = -1;

procedure RegisterProjectMenuWizard;

implementation

uses
  MyOTAWizard.ProjectMenu.Consts,
  MyOTAWizard.ProjectMenu.Item,
  MyOTAWizard.Utils,
  View.ProjectsList.AddProject;

procedure RegisterProjectMenuWizard;
begin
   IndexContextMenu := (BorlandIDEServices as IOTAProjectManager).AddMenuItemCreatorNotifier(TMyOTAWizardProjectMenu.New);
end;

class function TMyOTAWizardProjectMenu.New: IOTAProjectMenuItemCreatorNotifier;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardProjectMenu.AddMenu(const Project: IOTAProject; const IdentList: TStrings; const ProjectManagerMenuList: IInterfaceList; IsMultiSelect: Boolean);
begin
   if((IdentList.IndexOf(sProjectContainer) < 0)and(IdentList.IndexOf(sProjectGroupContainer) < 0)or
      (not Assigned(ProjectManagerMenuList))
   )then
     Exit;

   FProject := Project;
   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_SEPARATOR, MY_MENU_POSITION -1));
   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_CAPTION, MY_MENU_POSITION));

   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_ITEM_ADICIONAR_PROJETO_CAPTION, MY_MENU_ITEM_ADICIONAR_PROJETO_POSITION, MY_MENU_CAPTION, OnExecuteAddProjectToList));
   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_SEPARATOR, MY_MENU_ITEM_ADICIONAR_PROJETO_POSITION + 1, MY_MENU_CAPTION));

   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_ITEM_GITHUB_DESKTOP_CAPTION, MY_MENU_ITEM_GITHUB_DESKTOP_POSITION, MY_MENU_CAPTION, OnExecuteOpenGithubDesktop));
   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_ITEM_GITHUB_WEB_CAPTION, MY_MENU_ITEM_GITHUB_WEB_POSITION, MY_MENU_CAPTION, OnExecuteOpenGithubWeb));

   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_SEPARATOR, MY_MENU_ITEM_GITHUB_WEB_POSITION + 1, MY_MENU_CAPTION));
   ProjectManagerMenuList.Add(Self.AddMenu(BossInitCaption, MY_MENU_ITEM_BOSS_INITIALIZED_POSITION, MY_MENU_CAPTION, OnExecuteBossIntall, BossInitialized));
end;

function TMyOTAWizardProjectMenu.AddMenu(ACaption: String; APosition: Integer; AParent: string; AOnExecute: TMYOnContextMenuClick; AChecked: Boolean): IOTAProjectManagerMenu;
begin
   result                   := TMyOTAWizardProjectMenuItem.New(AOnExecute);
   Result.Caption           := ACaption;
   result.Verb              := ACaption;
   Result.Parent            := AParent;
   result.Position          := APosition;
   result.Checked           := AChecked;
   result.IsMultiSelectable := False;
end;

{$REGION 'OnExecute'}

procedure TMyOTAWizardProjectMenu.OnExecuteAddProjectToList(const MenuContextList: IInterfaceList);
begin
   ViewProjectsListAddProject := TViewProjectsListAddProject.Create(nil);
   try
     ViewProjectsListAddProject.edtDiretorioProjeto.Text := FProject.FileName;
     ViewProjectsListAddProject.ShowModal;
   finally
     FreeAndNil(ViewProjectsListAddProject);
   end;
end;

procedure TMyOTAWizardProjectMenu.OnExecuteBossIntall(const MenuContextList: IInterfaceList);
begin
   if(BossInitialized)then
     Exit;

   TMyOTAWizardUtils.Exec(BOSS_INIT);
end;

procedure TMyOTAWizardProjectMenu.OnExecuteOpenGithubWeb(const MenuContextList: IInterfaceList);
var
  LURL: string;
begin
   LURL := TMyOTAWizardUtils.GetGitURL(FProject.FileName);
   if(not LURL.Trim.IsEmpty)then
     TMyOTAWizardUtils.Open(LURL.Trim);
end;

procedure TMyOTAWizardProjectMenu.OnExecuteOpenGithubDesktop(const MenuContextList: IInterfaceList);
begin
   TMyOTAWizardUtils.OpenProjectOnGithubDesktop(FProject.FileName);
end;

function TMyOTAWizardProjectMenu.BossInitCaption: string;
begin
   Result := MY_MENU_ITEM_BOSS_INITIALIZE_CAPTION;
   if(BossInitialized)then
     Result := MY_MENU_ITEM_BOSS_INITIALIZED_CAPTION;
end;

function TMyOTAWizardProjectMenu.BossInitialized: Boolean;
begin
   Result := FileExists(ExtractFilePath(FProject.FileName) + 'boss.json');
end;

{$ENDREGION 'OnExecute'}

initialization

finalization
  (BorlandIDEServices as IOTAProjectManager)
    .RemoveMenuItemCreatorNotifier(IndexContextMenu);

end.
