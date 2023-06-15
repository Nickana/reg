unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, CPort, StrUtils, XMLIntf, XMLDoc,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    read_data_button: TButton;
    ComPort: TComPort;
    Connect_button: TButton;
    Memo1: TMemo;
    ComDataPacket1: TComDataPacket;
    array_read_button: TButton;
    XML_button: TButton;
    ClearMemory_button: TButton;
    set_date_button: TButton;
    Panel1: TPanel;
    connect_indicator: TPanel;
    connect_indicator_2: TPanel;
    read_progress_bar: TProgressBar;
    timer_smena: TTimer;
    timer_table: TTimer;
    reset_time_button: TButton;
    drop_cycle_button: TButton;
    disconect_button: TButton;
    timer_connect_timeout: TTimer;
    Panel2: TPanel;
    text_label: TLabel;
    procedure read_data_buttonClick(Sender: TObject);
    procedure Connect_buttonClick(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure array_read_buttonClick(Sender: TObject);
    procedure XML_buttonClick(Sender: TObject);
    procedure ClearMemory_buttonClick(Sender: TObject);
    procedure set_date_buttonClick(Sender: TObject);
    procedure timer_smenaTimer(Sender: TObject);
    procedure timer_tableTimer(Sender: TObject);
    procedure resetTime_buttonClick(Sender: TObject);
    procedure drop_cycle_buttonClick(Sender: TObject);
    procedure reset_time_buttonClick(Sender: TObject);
    procedure close_connection_buttonClick(Sender: TObject);
    procedure disconect_buttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure timer_connect_timeoutTimer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Data: array of array of Integer; //массив данных в который заносится обработанный пакет с весов.
  I : Integer; // для массива в который будет заноситься data

implementation

{$R *.dfm}

procedure TForm1.array_read_buttonClick(Sender: TObject);
var
I,J:Integer;
Str: String;

begin
  for I:=0 to Length(Data)-1 do
    Begin
      Str := '';
      for J := 0 to 6 do
        Begin
        Str := Str + IntToStr(Integer(Data[I,J]))+ ' ';
        End;
      Memo1.Lines.Add(Str);
    End;


end;

procedure TForm1.read_data_buttonClick(Sender: TObject);
var
number: integer;

begin
  timer_connect_timeout.Enabled := false;
  number := 3;
  ComPort.Write(number,1);//посылается в порядке little-endian, то есть младшим байтом вперед;
  I:=0;

end;



procedure TForm1.resetTime_buttonClick(Sender: TObject);
Var
today : TDateTime;
date : string;
value : integer;
begin
  today := Now;
  value := 4;
//date := (DateToStr(today) + '\'+ TimeToStr(today));
  date := '00-00-00\00:00:00\';
//date := '09-15-23\12:33:48\';

  ComPort.Write(value,1);

  ComPort.WriteStr(date);
  //Memo1.Lines.Add(date);

end;
procedure TForm1.set_date_buttonClick(Sender: TObject);
Var
today : TDateTime;
date : string;
value : integer;
begin
  today := Now;
  value := 4;
//date := (DateToStr(today) + '\'+ TimeToStr(today));
  date := FormatDateTime('dd-mm-yy\hh:mm:ss',today) +'\';
//date := '09-15-23\12:33:48\';

  ComPort.Write(value,1);

  ComPort.WriteStr(date);
  //Memo1.Lines.Add(date);

  timer_connect_timeout.Enabled := false;
  text_label.Font.Size := 14;
  text_label.Caption := 'Устанавливается дата и время с пк...';

end;

procedure TForm1.timer_connect_timeoutTimer(Sender: TObject);
begin
  if read_progress_bar.Position > 0 then
    begin
      timer_connect_timeout.Enabled := false;
      exit
    end
  else if (read_progress_bar.Position = 0) and not (text_label.Caption = 'Устанавливается дата и время с пк...') then
    begin
      text_label.Font.Size := 20;
      text_label.Caption := 'НЕТ ОТВЕТА ОТ ВЕСОВ';
      text_label.Font.Color := clRed;
    end;
end;


procedure TForm1.timer_smenaTimer(Sender: TObject);
begin
  text_label.Caption := '';
  timer_connect_timeout.Enabled := true;
  timer_smena.Enabled := false;
end;

procedure TForm1.timer_tableTimer(Sender: TObject);
begin
  if text_label.Caption = 'Comport ОТКЛЮЧЕН' then
    begin
      text_label.Caption := '';
    end;

  timer_table.Enabled := false;
  text_label.Caption := '';
end;

procedure TForm1.reset_time_buttonClick(Sender: TObject);// сброс времени даты в 0
Var
today : TDateTime;
date : string;
value : integer;
begin
  today := Now;
  value := 4;
//date := (DateToStr(today) + '\'+ TimeToStr(today));
  date := '00-00-00\00:00:00\';
//date := '09-15-23\12:33:48\';

  ComPort.Write(value,1);

  ComPort.WriteStr(date);
  //Memo1.Lines.Add(date);

end;

procedure TForm1.disconect_buttonClick(Sender: TObject);
begin
  ComPort.Close;
  Memo1.Lines.Add('Ком порт отключен');
  read_data_button.Enabled := false;
  XML_button.Enabled := false;
  set_date_button.Enabled :=false;
  ClearMemory_button.Enabled :=false;
  disconect_button.Enabled := false;

  timer_connect_timeout.Enabled := false;
  text_label.Caption := 'Comport ОТКЛЮЧЕН';
  text_label.Font.Color := clRed;
  timer_table.Enabled := true;


end;

procedure TForm1.drop_cycle_buttonClick(Sender: TObject); //дебажная команда для выхода из цикла соединения без очистки памяти
var
Value : integer;
begin
  timer_connect_timeout.Enabled := false;
  Value := 5;
  ComPort.Write(Value,1);
  read_data_button.Enabled := false;
  XML_button.Enabled := false;
  set_date_button.Enabled :=false;
  ClearMemory_button.Enabled :=false;
  read_progress_bar.Enabled :=false;
  disconect_button.Enabled := false;
end;

procedure TForm1.FormCreate(Sender: TObject);//создание формы
begin
  read_data_button.Enabled := false;
  XML_button.Enabled := false;
  set_date_button.Enabled :=false;
  ClearMemory_button.Enabled :=false;
  read_progress_bar.Enabled :=false;
  disconect_button.Enabled := false;

end;

procedure TForm1.close_connection_buttonClick(Sender: TObject);
begin
 ComPort.Close;
 Memo1.Lines.add('соединение принудительно разорвано приложением');
end;

procedure TForm1.ClearMemory_buttonClick(Sender: TObject);
var
clearValue : integer;
begin
  timer_connect_timeout.Enabled := false;
  clearValue := 2;
  ComPort.Write(clearValue,1);
  connect_indicator.Color := clRed;
  connect_indicator_2.Color := clRed;

  text_label.Font.Color := clGreen;
  text_label.Font.Size := 11;
  text_label.Caption := 'СМЕНА ЗАВЕРШЕНА, выполните отключение...';
  timer_smena.Enabled := true;
  disconect_button.Enabled := true;

end;



procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: string);
var
recievedValue : string;
cutNum : Integer;
subStrings: TArray<string>;
J: Integer;

