unit MyOTAWizard.MainMenu.CustomMenu.Types;

interface

uses
  System.TypInfo;

type
  {$SCOPEDENUMS ON}
  TCustomMenuType  = (Separator, ExternalFile, Link, CMDCommand);
  {$SCOPEDENUMS OFF}

  TCustomMenuTypeHelper = record helper for TCustomMenuType
   function ToString: string;
   function ToInteger: Integer;
  end;

function StrToCustomMenuType(AString: string): TCustomMenuType;

implementation

function TCustomMenuTypeHelper.ToInteger: Integer;
begin
   Result := Integer(Self);
end;

function TCustomMenuTypeHelper.ToString: string;
begin
   Result := GetEnumName(TypeInfo(TCustomMenuType), Integer(Self));
end;

function StrToCustomMenuType(AString: string): TCustomMenuType;
var
  I: TCustomMenuType;
begin
   Result := TCustomMenuType.Separator;
   for I := Low(TCustomMenuType) to High(TCustomMenuType) do
   begin
      if(I.ToString = AString)then
        Result := I;
   end;
end;

end.
