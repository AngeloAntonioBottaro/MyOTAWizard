unit ProjectsList.IniFileUtils;

interface

uses
  System.SysUtils,
  System.IniFiles;

const
  IdentifierDirectory = 'Directory';

type
  TProjectsListIniFileUtils = class
    class function IniFile: string;
    class function IniFilePath: string;
    class procedure ExcluirSection(ASection: string);
  end;

implementation

class function TProjectsListIniFileUtils.IniFile: string;
begin
   Result := Self.IniFilePath +  'ProjectsList.ini';
end;

class function TProjectsListIniFileUtils.IniFilePath: string;
begin
   Result := ExtractFilePath(GetModuleName(HInstance));
end;

class procedure TProjectsListIniFileUtils.ExcluirSection(ASection: string);
var
  LIniFile: TIniFile;
begin
   if(ASection.Trim.IsEmpty)then
     Exit;

   LIniFile := TIniFile.Create(TProjectsListIniFileUtils.IniFile);
   try
     LIniFile.EraseSection(ASection.Trim);
   finally
     LIniFile.Free;
   end;
end;

end.
