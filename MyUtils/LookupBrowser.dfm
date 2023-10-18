inherited frmLookupBrowser: TfrmLookupBrowser
  Left = 458
  Top = 190
  Width = 732
  Height = 410
  Caption = 'Lookup Browser'
  PixelsPerInch = 96
  TextHeight = 14
  inherited lblStatus: TLabel
    Left = 491
    Top = 332
  end
  inherited DBGrid1: TDBGrid
    Width = 768
    Height = 313
    Columns = <
      item
        Expanded = False
        FieldName = 'LookupName'
        Title.Caption = 'Name'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LookupValue'
        Title.Caption = 'Value'
        Width = 475
        Visible = True
      end>
  end
  inherited DBNavigator1: TDBNavigator
    Top = 327
    Hints.Strings = ()
  end
  inherited btnClose: TButton
    Left = 640
    Top = 326
  end
  object Button1: TButton [4]
    Left = 542
    Top = 326
    Width = 81
    Height = 27
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
