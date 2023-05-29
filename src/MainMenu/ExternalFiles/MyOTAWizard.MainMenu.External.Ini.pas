unit MyOTAWizard.MainMenu.External.Ini;

interface

uses
  System.SysUtils,
  System.IniFiles;

const
  INI_IDENTIFIER_TYPE    = 'Type';
  INI_IDENTIFIER_CAPTION = 'Caption';
  INI_IDENTIFIER_FILE    = 'File';
  INI_IDENTIFIER_COMMAND = 'CmdComand';

type
  IExternalFile = interface
   ['{0A894591-62BB-4C91-82F3-405DAE05F375}']
   function IniFile: TIniFile;
   function IniFilePath: string;
   function IniFileName: string;
  end;

  TExternalIniFile = class(TInterfacedObject, IExternalFile)
  private
    FIniFile: TIniFile;
    FIniFilePath: string;
    FIniFileName: string;
  protected
    function IniFile: TIniFile;
    function IniFilePath: string;
    function IniFileName: string;
  public
    class function New: IExternalFile;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

class function TExternalIniFile.New: IExternalFile;
begin
   Result := Self.Create;
end;

constructor TExternalIniFile.Create;
begin
   FIniFilePath := ExtractFilePath(GetModuleName(HInstance));
   FIniFileName := 'ExternalFilesConf.ini';
   FIniFile     := TIniFile.Create(FIniFilePath + FIniFileName);
end;

destructor TExternalIniFile.Destroy;
begin
   FIniFile.Free;
   inherited;
end;

function TExternalIniFile.IniFile: TIniFile;
begin
   Result := FIniFile;
end;

function TExternalIniFile.IniFileName: string;
begin
   Result := FIniFileName;
end;

function TExternalIniFile.IniFilePath: string;
begin
   Result := FIniFilePath;
end;

end.
