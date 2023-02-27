unit View.AddProject;

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
  Vcl.Clipbrd,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TViewAddProject = class(TForm)
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
    procedure ConfComponentsTheme;
    procedure ValidarCampos;
    procedure SalvarNaLista;
    procedure LimparCampos;
  public
    procedure PegarNomeArquivoSelecionado;
  end;

var
  ViewAddProject: TViewAddProject;

implementation

{$R *.dfm}

uses
  MyOTAWizard.Utils,
  ProjectsList.IniFile,
  ProjectsList.Types;

procedure TViewAddProject.FormCreate(Sender: TObject);
begin
   cbGrupo.Items.Clear;
   TEnumUtils<TPLGroup>.EnumToList(cbGrupo.Items);
   cbGrupo.ItemIndex := 0;

   cbCor.Items.Clear;
   TEnumUtils<TPLColors>.EnumToList(cbCor.Items);
   cbCor.ItemIndex := 0;
end;

procedure TViewAddProject.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
   end;
end;

procedure TViewAddProject.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewAddProject.FormShow(Sender: TObject);
begin
   TMyOTAWizardUtils.ApplyTheme(TViewAddProject, Self);
   Self.ConfComponentsTheme;
end;

procedure TViewAddProject.ConfComponentsTheme;
begin
   lbNomeProjeto.Font.Color      := TPLColors.Texto.ToColor;
   lbDiretorioProjeto.Font.Color := TPLColors.Texto.ToColor;
   lbGrupo.Font.Color            := TPLColors.Texto.ToColor;
end;

procedure TViewAddProject.pnIniFilePathClick(Sender: TObject);
begin
   Clipboard.AsText := TProjectsListIniFile.New.IniFilePath;
end;

procedure TViewAddProject.pnIniFilePathDblClick(Sender: TObject);
begin
   TMyOTAWizardUtils.Open(TProjectsListIniFile.New.IniFilePath);
end;

procedure TViewAddProject.btnSelecionarProjetoClick(Sender: TObject);
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
   Self.PegarNomeArquivoSelecionado;
end;

procedure TViewAddProject.PegarNomeArquivoSelecionado;
var
  LFile: string;
begin
   LFile := edtDiretorioProjeto.Text;

   if(Trim(LFile).IsEmpty)then
     Exit;

   if(Trim(edtNomeProjeto.Text).IsEmpty)then
     edtNomeProjeto.Text := StringReplace(ExtractFileName(LFile), ExtractFileExt(LFile), '', []);
end;

procedure TViewAddProject.btnSalvarClick(Sender: TObject);
begin
   Self.ValidarCampos;
   Self.SalvarNaLista;
   Self.LimparCampos;
end;

procedure TViewAddProject.ValidarCampos;
begin
   if(Trim(edtDiretorioProjeto.Text).IsEmpty)then
   begin
      edtDiretorioProjeto.SetFocus;
      ShowMessage('Diretório do projeto não informado');
      Abort;
   end;

   if(Trim(edtNomeProjeto.Text).IsEmpty)then
   begin
      edtNomeProjeto.SetFocus;
      ShowMessage('Nome do projeto não informado');
      Abort;
   end;
end;

procedure TViewAddProject.SalvarNaLista;
var
  LSection: string;
begin
   LSection := Trim(edtNomeProjeto.Text);
   TProjectsListIniFile.New.IniFile.WriteString(LSection, IdentifierDirectory, Trim(edtDiretorioProjeto.Text));
   TProjectsListIniFile.New.IniFile.WriteString(LSection, IdentifierGroup, Trim(cbGrupo.Text));
   TProjectsListIniFile.New.IniFile.WriteString(LSection, IdentifierColor, Trim(cbCor.Text));
end;

procedure TViewAddProject.LimparCampos;
begin
   edtNomeProjeto.Text      := EmptyStr;
   edtDiretorioProjeto.Text := EmptyStr;
   cbGrupo.ItemIndex        := 0;
   cbCor.ItemIndex          := 0;
end;

end.
