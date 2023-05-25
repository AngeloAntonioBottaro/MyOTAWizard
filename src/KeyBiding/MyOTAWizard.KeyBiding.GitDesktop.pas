unit MyOTAWizard.KeyBiding.GitDesktop;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Menus;

type
  TMyOTAWizardKeyBidingGitDesktop = class(TNotifierObject, IOTAKeyboardBinding)
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

class function TMyOTAWizardKeyBidingGitDesktop.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingGitDesktop.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.OpenGitDesktop)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MenuItemGitDesktopName);
end;

procedure TMyOTAWizardKeyBidingGitDesktop.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.GitDesktop(nil);
end;

function TMyOTAWizardKeyBidingGitDesktop.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingGitDesktop.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingGitDesktop.GetName: string;
begin
   Result := Self.ClassName;
end;

end.
