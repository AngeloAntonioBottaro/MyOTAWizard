unit MyOTAWizard.Utils;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.ExtCtrls;

type
  TMyOTAWizardUtils = class
  public
    class function ActiveTheme: string;
    class procedure ApplyTheme(AClass: TCustomFormClass; AForm: TForm);
    class function FontColor(AColor: Integer): Integer;
  end;

implementation

function ColorDark(AColor: Integer): Integer;
begin
   case(AColor)of
    clBlack:  Result := clWhite;
    clRed:    Result := clWebRed;
    clBlue:   Result := clWebBlue;
    clAqua:   Result := clWebAqua;
    clYellow: Result := clWebYellow;
    clGreen:  Result := clWebGreen;
   end;
end;

function ColorLight(AColor: Integer): Integer;
begin
   case(AColor)of
    clWhite:  Result := clBlack;
    clRed:    Result := clWebDarkRed;
    clBlue:   Result := clWebDarkBlue;
    clAqua:   Result := clWebBlue;
    clYellow: Result := clWebOrange;
    clGreen:  Result := clWebDarkGreen;
   end;
end;

class function TMyOTAWizardUtils.ActiveTheme: string;
begin
   Result := EmptyStr;
   {$IF CompilerVersion >= 32.0}
   Result := (BorlandIDEServices as IOTAIDEThemingServices250).ActiveTheme;
   {$ENDIF}
end;

class procedure TMyOTAWizardUtils.ApplyTheme(AClass: TCustomFormClass; AForm: TForm);
var
  I: Integer;
begin
   {$IF CompilerVersion >= 32.0}
   (BorlandIDEServices as IOTAIDEThemingServices250).RegisterFormClass(AClass);
   for I := 0 to Pred(AForm.ComponentCount) do
   begin
      if(AForm.Components[I] is TPanel)then
        TPanel(AForm.Components[I]).ParentBackground := True;

      (BorlandIDEServices as IOTAIDEThemingServices250).ApplyTheme(AForm.Components[i]);
   end;
   {$ENDIF}
end;

class function TMyOTAWizardUtils.FontColor(AColor: Integer): Integer;
begin
   Result := ColorLight(AColor);
   if(ActiveTheme = 'Dark')then
     Result := ColorDark(AColor);
end;

end.
