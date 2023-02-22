unit MyOTAWizard.Register;

interface

uses
  ToolsAPI,
  MyOTAWizard.Splash,
  MyOTAWizard.MainMenu,
  MyOTAWizard.KeyBiding;

procedure Register;

implementation

procedure Register;
begin
   RegisterSplashWizard;
   RegisterMainMenuWizard;
   RegisterKeyBidings;
end;

end.
