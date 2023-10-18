object frmChangeAFNs: TfrmChangeAFNs
  Left = 671
  Top = 348
  BorderStyle = bsDialog
  Caption = 'Change AFNs for Selected Records'
  ClientHeight = 185
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    317
    185)
  PixelsPerInch = 96
  TextHeight = 13
  object lblStatus: TLabel
    Left = 160
    Top = 24
    Width = 40
    Height = 13
    Caption = 'lblStatus'
    Color = clYellow
    ParentColor = False
  end
  object leOldAFN: TLabeledEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 21
    EditLabel.Width = 40
    EditLabel.Height = 13
    EditLabel.Caption = 'Old &AFN'
    TabOrder = 0
  end
  object leNewAFN: TLabeledEdit
    Left = 16
    Top = 72
    Width = 121
    Height = 21
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = '&New AFN'
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 145
    Top = 145
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 231
    Top = 145
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
