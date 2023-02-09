unit MyOTAWizard.OnClicks;

interface

uses
  Winapi.ShellAPI,
  Winapi.Windows,
  system.SysUtils;

type
  TMyOTAWizardOnClicks = class
    class procedure Notepad(Sender: TObject);
  end;

implementation

class procedure TMyOTAWizardOnClicks.Notepad(Sender: TObject);
var
  LArquivo: string;
begin
   LArquivo := 'C:\Program Files\Notepad++\notepad++.exe';
   if(not FileExists(LArquivo))then
     LArquivo := '';

   if(not LArquivo.IsEmpty)then
     ShellExecute(HInstance, 'open', Pchar(LArquivo), nil, nil, SW_SHOWNORMAL);
end;

end.
