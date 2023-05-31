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
    class procedure Exec(AComand: string);
    class function ReturnEdtValidChar(const AChar: string): string;
    class function CreateGuidStr: String;
    class function FileExists(AFile1: string; AFile2: string = ''; AFile3: string = ''; AFile4: string = ''; AFile5: string = ''): string;
    class function GetGitDirectory(AProject: string; ANotFoundMessage: Boolean = False): string;
    class function GetGitURL(AProject: string): string;
    class procedure OpenProjectOnGithubDesktop(AProject: string);
    class procedure OpenProjectOnGithubWeb(AProject: string);
    class function SelectDirectory(ATitulo: String = ''): String;
    class function SelectFile: string;
  end;

procedure MessageInfo(AMsg: string);
procedure MessageError(AMsg: string);
procedure MessageLog(AMsg: string);
procedure ShowInfo(AMsg: string);
function ShowQuestion(AMsg: string): Boolean;

implementation

uses
  ProjectsList.IniFile,
  MyOTAWizard.IOTAUtils;

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

function GetGitDirectoryFromINI(AProjectPath: string): string;
var
  LSections: TStringList;
  I: Integer;
  LProjectDir: string;
begin
   Result    := EmptyStr;
   LSections := TStringList.Create;
   try
     TProjectsListIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
     begin
        LProjectDir := TProjectsListIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_DIRECTORY, '');
        if(not ExtractFilePath(LProjectDir).Equals(AProjectPath))then
          Continue;

        Result := TProjectsListIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_GITDIRECTORY, '');
     end;
   finally
     LSections.Free;
   end;
end;

class function TMyOTAWizardUtils.GetGitDirectory(AProject: string; ANotFoundMessage: Boolean = False): string;
var
  LDirectoryDef: string;
begin
   Result := EmptyStr;
   if(AProject.Trim.IsEmpty)then
     Exit;

   Result := GetGitDirectoryFromINI(ExtractFilePath(AProject));

   if(not Result.IsEmpty)then
     Exit;

   //DEFAULT DIRECTORY
   LDirectoryDef := IncludeTrailingPathDelimiter(ExtractFilePath(AProject)) + '.git';
   if(DirectoryExists(LDirectoryDef))then
     Result := LDirectoryDef;

   if(ANotFoundMessage)and(Result.IsEmpty)then
     ShowInfo('Directory ".git" not found');
end;

class function TMyOTAWizardUtils.GetGitURL(AProject: string): string;
var
  LArquivo: TextFile;
  LArqConf: string;
  LStrLinha: string;
begin
   Result := EmptyStr;

   if(not DirectoryExists(TMyOTAWizardUtils.GetGitDirectory(AProject, True)))then
     Exit;

   LArqConf := TMyOTAWizardUtils.GetGitDirectory(AProject) + '\config';

   if(not System.SysUtils.FileExists(LArqConf))then
     Exit;

   AssignFile(LArquivo, LArqConf);
   try
     Reset(LArquivo);

     while(not Eof(LArquivo))do
     begin
        Readln(LArquivo, LStrLinha);
        if(not LStrLinha.Contains('url ='))then
          Continue;

        LStrLinha := StringReplace(LStrLinha, 'url =', '', [rfReplaceAll, rfIgnoreCase]);
        if(LStrLinha.Trim.IsEmpty)then
          Exit;

        Result := LStrLinha.Trim;
     end;
   finally
     CloseFile(LArquivo);
   end;
end;

class procedure TMyOTAWizardUtils.Open(AFileName: string);
begin
   ShellExecute(0, 'open', Pchar(AFileName), nil, nil, SW_SHOWNORMAL);
end;

class procedure TMyOTAWizardUtils.Exec(AComand: string);
begin
   ShellExecute(0, nil, 'cmd.exe', Pchar('/C ' + AComand), nil, SW_HIDE);
end;

class procedure TMyOTAWizardUtils.OpenProjectOnGithubDesktop(AProject: string);
var
  LDir: string;
begin
   LDir := TMyOTAWizardUtils.GetGitDirectory(AProject, True);
   LDir := StringReplace(LDir, '\.git', '', [rfIgnoreCase]);
   if(not LDir.Trim.IsEmpty)then
     TMyOTAWizardUtils.Exec('Github ' + LDir.Trim);
end;

class procedure TMyOTAWizardUtils.OpenProjectOnGithubWeb(AProject: string);
var
  LURL: string;
begin
   LURL := TMyOTAWizardUtils.GetGitURL(AProject);
   if(not LURL.Trim.IsEmpty)then
     TMyOTAWizardUtils.Open(LURL.Trim);
end;

class function TMyOTAWizardUtils.ReturnEdtValidChar(const AChar: string): string;
begin
   Result := EmptyStr;
   if(Pos(AChar, ALFA_ARRAY) <> 0)then
     Result := LowerCase(AChar)
end;

class function TMyOTAWizardUtils.SelectDirectory(ATitulo: String): String;
var
 LFileOpenDialog: TFileOpenDialog;
begin
   Result := EmptyStr;
   if(ATitulo = EmptyStr)then
     ATitulo := 'Select a folder';

   LFileOpenDialog := TFileOpenDialog.Create(nil);
   try
     LFileOpenDialog.Title    := ATitulo;
     LFileOpenDialog.Options  := [fdoPickFolders];

     if(not LFileOpenDialog.Execute)then
       Exit;

     Result := Trim(LFileOpenDialog.FileName);
   finally
     LFileOpenDialog.Free;
   end;
end;

class function TMyOTAWizardUtils.SelectFile: string;
var
  LSaveDialog: TSaveDialog;
begin
   Result := EmptyStr;
   LSaveDialog := TSaveDialog.Create(nil);
   try
     LSaveDialog.DefaultExt := '*';
     LSaveDialog.Filter     := 'All|*.*|Project|*.dproj|Project Group|*.groupproj';
     LSaveDialog.InitialDir := 'C:\';
     LSaveDialog.FileName   := '';
     if(LSaveDialog.Execute)then
       Result := LSaveDialog.FileName;
   finally
     LSaveDialog.Free;
   end;
end;

procedure MessageInfo(AMsg: string);
begin
   ShowMessageView('Information: ' + AMsg);
end;

procedure MessageError(AMsg: string);
begin
   ShowMessageView('Error: ' + AMsg);;
end;

procedure MessageLog(AMsg: string);
begin
   ShowMessageView('  - Log: ' + AMsg);;
end;

procedure ShowInfo(AMsg: string);
begin
   MessageDlg(AMsg, mtInformation, [mbOK], 0);
end;

function ShowQuestion(AMsg: string): Boolean;
begin
   Result := True;
   if(MessageDlg(AMsg, mtConfirmation, [mbNo, mbYes], 0) = mrNo)then
     Result := False;
end;

end.
