unit MyOTAWizard.KeyBiding.AddProjectsToList;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Menus;

type
  TMyOTAWizardKeyBidingAddProjectsToList = class(TNotifierObject, IOTAKeyboardBinding)
  private
    procedure Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
  protected
    function GetBindingType : TBindingType;
    function GetDisplayName : string;
    function GetName        : string;
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
  public
    class function New: IOTAKeyboardBinding;
  end;

implementation

uses
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks;

class function TMyOTAWizardKeyBidingAddProjectsToList.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingAddProjectsToList.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.AddProjects)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MenuItemExtrasListaAddProjetosName);
end;

procedure TMyOTAWizardKeyBidingAddProjectsToList.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.AddProjectsToList(nil);
end;

function TMyOTAWizardKeyBidingAddProjectsToList.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingAddProjectsToList.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingAddProjectsToList.GetName: string;
begin
   Result := Self.ClassName;
end;

end.
