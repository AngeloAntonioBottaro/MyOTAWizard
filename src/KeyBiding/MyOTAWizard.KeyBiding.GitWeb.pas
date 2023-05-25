unit MyOTAWizard.KeyBiding.GitWeb;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Menus;

type
  TMyOTAWizardKeyBidingGitWeb = class(TNotifierObject, IOTAKeyboardBinding)
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

class function TMyOTAWizardKeyBidingGitWeb.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingGitWeb.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.OpenGitWeb)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MenuItemGitWebName);
end;

procedure TMyOTAWizardKeyBidingGitWeb.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.OpenGitWeb(nil);
end;

function TMyOTAWizardKeyBidingGitWeb.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingGitWeb.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingGitWeb.GetName: string;
begin
   Result := Self.ClassName;
end;

end.
