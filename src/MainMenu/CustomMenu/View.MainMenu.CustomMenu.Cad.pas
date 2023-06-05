unit View.MainMenu.CustomMenu.Cad;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Menus;

type
  TViewMainMenuCustomMenuCad = class(TForm)
    pnButtons: TPanel;
    btnSave: TButton;
    pnFile: TPanel;
    edtFile: TEdit;
    btnSelectFile: TButton;
    lbFile: TLabel;
    pnMenuInfo: TPanel;
    lbCaption: TLabel;
    edtCaption: TEdit;
    cbType: TComboBox;
    lbType: TLabel;
    UpDownOrder: TUpDown;
    edtOrder: TEdit;
    lbOrder: TLabel;
    pnCmdCommand: TPanel;
    lbCMDCommand: TLabel;
    edtCmdCommand: TEdit;
    pnParameter: TPanel;
    lbParameter: TLabel;
    edtParameter: TEdit;
    edtShortcut: THotKey;
    lbShortcut: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnSelectFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
  private
    FSectionToUpdate: string;
    procedure ClearField;
    procedure EnableFields;
    procedure SaveToIni(ASection: string);
    procedure LoadSectionToUpdate;
    procedure ValidateFields;
  public
    property SectionToUpdate: string read FSectionToUpdate write FSectionToUpdate;
  end;

var
  ViewMainMenuCustomMenuCad: TViewMainMenuCustomMenuCad;

implementation

{$R *.dfm}

uses
  MyOTAWizard.Utils,
  MyOTAWizard.MainMenu.CustomMenu.Types,
  MyOTAWizard.MainMenu.CustomMenu.Ini,
  View.MainMenu.CustomMenu.List;

procedure TViewMainMenuCustomMenuCad.FormCreate(Sender: TObject);
var
  I: TCustomMenuType;
begin
   cbType.Items.Clear;
   for I := Low(TCustomMenuType) to High(TCustomMenuType) do
     cbType.Items.Add(I.ToString);
end;

procedure TViewMainMenuCustomMenuCad.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
     VK_ESCAPE: if(Shift = [])then Self.Close;
   end;
end;

