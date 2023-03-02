unit MyOTAWizard.Utils;

interface

uses
  ToolsAPI,
  Winapi.Windows,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.ExtCtrls;

type
  TMyOTAWizardUtils = class
  public
    class function ActiveTheme: string;
    class procedure ApplyTheme(AClass: TCustomFormClass; AForm: TForm);
    class function FontColor(AColor: Integer): Integer;
    class procedure Open(AFileName: string);
    class function ReturnEdtValidChar(const AChar: string): string;
  end;

procedure ShowInfo(AMsg: string);
procedure ShowError(AMsg: string);

implementation

const
  ALFA_ARRAY: PChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz���������������������������� 0123456789.;,<>?/[]{}*&^%$#@!_+-="`~\';

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

function ColorDark(AColor: Integer): Integer;
begin
   case(AColor)of
    TColors.Red:    Result := TColors.Red;
    TColors.Blue:   Result := TColors.Aqua;
    TColors.Yellow: Result := TColors.Yellow;
    TColors.Green:  Result := TColors.Lightgreen;
   else
    Result := TColors.White;
   end;
end;

function ColorLight(AColor: Integer): Integer;
begin
   case(AColor)of
    TColors.Red:    Result := TColors.red;
    TColors.Blue:   Result := TColors.blue;
    TColors.Yellow: Result := TColors.Olive;
    TColors.Green:  Result := TColors.Green;
   else
    Result := TColors.Black;
   end;
end;

class function TMyOTAWizardUtils.FontColor(AColor: Integer): Integer;
begin
   Result := ColorLight(AColor);
   if(ActiveTheme = 'Dark')then
     Result := ColorDark(AColor);
end;

class procedure TMyOTAWizardUtils.Open(AFileName: string);
begin
   ShellExecute(HInstance, 'open', Pchar(AFileName), nil, nil, SW_SHOWNORMAL);
end;

class function TMyOTAWizardUtils.ReturnEdtValidChar(const AChar: string): string;
begin
   Result := EmptyStr;
   if(Pos(AChar, ALFA_ARRAY) <> 0)then
     Result := LowerCase(AChar)
end;

procedure ShowInfo(AMsg: string);
begin
   MessageDlg(AMsg, mtInformation, [mbOK], 0);
end;

procedure ShowError(AMsg: string);
begin
   MessageDlg(AMsg, mtError, [mbOK], 0);
end;

end.
