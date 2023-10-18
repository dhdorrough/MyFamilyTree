object frmCalendarArithmetic: TfrmCalendarArithmetic
  Left = 749
  Top = 395
  Width = 480
  Height = 150
  Caption = 'Calendar Arithmetic'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 23
    Height = 13
    Caption = 'Date'
  end
  object lblAnswer: TLabel
    Left = 208
    Top = 40
    Width = 45
    Height = 13
    Caption = 'lblAnswer'
  end
  object meDate: TMaskEdit
    Left = 24
    Top = 40
    Width = 64
    Height = 21
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    TabOrder = 0
    Text = '  /  /    '
  end
  object btnPlus: TButton
    Left = 97
    Top = 22
    Width = 25
    Height = 25
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    TabStop = False
    OnClick = btnPlusClick
  end
  object btnMinus: TButton
    Left = 97
    Top = 54
    Width = 25
    Height = 25
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    TabStop = False
    OnClick = btnMinusClick
  end
  object meAmt: TEdit
    Left = 128
    Top = 40
    Width = 69
    Height = 21
    MaxLength = 10
    TabOrder = 1
    Text = '   '
  end
end
