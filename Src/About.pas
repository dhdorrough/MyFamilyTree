unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    lblVersion: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses FamilyTree_Decl;

{$R *.dfm}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := 'Compiled: ' + DateTimeToStr(FileDateToDateTime(FileAge(ParamStr(0))));
  Copyright.Caption := Format(FamilyTree_Decl.Copyright, [FamilyTree_Decl.Version_Date]);
  Comments.Caption  := FamilyTree_Decl.contact;
end;

end.
 
