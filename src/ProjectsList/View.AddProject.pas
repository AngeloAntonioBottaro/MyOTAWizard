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
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarProjetoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure pnIniFilePathClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ConfComponentsTheme(ATheme: string);
    procedure ValidarCampos;
    procedure SalvarNaLista;
    procedure LimparCampos;
  public
  end;

var
  ViewAddProject: TViewAddProject;

implementation

{$R *.dfm}

uses
  ProjectsList.IniFile,
  ProjectsList.Types;

procedure TViewAddProject.FormCreate(Sender: TObject);
begin
   cbGrupo.Items.Clear;
   TEnumUtils<TGroup>.EnumToList(cbGrupo.Items);
   cbGrupo.ItemIndex := 0;
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
   {$IF CompilerVersion >= 32.0}
    (BorlandIDEServices as IOTAIDEThemingServices250).RegisterFormClass(TViewAddProject);
    Self.ConfComponentsTheme((BorlandIDEServices as IOTAIDEThemingServices250).ActiveTheme);
   {$ENDIF}
end;

procedure TViewAddProject.ConfComponentsTheme(ATheme: string);
var
  LColor: TColor;
begin
   LColor := clBlack;
   if(ATheme = 'Dark')then
     LColor := clWhite;

   lbNomeProjeto.Font.Color      := LColor;
   lbDiretorioProjeto.Font.Color := LColor;
   lbGrupo.Font.Color            := LColor;
end;

procedure TViewAddProject.pnIniFilePathClick(Sender: TObject);
begin
   Clipboard.AsText := TProjectsListIniFile.New.IniFilePath;
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
   if(Trim(edtNomeProjeto.Text).IsEmpty)then
   begin
      edtNomeProjeto.SetFocus;
      ShowMessage('Nome do projeto não informado');
      Abort;
   end;

   if(Trim(edtDiretorioProjeto.Text).IsEmpty)then
   begin
      edtDiretorioProjeto.SetFocus;
      ShowMessage('Diretório do projeto não informado');
      Abort;
   end;
end;

procedure TViewAddProject.SalvarNaLista;
begin
   TProjectsListIniFile.New.IniFile.WriteString(Trim(edtNomeProjeto.Text), IdentifierDirectory, Trim(edtDiretorioProjeto.Text));
   TProjectsListIniFile.New.IniFile.WriteString(Trim(edtNomeProjeto.Text), IdentifierGroup, Trim(cbGrupo.Text));
end;

procedure TViewAddProject.LimparCampos;
begin
   edtNomeProjeto.Text := EmptyStr;
   edtDiretorioProjeto.Text := EmptyStr;
   cbGrupo.ItemIndex := 0;
end;

end.
