unit MyOTAWizard.KeyBiding.ListProjects;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Menus;

type
  TMyOTAWizardKeyBidingListProjects = class(TNotifierObject, IOTAKeyboardBinding)
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

class function TMyOTAWizardKeyBidingListProjects.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingListProjects.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.ListProjects)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MenuItemToolsListaProjetosName);
end;

procedure TMyOTAWizardKeyBidingListProjects.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.ListProjects(nil);
end;

function TMyOTAWizardKeyBidingListProjects.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingListProjects.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingListProjects.GetName: string;
begin
   Result := Self.ClassName;
end;

end.
