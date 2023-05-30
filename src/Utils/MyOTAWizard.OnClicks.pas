unit MyOTAWizard.OnClicks;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  System.UITypes,
  Vcl.Dialogs;

type
  TMyOTAWizardOnClicks = class
    class procedure Notepad(Sender: TObject);
    class procedure OpenGitDesktop(Sender: TObject);
    class procedure OpenGitWeb(Sender: TObject);
    class procedure Info(Sender: TObject);

    class procedure CustomMenuConf(Sender: TObject);
    class procedure ListProjects(Sender: TObject);
    class procedure AddProjectsToList(Sender: TObject);
    class procedure ArrangeUses(Sender: TObject);
  end;

implementation

uses
  MyOTAWizard.Utils,
  MyOTAWizard.IOTAUtils,
  MyOTAWizard.Consts,
  View.ProjectsList.List,
  View.ProjectsList.AddProject,
  View.MainMenu.CustomMenu.List;

class procedure TMyOTAWizardOnClicks.Notepad(Sender: TObject);
var
  LExe: string;
begin
   LExe := TMyOTAWizardUtils.FileExists('C:\Program Files\Notepad++\notepad++.exe',
                                        'C:\Program Files (x86)\Notepad++\notepad++.exe',
                                        'C:\Program Files\Sublime Text 3\sublime_text.exe',
                                        'C:\Program Files (x86)\Sublime Text 3\sublime_text.exe',
                                        'C:\Windows\system32\notepad.exe');

   if(not LExe.IsEmpty)then
     TMyOTAWizardUtils.Open(LExe);
end;

class procedure TMyOTAWizardOnClicks.CustomMenuConf(Sender: TObject);
begin
   ViewMainMenuCustomMenuList := TViewMainMenuCustomMenuList.Create(nil);
   try
     ViewMainMenuCustomMenuList.ShowModal;
   finally
     FreeAndNil(ViewMainMenuCustomMenuList);
   end;
end;

function ActiveProjectName: string;
var
  LProject: IOTAProject;
begin
   Result   := EmptyStr;
   LProject := ActiveProject;

   if(not Assigned(LProject))then
   begin
      MessageInfo('Nenhum projeto selecionado para a realização da ação desejada');
      Exit;
   end;

   Result := LProject.FileName;
end;

class procedure TMyOTAWizardOnClicks.OpenGitDesktop(Sender: TObject);
begin
   if(ActiveProjectName.IsEmpty)then
     Exit;

   TMyOTAWizardUtils.OpenProjectOnGithubDesktop(ActiveProjectName);
end;

class procedure TMyOTAWizardOnClicks.OpenGitWeb(Sender: TObject);
begin
   if(ActiveProjectName.IsEmpty)then
     Exit;

   TMyOTAWizardUtils.OpenProjectOnGithubWeb(ActiveProjectName);
end;

class procedure TMyOTAWizardOnClicks.Info(Sender: TObject);
begin
   ShowInfo('AAB Softwares Delphi wizard.' + sLineBreak +
            'Email: angeloantoniobottaro@gmail.com' + sLineBreak +
            'Phone: (43) 99631-0834');
end;

class procedure TMyOTAWizardOnClicks.ListProjects(Sender: TObject);
begin
   ShowProjectList;
end;

class procedure TMyOTAWizardOnClicks.AddProjectsToList(Sender: TObject);
begin
   ViewProjectsListAddProject := TViewProjectsListAddProject.Create(nil);
   try
     ViewProjectsListAddProject.ShowModal;
   finally
     FreeAndNil(ViewProjectsListAddProject);
   end;
end;

class procedure TMyOTAWizardOnClicks.ArrangeUses(Sender: TObject);
var
  EditorServices: IOTAEditorServices;
  EditView: IOTAEditView;
  LActiveFileName: string;
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
  LTemp: string;
begin
  EditorServices := (BorlandIDEServices as IOTAEditorServices);
  EditView       := EditorServices.TopView;

  if(not Assigned(EditView))then
    Exit;

  LActiveFileName := EditView.Buffer.FileName;
  LUsesAchadas    := 0;

  (BorlandIDEServices as IOTAActionServices).SaveFile(LActiveFileName);

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

         //SE A LINHA TEM O TEXTO PRIVATE OU PUBLIC DECLARATIONS
         if(LTextoDaLinha.Trim.Contains(PRIVATE_DECLARATION))or(LTextoDaLinha.Trim.Contains(PUBLIC_DECLARATION))then
         begin
            Inc(LLinha);
            Continue;
         end;

         //SE NÃO É A LINHA COM O TEXTO USES ADD A LINHA INTEIRA
         LTemp := Copy(LTextoDaLinha.Trim, 0, 4);
         if(not LTemp.Equals('uses'))or(LUsesAchadas = 2)then
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
         LStrUses := StringReplace(LStrUses, 'uses', '', [rfIgnoreCase]);

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

      LStrList.SavetoFile(LActiveFileName);
      (BorlandIDEServices as IOTAActionServices).ReloadFile(LActiveFileName);
    finally
      LStrListAux.Free;
      LStrList.Free;
    end;
  except on E: Exception do
    MessageError('Ocorreu o erro: ' + E.Message);
  end;
end;

end.
