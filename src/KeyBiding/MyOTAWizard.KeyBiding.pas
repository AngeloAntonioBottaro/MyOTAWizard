unit MyOTAWizard.KeyBiding;

interface

uses
  ToolsAPI,
  System.Generics.Collections;

procedure RegisterKeyBidings;

implementation

uses
  MyOTAWizard.KeyBiding.AdicionarProjetosLista,
  MyOTAWizard.KeyBiding.ProjetosListar;

var
  FLista: TList<Integer>;

procedure RegisterKeyBidings;
begin
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingProjetosListar.New));
   FLista.Add((BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TMyOTAWizardKeyBidingAdicionarProjetosLista.New));
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
