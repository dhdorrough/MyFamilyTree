unit uGetString;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmGetString = class(TForm)
    edtGetString: TEdit;
    lblCaption: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetString( const FormCaption, aLabelCaption: string;
                    var aResult: string; FldLen: integer = 0; aCharCase: TEditCharCase = ecNormal): boolean;

implementation

{$R *.DFM}

function GetString( const FormCaption, aLabelCaption: string;
                    var aResult: string; FldLen: integer = 0; aCharCase: TEditCharCase = ecNormal): boolean;
var
  frmGetString: TfrmGetString;
begin
  frmGetString := TfrmGetString.Create(nil);
  try
    with frmGetString do
      begin
        Caption  := FormCaption;
        edtGetString.CharCase := aCharCase;
        lblCaption.Caption := aLabelCaption;
        edtGetString.Text  := aResult;
        if FldLen > 0 then
          edtGetString.Width := FldLen *10;
        Result := ShowModal = mrOk;
        if result then
          aResult := edtGetString.Text;
      end;
  finally
    frmGetString.Free;
  end;
end;

end.
