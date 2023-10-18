object frmSetFilter: TfrmSetFilter
  Left = 514
  Top = 276
  Width = 517
  Height = 449
  Caption = 'Set Filter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    509
    415)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TBitBtn
    Left = 330
    Top = 381
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 422
    Top = 381
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 3
    Kind = bkCancel
  end
  object leFirstName: TLabeledEdit
    Left = 16
    Top = 32
    Width = 121
    Height = 21
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = '&First Name'
    TabOrder = 0
  end
  object leLastName: TLabeledEdit
    Left = 16
    Top = 72
    Width = 121
    Height = 21
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = '&Last Name'
    TabOrder = 1
  end
end
