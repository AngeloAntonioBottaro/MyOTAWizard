unit View.MainMenu.ExternalFiles.Configuration;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs;

type
  TViewMainMenuExternalFilesConfiguration = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
  end;

var
  ViewMainMenuExternalFilesConfiguration: TViewMainMenuExternalFilesConfiguration;

implementation

{$R *.dfm}

uses MyOTAWizard.Utils;

procedure TViewMainMenuExternalFilesConfiguration.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
   end;
end;

procedure TViewMainMenuExternalFilesConfiguration.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewMainMenuExternalFilesConfiguration.FormShow(Sender: TObject);
begin
   TMyOTAWizardUtils.ApplyTheme(TViewMainMenuExternalFilesConfiguration, Self);
end;

end.
