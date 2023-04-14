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
    class function CreateGuidStr: String;
    class function FileExists(AFile1: string; AFile2: string = ''; AFile3: string = ''; AFile4: string = ''; AFile5: string = ''): string;
  end;

procedure ShowInfo(AMsg: string);
procedure ShowError(AMsg: string);
function ShowQuestion(AMsg: string): Boolean;

implementation

const
  ALFA_ARRAY: PChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸¿¬ ‘€√’¡…Õ”⁄«‹ 0123456789.;,<>?/[]{}*&^%$#@!_+-="`~\';

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

class function TMyOTAWizardUtils.CreateGuidStr: String;
var
 LGUID1: TGUID;
begin
   Result := EmptyStr;
   CreateGUID(LGUID1);
   Result := GUIDToString(LGUID1);
end;

function ColorDark(AColor: Integer): Integer;
begin
   case(AColor)of
    TColors.Red:    Result := TColors.Red;
    TColors.Blue:   Result := TColors.Aqua;
    TColors.Yellow: Result := TColors.Yellow;
    TColors.Green:  Result := TColors.Lightgreen;
    TColors.Purple: Result := TColors.Magenta;
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
    TColors.Purple: Result := TColors.Purple;
   else
    Result := TColors.Black;
   end;
end;

function IfThenFileExist(AFileIFExists, AFileElse: string): string;
begin
   Result := AFileElse;

   if(AFileIFExists.IsEmpty)then
     Exit;

   if(System.SysUtils.FileExists(AFileIFExists))then
     Result := AFileIFExists
end;

class function TMyOTAWizardUtils.FileExists(AFile1: string; AFile2: string = ''; AFile3: string = ''; AFile4: string = ''; AFile5: string = ''): string;
begin
   Result := EmptyStr;
   Result := IfThenFileExist(AFile5, Result);
   Result := IfThenFileExist(AFile4, Result);
   Result := IfThenFileExist(AFile3, Result);
   Result := IfThenFileExist(AFile2, Result);
   Result := IfThenFileExist(AFile1, Result);
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

function ShowQuestion(AMsg: string): Boolean;
begin
   Result := True;
   if(MessageDlg(AMsg, mtConfirmation, [mbNo, mbYes], 0) = mrNo)then
     Result := False;
end;

end.
