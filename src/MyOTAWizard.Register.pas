unit MyOTAWizard.Register;

interface

procedure Register;

implementation

uses
  MyOTAWizard.Splash,
  MyOTAWizard.MainMenu,
  MyOTAWizard.KeyBiding,
  MyOTAWizard.ProjectMenu,
  View.ProjectsList;

procedure Register;
begin
   RegisterSplashWizard;
   RegisterMainMenuWizard;
   RegisterKeyBidings;
   RegisterProjectMenuWizard;
   RegisterModeloDockForm;
end;

end.
