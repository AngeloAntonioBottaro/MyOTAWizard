unit View.ProjectsList;

interface

uses
  ToolsAPI,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.IniFiles,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  TViewProjectsList = class(TForm)
    ListBox: TListBox;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ListarProjetos;
  public
  end;

var
  ViewProjectsList: TViewProjectsList;

implementation

{$R *.dfm}

uses
  ProjectsList.IniFileConsts;

procedure TViewProjectsList.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
   end;
end;

procedure TViewProjectsList.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewProjectsList.FormShow(Sender: TObject);
begin
   {$IF CompilerVersion >= 32.0}
   (BorlandIDEServices as IOTAIDEThemingServices250).RegisterFormClass(TViewProjectsList);
   {$ENDIF}
   Self.ListarProjetos;
end;

procedure TViewProjectsList.ListarProjetos;
var
  LIniFile: TIniFile;
  LSections: TStringList;
  I: Integer;
begin
   LIniFile := TIniFile.Create(TProjectsListIniFileConsts.IniFile);
   try
     LSections := TStringList.Create;
     try
       LIniFile.ReadSections(LSections);

       for I := 0 to Pred(LSections.Count) do
       begin
          ListBox.Items.Add(LSections[I] + '  -  ' + LIniFile.ReadString(LSections[I], TProjectsListIniFileConsts.IdentifierDirectory, ''));
       end;
     finally
       LSections.Free;
     end;
   finally
     LIniFile.Free;
   end;
end;

end.
