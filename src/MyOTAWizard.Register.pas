unit MyOTAWizard.Register;

interface

procedure Register;

implementation

uses
  MyOTAWizard.Splash,
  MyOTAWizard.MainMenu,
  MyOTAWizard.KeyBiding,
  MyOTAWizard.ProjectMenu,
  View.ProjectsList.List;

procedure Register;
begin
   RegisterSplashWizard;
   RegisterMainMenuWizard;
   RegisterKeyBidings;
   RegisterProjectMenuWizard;
   RegisterProjectListDockForm;
end;

end.
