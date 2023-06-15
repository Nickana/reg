object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Weight registrator'
  ClientHeight = 400
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = -8
    Top = -8
    Width = 1002
    Height = 531
    BorderStyle = bsSingle
    Color = 4473924
    ParentBackground = False
    TabOrder = 7
  end
  object read_data_button: TButton
    Left = 25
    Top = 144
    Width = 392
    Height = 31
    Caption = #1057#1095#1080#1090#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089' '#1074#1077#1089#1086#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = read_data_buttonClick
  end
  object Connect_button: TButton
    Left = 41
    Top = 84
    Width = 361
    Height = 54
    Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Connect_buttonClick
  end
  object Memo1: TMemo
    Left = 831
    Top = 37
    Width = 146
    Height = 288
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object array_read_button: TButton
    Left = 831
    Top = 340
    Width = 146
    Height = 25
    Caption = #1057#1095#1080#1090#1072#1090#1100' '#1084#1072#1089#1089#1080#1074
    TabOrder = 3
    OnClick = array_read_buttonClick
  end
  object XML_button: TButton
    Left = 25
    Top = 189
    Width = 392
    Height = 41
    Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1074#1077#1089#1086#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = XML_buttonClick
  end
  object ClearMemory_button: TButton
    Left = 25
    Top = 279
    Width = 200
    Height = 61
    Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1084#1077#1085#1091
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = ClearMemory_buttonClick
  end
  object set_date_button: TButton
    Left = 25
    Top = 236
    Width = 392
    Height = 37
    Caption = #1047#1072#1076#1072#1090#1100' '#1076#1072#1090#1091' '#1080' '#1074#1088#1077#1084#1103' '#1089' '#1055#1050
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = set_date_buttonClick
  end
  object disconect_button: TButton
    Left = 231
    Top = 279
    Width = 186
    Height = 61
    Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100#1089#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = disconect_buttonClick
  end
  object Panel2: TPanel
    Left = 25
    Top = 26
    Width = 392
    Height = 41
    BevelInner = bvLowered
    BevelKind = bkFlat
    BevelOuter = bvLowered
    Color = 11258579
    ParentBackground = False
    TabOrder = 9
    object text_label: TLabel
      Left = 2
      Top = 2
      Width = 384
      Height = 33
      Align = alClient
      Alignment = taCenter
      Color = 11258579
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      GlowSize = 30
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      Transparent = True
      ExplicitWidth = 68
      ExplicitHeight = 93
    end
  end
  object read_progress_bar: TProgressBar
    Left = 25
    Top = 172
    Width = 392
    Height = 11
    ParentShowHint = False
    Smooth = True
    MarqueeInterval = 1
    BarColor = 2731774
    SmoothReverse = True
    Step = 1
    ShowHint = True
    TabOrder = 10
  end
  object drop_cycle_button: TButton
    Left = 25
    Top = 362
    Width = 392
    Height = 19
    Caption = #1057#1073#1088#1086#1089' '#1094#1080#1082#1083#1072' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
    TabOrder = 11
    OnClick = drop_cycle_buttonClick
  end
  object reset_time_button: TButton
    Left = 840
    Top = 488
    Width = 147
    Height = 25
    Caption = '0 '#1074#1088#1077#1084#1103' '#1080' '#1076#1072#1090#1072
    TabOrder = 12
    OnClick = reset_time_buttonClick
  end
  object connect_indicator: TPanel
    Left = 400
    Top = 84
    Width = 17
    Height = 54
    Color = clRed
    ParentBackground = False
    TabOrder = 13
  end
  object connect_indicator_2: TPanel
    Left = 25
    Top = 84
    Width = 17
    Height = 54
    Color = clRed
    ParentBackground = False
    TabOrder = 14
  end
  object ComPort: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = False
    Left = 408
    Top = 448
  end
  object ComDataPacket1: TComDataPacket
    ComPort = ComPort
    IncludeStrings = True
    StartString = '<'
    StopString = '>'
    OnPacket = ComDataPacket1Packet
    Left = 408
    Top = 496
  end
  object timer_smena: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = timer_smenaTimer
    Left = 161
    Top = 497
  end
  object timer_table: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = timer_tableTimer
    Left = 160
    Top = 440
  end
  object timer_connect_timeout: TTimer
    Enabled = False
    OnTimer = timer_connect_timeoutTimer
    Left = 55
    Top = 442
  end
end
