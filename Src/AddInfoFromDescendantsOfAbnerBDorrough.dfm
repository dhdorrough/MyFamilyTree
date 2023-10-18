object frmAddInfoFromDescendantsOfAbnerBDorrough: TfrmAddInfoFromDescendantsOfAbnerBDorrough
  Left = 718
  Top = 261
  Width = 882
  Height = 551
  Caption = 'Add Info from Descendants of Abner B Dorrough'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    866
    513)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 320
    Width = 61
    Height = 13
    Caption = '&2. Comments'
    FocusControl = mmoComments
  end
  object Label2: TLabel
    Left = 90
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Father'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 464
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Mother'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 573
    Top = 96
    Width = 43
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Spouse'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblStatus: TLabel
    Left = 96
    Top = 480
    Width = 569
    Height = 33
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'lblStatus'
    Color = clBtnFace
    ParentColor = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 16
    Top = 96
    Width = 35
    Height = 13
    Caption = '&1. Main'
    FocusControl = Memo1
  end
  object Memo1: TMemo
    Left = 13
    Top = 117
    Width = 500
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    PopupMenu = PopupMenu2
    TabOrder = 0
    OnChange = Memo1Change
    OnKeyUp = Memo1KeyUp
  end
  object btnCancel: TButton
    Left = 776
    Top = 480
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
    TabStop = False
    OnClick = btnCancelClick
  end
  object leAFN: TLabeledEdit
    Left = 18
    Top = 256
    Width = 74
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 21
    EditLabel.Height = 13
    EditLabel.Caption = 'AFN'
    PopupMenu = PopupMenu3
    TabOrder = 2
  end
  object leSex: TLabeledEdit
    Left = 110
    Top = 256
    Width = 33
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 18
    EditLabel.Height = 13
    EditLabel.Caption = 'Sex'
    TabOrder = 3
    OnChange = leSexChange
  end
  object leBirthOrder: TLabeledEdit
    Left = 160
    Top = 256
    Width = 41
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = 'Birth Order'
    TabOrder = 4
  end
  object leBirthDate: TLabeledEdit
    Left = 245
    Top = 256
    Width = 97
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = '&Birth Date'
    TabOrder = 5
  end
  object leDeathDate: TLabeledEdit
    Left = 554
    Top = 256
    Width = 97
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 55
    EditLabel.Height = 13
    EditLabel.Caption = '&Death Date'
    TabOrder = 7
  end
  object leBirthPlace: TLabeledEdit
    Left = 356
    Top = 256
    Width = 185
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Birth Place'
    TabOrder = 6
  end
  object leDeathPlace: TLabeledEdit
    Left = 665
    Top = 256
    Width = 185
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 59
    EditLabel.Height = 13
    EditLabel.Caption = 'Death Place'
    TabOrder = 8
  end
  object lePersonName: TLabeledEdit
    Left = 18
    Top = 296
    Width = 201
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 64
    EditLabel.Height = 13
    EditLabel.Caption = 'Person Name'
    TabOrder = 9
    OnExit = lePersonNameExit
  end
  object btnParse: TButton
    Left = 774
    Top = 21
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Parse'
    TabOrder = 17
    TabStop = False
    OnClick = btnParseClick
  end
  object btnClear: TButton
    Left = 16
    Top = 480
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Clear'
    TabOrder = 18
    TabStop = False
    OnClick = btnClearClick
  end
  object cbMoreToCome: TCheckBox
    Left = 738
    Top = 298
    Width = 111
    Height = 17
    Anchors = [akTop]
    Caption = 'More To Come'
    TabOrder = 19
  end
  object mmoComments: TMemo
    Left = 16
    Top = 337
    Width = 839
    Height = 134
    Anchors = [akLeft, akTop, akRight, akBottom]
    PopupMenu = PopupMenu1
    ScrollBars = ssVertical
    TabOrder = 16
  end
  object leFirstName: TLabeledEdit
    Left = 296
    Top = 296
    Width = 89
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = '&First Name'
    TabOrder = 11
    OnChange = leFirstNameChange
  end
  object leMiddleName: TLabeledEdit
    Left = 397
    Top = 296
    Width = 61
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 62
    EditLabel.Height = 13
    EditLabel.Caption = 'Middle Name'
    TabOrder = 12
  end
  object leLastName: TLabeledEdit
    Left = 467
    Top = 296
    Width = 121
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'Last Name'
    TabOrder = 13
    OnChange = leLastNameChange
  end
  object mmoFather: TMemo
    Left = 87
    Top = 24
    Width = 262
    Height = 65
    BevelInner = bvNone
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 20
  end
  object btnLoadFather: TButton
    Left = 4
    Top = 24
    Width = 75
    Height = 18
    Caption = '&Load Father'
    TabOrder = 21
    TabStop = False
    WordWrap = True
    OnClick = btnLoadFatherClick
  end
  object mmoMother: TMemo
    Left = 464
    Top = 24
    Width = 262
    Height = 65
    BevelInner = bvNone
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 22
  end
  object btnLoadMother: TButton
    Left = 384
    Top = 24
    Width = 75
    Height = 17
    Caption = 'Load &Mother'
    TabOrder = 23
    TabStop = False
    WordWrap = True
    OnClick = btnLoadMotherClick
  end
  object mmoSpouse: TMemo
    Left = 573
    Top = 112
    Width = 273
    Height = 104
    Anchors = [akTop, akRight]
    BevelInner = bvNone
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 24
  end
  object btnLoadSpouse: TButton
    Left = 518
    Top = 114
    Width = 52
    Height = 31
    Anchors = [akTop, akRight]
    Caption = 'Load &Spouse'
    TabOrder = 25
    TabStop = False
    WordWrap = True
    OnClick = btnLoadSpouseClick
  end
  object btnAddAsChild: TButton
    Left = 668
    Top = 480
    Width = 100
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Add As Child'
    Enabled = False
    TabOrder = 26
    TabStop = False
    OnClick = btnAddAsChildClick
  end
  object leNickName: TLabeledEdit
    Left = 670
    Top = 296
    Width = 61
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 53
    EditLabel.Height = 13
    EditLabel.Caption = 'Nick Name'
    TabOrder = 15
  end
  object btnClearSpouse: TButton
    Left = 518
    Top = 148
    Width = 52
    Height = 31
    Anchors = [akTop, akRight]
    Caption = 'Clear Spouse'
    TabOrder = 27
    TabStop = False
    WordWrap = True
    OnClick = btnClearSpouseClick
  end
  object btnClearFather: TButton
    Left = 4
    Top = 47
    Width = 75
    Height = 18
    Caption = 'Clear Father'
    TabOrder = 28
    TabStop = False
    WordWrap = True
    OnClick = btnClearFatherClick
  end
  object btnClearMother: TButton
    Left = 384
    Top = 47
    Width = 75
    Height = 17
    Caption = 'Clear Mother'
    TabOrder = 29
    TabStop = False
    WordWrap = True
    OnClick = btnClearMotherClick
  end
  object btnEditFather: TButton
    Left = 4
    Top = 70
    Width = 75
    Height = 18
    Caption = 'Edit Father'
    TabOrder = 30
    TabStop = False
    WordWrap = True
    OnClick = btnEditFatherClick
  end
  object btnEditMother: TButton
    Left = 384
    Top = 70
    Width = 75
    Height = 18
    Caption = 'Edit Mother'
    TabOrder = 31
    TabStop = False
    WordWrap = True
    OnClick = btnEditMotherClick
  end
  object btnEditSpouse: TButton
    Left = 518
    Top = 182
    Width = 52
    Height = 31
    Anchors = [akTop, akRight]
    Caption = 'Edit Spouse'
    TabOrder = 32
    TabStop = False
    WordWrap = True
    OnClick = btnEditSpouseClick
  end
  object leSuffix: TLabeledEdit
    Left = 595
    Top = 296
    Width = 42
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = 'Suffix'
    TabOrder = 14
    OnChange = leSuffixChange
  end
  object lePrefix: TLabeledEdit
    Left = 243
    Top = 296
    Width = 42
    Height = 21
    Anchors = [akTop]
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = 'Prefix'
    TabOrder = 10
    OnChange = leSuffixChange
  end
  object PopupMenu1: TPopupMenu
    Left = 128
    Top = 440
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
      OnClick = SelectedtexttoDeathDatePlace1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ParseSelectedtext1: TMenuItem
      Caption = 'Parse Comments text'
      OnClick = ParseSelectedtext1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object InsertParentsString1: TMenuItem
      Caption = 'Insert Parent'#39's String'
      ShortCut = 49232
      OnClick = InsertParentsString1Click
    end
    object DeleteFirstSentenceinComments1: TMenuItem
      Caption = 'Clean up comments'
      ShortCut = 49219
      OnClick = DeleteFirstSentenceinComments1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 120
    Top = 168
    object miParseSelectedTextAsName0: TMenuItem
      Caption = 'Parse selected text as name'
      ShortCut = 49230
      OnClick = miParseSelectedTextAsName0Click
    end
    object miSelectedTextToBirthDate0: TMenuItem
      Caption = 'Selected text to Birth Date'
      ShortCut = 16450
      OnClick = miSelectedTextToBirthDate0Click
    end
    object miSelectedTextToBirthPlace0: TMenuItem
      Caption = 'Selected text to Birth Place'
      ShortCut = 16464
      OnClick = miSelectedTextToBirthPlace0Click
    end
    object miSelectedTextToDeathDate0: TMenuItem
      Caption = 'Selected text to Death Date'
      ShortCut = 16452
      OnClick = miSelectedTextToDeathDate0Click
    end
    object miSelectedTextToDeathPlace: TMenuItem
      Caption = 'Selected text to Death Place'
      OnClick = miSelectedTextToDeathPlaceClick
    end
    object MenuItem6: TMenuItem
      Caption = '-'
    end
    object miSelectedTextToBirthDatePlace: TMenuItem
      Caption = 'Selected text to Birth Date / Place'
      ShortCut = 49218
      OnClick = miSelectedTextToBirthDatePlaceClick
    end
    object miSelectedTextToDeathPlaceDate: TMenuItem
      Caption = 'Selected text to Death Date / Place'
      OnClick = miSelectedTextToDeathPlaceDateClick
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 72
    Top = 240
    object AutoFillDABD1: TMenuItem
      Caption = 'Auto-Fill DABD'
      OnClick = AutoFillDABD1Click
    end
  end
end
