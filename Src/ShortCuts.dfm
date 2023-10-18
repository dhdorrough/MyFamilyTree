object frmShortcuts: TfrmShortcuts
  Left = 694
  Top = 278
  Width = 312
  Height = 289
  Caption = 'Shortcuts'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    296
    251)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 24
    Top = 16
    Width = 251
    Height = 191
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '<Alt>+F:        Find'
      '<Alt>+I:        Individual'
      '<Alt>+N:        Navigate'
      '<Alt>+P:        Load Picture'
      '<Alt>+S:        Search'
      '<Alt>+U:        Utilities'
      '<ctrl>+<Home>:  First Record'
      '<PgUp>:         Previous record'
      '<PgDn>:         Next record'
      '<Ctrl>+<End>:   Last record'
      '<Ctrl>+<Alt>+M: Add male child'
      '<Ctrl>+<Alt>+F: Add female child'
      '<Ctrl>+F:       Find'
      '')
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 208
    Top = 220
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Ok'
    Default = True
    ModalResult = 2
    TabOrder = 1
    OnClick = Button1Click
  end
end
