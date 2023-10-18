object frmGetString: TfrmGetString
  Left = 597
  Top = 454
  Width = 638
  Height = 154
  Caption = 'Get String'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    630
    123)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 16
    Top = 19
    Width = 46
    Height = 13
    Caption = 'lblCaption'
  end
  object edtGetString: TEdit
    Left = 18
    Top = 47
    Width = 586
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 188
    Top = 86
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 274
    Top = 86
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
