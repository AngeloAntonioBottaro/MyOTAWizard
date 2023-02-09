unit MyOTAWizard.KeyBiding;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Menus;

type
{$REGION 'Notepad'}
  TMyOTAWizardKeyBidingNotepad = class(TNotifierObject, IOTAKeyboardBinding)
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
{$ENDREGION 'Notepad'}

procedure RegisterKeyBidings;

implementation

uses
  MyOTAWizard.Consts,
  MyOTAWizard.OnClicks;

var
  FLista: TList<Integer>;

procedure RegisterKeyBidings;
begin
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingNotepad.New));
end;

{$REGION 'Notepad'}
class function TMyOTAWizardKeyBidingNotepad.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingNotepad.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.Notepad)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MyMenuItemNotepadName);
end;

procedure TMyOTAWizardKeyBidingNotepad.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.Notepad(nil);
end;

function TMyOTAWizardKeyBidingNotepad.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingNotepad.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingNotepad.GetName: string;
begin
   Result := Self.ClassName;
end;
{$ENDREGION 'Notepad'}

initialization
  FLista := TList<Integer>.Create;

finalization
  while(FLista.Count <> 0)do
  begin
     (BorlandIDEServices as IOTAKeyboardServices)
      .RemoveKeyboardBinding(FLista.Items[0]);
     FLista.Delete(0);
  end;
  FLista.Free;


end.
