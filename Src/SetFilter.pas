unit SetFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmSetFilter = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    leFirstName: TLabeledEdit;
    leLastName: TLabeledEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSetFilter: TfrmSetFilter;

implementation

{$R *.dfm}

end.
