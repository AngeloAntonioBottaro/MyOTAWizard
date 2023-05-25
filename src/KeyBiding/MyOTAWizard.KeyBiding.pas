unit MyOTAWizard.KeyBiding;

interface

uses
  ToolsAPI,
  System.Generics.Collections;

procedure RegisterKeyBidings;

implementation

uses
  MyOTAWizard.KeyBiding.ListProjects,
  MyOTAWizard.KeyBiding.AddProjectsToList,
  MyOTAWizard.KeyBiding.ArrangeUses,
  MyOTAWizard.KeyBiding.GitWeb,
  MyOTAWizard.KeyBiding.GitDesktop;

var
  FLista: TList<Integer>;

procedure RegisterKeyBidings;
begin
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingListProjects.New));
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingAddProjectsToList.New));
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingArrangeUses.New));
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingGitWeb.New));
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingGitDesktop.New));
end;

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
