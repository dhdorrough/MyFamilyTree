unit CalendarArithmetic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask;

type
  TfrmCalendarArithmetic = class(TForm)
    meDate: TMaskEdit;
    Label1: TLabel;
    btnPlus: TButton;
    btnMinus: TButton;
    meAmt: TEdit;
    lblAnswer: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPlusClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCalendarArithmetic: TfrmCalendarArithmetic;

implementation

uses MyUtils;

{$R *.dfm}

procedure TfrmCalendarArithmetic.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := true;
end;

procedure TfrmCalendarArithmetic.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmCalendarArithmetic.btnPlusClick(Sender: TObject);
begin
  lblAnswer.Caption := DateTimeToStr(StrToDate(meDate.Text) + StrToFloat(meAmt.Text));
end;

procedure TfrmCalendarArithmetic.btnMinusClick(Sender: TObject);
var
  NrDays,NrMonths, NrYears: integer;
begin
  if IsValidDate(meAmt.Text) then
    begin
      NrMonths := 0; NrYears := 0;
      NrDays := Trunc(StrToDate(meDate.Text) - StrToDate(meAmt.Text));
      if NrDays > 365 then
        begin
          NrYears := NrDays div 365;
          NrDays  := NrDays - (NrYears * 365);
          if NrDays > 30 then
            begin
              NrMonths := NrDays div 30;
              NrDays   := NrDays - (NrMonths * 30);
            end;
        end;
      if NrYears > 0 then
        lblAnswer.Caption := Format('Approx %d years, %d months, %d days', [NrYears, NrMonths, NrDays]) else
      if NrMonths > 0 then
        lblAnswer.Caption := Format('Approx %d months, %d days', [NrYears, NrMonths, NrDays]) 
      else
        lblAnswer.Caption := Format('%d days', [NrYears, NrMonths, NrDays]);
    end
  else if IsPureNumeric(meAmt.Text) then
    lblAnswer.Caption := DateTimeToStr(StrToDate(meDate.Text) - StrToFloat(meAmt.Text))
  else
    lblAnswer.Caption := 'The amount must either be a date or a number of days';
end;

end.
