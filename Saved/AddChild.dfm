object frmAddChild: TfrmAddChild
  Left = 904
  Top = 416
  Width = 479
  Height = 285
  Caption = 'Add child'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 57
    Top = 21
    Width = 47
    Height = 13
    Caption = 'FirstName'
    FocusControl = dbFirstName
  end
  object Label2: TLabel
    Left = 118
    Top = 21
    Width = 59
    Height = 13
    Caption = 'MiddleName'
    FocusControl = dbMiddleName
  end
  object Label3: TLabel
    Left = 182
    Top = 21
    Width = 48
    Height = 13
    Caption = 'LastName'
    FocusControl = dbLastName
  end
  object Label4: TLabel
    Left = 14
    Top = 103
    Width = 44
    Height = 13
    Caption = 'BirthDate'
    FocusControl = dbBirthDate
  end
  object Label5: TLabel
    Left = 167
    Top = 103
    Width = 52
    Height = 13
    Caption = 'DeathDate'
    FocusControl = dbDeathDate
  end
  object Label6: TLabel
    Left = 337
    Top = 21
    Width = 18
    Height = 13
    Caption = 'Sex'
    FocusControl = dbSex
  end
  object Label8: TLabel
    Left = 15
    Top = 142
    Width = 50
    Height = 13
    Caption = 'Birth place'
    FocusControl = dbBirthPlace
  end
  object Label9: TLabel
    Left = 14
    Top = 61
    Width = 235
    Height = 13
    Caption = '&Search (F2 = set to default and copy to ClipBoard)'
    FocusControl = dbSearch
  end
  object Label16: TLabel
    Left = 285
    Top = 21
    Width = 26
    Height = 13
    Caption = 'Suffix'
  end
  object Label17: TLabel
    Left = 167
    Top = 142
    Width = 58
    Height = 13
    Caption = 'Death place'
    FocusControl = dbDeathPlace
  end
  object Label18: TLabel
    Left = 15
    Top = 21
    Width = 26
    Height = 13
    Caption = 'Prefix'
    FocusControl = DBEdit1
  end
  object Label19: TLabel
    Left = 94
    Top = 103
    Width = 52
    Height = 13
    Caption = 'CanonBirth'
    FocusControl = dbCanonBirth
  end
  object lblCanonDeath: TLabel
    Left = 245
    Top = 103
    Width = 60
    Height = 13
    Caption = 'CanonDeath'
    FocusControl = dbCanonDeath
  end
  object dbFirstName: TDBEdit
    Left = 57
    Top = 37
    Width = 60
    Height = 21
    DataField = 'FirstName'
    TabOrder = 0
  end
  object dbMiddleName: TDBEdit
    Left = 118
    Top = 37
    Width = 59
    Height = 21
    DataField = 'MiddleName'
    TabOrder = 1
  end
  object dbLastName: TDBEdit
    Left = 182
    Top = 37
    Width = 98
    Height = 21
    DataField = 'LastName'
    TabOrder = 2
  end
  object dbBirthDate: TDBEdit
    Left = 14
    Top = 119
    Width = 75
    Height = 21
    DataField = 'BirthDate'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object dbDeathDate: TDBEdit
    Left = 167
    Top = 119
    Width = 75
    Height = 21
    DataField = 'DeathDate'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object dbSex: TDBEdit
    Left = 337
    Top = 37
    Width = 17
    Height = 21
    DataField = 'Sex'
    TabOrder = 5
  end
  object dbBirthPlace: TDBEdit
    Left = 15
    Top = 158
    Width = 130
    Height = 21
    DataField = 'Birthplace'
    TabOrder = 6
  end
  object dbSearch: TDBEdit
    Left = 14
    Top = 77
    Width = 347
    Height = 21
    DataField = 'Search'
    TabOrder = 7
  end
  object dbSuffix: TDBEdit
    Left = 285
    Top = 37
    Width = 44
    Height = 21
    DataField = 'Suffix'
    TabOrder = 8
  end
  object dbDeathPlace: TDBEdit
    Left = 167
    Top = 158
    Width = 130
    Height = 21
    DataField = 'DeathPlace'
    TabOrder = 9
  end
  object DBEdit1: TDBEdit
    Left = 15
    Top = 37
    Width = 32
    Height = 21
    DataField = 'Prefix'
    TabOrder = 10
  end
  object dbCanonBirth: TDBEdit
    Left = 94
    Top = 119
    Width = 69
    Height = 21
    TabStop = False
    DataField = 'CanonBirth'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
  end
  object dbCanonDeath: TDBEdit
    Left = 245
    Top = 119
    Width = 69
    Height = 21
    TabStop = False
    DataField = 'CanonDeath'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
  end
  object btnCancel: TButton
    Left = 368
    Top = 208
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 13
  end
  object btnOK: TButton
    Left = 280
    Top = 208
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 14
  end
end
