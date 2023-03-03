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
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarProjetoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure pnIniFilePathClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnIniFilePathDblClick(Sender: TObject);
  private
    FSectionToUpdate: string;
    procedure ConfComponentsTheme;
    procedure LoadSectionInformations(ASection: string);
    procedure VerifyFields;
    procedure SaveToList(ASection: string);
    procedure VerifyProjectName;
    procedure CleanFields;
  public
    property SectionToUpdate: string read FSectionToUpdate write FSectionToUpdate;
    procedure GetSelectedFileName;
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
   Self.ConfComponentsTheme;
   Self.LoadSectionInformations(SectionToUpdate);
end;

procedure TViewProjectsListAddProject.ConfComponentsTheme;
begin
   lbNomeProjeto.Font.Color      := TPLColors.Texto.ToColor;
   lbDiretorioProjeto.Font.Color := TPLColors.Texto.ToColor;
   lbGrupo.Font.Color            := TPLColors.Texto.ToColor;
   lbCor.Font.Color              := TPLColors.Texto.ToColor;
end;

procedure TViewProjectsListAddProject.LoadSectionInformations(ASection: string);
begin
   if(ASection.IsEmpty)then
     Exit;

   edtNomeProjeto.Text      := TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_NAME, '');
   edtDiretorioProjeto.Text := TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_DIRECTORY, '');
   cbGrupo.ItemIndex        := Integer(StrToPLGroup(TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_GROUP, TPLGroup.Tudo.ToString)));
   cbCor.ItemIndex          := Integer(StrToPLColors(TProjectsListIniFile.New.IniFile.ReadString(ASection, INI_IDENTIFIER_COLOR, TPLColors.Texto.ToString)));
end;

procedure TViewProjectsListAddProject.pnIniFilePathClick(Sender: TObject);
begin
   Clipboard.AsText := TProjectsListIniFile.New.IniFilePath;
end;

procedure TViewProjectsListAddProject.pnIniFilePathDblClick(Sender: TObject);
begin
   TMyOTAWizardUtils.Open(TProjectsListIniFile.New.IniFilePath);
end;

procedure TViewProjectsListAddProject.btnSelecionarProjetoClick(Sender: TObject);
var
  LSaveDialog: TSaveDialog;
  LFile: string;
begin
   edtDiretorioProjeto.Text := '';
   LFile := '';
   LSaveDialog := TSaveDialog.Create(nil);
   try
     LSaveDialog.DefaultExt := 'pdf';
     LSaveDialog.Filter     := 'All|*.*|Project|*.dproj|Project Group|*.groupproj';
     LSaveDialog.InitialDir := 'C:\';
     LSaveDialog.FileName   := '';
     if(LSaveDialog.Execute)then
       LFile := LSaveDialog.FileName;
   finally
     LSaveDialog.Free;
   end;

   if(LFile = EmptyStr)then
     Exit;

   edtDiretorioProjeto.Text := LFile;
   Self.GetSelectedFileName;
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
      ShowInfo('Diretório do projeto não informado');
      Abort;
   end;

   if(Trim(edtNomeProjeto.Text).IsEmpty)then
   begin
      edtNomeProjeto.SetFocus;
      ShowInfo('Nome do projeto não informado');
      Abort;
   end;
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
     if(not ShowQuestion('Nome do projeto já existe. ' + sLineBreak + 'Deseja continuar?'))then
       Abort;

   if(LExistsDirectory)then
     if(not ShowQuestion('Diretório do projeto já existe. ' + sLineBreak + 'Deseja continuar?'))then
       Abort;
end;

procedure TViewProjectsListAddProject.SaveToList(ASection: string);
begin
   Self.VerifyProjectName;

   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_NAME,      Trim(edtNomeProjeto.Text));
   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_DIRECTORY, Trim(edtDiretorioProjeto.Text));
   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_GROUP,     Trim(cbGrupo.Text));
   TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_COLOR,     Trim(cbCor.Text));

   if(SectionToUpdate.IsEmpty)then
     TProjectsListIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_DATELASTOPENED, DateTimeToStr(Now));
end;

procedure TViewProjectsListAddProject.CleanFields;
begin
   edtNomeProjeto.Text      := EmptyStr;
   edtDiretorioProjeto.Text := EmptyStr;
   cbGrupo.ItemIndex        := 0;
   cbCor.ItemIndex          := 0;
end;

end.
