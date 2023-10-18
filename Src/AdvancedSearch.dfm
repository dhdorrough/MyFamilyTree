object frmAdvancedSearch: TfrmAdvancedSearch
  Left = 528
  Top = 190
  BorderStyle = bsDialog
  Caption = 'Advanced Search'
  ClientHeight = 587
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    418
    587)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 65
    Top = 144
    Width = 47
    Height = 13
    Caption = 'FirstName'
    FocusControl = edtFirstName
  end
  object Label2: TLabel
    Left = 126
    Top = 144
    Width = 59
    Height = 13
    Caption = 'MiddleName'
    FocusControl = edtMiddleName
  end
  object Label3: TLabel
    Left = 190
    Top = 144
    Width = 48
    Height = 13
    Caption = 'LastName'
    FocusControl = edtLastName
  end
  object Label4: TLabel
    Left = 22
    Top = 273
    Width = 44
    Height = 13
    Caption = 'BirthDate'
    FocusControl = edtBirthDate
  end
  object Label5: TLabel
    Left = 175
    Top = 273
    Width = 52
    Height = 13
    Caption = 'DeathDate'
    FocusControl = edtDeathDate
  end
  object Label6: TLabel
    Left = 345
    Top = 144
    Width = 18
    Height = 13
    Caption = 'Sex'
    FocusControl = edtSex
  end
  object Label7: TLabel
    Left = 22
    Top = 100
    Width = 21
    Height = 13
    Caption = 'AFN'
    FocusControl = edtAFN
  end
  object Label8: TLabel
    Left = 23
    Top = 312
    Width = 50
    Height = 13
    Caption = 'Birth place'
    FocusControl = edtBirthPlace
  end
  object lblComments: TLabel
    Left = 22
    Top = 432
    Width = 49
    Height = 13
    Caption = 'Comments'
    FocusControl = edtComments
  end
  object Label13: TLabel
    Left = 128
    Top = 99
    Width = 92
    Height = 13
    Caption = 'External ID Number'
  end
  object lblDocFileName: TLabel
    Left = 24
    Top = 354
    Width = 96
    Height = 13
    Caption = 'Document FileName'
  end
  object lblDocDescription: TLabel
    Left = 24
    Top = 394
    Width = 105
    Height = 13
    Caption = 'Document Description'
  end
  object Label16: TLabel
    Left = 293
    Top = 144
    Width = 26
    Height = 13
    Caption = 'Suffix'
  end
  object Label17: TLabel
    Left = 175
    Top = 312
    Width = 58
    Height = 13
    Caption = 'Death place'
    FocusControl = edtDeathPlace
  end
  object Label18: TLabel
    Left = 23
    Top = 144
    Width = 26
    Height = 13
    Caption = 'Prefix'
    FocusControl = edtPrefix
  end
  object Label19: TLabel
    Left = 102
    Top = 273
    Width = 52
    Height = 13
    Caption = 'CanonBirth'
    FocusControl = edtCanonBirth
  end
  object lblCanonDeath: TLabel
    Left = 253
    Top = 273
    Width = 60
    Height = 13
    Caption = 'CanonDeath'
    FocusControl = edtCanonDeath
  end
  object lblSearch: TLabel
    Left = 22
    Top = 229
    Width = 34
    Height = 13
    Caption = '&Search'
    FocusControl = edtSearch
  end
  object Label12: TLabel
    Left = 249
    Top = 6
    Width = 17
    Height = 13
    Caption = '&Ref'
    FocusControl = edtRef
  end
  object lblDateAdded: TLabel
    Left = 22
    Top = 6
    Width = 80
    Height = 13
    Caption = 'Date Added Low'
    FocusControl = edtDateAddedLow
  end
  object lblDateUpdated: TLabel
    Left = 128
    Top = 6
    Width = 90
    Height = 13
    Caption = 'Date Updated Low'
    FocusControl = edtDateUpdatedLow
  end
  object lblNickName: TLabel
    Left = 23
    Top = 186
    Width = 50
    Height = 13
    Caption = 'NickName'
    FocusControl = edtNickName
  end
  object edtFirstName: TEdit
    Left = 65
    Top = 160
    Width = 60
    Height = 21
    TabOrder = 0
    OnChange = edtFirstNameChange
  end
  object edtMiddleName: TEdit
    Left = 126
    Top = 160
    Width = 59
    Height = 21
    TabOrder = 1
  end
  object edtLastName: TEdit
    Left = 190
    Top = 160
    Width = 98
    Height = 21
    TabOrder = 2
    OnChange = edtLastNameChange
  end
  object edtBirthDate: TEdit
    Left = 22
    Top = 289
    Width = 75
    Height = 21
    TabStop = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
  end
  object edtDeathDate: TEdit
    Left = 175
    Top = 289
    Width = 75
    Height = 21
    TabStop = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
  end
  object edtSex: TEdit
    Left = 345
    Top = 160
    Width = 17
    Height = 21
    TabOrder = 4
    OnChange = edtSexChange
  end
  object edtAFN: TEdit
    Left = 22
    Top = 116
    Width = 95
    Height = 21
    TabStop = False
    TabOrder = 15
  end
  object edtBirthPlace: TEdit
    Left = 23
    Top = 328
    Width = 130
    Height = 21
    TabOrder = 8
  end
  object edtSearch: TEdit
    Left = 22
    Top = 247
    Width = 347
    Height = 21
    TabOrder = 6
  end
  object edtComments: TMemo
    Left = 22
    Top = 450
    Width = 367
    Height = 36
    TabStop = False
    PopupMenu = PopupMenu1
    ScrollBars = ssVertical
    TabOrder = 11
  end
  object edtDocFileName: TEdit
    Left = 22
    Top = 370
    Width = 305
    Height = 21
    TabStop = False
    TabOrder = 12
  end
  object edtDocDescription: TEdit
    Left = 22
    Top = 411
    Width = 347
    Height = 21
    TabStop = False
    TabOrder = 16
  end
  object edtDABD: TEdit
    Left = 129
    Top = 116
    Width = 95
    Height = 21
    TabStop = False
    TabOrder = 17
  end
  object edtSuffix: TEdit
    Left = 293
    Top = 160
    Width = 44
    Height = 21
    TabOrder = 3
  end
  object edtDeathPlace: TEdit
    Left = 175
    Top = 328
    Width = 130
    Height = 21
    TabOrder = 10
  end
  object edtPrefix: TEdit
    Left = 23
    Top = 160
    Width = 32
    Height = 21
    TabOrder = 18
  end
  object edtCanonBirth: TEdit
    Left = 102
    Top = 289
    Width = 69
    Height = 21
    TabStop = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
  end
  object edtCanonDeath: TEdit
    Left = 253
    Top = 289
    Width = 69
    Height = 21
    TabStop = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
  end
  object btnOk: TButton
    Left = 248
    Top = 493
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 19
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 334
    Top = 493
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 20
  end
  object btnClearAll: TButton
    Left = 24
    Top = 493
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Clear All'
    TabOrder = 21
    OnClick = btnClearAllClick
  end
  object btnExpression: TButton
    Left = 112
    Top = 493
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Expression'
    TabOrder = 22
    OnClick = btnExpressionClick
  end
  object mmoExpression: TMemo
    Left = 22
    Top = 523
    Width = 387
    Height = 57
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 23
  end
  object edtRef: TEdit
    Left = 249
    Top = 22
    Width = 120
    Height = 21
    TabStop = False
    TabOrder = 24
  end
  object edtDateAddedLow: TEdit
    Left = 22
    Top = 22
    Width = 75
    Height = 21
    TabStop = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
  end
  object edtDateUpdatedLow: TEdit
    Left = 128
    Top = 22
    Width = 75
    Height = 21
    TabStop = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
  end
  object edtNickName: TEdit
    Left = 23
    Top = 203
    Width = 199
    Height = 21
    TabStop = False
    TabOrder = 5
  end
  object pnlSearch: TPanel
    Left = 8
    Top = 46
    Width = 329
    Height = 43
    BevelOuter = bvNone
    TabOrder = 27
    object Label10: TLabel
      Left = 14
      Top = 1
      Width = 82
      Height = 13
      Caption = 'Date Added High'
      FocusControl = edtDateAddedHigh
    end
    object Label11: TLabel
      Left = 120
      Top = 1
      Width = 92
      Height = 13
      Caption = 'Date Updated High'
      FocusControl = edtDateUpdatedHigh
    end
    object edtDateAddedHigh: TEdit
      Left = 14
      Top = 17
      Width = 75
      Height = 21
      TabStop = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object edtDateUpdatedHigh: TEdit
      Left = 120
      Top = 17
      Width = 75
      Height = 21
      TabStop = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 128
    Top = 476
    object Parseselectedtextasname1: TMenuItem
      Caption = 'Parse selected text as name'
      ShortCut = 49230
      OnClick = Parseselectedtextasname1Click
    end
    object SelectedTextToBirthDate1: TMenuItem
      Caption = 'Selected text to Birth Date'
      ShortCut = 16450
      OnClick = SelectedTextToBirthDate1Click
    end
    object SelectedtexttoBirthPlace1: TMenuItem
      Caption = 'Selected text to Birth Place'
      ShortCut = 16464
      OnClick = SelectedtexttoBirthPlace1Click
    end
    object SelectedtexttoDeathDate1: TMenuItem
      Caption = 'Selected text to Death Date'
      ShortCut = 16452
      OnClick = SelectedtexttoDeathDate1Click
    end
    object SelectedtexttoDeathPlace1: TMenuItem
      Caption = 'Selected text to Death Place'
      OnClick = SelectedtexttoDeathPlace1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SelectedtexttoBirthDateBirthPlace1: TMenuItem
      Caption = 'Selected text to Birth Date / Place'
      ShortCut = 49218
      OnClick = SelectedtexttoBirthDateBirthPlace1Click
    end
    object SelectedtexttoDeathDatePlace1: TMenuItem
      Caption = 'Selected text to Death Date / Place'
      ShortCut = 49232
      OnClick = SelectedtexttoDeathDatePlace1Click
    end
  end
end
