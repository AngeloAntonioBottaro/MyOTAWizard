unit MyOTAWizard.IOTAUtils;

interface

uses
  ToolsAPI;

{$REGION 'MESSAGE'}
procedure ShowMessageView(AMsg: string);
procedure ClearMessages;
procedure RemoveMessageGroup;
{$ENDREGION 'MESSAGE'}

{$REGION 'PROJECTS AND PROJECT GROUP'}
function ProjectGroup: IOTAProjectGroup;
function ActiveProject : IOTAProject;
{$ENDREGION'PROJECTS AND PROJECT GROUP'}

implementation

{$REGION 'MESSAGE'}
function GetMyMessageGroup: IOTAMessageGroup;
const
  WIZARD_MSG_GROUP = 'MyOTAWizard';
begin
   Result := (BorlandIDEServices as IOTAMessageServices).GetGroup(WIZARD_MSG_GROUP);
   if(Result = nil)then
     Result := (BorlandIDEServices as IOTAMessageServices).AddMessageGroup(WIZARD_MSG_GROUP);
end;

procedure ShowMessageView(AMsg: string);
var
  LMsgTab: IOTAMessageGroup;
begin
   with (BorlandIDEServices as IOTAMessageServices) do
   begin
      LMsgTab := GetMyMessageGroup;
      ShowMessageView(LMsgTab);
      AddTitleMessage(AMsg, LMsgTab);
      LMsgTab.AutoScroll := True;
   end;
end;

procedure ClearMessages;
begin
   (BorlandIDEServices As IOTAMessageServices).ClearMessageGroup(GetMyMessageGroup);
end;

procedure RemoveMessageGroup;
begin
   (BorlandIDEServices As IOTAMessageServices).RemoveMessageGroup(GetMyMessageGroup);
end;
{$ENDREGION 'MESSAGE'}

{$REGION 'PROJECTS AND PROJECT GROUP'}
function ProjectGroup: IOTAProjectGroup;
var
  LModuleServices: IOTAModuleServices;
  LModule: IOTAModule;
  I: integer;
  LProjectGroup: IOTAProjectGroup;
begin
  Result := nil;
  LModuleServices := (BorlandIDEServices as IOTAModuleServices);
  for I := 0 To LModuleServices.ModuleCount - 1 Do
  begin
     LModule := LModuleServices.Modules[I];
     if(LModule.QueryInterface(IOTAProjectGroup, LProjectGroup) = S_OK)then
      Break;
  end;
  Result := LProjectGroup;
end;

function ActiveProject : IOTAProject;
var
  LProjectGroup: IOTAProjectGroup;
begin
  Result := nil;
  LProjectGroup := ProjectGroup;
  if(LProjectGroup <> nil)then
    Result := LProjectGroup.ActiveProject;
end;

{$ENDREGION'PROJECTS AND PROJECT GROUP'}

end.
