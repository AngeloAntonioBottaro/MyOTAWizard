unit MyOTAWizard.ProjectMenu.Item;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  MyOTAWizard.Types;

type
  TMyOTAWizardProjectMenuItem = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
  private
    FCaption: String;
    FIsMultiSelectable: Boolean;
    FChecked: Boolean;
    FEnabled: Boolean;
    FHelpContext: Integer;
    FName: string;
    FParent: string;
    FPosition: Integer;
    FVerb: string;
    FOnExecute: TMyOnContextMenuClick;
  protected
    function GetCaption: string;
    function GetChecked: Boolean;
    function GetEnabled: Boolean;
    function GetHelpContext: Integer;
    function GetName: string;
    function GetParent: string;
    function GetPosition: Integer;
    function GetVerb: string;
    procedure SetCaption(const Value: string);
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetHelpContext(Value: Integer);
    procedure SetName(const Value: string);
    procedure SetParent(const Value: string);
    procedure SetPosition(Value: Integer);
    procedure SetVerb(const Value: string);
    function GetIsMultiSelectable: Boolean;
    procedure SetIsMultiSelectable(Value: Boolean);
    procedure Execute(const MenuContextList: IInterfaceList); overload;
    function PreExecute(const MenuContextList: IInterfaceList): Boolean;
    function PostExecute(const MenuContextList: IInterfaceList): Boolean;
  public
    constructor create(AOnExecute: TMyOnContextMenuClick); overload;
    class function New(AOnExecute: TMyOnContextMenuClick): IOTAProjectManagerMenu; overload;
  end;

implementation

class function TMyOTAWizardProjectMenuItem.New(AOnExecute: TMyOnContextMenuClick): IOTAProjectManagerMenu;
begin
   Result := Self.Create(AOnExecute);
end;

constructor TMyOTAWizardProjectMenuItem.create(AOnExecute: TMyOnContextMenuClick);
begin
   FOnExecute         := AOnExecute;
   FEnabled           := True;
   FChecked           := False;
   FIsMultiSelectable := False;
end;

procedure TMyOTAWizardProjectMenuItem.Execute(const MenuContextList: IInterfaceList);
begin
   if Assigned(FOnExecute) then
    FOnExecute(MenuContextList);
end;

function TMyOTAWizardProjectMenuItem.GetCaption: string;
begin
   Result := FCaption;
end;

function TMyOTAWizardProjectMenuItem.GetChecked: Boolean;
begin
   Result := FChecked;
end;

function TMyOTAWizardProjectMenuItem.GetEnabled: Boolean;
begin
   Result := FEnabled;
end;

function TMyOTAWizardProjectMenuItem.GetHelpContext: Integer;
begin
   Result := FHelpContext;
end;

function TMyOTAWizardProjectMenuItem.GetIsMultiSelectable: Boolean;
begin
   Result := FIsMultiSelectable;
end;

function TMyOTAWizardProjectMenuItem.GetName: string;
begin
   Result := FName;
end;

function TMyOTAWizardProjectMenuItem.GetParent: string;
begin
   Result := FParent;
end;

function TMyOTAWizardProjectMenuItem.GetPosition: Integer;
begin
   Result := FPosition;
end;

function TMyOTAWizardProjectMenuItem.GetVerb: string;
begin
   Result := FVerb;
end;

function TMyOTAWizardProjectMenuItem.PostExecute(const MenuContextList: IInterfaceList): Boolean;
begin
   Result := True;
end;

function TMyOTAWizardProjectMenuItem.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
   Result := True;
end;

procedure TMyOTAWizardProjectMenuItem.SetCaption(const Value: string);
begin
   FCaption := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetChecked(Value: Boolean);
begin
   FChecked := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetEnabled(Value: Boolean);
begin
   FEnabled := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetHelpContext(Value: Integer);
begin
   FHelpContext := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetIsMultiSelectable(Value: Boolean);
begin
   FIsMultiSelectable := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetName(const Value: string);
begin
   FName := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetParent(const Value: string);
begin
   FParent := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetPosition(Value: Integer);
begin
   FPosition := Value;
end;

procedure TMyOTAWizardProjectMenuItem.SetVerb(const Value: string);
begin
   FVerb := Value;
end;

end.
