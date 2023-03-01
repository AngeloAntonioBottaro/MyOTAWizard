unit MyOTAWizard.OnClicks;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  Vcl.Dialogs;

type
  TMyOTAWizardOnClicks = class
    class procedure BatchCompactarMyERP(Sender: TObject);
    class procedure Notepad(Sender: TObject);
    class procedure ListarProjetos(Sender: TObject);
    class procedure AdicionarProjetosLista(Sender: TObject);
    class procedure OrganizarUses(Sender: TObject);
    class procedure Testes(Sender: TObject);
  end;

implementation

uses
  MyOTAWizard.Utils,
  View.ProjectsList,
  View.AddProject;

class procedure TMyOTAWizardOnClicks.AdicionarProjetosLista(Sender: TObject);
begin
   try
     ViewAddProject := TViewAddProject.Create(nil);
     ViewAddProject.ShowModal;
   finally
     FreeAndNil(ViewAddProject);
   end;
end;

class procedure TMyOTAWizardOnClicks.BatchCompactarMyERP(Sender: TObject);
var
  LBatch: string;
begin
   LBatch := '';
   if(FileExists('C:\Projetos\MyHelpers\Batchs\MyERP Sign.bat'))then
     LBatch := 'C:\Projetos\MyHelpers\Batchs\MyERP Sign.bat';

   if(not LBatch.IsEmpty)then
     TMyOTAWizardUtils.Open(LBatch);
end;

class procedure TMyOTAWizardOnClicks.ListarProjetos(Sender: TObject);
begin
   try
     ViewProjectsList := TViewProjectsList.Create(nil);
     ViewProjectsList.ShowModal;
   finally
     FreeAndNil(ViewProjectsList);
   end;
end;

class procedure TMyOTAWizardOnClicks.Notepad(Sender: TObject);
var
  LExe: string;
begin
   LExe := '';

   if(FileExists('C:\Program Files\Notepad++\notepad++.exe'))then
     LExe := 'C:\Program Files\Notepad++\notepad++.exe'
   else if(FileExists('C:\Program Files (x86)\Notepad++\notepad++.exe'))then
     LExe := 'C:\Program Files (x86)\Notepad++\notepad++.exe'

   else if(FileExists('C:\Program Files\Sublime Text 3\sublime_text.exe'))then
     LExe := 'C:\Program Files (x86)\Sublime Text 3\sublime_text.exe'
   else if(FileExists('C:\Program Files (x86)\Sublime Text 3\sublime_text.exe'))then
     LExe := 'C:\Program Files (x86)\Sublime Text 3\sublime_text.exe'

   else if(FileExists('C:\Windows\system32\notepad.exe'))then
     LExe := 'C:\Windows\system32\notepad.exe';

   if(not LExe.IsEmpty)then
     TMyOTAWizardUtils.Open(LExe);
end;

class procedure TMyOTAWizardOnClicks.OrganizarUses(Sender: TObject);
var
  EditorServices: IOTAEditorServices;
  EditView: IOTAEditView;
  LActiveFileName: string;

  //***
  LStrList: TStringList;
  LStrListAux: TStringList;
  LListaDosUses: TStringList;
  LLinha: Integer;
  LTextoDaLinha: string;
  LStrUses: string;
  LLinhaTemPontoVirgula: Boolean;
  I: Integer;
  LSeparador: string;
  LUsesAchadas: Integer;
begin
  EditorServices := (BorlandIDEServices as IOTAEditorServices);
  EditView       := EditorServices.TopView;

  if(not Assigned(EditView))then
    Exit;

  LActiveFileName := EditView.Buffer.FileName;
  LUsesAchadas    := 0;
  try
    LStrList    := TStringList.Create;
    LStrListAux := TStringList.Create;
    try
      LStrList.LoadFromFile(LActiveFileName);

      LStrListAux.Text := LStrList.Text;
      LStrList.Clear;

      LLinha := 0;
      while(LLinha <= Pred(LStrListAux.Count))do
      begin
         LTextoDaLinha := LStrListAux.Strings[LLinha];

         //SE N�O � A LINHA COM O TEXTO USES ADD A LINHA INTEIRA
         if(LTextoDaLinha.Trim <> 'uses')or(LUsesAchadas = 2)then
         begin
            LStrList.Add(LTextoDaLinha);
            Inc(LLinha);
            Continue;
         end;

         LStrUses              := '';
         LLinhaTemPontoVirgula := False;
         //CONTINUA ATE ACHAR O PONTO E VIRGULA QUE ENCERRA O USES
         while(not LLinhaTemPontoVirgula)do
         begin
            LLinhaTemPontoVirgula := Pos(';', LTextoDaLinha) > 0;

            //PEGA TODOS OS USES ATE O ;
            LStrUses := LStrUses + LTextoDaLinha;
            Inc(LLinha);
            LTextoDaLinha := LStrListAux.Strings[LLinha];
         end;
         LStrUses := StringReplace(LStrUses, 'uses', '', [rfReplaceAll, rfIgnoreCase]);

         LListaDosUses := TStringList.Create;
         try
           //SEPARA OS USES NA LISTA
           ExtractStrings([','], [], PChar(LStrUses), LListaDosUses);

           LStrList.Add('uses');
           //PERCORRE A LISTA DOS USES ADICIONANDO CADA UM EM UMA LINHA
           for I := 0 to Pred(LListaDosUses.Count) do
           begin
              LStrUses := LListaDosUses.Strings[i];

              LSeparador := '';
              if(I < Pred(LListaDosUses.Count))then
                LSeparador := ',';

              LStrList.Add('  ' + LStrUses.Trim + LSeparador);
           end;
         finally
           LListaDosUses.Free;
         end;

         Inc(LUsesAchadas);
      end;

      if(LStrListAux.Text <> LStrList.Text)then
      begin
         LStrList.SavetoFile(LActiveFileName);
         //(BorlandIDEServices as IOTAActionServices).SaveFile(LActiveFileName);
         (BorlandIDEServices as IOTAActionServices).ReloadFile(LActiveFileName);
      end;
    finally
      LStrListAux.Free;
      LStrList.Free;
    end;
  except
   on E: Exception do
   begin
      ShowMessage('Ocorreu o erro: ' + E.Message + sLineBreak);
   end
  end;
end;

class procedure TMyOTAWizardOnClicks.Testes(Sender: TObject);
begin
   //
end;

end.
