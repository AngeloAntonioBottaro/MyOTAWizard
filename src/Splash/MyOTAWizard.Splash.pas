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
     LBmp.LoadFromResourceName(HInstance, 'splash');
     SplashScreenServices
      .AddPluginBitmap(TMyOTAWizardConsts.SplashWizardName, LBmp.Handle, False, '', '');
   finally
     LBmp.Free;
   end;
end;

end.
