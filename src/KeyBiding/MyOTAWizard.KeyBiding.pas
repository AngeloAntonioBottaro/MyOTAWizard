unit MyOTAWizard.KeyBiding;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Menus;

type
{$REGION 'ListarProjetos'}
  TMyOTAWizardKeyBidingListarProjetos = class(TNotifierObject, IOTAKeyboardBinding)
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
{$ENDREGION 'ListarProjetos'}

{$REGION 'AdicionarProjetos'}
  TMyOTAWizardKeyBidingAdicionarProjetos = class(TNotifierObject, IOTAKeyboardBinding)
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
{$ENDREGION 'AdicionarProjetos'}

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
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingListarProjetos.New));
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingAdicionarProjetos.New));
end;

{$REGION 'ListarProjetos'}
class function TMyOTAWizardKeyBidingListarProjetos.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingListarProjetos.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.ListarProjetos)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MyMenuItemExtrasListaProjetosName);
end;

procedure TMyOTAWizardKeyBidingListarProjetos.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.ListarProjetos(nil);
end;

function TMyOTAWizardKeyBidingListarProjetos.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingListarProjetos.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingListarProjetos.GetName: string;
begin
   Result := Self.ClassName;
end;
{$ENDREGION 'ListarProjetos'}

{$REGION 'AdicionarProjetos'}
class function TMyOTAWizardKeyBidingAdicionarProjetos.New: IOTAKeyboardBinding;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardKeyBidingAdicionarProjetos.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
   BindingServices.AddKeyBinding([TextToShortCut(TMyOTAWizardShortCuts.AdicionarProjetos)], Self.Execute, nil, 0, '', TMyOTAWizardConsts.MyMenuItemExtrasListaAddProjetosName);
end;

procedure TMyOTAWizardKeyBidingAdicionarProjetos.Execute(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
   BindingResult := krHandled;
   TMyOTAWizardOnClicks.AdicionarProjetosLista(nil);
end;

function TMyOTAWizardKeyBidingAdicionarProjetos.GetBindingType: TBindingType;
begin
   Result := btPartial;
end;

function TMyOTAWizardKeyBidingAdicionarProjetos.GetDisplayName: string;
begin
   Result := Self.ClassName;
end;

function TMyOTAWizardKeyBidingAdicionarProjetos.GetName: string;
begin
   Result := Self.ClassName;
end;
{$ENDREGION 'AdicionarProjetos'}

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
