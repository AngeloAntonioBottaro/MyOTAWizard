unit MyOTAWizard.MainMenu.CustomMenu.Ini;

interface

uses
  System.SysUtils,
  System.IniFiles;

const
  INI_IDENTIFIER_TYPE     = 'Type';
  INI_IDENTIFIER_CAPTION  = 'Caption';
  INI_IDENTIFIER_ORDER    = 'Order';
  INI_IDENTIFIER_SHORTCUT = 'Shortcut';
  INI_IDENTIFIER_ACTION   = 'Action';
  INI_IDENTIFIER_PARAM    = 'Parameter';

type
  ICustomMenuIniFile = interface
   ['{0A894591-62BB-4C91-82F3-405DAE05F375}']
   function IniFile: TIniFile;
   function IniFilePath: string;
   function IniFileName: string;
  end;

  TCustomMenuIniFile = class(TInterfacedObject, ICustomMenuIniFile)
  private
    FIniFile: TIniFile;
    FIniFilePath: string;
    FIniFileName: string;
  protected
    function IniFile: TIniFile;
    function IniFilePath: string;
    function IniFileName: string;
  public
    class function New: ICustomMenuIniFile;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

class function TCustomMenuIniFile.New: ICustomMenuIniFile;
begin
   Result := Self.Create;
end;

constructor TCustomMenuIniFile.Create;
begin
   FIniFilePath := ExtractFilePath(GetModuleName(HInstance));
   FIniFileName := 'ExternalFilesConf.ini';
   FIniFile     := TIniFile.Create(FIniFilePath + FIniFileName);
end;

destructor TCustomMenuIniFile.Destroy;
begin
   FIniFile.Free;
   inherited;
end;

function TCustomMenuIniFile.IniFile: TIniFile;
begin
   Result := FIniFile;
end;

function TCustomMenuIniFile.IniFileName: string;
begin
   Result := FIniFileName;
end;

function TCustomMenuIniFile.IniFilePath: string;
begin
   Result := FIniFilePath;
end;

end.
