unit MyOTAWizard.Register;

interface

procedure Register;

implementation

uses
  MyOTAWizard.Splash,
  MyOTAWizard.MainMenu,
  MyOTAWizard.KeyBiding,
  MyOTAWizard.ProjectMenu;

procedure Register;
begin
   RegisterSplashWizard;
   RegisterMainMenuWizard;
   RegisterKeyBidings;
   RegisterProjectMenuWizard;
end;

end.
