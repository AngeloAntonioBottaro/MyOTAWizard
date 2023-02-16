unit ProjectsList.IniFile;

interface

uses
  System.SysUtils,
  System.IniFiles;

const
  IdentifierDirectory = 'Directory';
  IdentifierGroup     = 'Group';

type
  IProjectsListIniFile = interface
   ['{7FACB465-1798-45A9-BC21-89E1277846D7}']
   function IniFile: TIniFile;
   function IniFilePath: string;
  end;

  TProjectsListIniFile = class(TInterfacedObject, IProjectsListIniFile)
  private
    FIniFile: TIniFile;
    FIniFilePath: string;
    FIniFileName: string;
  protected
    function IniFile: TIniFile;
    function IniFilePath: string;
  public
    class function New: IProjectsListIniFile;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

class function TProjectsListIniFile.New: IProjectsListIniFile;
begin
   Result := Self.Create;
end;

constructor TProjectsListIniFile.Create;
begin
   FIniFilePath := ExtractFilePath(GetModuleName(HInstance));
   FIniFileName := 'ProjectsList.ini';
   FIniFile     := TIniFile.Create(FIniFilePath + FIniFileName);
end;

destructor TProjectsListIniFile.Destroy;
begin
   FIniFile.Free;
   inherited;
end;

function TProjectsListIniFile.IniFile: TIniFile;
begin
   Result := FIniFile;
end;

function TProjectsListIniFile.IniFilePath: string;
begin
   Result := FIniFilePath;
end;

end.
