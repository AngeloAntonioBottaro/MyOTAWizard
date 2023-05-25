unit View.ProjectsList.AddProject;

interface

uses
  ToolsAPI,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.IniFiles,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Clipbrd,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TViewProjectsListAddProject = class(TForm)
    btnSalvar: TButton;
    btnSelecionarProjeto: TButton;
    edtDiretorioProjeto: TEdit;
    edtNomeProjeto: TEdit;
    lbNomeProjeto: TLabel;
    lbDiretorioProjeto: TLabel;
    pnIniFilePath: TPanel;
    cbGrupo: TComboBox;
    lbGrupo: TLabel;
    lbCor: TLabel;
    cbCor: TComboBox;
    lbGitURL: TLabel;
    edtGitDirectory: TEdit;
    btnSelectGitDirectory: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarProjetoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure pnIniFilePathClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnIniFilePathDblClick(Sender: TObject);
    procedure btnSelectGitDirectoryClick(Sender: TObject);
  private
    FSectionToUpdate: string;
    procedure LoadSectionInformations(ASection: string);
    procedure VerifyFields;
    procedure SaveToList(ASection: string);
    procedure VerifyProjectName;
    procedure CleanFields;
    procedure InformedFileExists;
    procedure GetInfFromNewDirectory;
    procedure GetSelectedFileName;
    procedure GetGitDirectory;
  public
    property SectionToUpdate: string read FSectionToUpdate write FSectionToUpdate;
  end;

var
  ViewProjectsListAddProject: TViewProjectsListAddProject;

implementation

{$R *.dfm}

uses
  MyOTAWizard.Utils,
  ProjectsList.IniFile,
  ProjectsList.Types;

procedure TViewProjectsListAddProject.FormCreate(Sender: TObject);
begin
   cbGrupo.Items.Clear;
   TEnumUtils<TPLGroup>.EnumToList(cbGrupo.Items);
   cbGrupo.ItemIndex := 0;

   cbCor.Items.Clear;
   TEnumUtils<TPLColors>.EnumToList(cbCor.Items);
   cbCor.ItemIndex := 0;

   SectionToUpdate := EmptyStr;
end;

procedure TViewProjectsListAddProject.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
   end;
end;

procedure TViewProjectsListAddProject.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewProjectsListAddProject.FormShow(Sender: TObject);
begin
   TMyOTAWizardUtils.ApplyTheme(TViewProjectsListAddProject, Self);
   Self.LoadSectionInformations(SectionToUpdate);
   Self.GetInfFromNewDirectory;
end;

procedure TViewProjectsListAddProject.LoadSectionInformations(ASection: string);
begin
   if(ASection.IsEmpty)then
     Exit;

   edtNomeProjeto.Text      := TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_NAME, '');
   edtDiretorioProjeto.Text := TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_DIRECTORY, '');
   edtGitDirectory.Text     := TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_GITDIRECTORY, '');
   cbGrupo.ItemIndex        := Integer(StrToPLGroup(TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_GROUP, TPLGroup.Tudo.ToString)));
   cbCor.ItemIndex          := Integer(StrToPLColors(TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_COLOR, TPLColors.Texto.ToString)));
end;

procedure TViewProjectsListAddProject.pnIniFilePathClick(Sender: TObject);
begin
   Clipboard.AsText := TProjectsListIniFile.New.IniFilePath;
end;

procedure TViewProjectsListAddProject.pnIniFilePathDblClick(Sender: TObject);
begin
   TMyOTAWizardUtils.Open(TProjectsListIniFile.New.IniFilePath + TProjectsListIniFile.New.IniFileName);
end;

procedure TViewProjectsListAddProject.btnSelecionarProjetoClick(Sender: TObject);
var
  LFile: string;
begin
   edtDiretorioProjeto.Text := '';
   LFile := TMyOTAWizardUtils.SelectFile;
   if(LFile = EmptyStr)then
     Exit;

   edtDiretorioProjeto.Text := LFile.Trim;
   Self.GetInfFromNewDirectory;
end;

procedure TViewProjectsListAddProject.btnSelectGitDirectoryClick(Sender: TObject);
var
  LFile: string;
begin
   edtGitDirectory.Text := '';
   LFile := TMyOTAWizardUtils.SelectDirectory('Selecione a pasta de configuração do git (.git)');
   if(LFile = EmptyStr)then
     Exit;

   edtGitDirectory.Text := LFile.Trim;
end;

procedure TViewProjectsListAddProject.GetGitDirectory;
begin
   edtGitDirectory.Text := TMyOTAWizardUtils.GetGitDirectory(edtDiretorioProjeto.Text);
