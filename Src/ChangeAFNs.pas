unit ChangeAFNs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmChangeAFNs = class(TForm)
    leOldAFN: TLabeledEdit;
    leNewAFN: TLabeledEdit;
    btnOk: TButton;
    btnCancel: TButton;
    lblStatus: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TfrmChangeAFNs }

end.
