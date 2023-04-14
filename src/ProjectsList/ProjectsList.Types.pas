unit ProjectsList.Types;

interface

uses
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  System.UITypes;

type
  {$SCOPEDENUMS ON}
  TPLGroup  = (Tudo, Trabalho, Pessoal, Packets, Extras, Outros);
  TPLColors = (Texto, Vermelho, Azul, Amarelo, Verde, Roxo);
  {$SCOPEDENUMS OFF}

  TEnumUtils<T> = class
   class procedure EnumToList(Value: TStrings);
  end;

  TProjectsListGroupHelper = record helper for TPLGroup
   function ToString: string;
   function ToInteger: Integer;
   function ToPLColors: TPLColors;
   function ToColor: Integer;
  end;

  TProjectsListColorsHelper = record helper for TPLColors
   function ToString: string;
   function ToColor: Integer;
   function ToInteger: Integer;
  end;

function StrToPLGroup(AStr: string): TPLGroup;
function StrToPLColors(AStr: string): TPLColors;

implementation

uses
  MyOTAWizard.UTils;

function StrToPLGroup(AStr: string): TPLGroup;
begin
   if(AStr.Trim.IsEmpty)then
     Exit(TPLGroup.Tudo);

   Result := TPLGroup(GetEnumValue(TypeInfo(TPLGroup), AStr));
end;

function StrToPLColors(AStr: string): TPLColors;
begin
   if(AStr.Trim.IsEmpty)then
     Exit(TPLColors.Texto);

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

function TProjectsListGroupHelper.ToColor: Integer;
begin
   Result := Self.ToPLColors.ToColor;
end;

function TProjectsListGroupHelper.ToInteger: Integer;
begin
   Result := Integer(Self);
end;

function TProjectsListGroupHelper.ToPLColors: TPLColors;
begin
   case(Self)of
    TPLGroup.Trabalho: Result := TPLColors.Amarelo;
    TPLGroup.Pessoal:  Result := TPLColors.Azul;
    TPLGroup.Packets:  Result := TPLColors.Verde;
    TPLGroup.Extras:   Result := TPLColors.Vermelho;
    TPLGroup.Outros:   Result := TPLColors.Texto;
    //TPLGroup.NOVO:   Result := TPLColors.Roxo;
   else
     Result := TPLColors.Texto;
   end;
end;

function TProjectsListGroupHelper.ToString: string;
begin
   Result := GetEnumName(TypeInfo(TPLGroup), Integer(Self));
end;

function TProjectsListColorsHelper.ToColor: Integer;
begin
   case(Self)of
    TPLColors.Vermelho: Result := TMyOTAWizardUtils.FontColor(TColors.Red);
    TPLColors.Azul:     Result := TMyOTAWizardUtils.FontColor(TColors.Blue);
    TPLColors.Amarelo:  Result := TMyOTAWizardUtils.FontColor(TColors.Yellow);
    TPLColors.Verde:    Result := TMyOTAWizardUtils.FontColor(TColors.Green);
    TPLColors.Roxo:     Result := TMyOTAWizardUtils.FontColor(TColors.Purple);
   else
     Result := TMyOTAWizardUtils.FontColor(TColors.Black);
   end;
end;

function TProjectsListColorsHelper.ToInteger: Integer;
begin
   Result := Integer(Self);
end;

function TProjectsListColorsHelper.ToString: string;
begin
   Result := GetEnumName(TypeInfo(TPLColors), Integer(Self));
end;

end.
