object frmIndividual: TfrmIndividual
  Left = 398
  Top = 92
  Width = 996
  Height = 842
  Caption = 'Family Tree Individual'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopupMenuForm
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    980
    783)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 9
    Top = 64
    Width = 201
    Height = 209
    PopupMenu = pmPersonName
  end
  object lblPerson: TLabel
    Left = 10
    Top = 43
    Width = 53
    Height = 13
    Caption = 'lblPerson'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = pmPersonName
  end
  object lblName: TLabel
    Left = 453
    Top = 24
    Width = 33
    Height = 13
    Caption = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblBirth: TLabel
    Left = 597
    Top = 24
    Width = 27
    Height = 13
    Caption = 'Birth'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDeath: TLabel
    Left = 673
    Top = 24
    Width = 35
    Height = 13
    Caption = 'Death'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblSpouseName: TLabel
    Left = 453
    Top = 54
    Width = 74
    Height = 13
    Caption = 'lblSpouseName'
  end
  object lblSpouseBirth: TLabel
    Left = 597
    Top = 54
    Width = 67
    Height = 13
    Caption = 'lblSpouseBirth'
  end
  object lblSpouseDeath: TLabel
    Left = 673
    Top = 54
    Width = 75
    Height = 13
    Caption = 'lblSpouseDeath'
  end
  object lblFatherName: TLabel
    Left = 453
    Top = 85
    Width = 68
    Height = 13
    Caption = 'lblFatherName'
  end
  object lblFatherBirth: TLabel
    Left = 597
    Top = 85
    Width = 61
    Height = 13
    Caption = 'lblFatherBirth'
  end
  object lblFatherDeath: TLabel
    Left = 673
    Top = 85
    Width = 69
    Height = 13
    Caption = 'lblFatherDeath'
  end
  object lblMotherName: TLabel
    Left = 453
    Top = 117
    Width = 71
    Height = 13
    Caption = 'lblMotherName'
  end
  object lblMotherBirth: TLabel
    Left = 597
    Top = 117
    Width = 64
    Height = 13
    Caption = 'lblMotherBirth'
  end
  object lblMotherDeath: TLabel
    Left = 673
    Top = 117
    Width = 72
    Height = 13
    Caption = 'lblMotherDeath'
  end
  object Label1: TLabel
    Left = 49
    Top = 357
    Width = 47
    Height = 13
    Caption = 'FirstName'
    FocusControl = dbFirstName
  end
  object Label2: TLabel
    Left = 110
    Top = 357
    Width = 59
    Height = 13
    Caption = 'MiddleName'
    FocusControl = dbMiddleName
  end
  object Label3: TLabel
    Left = 174
    Top = 357
    Width = 48
    Height = 13
    Caption = 'LastName'
    FocusControl = dbLastName
  end
  object Label4: TLabel
    Left = 6
    Top = 439
    Width = 44
    Height = 13
    Caption = 'BirthDate'
    FocusControl = dbBirthDate
  end
  object Label5: TLabel
    Left = 230
    Top = 439
    Width = 52
    Height = 13
    Caption = 'DeathDate'
    FocusControl = dbDeathDate
  end
  object Label6: TLabel
    Left = 329
    Top = 357
    Width = 18
    Height = 13
    Caption = 'Sex'
    FocusControl = dbSex
  end
  object Label7: TLabel
    Left = 6
    Top = 313
    Width = 21
    Height = 13
    Caption = 'AFN'
    FocusControl = dbAFN
  end
  object Label8: TLabel
    Left = 7
    Top = 478
    Width = 50
    Height = 13
    Caption = 'Birth place'
    FocusControl = dbBirthPlace
  end
  object lblSearch: TLabel
    Left = 6
    Top = 397
    Width = 235
    Height = 13
    Caption = 'Search (F2 = set to default and copy to ClipBoard)'
    FocusControl = dbSearch
  end
  object lblNickName: TLabel
    Left = 352
    Top = 357
    Width = 50
    Height = 13
    Caption = 'NickName'
    FocusControl = dbNickName
  end
  object Label11: TLabel
    Left = 6
    Top = 598
    Width = 61
    Height = 13
    Caption = '&2. Comments'
    FocusControl = dbComments
  end
  object lblDoubleClick: TLabel
    Left = 450
    Top = 760
    Width = 212
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Double-click on relation to link to that relation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 112
    Top = 312
    Width = 92
    Height = 13
    Caption = 'External ID Number'
  end
  object Label14: TLabel
    Left = 8
    Top = 520
    Width = 96
    Height = 13
    Caption = 'Document FileName'
  end
  object Label15: TLabel
    Left = 8
    Top = 560
    Width = 105
    Height = 13
    Caption = 'Document Description'
  end
  object Label16: TLabel
    Left = 277
    Top = 357
    Width = 26
    Height = 13
    Caption = 'Suffix'
  end
  object Label17: TLabel
    Left = 159
    Top = 478
    Width = 58
    Height = 13
    Caption = 'Death place'
    FocusControl = dbDeathPlace
  end
  object Label18: TLabel
    Left = 7
    Top = 357
    Width = 26
    Height = 13
    Caption = 'Prefix'
    FocusControl = dbPrefix
  end
  object Label19: TLabel
    Left = 86
    Top = 439
    Width = 52
    Height = 13
    Caption = 'CanonBirth'
    FocusControl = dbCanonBirth
  end
  object lblCanonDeath: TLabel
    Left = 308
    Top = 439
    Width = 60
    Height = 13
    Caption = 'CanonDeath'
    FocusControl = dbCanonDeath
  end
  object dbSource1: TDBText
    Left = 285
    Top = 68
    Width = 65
    Height = 17
    DataField = 'SourceID1'
    DataSource = DataSource1
  end
  object dbSource2: TDBText
    Left = 285
    Top = 100
    Width = 65
    Height = 17
    DataField = 'SourceID2'
    DataSource = DataSource1
  end
  object Label9: TLabel
    Left = 8
    Top = 689
    Width = 31
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Added'
  end
  object Label10: TLabel
    Left = 155
    Top = 689
    Width = 41
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Updated'
  end
  object Label12: TLabel
    Left = 225
    Top = 125
    Width = 17
    Height = 13
    Caption = '&Ref'
    FocusControl = dbRef
  end
  object Label20: TLabel
    Left = 160
    Top = 439
    Width = 50
    Height = 13
    Caption = 'Birth Order'
    FocusControl = dbBirthOrder
  end
  object lblStatus: TLabel
    Left = 925
    Top = 758
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'lblStatus'
  end
  object dbNickName: TDBEdit
    Left = 352
    Top = 373
    Width = 91
    Height = 21
    DataField = 'NickName'
    DataSource = DataSource1
    TabOrder = 7
  end
  object btnSpouse: TButton
    Left = 365
    Top = 48
    Width = 75
    Height = 25
    Caption = '&Spouse'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 26
    TabStop = False
    OnClick = btnSpouseClick
  end
  object btnFather: TButton
    Left = 365
    Top = 80
    Width = 75
    Height = 25
    Caption = '&Father'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 27
    TabStop = False
    OnClick = btnFatherClick
  end
  object btnMother: TButton
    Left = 365
    Top = 112
    Width = 75
    Height = 25
    Caption = '&Mother'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 28
    TabStop = False
    OnClick = btnMotherClick
  end
  object btnLookupSpouse: TButton
    Left = 765
    Top = 48
    Width = 57
    Height = 25
    Caption = 'Lookup'
    TabOrder = 17
    TabStop = False
    OnClick = btnLookupSpouseClick
  end
  object btnLookupFather: TButton
    Left = 765
    Top = 80
    Width = 57
    Height = 25
    Caption = 'Lookup'
    TabOrder = 20
    TabStop = False
    OnClick = btnLookupFatherClick
  end
  object btnLookupMother: TButton
    Left = 765
    Top = 112
    Width = 57
    Height = 25
    Caption = 'Lookup'
    TabOrder = 23
    TabStop = False
    OnClick = btnLookupMotherClick
  end
  object btnLocatePicture: TButton
    Left = 32
    Top = 280
    Width = 113
    Height = 25
    Caption = 'Locate &Picture'
    TabOrder = 29
    TabStop = False
    OnClick = btnLocatePictureClick
  end
  object otRelations: TOvcTable
    Left = 447
    Top = 152
    Width = 504
    Height = 598
    RowLimit = 2
    LockedCols = 0
    LeftCol = 0
    Anchors = [akTop, akRight, akBottom]
    Access = otxReadOnly
    GridPenSet.NormalGrid.NormalColor = clBtnShadow
    GridPenSet.NormalGrid.Style = psDot
    GridPenSet.NormalGrid.Effect = geBoth
    GridPenSet.LockedGrid.NormalColor = clBtnShadow
    GridPenSet.LockedGrid.Style = psSolid
    GridPenSet.LockedGrid.Effect = ge3D
    GridPenSet.CellWhenFocused.NormalColor = clBlack
    GridPenSet.CellWhenFocused.Style = psSolid
    GridPenSet.CellWhenFocused.Effect = geBoth
    GridPenSet.CellWhenUnfocused.NormalColor = clBlack
    GridPenSet.CellWhenUnfocused.Style = psDash
    GridPenSet.CellWhenUnfocused.Effect = geBoth
    LockedRowsCell = OvcTCColHead1
    Options = [otoNoRowResizing, otoNoSelection]
    PopupMenu = puRelations
    ScrollBars = ssVertical
    TabOrder = 31
    TabStop = False
    OnDblClick = otRelationsDblClick
    OnGetCellData = otRelationsGetCellData
    CellData = (
      'frmIndividual.OvcTCColHead1'
      'frmIndividual.OvcTCString1')
    RowData = (
      24
      1
      False
      25)
    ColData = (
      62
      False
      True
      'frmIndividual.OvcTCString1'
      142
      False
      True
      'frmIndividual.OvcTCString1'
      90
      False
      True
      'frmIndividual.OvcTCString1'
      93
      False
      True
      'frmIndividual.OvcTCString1'
      150
      False
      True
      'frmIndividual.OvcTCString1')
  end
  object dbFirstName: TDBEdit
    Left = 49
    Top = 373
    Width = 60
    Height = 21
    DataField = 'FirstName'
    DataSource = DataSource1
    TabOrder = 1
  end
  object dbMiddleName: TDBEdit
    Left = 110
    Top = 373
    Width = 59
    Height = 21
    DataField = 'MiddleName'
    DataSource = DataSource1
    TabOrder = 2
  end
  object dbLastName: TDBEdit
    Left = 174
    Top = 373
    Width = 98
    Height = 21
    DataField = 'LastName'
    DataSource = DataSource1
    TabOrder = 3
  end
  object dbBirthDate: TDBEdit
    Left = 6
    Top = 455
    Width = 75
    Height = 21
    DataField = 'BirthDate'
    DataSource = DataSource1
    ParentShowHint = False
    PopupMenu = puCalendar
    ShowHint = True
    TabOrder = 8
    OnExit = dbBirthDateExit
  end
  object dbDeathDate: TDBEdit
    Left = 230
    Top = 455
    Width = 75
    Height = 21
    DataField = 'DeathDate'
    DataSource = DataSource1
    ParentShowHint = False
    PopupMenu = puCalendar
    ShowHint = True
    TabOrder = 10
    OnExit = dbDeathDateExit
  end
  object dbSex: TDBEdit
    Left = 329
    Top = 373
    Width = 17
    Height = 21
    DataField = 'Sex'
    DataSource = DataSource1
    TabOrder = 5
  end
  object dbAFN: TDBEdit
    Left = 6
    Top = 329
    Width = 95
    Height = 21
    DataField = 'AFN'
    DataSource = DataSource1
    TabOrder = 32
  end
  object DBNavigator1: TDBNavigator
    Left = 6
    Top = 729
    Width = 216
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbPost, nbCancel, nbRefresh]
    Anchors = [akLeft, akBottom]
    TabOrder = 34
  end
  object btnLookup: TButton
    Left = 6
    Top = 758
    Width = 98
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Find Individual'
    TabOrder = 35
    TabStop = False
    OnClick = btnLookupClick
  end
  object btnBack: TBitBtn
    Left = 9
    Top = 12
    Width = 75
    Height = 25
    Caption = '&Back'
    Enabled = False
    TabOrder = 36
    OnClick = btnBackClick
    Glyph.Data = {
      BE000000424DBE00000000000000760000002800000009000000090000000100
      0400000000004800000000000000000000001000000000000000000000008000
      00000080000080800000000080008000800000808000C0C0C00080808000FF00
      000000FF0000FFFF00000000FF00FF00FF0000FFFF00FFFFFF00FFFFF0FFF000
      0000FFFF00FFF0000000FFF000FFF0000000FF0000FFF0000000F00000FFF000
      0000FF0000FFF0000000FFF000FFF0000000FFFF00FFF0000000FFFFF0FFF000
      0000}
  end
  object dbBirthPlace: TDBEdit
    Left = 7
    Top = 494
    Width = 130
    Height = 21
    DataField = 'Birthplace'
    DataSource = DataSource1
    TabOrder = 9
  end
  object dbSearch: TDBEdit
    Left = 6
    Top = 413
    Width = 347
    Height = 21
    DataField = 'Search'
    DataSource = DataSource1
    TabOrder = 6
    OnEnter = dbSearchEnter
    OnKeyUp = dbSearchKeyUp
  end
  object dbComments: TDBMemo
    Left = 6
    Top = 616
    Width = 427
    Height = 70
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataField = 'Comments'
    DataSource = DataSource1
    PopupMenu = PopupMenu1
    ScrollBars = ssVertical
    TabOrder = 14
  end
  object btnBrowseDocument: TButton
    Left = 325
    Top = 534
    Width = 27
    Height = 25
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 33
    OnClick = btnBrowseDocumentClick
  end
  object dbDocFileName: TDBEdit
    Left = 6
    Top = 536
    Width = 305
    Height = 21
    DataField = 'DocFile'
    DataSource = DataSource1
    TabOrder = 12
  end
  object dbDocDescription: TDBEdit
    Left = 6
    Top = 577
    Width = 347
    Height = 21
    DataField = 'DocDescription'
    DataSource = DataSource1
    TabOrder = 13
  end
  object dbDABD: TDBEdit
    Left = 113
    Top = 329
    Width = 95
    Height = 21
    DataField = 'DABDN'
    DataSource = DataSource1
    TabOrder = 37
  end
  object dbSuffix: TDBEdit
    Left = 277
    Top = 373
    Width = 44
    Height = 21
    DataField = 'Suffix'
    DataSource = DataSource1
    TabOrder = 4
  end
  object btnClearSpouse: TButton
    Left = 903
    Top = 48
    Width = 39
    Height = 25
    Caption = 'Clear'
    TabOrder = 19
    TabStop = False
    OnClick = btnClearSpouseClick
  end
  object btnClearFather: TButton
    Left = 903
    Top = 80
    Width = 39
    Height = 25
    Caption = 'Clear'
    TabOrder = 22
    TabStop = False
    OnClick = btnClearFatherClick
  end
  object btnClearMother: TButton
    Left = 903
    Top = 112
    Width = 39
    Height = 25
    Caption = 'Clear'
    TabOrder = 25
    TabStop = False
    OnClick = btnClearMotherClick
  end
  object dbDeathPlace: TDBEdit
    Left = 159
    Top = 494
    Width = 130
    Height = 21
    DataField = 'DeathPlace'
    DataSource = DataSource1
    TabOrder = 11
    OnKeyUp = dbDeathPlaceKeyUp
  end
  object dbPrefix: TDBEdit
    Left = 7
    Top = 373
    Width = 38
    Height = 21
    DataField = 'Prefix'
    DataSource = DataSource1
    TabOrder = 0
  end
  object dbCanonBirth: TDBEdit
    Left = 86
    Top = 455
    Width = 69
    Height = 21
    TabStop = False
    DataField = 'CanonBirth'
    DataSource = DataSource1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 38
  end
  object dbCanonDeath: TDBEdit
    Left = 308
    Top = 455
    Width = 69
    Height = 21
    TabStop = False
    DataField = 'CanonDeath'
    DataSource = DataSource1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 40
  end
  object btnSourceID1: TButton
    Left = 221
    Top = 64
    Width = 60
    Height = 25
    Caption = 'Source 1'
    TabOrder = 41
    OnClick = btnSourceID1Click
  end
  object btnSourceID2: TButton
    Left = 221
    Top = 96
    Width = 60
    Height = 25
    Caption = 'Source 2'
    TabOrder = 42
    OnClick = btnSourceID2Click
  end
  object btnAdvancedSearch: TButton
    Left = 112
    Top = 758
    Width = 98
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Advanced Search'
    TabOrder = 43
    TabStop = False
    OnClick = btnAdvancedSearchClick
  end
  object dbAdded: TDBEdit
    Left = 6
    Top = 704
    Width = 146
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'DateAdded'
    DataSource = DataSource1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    OnExit = dbBirthDateExit
  end
  object DBEdit2: TDBEdit
    Left = 155
    Top = 704
    Width = 146
    Height = 21
    Anchors = [akLeft, akBottom]
    DataField = 'DateUpdated'
    DataSource = DataSource1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
    OnExit = dbBirthDateExit
  end
  object dbRef: TDBEdit
    Left = 225
    Top = 141
    Width = 120
    Height = 21
    DataField = 'Ref'
    DataSource = DataSource1
    TabOrder = 45
  end
  object pnlFiltered: TPanel
    Left = 760
    Top = 8
    Width = 111
    Height = 25
    Caption = 'Filtered'
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 46
    OnClick = pnlFilteredClick
  end
  object btnEditSpouse: TButton
    Left = 830
    Top = 48
    Width = 65
    Height = 25
    Caption = 'Edit/Add'
    TabOrder = 18
    TabStop = False
    OnClick = btnEditSpouseClick
  end
  object btnEditFather: TButton
    Left = 830
    Top = 80
    Width = 65
    Height = 25
    Caption = 'Edit/Add'
    TabOrder = 21
    TabStop = False
    OnClick = btnEditFatherClick
  end
  object btnEditMother: TButton
    Left = 830
    Top = 112
    Width = 65
    Height = 25
    Caption = 'Edit/Add'
    TabOrder = 24
    TabStop = False
    OnClick = btnEditMotherClick
  end
  object dbBirthOrder: TDBEdit
    Left = 160
    Top = 455
    Width = 31
    Height = 21
    TabStop = False
    DataField = 'BirthOrder'
    DataSource = DataSource1
    MaxLength = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 39
  end
  object btnClearPictureRef: TButton
    Left = 160
    Top = 280
    Width = 99
    Height = 25
    Caption = 'Clear Picture Ref'
    TabOrder = 30
    OnClick = btnClearPictureRefClick
  end
  object btnFindNext: TButton
    Left = 309
    Top = 758
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Find Next'
    TabOrder = 44
    OnClick = btnFindNextClick
  end
  object btnFindPrev: TButton
    Left = 221
    Top = 758
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Find Prev'
    TabOrder = 47
    OnClick = btnFindPrevClick
  end
  object ProgressBar1: TProgressBar
    Left = 448
    Top = 756
    Width = 329
    Height = 20
    Anchors = [akRight, akBottom]
    TabOrder = 48
    Visible = False
  end
  object btnEditPhoto: TButton
    Left = 272
    Top = 280
    Width = 99
    Height = 25
    Caption = 'Edit Picture'
    TabOrder = 49
    OnClick = btnEditPhotoClick
  end
  object OvcTCString1: TOvcTCString
    Table = otRelations
    UseASCIIZStrings = True
    Left = 597
    Top = 136
  end
  object OvcTCColHead1: TOvcTCColHead
    Headings.Strings = (
      'Relation'
      'Name'
      'Birth Date'
      'Death Date'
      'Birth Place')
    ShowLetters = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Table = otRelations
    TableFont = False
    Left = 349
    Top = 184
  end
  object RelationCol: TOvcTCString
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    TableFont = False
    UseASCIIZStrings = True
    Left = 381
    Top = 128
  end
  object OpenDialog1: TOpenDialog
    Filter = 'JPEGS (*.jpg)|*.jpg'
    Top = 272
  end
  object OpenDialog2: TOpenDialog
    Left = 336
    Top = 480
  end
  object pmPersonName: TPopupMenu
    Left = 112
    Top = 40
    object CopyTextnoblanks1: TMenuItem
      Caption = 'Copy Text (no-blanks)'
      OnClick = CopyTextnoblanks1Click
    end
    object CopyText1: TMenuItem
      Caption = 'Copy Text'
      OnClick = CopyText1Click
    end
    object EditPhoto1: TMenuItem
      Caption = 'Edit Photo...'
      OnClick = EditPhoto1Click
    end
  end
  object PopupMenuForm: TPopupMenu
    Left = 304
    Top = 176
    object Changedatafilelocations2: TMenuItem
      Caption = 'Change data file locations...'
      OnClick = Changedatafilelocations2Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AboutFamilyTree1: TMenuItem
      Caption = 'About FamilyTree...'
      OnClick = AboutFamilyTree1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 16
    object File1: TMenuItem
      Caption = '&File'
      object N2: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = 'Print'
        OnClick = Print1Click
      end
      object ViewLastLogFileTxt1: TMenuItem
        Caption = 'View last LogFile.Txt'
        OnClick = ViewLastLogFileTxt1Click
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Navigate1: TMenuItem
      Caption = 'Navigate'
      object First1: TMenuItem
        Caption = 'First'
        ShortCut = 16420
        OnClick = First1Click
      end
      object Prev1: TMenuItem
        Caption = 'Prev'
        ShortCut = 33
        OnClick = Prev1Click
      end
      object Next1: TMenuItem
        Caption = 'Next'
        ShortCut = 34
        OnClick = Next1Click
      end
      object Last1: TMenuItem
        Caption = 'Last'
        ShortCut = 16419
        OnClick = Last1Click
      end
      object Post1: TMenuItem
        Caption = 'Post'
        ShortCut = 16467
        OnClick = Post1Click
      end
      object AddRecord1: TMenuItem
        Caption = 'New Record'
        ShortCut = 16462
        OnClick = AddRecord1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object AddMaleChild2: TMenuItem
        Caption = 'Add Male Child...'
        ShortCut = 49229
        OnClick = AddMaleChild2Click
      end
      object AddFemaleChild2: TMenuItem
        Caption = 'Add Female Child...'
        ShortCut = 49222
        OnClick = AddFemaleChild2Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object fIfIND1: TMenuItem
        Caption = 'Find...'
        ShortCut = 16454
        OnClick = btnLookupClick
      end
      object AdvancedFind1: TMenuItem
        Caption = 'Advanced Find...'
        OnClick = btnAdvancedSearchClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object SetFilter1: TMenuItem
        Caption = 'Set Filter...'
        OnClick = SetFilter1Click
      end
      object ClearFilter1: TMenuItem
        Caption = 'Clear Filter'
        OnClick = ClearFilter1Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object SetOrder1: TMenuItem
        Caption = 'Set Order'
        object LastFirstMiddle1: TMenuItem
          Caption = 'LastName; FirstName; MiddleName'
          RadioItem = True
          OnClick = LastFirstMiddle1Click
        end
        object CanonBirth1: TMenuItem
          Caption = 'CanonBirth'
          RadioItem = True
          OnClick = CanonBirth1Click
        end
        object AFN1: TMenuItem
          Caption = 'AFN'
          RadioItem = True
          OnClick = AFN1Click
        end
        object DateAdded1: TMenuItem
          Caption = 'Date Added'
          RadioItem = True
          OnClick = DateAdded1Click
        end
        object DateUpdated1: TMenuItem
          Caption = 'Date Updated'
          RadioItem = True
          OnClick = DateUpdated1Click
        end
      end
    end
    object Individual1: TMenuItem
      Caption = 'Individual'
      object SetbirthplaceforallChildren1: TMenuItem
        Caption = 'Set birthplace for all children...'
        OnClick = SetbirthplaceforallChildren1Click
      end
      object SetSourcesForAllChildren1: TMenuItem
        Caption = 'Set sources for all children to parent sources'
        OnClick = SetSourcesForAllChildren1Click
      end
      object SetParentsOfAllChildrenToCurrent1: TMenuItem
        Caption = 'Set parents of all children to current...'
        OnClick = SetParentsOfAllChildrenToCurrent1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object AddDABD1: TMenuItem
        Caption = 'Add DABD...'
        ShortCut = 49220
        OnClick = AddInfoFromDABDClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object Refresh1: TMenuItem
        Caption = 'Refresh'
        ShortCut = 116
        OnClick = Refresh1Click
      end
    end
    object Utilities1: TMenuItem
      Caption = 'Utilities'
      object UpdateCanonicalDates1: TMenuItem
        Caption = 'Update Canonical Dates'
        OnClick = UpdateCanonicalDates1Click
      end
      object SCanCanonicalDatesforErrors1: TMenuItem
        Caption = 'Scan Selected Records for Errors'
        OnClick = SCanCanonicalDatesforErrors1Click
      end
      object ReScanforHighestKey1: TMenuItem
        Caption = 'Re-Scan for Highest Key'
        OnClick = ReScanforHighestKey1Click
      end
      object ScanForSimilarRecords1: TMenuItem
        Caption = 'Scan for Similar Records'
        OnClick = ScanForSimilarRecords1Click
      end
      object ChangeAFNsForSelectedRecords1: TMenuItem
        Caption = 'Change AFNs for Selected Records...'
        OnClick = ChangeAFNsForSelectedRecords1Click
      end
      object FixDeathDateFormatforSelectedRecords1: TMenuItem
        Caption = 'Fix Death Date Format for Selected Records'
        Visible = False
        OnClick = FixDeathDateFormatforSelectedRecords1Click
      end
      object NormalizeDABDAFNs1: TMenuItem
        Caption = 'Normalize DABD AFNs'
        Visible = False
        OnClick = NormalizeDABDAFNs1Click
      end
      object ScanforMissingRelations1: TMenuItem
        Caption = 'Scan for Missing Relations'
        OnClick = ScanforMissingRelations1Click
      end
      object GenerateHTMLforSelectedRecords1: TMenuItem
        Caption = 'Generate HTML for Selected Records...'
        OnClick = GenerateHTMLforSelectedRecords1Click
      end
      object EnlargeAFNs1: TMenuItem
        Caption = 'Enlarge AFN #'#39's'
        OnClick = EnlargeAFNs1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object ReCalcNextAFN1: TMenuItem
        Caption = 'Re-Calc NextAFN'
        OnClick = ReCalcNextAFN1Click
      end
      object CountSelectedRecords1: TMenuItem
        Caption = 'Count Selected Records'
        OnClick = CountSelectedRecords1Click
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object CalendarArithmetic1: TMenuItem
        Caption = 'Calendar Arithmetic'
        OnClick = CalendarArithmetic1Click
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object Options1: TMenuItem
        Caption = 'Options...'
        OnClick = Options1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object ShowShortcuts1: TMenuItem
        Caption = 'Show Shortcuts'
        OnClick = ShowShortcuts1Click
      end
      object AboutFamilyTree2: TMenuItem
        Caption = 'About FamilyTree..'
        OnClick = AboutFamilyTree2Click
      end
    end
  end
  object DataSource1: TDataSource
    Left = 416
    Top = 232
  end
  object puRelations: TPopupMenu
    Left = 496
    Top = 344
    object Addmalechild1: TMenuItem
      Caption = 'Add male child...'
      ShortCut = 49229
      OnClick = Addmalechild1Click
    end
    object Addfemalechild1: TMenuItem
      Caption = 'Add female child...'
      ShortCut = 49222
      OnClick = Addfemalechild1Click
    end
    object AddUnknownChild1: TMenuItem
      Caption = 'Add unknown Child...'
      ShortCut = 49237
      OnClick = AddUnknownChild1Click
    end
    object AddInfoFromDABD: TMenuItem
      Caption = 'Add Info from DABD...'
      ShortCut = 49220
      OnClick = AddInfoFromDABDClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 632
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
    object MenuItem1: TMenuItem
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
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object InsertParentsString1: TMenuItem
      Caption = 'Insert Parent'#39's String'
      ShortCut = 49232
      OnClick = InsertParentsString1Click
    end
    object CleanUpComments1: TMenuItem
      Caption = 'Clean Up Comments'
      ShortCut = 49219
      OnClick = CleanUpComments1Click
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object CreateSpousefromSelectedText1: TMenuItem
      Caption = 'Create Spouse from Selected Text'
      ShortCut = 49235
      OnClick = CreateSpousefromSelectedText1Click
    end
  end
  object puCalendar: TPopupMenu
    Left = 40
    Top = 464
    object CalendarArithmetic2: TMenuItem
      Caption = 'BirthDate Calendar Arithmetic'
      OnClick = CalendarArithmetic2Click
    end
    object DeathDateCalendarArithmetic1: TMenuItem
      Caption = 'DeathDate Calendar Arithmetic'
      OnClick = DeathDateCalendarArithmetic1Click
    end
  end
end
