unit MyOTAWizard.Splash;

interface

uses
  ToolsAPI,
  Vcl.Graphics;

procedure RegisterSplashWizard;

implementation

uses
  MyOTAWizard.Consts;

procedure RegisterSplashWizard;
var
  LBmp: TBitmap;
begin
   LBmp := TBitmap.Create;
   try
     LBmp.LoadFromResourceName(HInstance, TMyOTAWizardConsts.MySplashIconeName);
     SplashScreenServices
      .AddPluginBitmap(TMyOTAWizardConsts.MySplashWizardName, LBmp.Handle, False, '', 'AA');
   finally
     LBmp.Free;
   end;
end;

end.
