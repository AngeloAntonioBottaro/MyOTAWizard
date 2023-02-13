unit View.AddProject;

interface

uses
  ToolsAPI,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
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
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarProjetoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
  public
  end;

var
  ViewAddProject: TViewAddProject;

implementation

{$R *.dfm}

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

procedure TViewAddProject.btnSelecionarProjetoClick(Sender: TObject);
begin
   //
end;

end.
