unit ShortCuts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmShortcuts = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShortcuts: TfrmShortcuts;

implementation

{$R *.dfm}

procedure TfrmShortcuts.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
