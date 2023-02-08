unit MyOTAWizard.OnClicks;

interface

uses
  Winapi.ShellAPI,
  Winapi.Windows,
  system.SysUtils;

type
  TMyOTAWizardOnClicks = class
    class procedure OnClickMenuNotepad(Sender: TObject);
  end;


implementation

{ TMyOTAWizardOnClicks }

class procedure TMyOTAWizardOnClicks.OnClickMenuNotepad(Sender: TObject);
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
