unit ProjectsList.Types;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  System.UITypes;

type
  {$SCOPEDENUMS ON}
  TPLGroup  = (Tudo, Executaveis, Trabalho, Pessoal, Packets, Outros);
  TPLColors = (Texto, Vermelho, Azul, Amarelo, Verde);
  {$SCOPEDENUMS OFF}

  TEnumUtils<T> = class
   class procedure EnumToList(Value: TStrings);
  end;

  TProjectsListGroupHelper = record helper for TPLGroup
   function ToString: string;
  end;

  TProjectsListColorsHelper = record helper for TPLColors
   function ToString: string;
   function ToColor: Integer;
  end;

function StrToProjectsListGroup(AStr: string): TPLGroup;
function StrToProjectsListColors(AStr: string): TPLColors;

implementation

uses
  MyOTAWizard.UTils;

function StrToProjectsListGroup(AStr: string): TPLGroup;
begin
   Result := TPLGroup(GetEnumValue(TypeInfo(TPLGroup), AStr));
end;

function StrToProjectsListColors(AStr: string): TPLColors;
begin
   Result := TPLColors(GetEnumValue(TypeInfo(TPLColors), AStr));
end;

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
   Result := GetEnumName(TypeInfo(TPLGroup), Integer(Self));
end;

function TProjectsListColorsHelper.ToColor: Integer;
begin
   Result := TMyOTAWizardUtils.FontColor(TColors.Black);
   case(Self)of
    TPLColors.Vermelho: Result := TMyOTAWizardUtils.FontColor(TColors.Red);
    TPLColors.Azul:     Result := TMyOTAWizardUtils.FontColor(TColors.Blue);
    TPLColors.Amarelo:  Result := TMyOTAWizardUtils.FontColor(TColors.Yellow);
    TPLColors.Verde:    Result := TMyOTAWizardUtils.FontColor(TColors.Green);
   end;
end;

function TProjectsListColorsHelper.ToString: string;
begin
   Result := GetEnumName(TypeInfo(TPLColors), Integer(Self));
end;

end.
