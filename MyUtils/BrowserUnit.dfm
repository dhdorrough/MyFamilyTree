object frmDataSetBrowser: TfrmDataSetBrowser
  Left = 438
  Top = 269
  Width = 1186
  Height = 415
  Caption = 'Dataset Browser'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    1170
    356)
  PixelsPerInch = 96
  TextHeight = 14
  object lblStatus: TLabel
    Left = 1040
    Top = 336
    Width = 41
    Height = 14
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'lblStatus'
  end
  object DBGrid1: TDBGrid
    Left = 6
    Top = 3
    Width = 1167
    Height = 325
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
  end
  object DBNavigator1: TDBNavigator
    Left = 9
    Top = 331
    Width = 290
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 1091
    Top = 330
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object MainMenu1: TMainMenu
    Left = 183
    Top = 19
    object File1: TMenuItem
      Caption = 'File'
      object Print1: TMenuItem
        Caption = 'Print...'
        OnClick = Print1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Find1: TMenuItem
        Caption = 'Find'
        ShortCut = 16454
        OnClick = Find1Click
      end
      object FindAgain1: TMenuItem
        Caption = 'Find Again'
        ShortCut = 114
        OnClick = FindAgain1Click
      end
    end
    object Navigate1: TMenuItem
      Caption = '&Navigate'
      object FilterOptions1: TMenuItem
        Caption = 'Filter Options...'
        OnClick = FilterOptions1Click
      end
      object ClearFilterOptions1: TMenuItem
        Caption = 'Clear Filter Options'
        OnClick = ClearFilterOptions1Click
      end
    end
  end
  object ReplaceDialog1: TReplaceDialog
    Options = [frDown, frHideMatchCase, frHideWholeWord, frHideUpDown]
    Left = 221
    Top = 18
  end
  object FindDialog1: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = FindDialog1Find
    Left = 264
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Text File (*.txt)|*.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofCreatePrompt, ofEnableSizing]
    Title = 'Output File Name'
    Left = 304
    Top = 24
  end
end
