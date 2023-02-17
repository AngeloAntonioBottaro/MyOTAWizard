unit ProjectsList.Types;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo;

type
  {$SCOPEDENUMS ON}
  TProjectsListGroup = (Tudo, Executaveis, Trabalho, Pessoal, Packets);
  {$SCOPEDENUMS OFF}

  TEnumUtils<T> = class
   class procedure EnumToList(Value: TStrings);
  end;

  TGroupHelper = record helper for TProjectsListGroup
   function ToString: string;
  end;

implementation

class procedure TEnumUtils<T>.EnumToList(Value: TStrings);
var
  I, Pos: Integer;
  Aux: String;
begin
   Value.Clear;
   I := 0;
   repeat
     Aux := GetEnumName(TypeInfo(T), I);
     Pos := GetEnumValue(TypeInfo(T), Aux);

     if(Pos <> -1)then
       Value.Add(Aux);

     System.Inc(I);
   until(Pos < 0);
end;

function TGroupHelper.ToString: string;
begin
   Result := GetEnumName(TypeInfo(TProjectsListGroup), Integer(Self));
end;

end.
