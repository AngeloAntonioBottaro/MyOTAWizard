unit MyOTAWizard.ProjectMenu.Item;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes;

type
  TMyOTAWizardProjectMenu = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
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

class function TMyOTAWizardProjectMenu.New: IOTAProjectManagerMenu;
begin
   Result := Self.Create;
end;

procedure TMyOTAWizardProjectMenu.Execute(const MenuContextList: IInterfaceList);
begin
   //
end;

function TMyOTAWizardProjectMenu.GetCaption: string;
begin
   Result := TMyOTAWizardConsts.MyProjectMenuCaption;
end;

function TMyOTAWizardProjectMenu.GetChecked: Boolean;
begin
   Result := False;
end;

function TMyOTAWizardProjectMenu.GetEnabled: Boolean;
begin
   Result := True;
end;

function TMyOTAWizardProjectMenu.GetHelpContext: Integer;
begin
   Result := 0;
end;

function TMyOTAWizardProjectMenu.GetIsMultiSelectable: Boolean;
begin
   Result := False;
end;

function TMyOTAWizardProjectMenu.GetName: string;
begin
   Result := TMyOTAWizardConsts.MyProjectMenuName;
end;

function TMyOTAWizardProjectMenu.GetParent: string;
begin
   Result := '';
end;

function TMyOTAWizardProjectMenu.GetPosition: Integer;
begin
   Result := pmmpInstallSeparator - TMyOTAWizardConsts.MyProjectMenuSpaceValue;
end;

function TMyOTAWizardProjectMenu.GetVerb: string;
begin
   Result := 'verb' + TMyOTAWizardConsts.MyProjectMenuName;
end;

function TMyOTAWizardProjectMenu.PostExecute(const MenuContextList: IInterfaceList): Boolean;
begin
   Result := True;
end;

function TMyOTAWizardProjectMenu.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
   Result := True;
end;

procedure TMyOTAWizardProjectMenu.SetCaption(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetChecked(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetEnabled(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetHelpContext(Value: Integer);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetIsMultiSelectable(Value: Boolean);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetName(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetParent(const Value: string);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetPosition(Value: Integer);
begin
   //
end;

procedure TMyOTAWizardProjectMenu.SetVerb(const Value: string);
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
