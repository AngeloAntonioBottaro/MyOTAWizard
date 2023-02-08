unit MyOTAWizard.Register;

interface

uses
  ToolsAPI,
  MyOTAWizard.Splash,
  MyOTAWizard.MainMenu;

procedure Register;

implementation

procedure Register;
begin
   //RegisterSplashWizard;
   RegisterMainMenuWizard;
end;

end.
