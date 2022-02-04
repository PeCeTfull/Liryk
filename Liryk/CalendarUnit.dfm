object frmCalendar: TfrmCalendar
  Left = 192
  Top = 107
  BorderStyle = bsToolWindow
  Caption = 'Ustaw dat'#281
  ClientHeight = 168
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelectedDate: TLabel
    Left = 8
    Top = 8
    Width = 91
    Height = 13
    Caption = '<wybrana data>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cldDate: TCalendar
    Left = 8
    Top = 32
    Width = 320
    Height = 120
    StartOfWeek = 0
    TabOrder = 0
    UseCurrentDate = False
    OnChange = cldDateChange
  end
  object btnOK: TButton
    Left = 336
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = btnOKClick
  end
  object btnPrevMonth: TButton
    Left = 336
    Top = 8
    Width = 75
    Height = 25
    Caption = '< Miesi'#261'c'
    TabOrder = 1
    OnClick = btnPrevMonthClick
  end
  object btnNextMonth: TButton
    Left = 336
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Miesi'#261'c >'
    TabOrder = 2
    OnClick = btnNextMonthClick
  end
  object btnPrevYear: TButton
    Left = 336
    Top = 72
    Width = 75
    Height = 25
    Caption = '< Rok'
    TabOrder = 3
    OnClick = btnPrevYearClick
  end
  object btnNextYear: TButton
    Left = 336
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Rok >'
    TabOrder = 4
    OnClick = btnNextYearClick
  end
end
