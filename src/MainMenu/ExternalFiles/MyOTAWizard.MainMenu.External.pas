unit MyOTAWizard.MainMenu.External;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Menus;

type
  TMyOTAWizardMainMenuExternal = class
  public
    class procedure ExternalFilesClick(Sender: TObject);
    class procedure CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
  end;

implementation

uses
  MyOTAWizard.MenuItem,
  MyOTAWizard.Consts,
  MyOTAWizard.ShortCuts,
  MyOTAWizard.OnClicks,
  MyOTAWizard.MainMenu.External.Ini, MyOTAWizard.Utils;

procedure LoadMenus(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
var
  LSections: TStringList;
  I: Integer;
  LCaption: string;
begin
   LSections := TStringList.Create;
   try
     TExternalIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
     begin
        LCaption := TExternalIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_CAPTION, '');

        TMyOTAWizardMenuItem.New
         .Parent(AParent)
         .ImageList(AImages)
         .Caption(LCaption)
         .Name('externalconf' + I.ToString)
         .ImageResource('external')
         .OnClick(TMyOTAWizardMainMenuExternal.ExternalFilesClick)
         .CreateMenuItem;
     end;
   finally
     LSections.Free;
   end;
end;

class procedure TMyOTAWizardMainMenuExternal.CreateMenu(AParent: TMenuItem; AImages: TDictionary<string, Integer>);
var
  LMyMenuExternal: TMenuItem;
begin
   TMyOTAWizardMenuItem.New
    .Parent(AParent)
    .Caption('-')
    .Name('miSeparatorExternal')
    .CreateMenuItem;

   LMyMenuExternal := TMyOTAWizardMenuItem.New.Parent(AParent)
                       .ImageList(AImages)
                       .Caption(TMyOTAWizardConsts.MenuItemExternalCaption)
                       .Name(TMyOTAWizardConsts.MenuItemExternalName)
                       .ImageResource('external')
                       .CreateMenuItem;

   LoadMenus(LMyMenuExternal, AImages);

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .Caption('-')
    .Name('miSeparatorExternalsConf')
    .CreateMenuItem;

   TMyOTAWizardMenuItem.New
    .Parent(LMyMenuExternal)
    .ImageList(AImages)
    .Caption(TMyOTAWizardConsts.MenuItemExternalConfCaption)
    .Name(TMyOTAWizardConsts.MenuItemExternalConfName)
    .ImageResource('externalconf')
    .OnClick(TMyOTAWizardOnClicks.ExternalFilesConf)
    .CreateMenuItem;
end;

class procedure TMyOTAWizardMainMenuExternal.ExternalFilesClick(Sender: TObject);
var
  LSections: TStringList;
  I: Integer;
  LSection: string;
  LType: Integer;
begin
   LSections := TStringList.Create;
   try
     TExternalIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
     begin
        LSection := LSections[I];
        //LCaption := TExternalIniFile.New.IniFile.ReadString(LSections[I], INI_IDENTIFIER_CAPTION, '');
        MessageInfo(LSection);
     end;
   finally
     LSections.Free;
   end;

   LType := TExternalIniFile.New.IniFile.ReadInteger(LSection, INI_IDENTIFIER_TYPE, 0);

   case(LType)of
    1:
    begin
       TMyOTAWizardUtils.Open(TExternalIniFile.New.IniFile.ReadString(LSection, INI_IDENTIFIER_FILE, ''));
    end;
    2:
    begin
       TMyOTAWizardUtils.Exec(TExternalIniFile.New.IniFile.ReadString(LSection, INI_IDENTIFIER_COMMAND, ''));
    end;
   end;
end;

end.
