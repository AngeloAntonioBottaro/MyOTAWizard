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
    btnAdicionar: TButton;
    btnSelecionarProjeto: TButton;
    edtDiretorioProjeto: TEdit;
    edtNomeProjeto: TEdit;
    lbNomeProjeto: TLabel;
    lbDiretorioProjeto: TLabel;
    pnIniFilePath: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarProjetoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAdicionarClick(Sender: TObject);
    procedure pnIniFilePathClick(Sender: TObject);
  private
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
  ProjectsList.IniFileUtils;

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
   lbNomeProjeto.Font.Color      := clBlack;
   lbDiretorioProjeto.Font.Color := clBlack;
   if((BorlandIDEServices as IOTAIDEThemingServices250).ActiveTheme = 'Dark')then
   begin
      lbNomeProjeto.Font.Color      := clWhite;
      lbDiretorioProjeto.Font.Color := clWhite;
   end;
   {$ENDIF}
end;

procedure TViewAddProject.pnIniFilePathClick(Sender: TObject);
begin
   Clipboard.AsText := TProjectsListIniFileUtils.IniFilePath;
end;

procedure TViewAddProject.btnSelecionarProjetoClick(Sender: TObject);
var
  LSaveDialog: TSaveDialog;
  LFile: string;
  LExt: string;
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

procedure TViewAddProject.btnAdicionarClick(Sender: TObject);
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
var
  LIniFile: TIniFile;
begin
   LIniFile := TIniFile.Create(TProjectsListIniFileUtils.IniFile);
   try
     LIniFile.WriteString(Trim(edtNomeProjeto.Text), IdentifierDirectory, Trim(edtDiretorioProjeto.Text));
   finally
     LIniFile.Free;
   end;
end;

procedure TViewAddProject.LimparCampos;
begin
   edtNomeProjeto.Text := EmptyStr;
   edtDiretorioProjeto.Text := EmptyStr;
end;

end.
