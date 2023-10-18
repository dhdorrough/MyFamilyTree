object frmGetPrivateSettingsFromUser: TfrmGetPrivateSettingsFromUser
  Left = 1023
  Top = 422
  Width = 629
  Height = 412
  Caption = 'FamilyTree Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    613
    373)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 176
    Height = 13
    Caption = 'Get Private Settings From User'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblStatus: TLabel
    Left = 552
    Top = 312
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'lblStatus'
    Color = clYellow
    ParentColor = False
  end
  object btnCancel: TButton
    Left = 520
    Top = 338
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 432
    Top = 338
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object leDatabaseName: TLabeledEdit
    Left = 16
    Top = 56
    Width = 521
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'Database'
    TabOrder = 2
    OnChange = leDatabaseNameChange
  end
  object leDataFolder: TLabeledEdit
    Left = 16
    Top = 104
    Width = 521
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 189
    EditLabel.Height = 13
    EditLabel.Caption = 'Folder containing "Images\" and"Docs\'
    TabOrder = 3
    OnChange = leDataFolderChange
  end
  object btnBrowseForACCDB: TButton
    Left = 544
    Top = 56
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    TabOrder = 5
    OnClick = btnBrowseForACCDBClick
  end
  object btnBrowseForDataFolder: TButton
    Left = 544
    Top = 104
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    TabOrder = 6
    OnClick = btnBrowseForDataFolderClick
  end
  object leNextAFN: TLabeledEdit
    Left = 16
    Top = 194
    Width = 121
    Height = 21
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'NextAFN'
    TabOrder = 7
  end
  object leLastAFN: TLabeledEdit
    Left = 160
    Top = 194
    Width = 121
    Height = 21
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'LastAFN'
    TabOrder = 8
  end
  object leLastOrderFields: TLabeledEdit
    Left = 288
    Top = 194
    Width = 121
    Height = 21
    EditLabel.Width = 73
    EditLabel.Height = 13
    EditLabel.Caption = 'LastOrderFields'
    TabOrder = 9
  end
  object leFakeDABDNr: TLabeledEdit
    Left = 416
    Top = 194
    Width = 121
    Height = 21
    EditLabel.Width = 65
    EditLabel.Height = 13
    EditLabel.Caption = 'FakeDABDNr'
    TabOrder = 10
  end
  object leHTMLOutputFolder: TLabeledEdit
    Left = 16
    Top = 145
    Width = 521
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 94
    EditLabel.Height = 13
    EditLabel.Caption = 'HTML Output folder'
    TabOrder = 4
    OnChange = leHTMLOutputFolderChange
  end
  object btnBrowseHTMLOutputFolder: TButton
    Left = 544
    Top = 145
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    TabOrder = 12
    OnClick = btnBrowseHTMLOutputFolderClick
  end
  object lePhotoEditorPathName: TLabeledEdit
    Left = 16
    Top = 241
    Width = 521
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 58
    EditLabel.Height = 13
    EditLabel.Caption = 'Photo Editor'
    TabOrder = 11
    OnChange = leHTMLOutputFolderChange
  end
  object btnBrowseForEditor: TButton
    Left = 544
    Top = 240
    Width = 57
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Browse'
    TabOrder = 13
    OnClick = btnBrowseForEditorClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.mdb'
    FileName = 'PhotoDB.mdb'
    Filter = 'Photo Database (*.mdb)|*.mdb'
    Left = 584
    Top = 40
  end
end