end;

procedure TViewProjectsListAddProject.GetInfFromNewDirectory;
begin
   if(Trim(edtDiretorioProjeto.Text).IsEmpty)then
     Exit;

   if(Trim(edtNomeProjeto.Text).IsEmpty)then
     Self.GetSelectedFileName;

   if(Trim(edtGitDirectory.Text).IsEmpty)then
     Self.GetGitDirectory;
end;

procedure TViewProjectsListAddProject.GetSelectedFileName;
var
  LFile: string;
begin
   LFile := edtDiretorioProjeto.Text;

   if(Trim(LFile).IsEmpty)then
     Exit;

   if(Trim(edtNomeProjeto.Text).IsEmpty)then
     edtNomeProjeto.Text := StringReplace(ExtractFileName(LFile), ExtractFileExt(LFile), '', []);
end;

procedure TViewProjectsListAddProject.btnSalvarClick(Sender: TObject);
begin
   Self.VerifyFields;

   if(SectionToUpdate.IsEmpty)then
     Self.SaveToList(TMyOTAWizardUtils.CreateGuidStr)
   else
     Self.SaveToList(SectionToUpdate);

   Self.CleanFields;
end;

procedure TViewProjectsListAddProject.VerifyFields;
begin
   if(Trim(edtDiretorioProjeto.Text).IsEmpty)then
   begin
      edtDiretorioProjeto.SetFocus;
      ShowInfo('Project path not informed');
      Abort;
   end;

   if(Trim(edtNomeProjeto.Text).IsEmpty)then
   begin
      edtNomeProjeto.SetFocus;
      ShowInfo('Project name not informed');
      Abort;
   end;

   if(Trim(edtGitDirectory.Text).IsEmpty)then
     Self.GetGitDirectory;
end;

procedure TViewProjectsListAddProject.VerifyProjectName;
var
  LSections: TStringList;
  I: Integer;
  LExistsName: Boolean;
  LExistsDirectory: Boolean;
  LString: string;
begin
   LExistsName      := False;
   LExistsDirectory := False;
   LSections := TStringList.Create;
   try
     TProjectsListIniFile.New.IniFile.ReadSections(LSections);

     for I := 0 to Pred(LSections.Count) do
     begin
        if(SectionToUpdate.Equals(LSections.Strings[I]))then
          Continue;

        LString     := TProjectsListIniFile.New.IniFile.ReadString(LSections.Strings[I], INI_IDENTIFIER_NAME, '');
        LExistsName := LString.Equals(Trim(edtNomeProjeto.Text));

        LString          := TProjectsListIniFile.New.IniFile.ReadString(LSections.Strings[I], INI_IDENTIFIER_DIRECTORY, '');
        LExistsDirectory := LString.Equals(Trim(edtDiretorioProjeto.Text));
     end;
   finally
     LSections.Free;
   end;

   if(not (LExistsName or LExistsDirectory))then
     Exit;

   if(LExistsName)then
     if(not ShowQuestion(' Project name already exists on list. ' + sLineBreak + 'Continue?'))then
       Abort;

   if(LExistsDirectory)then
     if(not ShowQuestion('Project path already exists on list. ' + sLineBreak + 'Continue?'))then
       Abort;
end;

procedure TViewProjectsListAddProject.SaveToList(ASection: string);
begin
   Self.VerifyProjectName;
   Self.InformedFileExists;

   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_NAME,         Trim(edtNomeProjeto.Text));
   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_DIRECTORY,    Trim(edtDiretorioProjeto.Text));
   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_GITDIRECTORY, Trim(edtGitDirectory.Text));
   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_GROUP,        Trim(cbGrupo.Text));
   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_COLOR,        Trim(cbCor.Text));

   if(SectionToUpdate.IsEmpty)then
     TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_DATELASTOPENED, DateTimeToStr(Now));
end;

procedure TViewProjectsListAddProject.CleanFields;
begin
   edtNomeProjeto.Text      := EmptyStr;
   edtDiretorioProjeto.Text := EmptyStr;
   edtGitDirectory.Text     := EmptyStr;
   cbGrupo.ItemIndex        := 0;
   cbCor.ItemIndex          := 0;
end;

procedure TViewProjectsListAddProject.InformedFileExists;
begin
   if(FileExists(Trim(edtDiretorioProjeto.Text)))then
     Exit;

   MessageError('File not found on path' + sLineBreak + 'Path: ' + Trim(edtDiretorioProjeto.Text));
   Abort;
end;

end.
