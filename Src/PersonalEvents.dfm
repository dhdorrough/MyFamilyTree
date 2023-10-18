object frmPersonalEvents: TfrmPersonalEvents
  Left = 510
  Top = 316
  Width = 789
  Height = 351
  Caption = 'Personal Events'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    773
    313)
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 7
    Top = 8
    Width = 784
    Height = 269
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 281
    Width = 234
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
    Anchors = [akLeft, akBottom]
    Hints.Strings = (
      'First record'
      'Prior record'
      'Next record'
      'Last record'
      'Insert record'
      'Delete record'
      'Edit record'
      'Post edit'
      'Cancel edit'
      '')
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 680
    Top = 285
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    Default = True
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object btnCancel: TButton
    Left = 592
    Top = 285
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 328
    Top = 264
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 296
    Top = 264
  end
end
