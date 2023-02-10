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

{$REGION 'BatchCompactarERP'}
  TMyOTAWizardKeyBidingCompactarMyERP = class(TNotifierObject, IOTAKeyboardBinding)
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
{$ENDREGION 'BatchCompactarERP'}

procedure RegisterKeyBidings;

implementation

uses
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks;

var
  FLista: TList<Integer>;

procedure RegisterKeyBidings;
begin
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingNotepad.New));
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingCompactarMyERP.New));
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

{$REGION 'CompactarMyERP'}
class function TMyOTAWizardKeyBidingCompactarMyERP.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingCompactarMyERP.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.BatchCompactarMyERP)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MyMenuItemBatchCompactarMyERPName);
end;

procedure TMyOTAWizardKeyBidingCompactarMyERP.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.BatchCompactarMyERP(nil);
end;

function TMyOTAWizardKeyBidingCompactarMyERP.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingCompactarMyERP.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingCompactarMyERP.GetName: string;
begin
   Result := Self.ClassName;
end;
{$ENDREGION 'CompactarMyERP'}

initialization
  FLista := TList<Integer>.Create;

finalization
  while(FLista.Count <> 0)do
  begin
     (BorlandIDEServices as IOTAKeyboardServices)
      .RemoveKeyboardBinding(FLista.Items[0]);
     FLista.Delete(0);
     FLista.TrimExcess;
  end;
  FLista.Free;


end.
