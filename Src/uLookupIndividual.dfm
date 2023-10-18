object frmLookupIndividual: TfrmLookupIndividual
  Left = 344
  Top = 205
  Width = 1224
  Height = 529
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Lookup Individual'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    1208
    471)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 19
    Top = 16
    Width = 21
    Height = 13
    Caption = '&AFN'
    FocusControl = edtAFN
  end
  object Label2: TLabel
    Left = 126
    Top = 16
    Width = 47
    Height = 13
    Caption = '&FirstName'
  end
  object Label3: TLabel
    Left = 400
    Top = 16
    Width = 48
    Height = 13
    Caption = '&LastName'
  end
  object Label4: TLabel
    Left = 257
    Top = 16
    Width = 59
    Height = 13
    Caption = '&MiddleName'
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 48
    Width = 1188
    Height = 389
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'AFN'
        Width = 103
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Prefix'
        Width = 37
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FirstName'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MiddleName'
        Width = 79
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LastName'
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Suffix'
        Width = 32
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BirthDate'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CanonBirth'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BirthPlace'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DeathDate'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CanonDeath'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DeathPlace'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Sex'
        Width = 26
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Comments'
        Width = 198
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DateUpdated'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DateAdded'
        Visible = True
      end>
  end
  object btnOk: TBitBtn
    Left = 1023
    Top = 445
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    TabOrder = 4
    OnClick = btnOkClick
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 1115
    Top = 445
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    TabOrder = 5
    Kind = bkCancel
  end
  object edtAFN: TEdit
    Left = 48
    Top = 12
    Width = 70
    Height = 21
    TabOrder = 6
    OnChange = edtAFNChange
  end
  object edtFirstName: TEdit
    Left = 180
    Top = 12
    Width = 70
    Height = 21
    TabOrder = 0
    OnChange = edtFirstNameChange
  end
  object edtLastName: TEdit
    Left = 453
    Top = 12
    Width = 70
    Height = 21
    TabOrder = 2
    OnChange = edtLastNameChange
  end
  object DBNavigator1: TDBNavigator
    Left = 96
    Top = 445
    Width = 240
    Height = 25
    Anchors = [akLeft, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
  end
  object edtMiddleName: TEdit
    Left = 322
    Top = 12
    Width = 70
    Height = 21
    TabOrder = 1
    OnChange = edtMiddleNameChange
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 65528
    object NAvigate1: TMenuItem
      Caption = 'Navigate'
      object First1: TMenuItem
        Caption = 'First'
        ShortCut = 16420
        OnClick = First1Click
      end
      object Last1: TMenuItem
        Caption = 'Last'
        ShortCut = 16419
        OnClick = Last1Click
      end
      object Next1: TMenuItem
        Caption = 'Next'
        ShortCut = 34
        OnClick = Next1Click
      end
      object Previous1: TMenuItem
        Caption = 'Previous'
        ShortCut = 33
        OnClick = Previous1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Add1: TMenuItem
        Caption = 'Add'
        ShortCut = 16462
        OnClick = Add1Click
      end
      object Post1: TMenuItem
        Caption = 'Post'
        ShortCut = 16464
        OnClick = Post1Click
      end
      object N2: TMenuItem
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
      object N3: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        ShortCut = 49240
        OnClick = Close1Click
      end
    end
    object Order1: TMenuItem
      Caption = 'Order'
      object CanonicalBirthdate1: TMenuItem
        Caption = 'Canonical Birthdate'
        OnClick = CanonicalBirthdate1Click
      end
      object LastNameFirstName1: TMenuItem
        Caption = 'LastName,  FirstName'
        OnClick = LastNameFirstName1Click
      end
      object AFN1: TMenuItem
        Caption = 'AFN'
        OnClick = AFN1Click
      end
      object LastNameCanonBirthFirstName1: TMenuItem
        Caption = 'LastName,CanonBirth,FirstName'
        OnClick = LastNameCanonBirthFirstName1Click
      end
      object DateAdded1: TMenuItem
        Caption = 'Date Added'
        OnClick = DateAdded1Click
      end
      object DateUpdated1: TMenuItem
        Caption = 'Date Updated'
        OnClick = DateUpdated1Click
      end
    end
  end
end
