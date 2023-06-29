unit MyOTAWizard.Version;

interface

uses
  System.SysUtils;

type
  TUtilsVersao = class
  public
    const
    C_MAJOR = 1;
    C_MINOR = 0;
    C_PATCH = 0;
    class function SemanticVersion: String;
  end;

implementation

class function TUtilsVersao.SemanticVersion: String;
begin
   Result := C_MAJOR.ToString + '.' + C_MINOR.ToString + '.' + C_PATCH.ToString;
end;

end.
