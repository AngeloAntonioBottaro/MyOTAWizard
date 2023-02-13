unit MyOTAWizard.OnClicks;

interface

uses
  Winapi.ShellAPI,
  Winapi.Windows,
  system.SysUtils;

type
  TMyOTAWizardOnClicks = class
    class procedure BatchCompactarMyERP(Sender: TObject);
    class procedure Notepad(Sender: TObject);
    class procedure ListarProjetos(Sender: TObject);
    class procedure AdicionarProjetosLista(Sender: TObject);
  end;

implementation

uses
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
     ShellExecute(HInstance, 'open', Pchar(LBatch), nil, nil, SW_SHOWNORMAL);
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
     ShellExecute(HInstance, 'open', Pchar(LExe), nil, nil, SW_SHOWNORMAL);
end;

end.
