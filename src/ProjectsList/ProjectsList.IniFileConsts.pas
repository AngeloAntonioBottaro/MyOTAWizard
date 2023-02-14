unit ProjectsList.IniFileConsts;

interface

uses
  System.SysUtils,
  System.IniFiles;

type
  TProjectsListIniFileConsts = class
    const
      IdentifierDirectory = 'Directory';
    class function IniFile: string;
    class function IniFilePath: string;
  end;

implementation

class function TProjectsListIniFileConsts.IniFile: string;
begin
   Result := Self.IniFilePath +  'ProjectsList.ini';
end;

class function TProjectsListIniFileConsts.IniFilePath: string;
begin
   Result := ExtractFilePath(GetModuleName(HInstance));
end;

end.
