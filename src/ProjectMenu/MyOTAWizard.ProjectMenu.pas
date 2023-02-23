unit MyOTAWizard.ProjectMenu;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes;

type
  TMyOTAWizardProjectMenu = class(TNotifierObject, IOTAProjectMenuItemCreatorNotifier)
  private
  protected
    procedure AddMenu(const Project: IOTAProject; const IdentList: TStrings; const ProjectManagerMenuList: IInterfaceList; IsMultiSelect: Boolean);
  public
    class function New: IOTAProjectMenuItemCreatorNotifier;
  end;

var
  IndexContextMenu: Integer = -1;

procedure RegisterProjectMenuWizard;

implementation

uses
  MyOTAWizard.ProjectMenu.Item;

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
   if(IdentList.IndexOf(sProjectContainer) < 0)then
     Exit;

   ProjectManagerMenuList.Add(TMyOTAWizardProjectMenuSeparator.New);
   ProjectManagerMenuList.Add(TMyOTAWizardProjectMenuItem.New);
end;

initialization

finalization
  (BorlandIDEServices as IOTAProjectManager)
    .RemoveMenuItemCreatorNotifier(IndexContextMenu);

end.
