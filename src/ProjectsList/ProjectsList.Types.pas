unit ProjectsList.Types;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  System.UITypes;

type
  {$SCOPEDENUMS ON}
  TProjectsListGroup  = (Tudo, Executaveis, Trabalho, Pessoal, Packets);
  TProjectsListColors = (Texto, Vermelho, Azul, Amarelo, Verde);
  {$SCOPEDENUMS OFF}

  TEnumUtils<T> = class
   class procedure EnumToList(Value: TStrings);
  end;

  TProjectsListGroupHelper = record helper for TProjectsListGroup
   function ToString: string;
  end;

  TProjectsListColorsHelper = record helper for TProjectsListColors
   function ToString: string;
   function ToColor: Integer;
  end;

implementation

uses
  MyOTAWizard.UTils;

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

function TProjectsListGroupHelper.ToString: string;
begin
   Result := GetEnumName(TypeInfo(TProjectsListGroup), Integer(Self));
end;

function TProjectsListColorsHelper.ToColor: Integer;
begin
   Result := TMyOTAWizardUtils.FontColor(TColors.Black);
   case(Self)of
    TProjectsListColors.Vermelho: Result := TMyOTAWizardUtils.FontColor(TColors.Red);
    TProjectsListColors.Azul:     Result := TMyOTAWizardUtils.FontColor(TColors.Blue);
    TProjectsListColors.Amarelo:  Result := TMyOTAWizardUtils.FontColor(TColors.Yellow);
    TProjectsListColors.Verde:    Result := TMyOTAWizardUtils.FontColor(TColors.Green);
   end;
end;

function TProjectsListColorsHelper.ToString: string;
begin
   Result := GetEnumName(TypeInfo(TProjectsListColors), Integer(Self));
end;

end.
