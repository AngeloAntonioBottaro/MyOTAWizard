unit MyOTAWizard.ProjectMenu.Item;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes;

type
  TMyOTAWizardProjectMenuItem = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
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
    class function New: IOTAProjectManagerMenu;
  end;
  TMyOTAWizardProjectMenuSeparator = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
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
    class function New: IOTAProjectManagerMenu;
  end;

implementation

uses
  MyOTAWizard.Consts;

{$REGION 'TMyOTAWizardProjectMenu'}

class function TMyOTAWizardProjectMenuItem.New: IOTAProjectManagerMenu;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardProjectMenuItem.Execute(const MenuContextList: IInterfaceList);
begin
   //
end;

function TMyOTAWizardProjectMenuItem.GetCaption: string;
begin
   Result := TMyOTAWizardConsts.MyProjectMenuCaption;
end;

function TMyOTAWizardProjectMenuItem.GetChecked: Boolean;
begin
   Result := False;
end;

function TMyOTAWizardProjectMenuItem.GetEnabled: Boolean;
begin
   Result := True;
end;

function TMyOTAWizardProjectMenuItem.GetHelpContext: Integer;
begin
   Result := 0;
end;

function TMyOTAWizardProjectMenuItem.GetIsMultiSelectable: Boolean;
begin
   Result := False;
end;

function TMyOTAWizardProjectMenuItem.GetName: string;
begin
   Result := TMyOTAWizardConsts.MyProjectMenuName;
end;

function TMyOTAWizardProjectMenuItem.GetParent: string;
begin
   Result := '';
end;

function TMyOTAWizardProjectMenuItem.GetPosition: Integer;
begin
   Result := pmmpInstallSeparator - TMyOTAWizardConsts.MyProjectMenuSpaceValue;
end;

function TMyOTAWizardProjectMenuItem.GetVerb: string;
begin
   Result := 'verb' + TMyOTAWizardConsts.MyProjectMenuName;
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
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetChecked(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetEnabled(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetHelpContext(Value: Integer);
begin
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetIsMultiSelectable(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetName(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetParent(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetPosition(Value: Integer);
begin
   //
end;

procedure TMyOTAWizardProjectMenuItem.SetVerb(const Value: string);
begin
   //
end;

{$ENDREGION 'TMyOTAWizardProjectMenu'}

{$REGION 'TMyOTAWizardProjectMenuSeparator'}

class function TMyOTAWizardProjectMenuSeparator.New: IOTAProjectManagerMenu;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardProjectMenuSeparator.Execute(const MenuContextList: IInterfaceList);
begin
   //
end;

function TMyOTAWizardProjectMenuSeparator.GetCaption: string;
begin
   Result := '-';
end;

function TMyOTAWizardProjectMenuSeparator.GetChecked: Boolean;
begin
   Result := False;
end;

function TMyOTAWizardProjectMenuSeparator.GetEnabled: Boolean;
begin
   Result := True;
end;

function TMyOTAWizardProjectMenuSeparator.GetHelpContext: Integer;
begin
   Result := 0;
end;

function TMyOTAWizardProjectMenuSeparator.GetIsMultiSelectable: Boolean;
begin
   Result := False;
end;

function TMyOTAWizardProjectMenuSeparator.GetName: string;
begin
   Result := TMyOTAWizardConsts.MyProjectMenuSeparatorName;
end;

function TMyOTAWizardProjectMenuSeparator.GetParent: string;
begin
   Result := '';
end;

function TMyOTAWizardProjectMenuSeparator.GetPosition: Integer;
begin
   Result := pmmpInstallSeparator - TMyOTAWizardConsts.MyProjectMenuSpaceValue - 1;
end;

function TMyOTAWizardProjectMenuSeparator.GetVerb: string;
begin
   Result := 'verb' + TMyOTAWizardConsts.MyProjectMenuSeparatorName;
end;

function TMyOTAWizardProjectMenuSeparator.PostExecute(const MenuContextList: IInterfaceList): Boolean;
begin
   Result := True;
end;

function TMyOTAWizardProjectMenuSeparator.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
   Result := True;
end;

procedure TMyOTAWizardProjectMenuSeparator.SetCaption(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetChecked(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetEnabled(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetHelpContext(Value: Integer);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetIsMultiSelectable(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetName(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetParent(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetPosition(Value: Integer);
begin
   //
end;

procedure TMyOTAWizardProjectMenuSeparator.SetVerb(const Value: string);
begin
   //
end;

{$ENDREGION 'TMyOTAWizardProjectMenuSeparator'}

end.