procedure TViewMainMenuCustomMenuCad.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if(Key = #13)then
   begin
      Perform(CM_DialogKey, VK_TAB, 0);
      Key := #0;
   end;
end;

procedure TViewMainMenuCustomMenuCad.FormShow(Sender: TObject);
begin
   TMyOTAWizardUtils.ApplyTheme(TViewMainMenuCustomMenuCad, Self);
   Self.ClearField;
   Self.LoadSectionToUpdate;
   Self.EnableFields;
end;

procedure TViewMainMenuCustomMenuCad.LoadSectionToUpdate;
var
  LType: TCustomMenuType;
  LAction: string;
begin
   if(FSectionToUpdate.IsEmpty)then
     Exit;

   LType := StrToCustomMenuType(TCustomMenuIniFile.New.IniFile.ReadString(FSectionToUpdate, INI_IDENTIFIER_TYPE, ''));
   cbType.ItemIndex   := LType.ToInteger;
   edtCaption.Text    := TCustomMenuIniFile.New.IniFile.ReadString(FSectionToUpdate, INI_IDENTIFIER_CAPTION,  '');
   edtOrder.Text      := TCustomMenuIniFile.New.IniFile.ReadString(FSectionToUpdate, INI_IDENTIFIER_ORDER,  '0');
   edtShortcut.HotKey := TextToShortCut(TCustomMenuIniFile.New.IniFile.ReadString(FSectionToUpdate, INI_IDENTIFIER_SHORTCUT,  ''));
   edtParameter.Text  := TCustomMenuIniFile.New.IniFile.ReadString(FSectionToUpdate, INI_IDENTIFIER_PARAM,  '');

   LAction := TCustomMenuIniFile.New.IniFile.ReadString(FSectionToUpdate, INI_IDENTIFIER_ACTION,  '');;
   case(LType)of
    TCustomMenuType.ExternalFile,
    TCustomMenuType.Folder,
    TCustomMenuType.Link: edtFile.Text := LAction;
    TCustomMenuType.CMDCommand: edtCmdCommand.Text := LAction;
   end;
end;

procedure TViewMainMenuCustomMenuCad.btnSelectFileClick(Sender: TObject);
var
  LFile: string;
begin
   edtFile.Text := '';

   LFile := '';
   if(cbType.ItemIndex = TCustomMenuType.ExternalFile.ToInteger)then
     LFile := TMyOTAWizardUtils.SelectFile
   else if(cbType.ItemIndex = TCustomMenuType.Folder.ToInteger)then
     LFile := TMyOTAWizardUtils.SelectDirectory;

   if(LFile = EmptyStr)then
     Exit;

   edtFile.Text := LFile.Trim;
end;

procedure TViewMainMenuCustomMenuCad.cbTypeChange(Sender: TObject);
begin
   Self.EnableFields;
end;

procedure TViewMainMenuCustomMenuCad.ClearField;
begin
   cbType.ItemIndex := -1;
   edtOrder.Text    := '0';
   edtCaption.Clear;
   edtFile.Clear;
   edtCmdCommand.Clear;
   edtParameter.Clear;
   edtShortcut.HotKey := TextToShortCut('');
end;

procedure TViewMainMenuCustomMenuCad.EnableFields;
begin
   if(cbType.ItemIndex = TCustomMenuType.Separator.ToInteger)then
     edtCaption.Text := '-';

   edtCaption.Enabled    := cbType.ItemIndex <> TCustomMenuType.Separator.ToInteger;
   edtShortcut.Enabled   := edtCaption.Enabled;
   edtFile.Enabled       := (cbType.ItemIndex = TCustomMenuType.ExternalFile.ToInteger) or
                            (cbType.ItemIndex = TCustomMenuType.Link.ToInteger) or
                            (cbType.ItemIndex = TCustomMenuType.Folder.ToInteger);
   btnSelectFile.Enabled := (cbType.ItemIndex = TCustomMenuType.ExternalFile.ToInteger) or
                            (cbType.ItemIndex = TCustomMenuType.Folder.ToInteger);
   edtCmdCommand.Enabled := cbType.ItemIndex = TCustomMenuType.CMDCommand.ToInteger;
   edtParameter.Enabled  := edtFile.Enabled or edtCmdCommand.Enabled;
end;

procedure TViewMainMenuCustomMenuCad.btnSaveClick(Sender: TObject);
begin
   Self.ValidateFields;

   if(SectionToUpdate.IsEmpty)then
     Self.SaveToIni(TMyOTAWizardUtils.CreateGuidStr)
   else
     Self.SaveToIni(SectionToUpdate);

   Self.ClearField;
   Self.EnableFields;

   if(Assigned(ViewMainMenuCustomMenuList))then
     ViewMainMenuCustomMenuList.UpdateList;
end;

procedure TViewMainMenuCustomMenuCad.SaveToIni(ASection: string);
var
  LCaption: string;
  LAction: string;
begin
   LCaption := Trim(edtCaption.Text);
   LAction  := EmptyStr;
   case(TCustomMenuType(cbType.ItemIndex))of
    TCustomMenuType.Separator: LCaption := '-';
    TCustomMenuType.ExternalFile:
    begin
       LAction  := edtFile.Text;
       if(not FileExists(LAction))then
       begin
          ShowInfo('File: ' + LAction + ' not found.');
          Exit;
       end;
    end;
    TCustomMenuType.Link: LAction  := edtFile.Text;
    TCustomMenuType.Folder:
    begin
       LAction  := edtFile.Text;
       if(not DirectoryExists(LAction))then
       begin
          ShowInfo('Folder: ' + LAction + ' not found.');
          Exit;
       end;
    end;
    TCustomMenuType.CMDCommand: LAction  := edtCmdCommand.Text;
   end;

   TCustomMenuIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_TYPE,     Trim(cbType.Text));
   TCustomMenuIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_CAPTION,  LCaption);
   TCustomMenuIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_ORDER,    Trim(edtOrder.Text));
   TCustomMenuIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_SHORTCUT, ShortCutToText(edtShortcut.HotKey));
   TCustomMenuIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_ACTION,   Trim(LAction));
   TCustomMenuIniFile.New.IniFile.WriteString(ASection, INI_IDENTIFIER_PARAM,    Trim(edtParameter.Text));
end;

procedure TViewMainMenuCustomMenuCad.ValidateFields;
begin
   if(cbType.ItemIndex < 0)then
   begin
      ShowInfo('Menu type required');
      cbType.SetFocus;
      Abort;
   end;

   if(Trim(edtCaption.Text).IsEmpty)then
   begin
      ShowInfo('Menu caption required');
      edtCaption.SetFocus;
      Abort;
   end;
end;

end.
