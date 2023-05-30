unit MyOTAWizard.MenuItem;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Menus;

type
  TMyOTAWizardMenuItem = class
  private
    FParent: TMenuItem;
    FCaption: string;
    FName: string;
    FImageList: TDictionary<string, Integer>;
    FImageResource: string;
    FShortCut: string;
    FVisible: Boolean;
    FTag: Integer;
    FHint: string;
    FOnClick: TNotifyEvent;

    function GetImageIndex(AResourceName: String): Integer;
    constructor Create;
  public
    class function New: TMyOTAWizardMenuItem;
    function Parent(AParent: TMenuItem): TMyOTAWizardMenuItem;
    function Caption(ACaption: string): TMyOTAWizardMenuItem;
    function Name(AName: string): TMyOTAWizardMenuItem;
    function ImageList(AImageList: TDictionary<string, Integer>): TMyOTAWizardMenuItem;
    function ImageResource(AImageResource: string): TMyOTAWizardMenuItem;
    function ShortCut(AShortCut: string): TMyOTAWizardMenuItem;
    function OnClick(AOnClick: TNotifyEvent): TMyOTAWizardMenuItem;
    function Visible(AVisible: Boolean): TMyOTAWizardMenuItem;
    function Hint(AHint: string): TMyOTAWizardMenuItem;
    function Tag(ATag: Integer): TMyOTAWizardMenuItem;
    function CreateMenuItem: TMenuItem;
  end;

implementation

class function TMyOTAWizardMenuItem.New: TMyOTAWizardMenuItem;
begin
   Result := Self.Create;
end;

constructor TMyOTAWizardMenuItem.Create;
begin
   FParent        := nil;
   FCaption       := '';
   FName          := '';
   FImageList     := nil;
   FImageResource := '';
   FShortCut      := '';
   FVisible       := True;
   FOnClick       := nil;
   FHint          := '';
   FTag           := 0;
end;

function TMyOTAWizardMenuItem.Parent(AParent: TMenuItem): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FParent := AParent;
end;

function TMyOTAWizardMenuItem.Caption(ACaption: string): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FCaption := ACaption;
end;

function TMyOTAWizardMenuItem.Name(AName: string): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FName := AName;
end;

function TMyOTAWizardMenuItem.ImageList(AImageList: TDictionary<string, Integer>): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FImageList := AImageList;
end;

function TMyOTAWizardMenuItem.ImageResource(AImageResource: string): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FImageResource := AImageResource;
end;

function TMyOTAWizardMenuItem.ShortCut(AShortCut: string): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FShortCut := AShortCut;
end;

function TMyOTAWizardMenuItem.Tag(ATag: Integer): TMyOTAWizardMenuItem;
begin
   Result := Self;
   if(ATag >= 0)then
     FTag := ATag;
end;

function TMyOTAWizardMenuItem.Visible(AVisible: Boolean): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FVisible := AVisible;
end;

function TMyOTAWizardMenuItem.OnClick(AOnClick: TNotifyEvent): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FOnClick := AOnClick;
end;

function TMyOTAWizardMenuItem.Hint(AHint: string): TMyOTAWizardMenuItem;
begin
   Result := Self;
   FHint  := AHint.Trim;
end;

function TMyOTAWizardMenuItem.CreateMenuItem: TMenuItem;
var
  LMenuItem: TMenuItem;
  LImageIndex: Integer;
begin
  LMenuItem         := TMenuItem.Create(FParent);
  LMenuItem.Caption := FCaption;
  LMenuItem.Name    := FName;
  LMenuItem.OnClick := FOnClick;
  LMenuItem.Visible := FVisible;
  LMenuItem.Tag     := FTag;
  LMenuItem.Hint    := FHint;

  if(not FImageResource.IsEmpty)then
  begin
     LImageIndex := GetImageIndex(FImageResource);
     if(LImageIndex > -1)then
       LMenuItem.ImageIndex := LImageIndex;
  end;

  if(not FShortCut.IsEmpty)then
    LMenuItem.ShortCut := TextToShortCut(FShortCut);

  FParent.Add(LMenuItem);
  Result := LMenuItem;
end;

function TMyOTAWizardMenuItem.GetImageIndex(AResourceName: String): Integer;
var
  Key: string;
begin
  Result := -1;
  for Key in FImageList.Keys do
  begin
    if(Key = AResourceName)then
      Exit(FImageList.Items[key]);
  end;
end;

end.
