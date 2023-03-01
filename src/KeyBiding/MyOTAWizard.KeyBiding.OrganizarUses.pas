unit MyOTAWizard.KeyBiding.OrganizarUses;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Menus;

type
  TMyOTAWizardKeyBidingOrganizarUses = class(TNotifierObject, IOTAKeyboardBinding)
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

class function TMyOTAWizardKeyBidingOrganizarUses.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingOrganizarUses.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.OrganizarUses)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MyMenuItemExtrasOrganizarUsesName);
end;

procedure TMyOTAWizardKeyBidingOrganizarUses.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.OrganizarUses(nil);
end;

function TMyOTAWizardKeyBidingOrganizarUses.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingOrganizarUses.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingOrganizarUses.GetName: string;
begin
   Result := Self.ClassName;
end;

end.