hilowInt :SmallInt;

proc, z:  integer;//переменная для заполнения прогресс бара

byteArray : array[0..1] of byte;
begin

    case Str[2] of
    '@' : begin
              recievedValue := Copy(Str, 3, Length(Str) - 3);// делаем - 3 потому что в str существует символы окончания str в виде \n;
              cutNum := StrToInt(recievedValue);
              SetLength(Data,cutNum,7);
              Memo1.Lines.Add(IntToStr(Length(Data)));
              text_label.Caption := 'Идет считывание';
          end;

    '+' : begin
             hilowInt := 0;
             recievedValue := Str;
             recievedValue := StringReplace(recievedValue, '<', '', [rfReplaceAll]);
             recievedValue := StringReplace(recievedValue, '>', '', [rfReplaceAll]);
             recievedValue := StringReplace(recievedValue, #10, '', [rfReplaceAll]);

             subStrings := SplitString(recievedValue, ' ');

             byteArray[0] := Byte(StrToInt(subStrings[6]));  //старший
             byteArray[1] := Byte(StrToInt(subStrings[7]));  //младший

             hilowInt:= (byteArray[0] shl 8) or byteArray[1];//совмещаем старший и младший байт

             SetLength(subStrings,7);//сокращаем массив на 1 элемент
//ОСТАНОВИЛСЯ ТУТ, СДЕЛАТЬ АДЕКВАТНОЕ СОЕДИНЕНИЕ----------------------------------------------------
             subStrings[6] := IntToStr(hilowInt);

             recievedValue := '';

             for J := 0 to 6 do
              begin
               Data[I,J] :=StrToInt(SubStrings[J]);
               recievedValue := recievedValue + IntToStr(Integer(Data[I,J])) +' ';
              end;

             I := I+1;

             proc:= ((I*100) div Length(Data));
             read_progress_bar.Position :=proc;
             if proc < 100 then
               begin
                 Connect_button.Enabled := false;
                 read_data_button.Enabled := false;
                 XML_button.Enabled := false;
                 set_date_button.Enabled :=false;
                 ClearMemory_button.Enabled :=false;
                 disconect_button.Enabled := false;
               end
               else
               begin
                 Connect_button.Enabled := true;
                 read_data_button.Enabled := true;
                 XML_button.Enabled := true;
                 set_date_button.Enabled :=true;
                 ClearMemory_button.Enabled :=true;
                 disconect_button.Enabled := true;
                 read_progress_bar.Position := 0;
               end
          end;

    '*' : begin
            Memo1.Lines.add(Str);
            connect_indicator.Color := clGreen;
            connect_indicator_2.Color := clGreen;

            Connect_button.Enabled := true;
            read_data_button.Enabled := true;
            XML_button.Enabled := true;
            set_date_button.Enabled :=true;
            ClearMemory_button.Enabled :=true;

            timer_connect_timeout.Enabled := false; //обновляем таймер
            timer_connect_timeout.Enabled := true;
            if (text_label.Caption = 'НЕТ ОТВЕТА ОТ ВЕСОВ') or (text_label.Caption  = '')
            or (text_label.Caption = 'Идет считывание') or (text_label.Caption = 'Дата и время с пк установлены') then
              begin
                text_label.Font.Size := 20;
                text_label.Font.Color := clGreen;
                text_label.Caption := 'ВЕСЫ ПОДКЛЮЧЕНЫ';
              end;
          end;

    '&' : begin
            timer_connect_timeout.Enabled:= false;
            Memo1.Lines.Add(Str + ' Время установлено');
            text_label.Font.Color := clGreen;
            text_label.Font.Size := 14;
            text_label.Caption := 'Дата и время с пк установлены';
          end;

    '!' : begin
            Memo1.Lines.Add(Str + ' Завершение подключения С очисткой памяти выполнено');
            connect_indicator.Color := clRed;
            connect_indicator_2.Color := clRed;
          end;

    '#' : begin
            Memo1.Lines.Add(Str + ' Завершение подключения без очистки памяти выполнено');
            connect_indicator.Color := clRed;
            connect_indicator_2.Color := clRed;

            read_data_button.Enabled := false;
            XML_button.Enabled := false;
            set_date_button.Enabled :=false;
            ClearMemory_button.Enabled :=false;
          end
    end;
end;



//
//    if Str[2] = '&' then   //Символ для даты
//      begin
//        timer_date.Enabled := true;
//        set_date_button.Caption := 'Дата и время установлены';
//        set_date_button.Font.Color := clGreen;
//      end;
////
//    if Str[2] = '%' then  //Символ для смены
//      begin
//        timer_smena.Enabled := true;
//        ClearMemory_button.Caption := 'Смена завершена';
//        ClearMemory_button.Font.Color := clGreen;
//        Memo1.Lines.add(Str);
//      end;
//

//    else if Str[2] = '*' then //символ успешности соединения
//     begin
//       connect_indicator.Color := clGreen;
//       connect_indicator_2.Color := clGreen;
//       Memo1.Lines.add(Str);
//     End
//--осноыв(раскментить если с свич кейс не получится
//    if Str[2] = '@' then  //символ для количеств даных(длинна массива)
//      Begin
//      recievedValue := Copy(Str, 3, Length(Str) - 3);// делаем - 3 потому что в str существует символы окончания str в виде \n;
//      cutNum := StrToInt(recievedValue);
//      SetLength(Data,cutNum,7);
//      Memo1.Lines.Add(IntToStr(Length(Data)));
//      End
//
//    else
//    begin
//        hilowInt := 0;
//        recievedValue := Str;
//        recievedValue := StringReplace(recievedValue, '<', '', [rfReplaceAll]);
//        recievedValue := StringReplace(recievedValue, '>', '', [rfReplaceAll]);
//        recievedValue := StringReplace(recievedValue, #10, '', [rfReplaceAll]);
//
//        subStrings := SplitString(recievedValue, ' ');
//
//        byteArray[0] := Byte(StrToInt(subStrings[6]));   //старший
//        byteArray[1] := Byte(StrToInt(subStrings[7]));  //младший
//
//        hilowInt:= (byteArray[0] shl 8) or byteArray[1];//совмещаем старший и младший байт
//
//        SetLength(subStrings,7);//сокращаем массив на 1 элемент
//                                                                  //ОСТАНОВИЛСЯ ТУТ, СДЕЛАТЬ АДЕКВАТНОЕ СОЕДИНЕНИЕ
//        subStrings[6] := IntToStr(hilowInt);
//
//        recievedValue := '';
//
//      for J := 0 to 6 do
//        begin
//          Data[I,J] :=StrToInt(SubStrings[J]);
//          recievedValue := recievedValue + IntToStr(Integer(Data[I,J])) +' ';
//        end;;
//
//      I := I+1;
//    end;
//      proc:= ((I*100) div Length(Data));
//      read_progress_bar.Position :=proc;
//      if proc < 100 then
//        begin
//          Connect_button.Enabled := false;
//          read_data_button.Enabled := false;
//          XML_button.Enabled := false;
//          set_date_button.Enabled :=false;
//          ClearMemory_button.Enabled :=false;
//        end
//        else
//        begin
//          Connect_button.Enabled := true;
//          read_data_button.Enabled := true;
//          XML_button.Enabled := true;
//          set_date_button.Enabled :=true;
//          ClearMemory_button.Enabled :=true;
//        end
//основа

//end;

procedure TForm1.XML_buttonClick(Sender: TObject);
var
  Doc: IXMLDocument;
  RootNode, CatalogNode, DateNode,TimeNode,WeightNode :IXMLNode;

  commaString : string; //переменная которая вставляет запятную в значение веса,перед разрядом едениц
  temp_symbol : string;
  I: Integer;

  today : TDateTime;
  date : string;

Begin

  today := Now;
  date := 'weight_of_' + FormatDateTime('dd-mm-yy(hh.mm.ss)',today) +'.xml';
  Doc:=NewXMLDocument();
  RootNode := Doc.AddChild('data');
  for I := 0 to Length(Data)-1 do
    Begin

       CatalogNode:=RootNode.AddChild('Catalog');

       DateNode := CatalogNode.AddChild('Date');
       TimeNode := CatalogNode.AddChild('Time');
       WeightNode := CatalogNode.AddChild('Weight');

       DateNode.Text := Format('%d-%d-%d',[Data[I,3],Data[I,4],Data[I,5]]);
       TimeNode.Text := Format('%d:%d:%d',[Data[I,0],Data[I,1],Data[I,2]]);

       commaString := IntToStr(Integer(Data[I,6]));

       if Length(commaString) = 1 then
         begin
           commaString := '0,' + IntToStr(Integer(Data[I,6]));
         end
       else
        begin
         temp_symbol := ',';
         temp_symbol := temp_symbol + commaString[Length(commaString)];

         delete(commaString, length(commaString),1);

         commaString := commaString + temp_symbol;


         Memo1.Lines.Add(commaString);

        end;
        WeightNode.Text := commaString;
    End;

  Doc.SaveToFile(date);

  timer_table.Enabled := true;

  text_label.Caption := 'таблица сохранена в корневом каталоге';
  text_label.Font.Color := clGreen;
  text_label.Font.Size := 12;
End;

procedure TForm1.Connect_buttonClick(Sender: TObject);
var
command : integer;

begin
  command := 1;
  ComPort.ShowSetupDialog();
  ComPort.Open();
  ComPort.Write(command,1);
  if ComPort.Connected then
  begin
    timer_connect_timeout.Enabled := true;
  end

end;

end.
end.

