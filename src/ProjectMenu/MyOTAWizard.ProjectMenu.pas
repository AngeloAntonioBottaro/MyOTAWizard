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
    procedure OnExecuteAdicionarProjetoNaLista(const MenuContextList: IInterfaceList);
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

   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_ITEM_ADICIONAR_PROJETO_CAPTION, MY_MENU_ITEM_ADICIONAR_PROJETO_POSITION, MY_MENU_CAPTION, OnExecuteAdicionarProjetoNaLista));
   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_SEPARATOR, MY_MENU_ITEM_ADICIONAR_PROJETO_POSITION + 1, MY_MENU_CAPTION));

   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_ITEM_GITHUB_DESKTOP_CAPTION, MY_MENU_ITEM_GITHUB_DESKTOP_POSITION, MY_MENU_CAPTION));
   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_ITEM_GITHUB_WEB_CAPTION, MY_MENU_ITEM_GITHUB_WEB_POSITION, MY_MENU_CAPTION));

   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_SEPARATOR, MY_MENU_ITEM_GITHUB_WEB_POSITION + 1, MY_MENU_CAPTION));
   ProjectManagerMenuList.Add(Self.AddMenu(MY_MENU_ITEM_BOSS_INITIALIZED_CAPTION, MY_MENU_ITEM_BOSS_INITIALIZED_POSITION, MY_MENU_CAPTION, NIL, BossInitialized));
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

procedure TMyOTAWizardProjectMenu.OnExecuteAdicionarProjetoNaLista(const MenuContextList: IInterfaceList);
begin
   ViewProjectsListAddProject := TViewProjectsListAddProject.Create(nil);
   try
     ViewProjectsListAddProject.edtDiretorioProjeto.Text := FProject.FileName;
     ViewProjectsListAddProject.GetSelectedFileName;
     ViewProjectsListAddProject.ShowModal;
   finally
     FreeAndNil(ViewProjectsListAddProject);
   end;
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
