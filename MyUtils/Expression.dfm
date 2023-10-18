object frmExpression: TfrmExpression
  Left = 800
  Top = 286
  Width = 570
  Height = 520
  Caption = 'Expression'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    554
    481)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 192
    Top = 12
    Width = 46
    Height = 13
    Caption = 'Functions'
  end
  object Label3: TLabel
    Left = 368
    Top = 12
    Width = 27
    Height = 13
    Caption = 'Fields'
  end
  object lblStatus: TLabel
    Left = 16
    Top = 275
    Width = 441
    Height = 33
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'lblStatus'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 125
    Top = 439
    Width = 73
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Lookup Name: '
  end
  object lblLookupName: TLabel
    Left = 224
    Top = 439
    Width = 67
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Lookup Name'
  end
  object btnOk: TButton
    Left = 389
    Top = 453
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 475
    Top = 453
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object cbFunctions: TComboBox
    Left = 192
    Top = 32
    Width = 169
    Height = 21
    Style = csDropDownList
    DropDownCount = 16
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbFunctionsChange
    OnClick = cbFunctionsClick
  end
  object cbFields: TComboBox
    Left = 368
    Top = 32
    Width = 169
    Height = 21
    Style = csDropDownList
    DropDownCount = 16
    ItemHeight = 13
    TabOrder = 4
    OnClick = cbFieldsClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 64
    Width = 519
    Height = 209
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 0
    OnChange = Memo1Change
  end
  object btnLoadExpression: TButton
    Left = 16
    Top = 454
    Width = 99
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Load Expression'
    TabOrder = 5
    OnClick = btnLoadExpressionClick
  end
  object btnSave: TButton
    Left = 124
    Top = 454
    Width = 99
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Save'
    Enabled = False
    TabOrder = 6
    OnClick = btnSaveClick
  end
  object btnSaveAs: TButton
    Left = 232
    Top = 454
    Width = 99
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save &As'
    TabOrder = 7
    OnClick = btnSaveAsClick
  end
  object btnEvaluate: TButton
    Left = 459
    Top = 277
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Evaluate'
    TabOrder = 8
    OnClick = btnEvaluateClick
  end
  object Panel1: TPanel
    Left = 16
    Top = 313
    Width = 529
    Height = 121
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    BevelWidth = 2
    TabOrder = 9
    DesignSize = (
      529
      121)
    object lblResultType: TLabel
      Left = 82
      Top = 9
      Width = 64
      Height = 13
      Caption = 'lblResultType'
    end
    object lblTemplate: TLabel
      Left = 67
      Top = 27
      Width = 77
      Height = 14
      Caption = 'lblTemplate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 6
      Top = 9
      Width = 69
      Height = 13
      Caption = 'Result Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 6
      Top = 27
      Width = 57
      Height = 13
      Caption = 'Template:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 160
      Top = 8
      Width = 41
      Height = 13
      Caption = 'Result:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Memo2: TMemo
      Left = 6
      Top = 48
      Width = 513
      Height = 65
      Anchors = [akLeft, akTop, akRight]
      Lines.Strings = (
        'Memo2')
      TabOrder = 0
    end
    object edtResult: TEdit
      Left = 208
      Top = 3
      Width = 305
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'edtResult'
    end
  end
end
