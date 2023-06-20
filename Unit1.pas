unit Unit1;

//by Isaev Alexandr Alexandrovich (89507562823)
//Прикладная программа для работы с весами КуАЭС
//ДЛЯ КОМПИЛЯЦИИ НЕОБХОДИМА БИБЛИОТЕКА TComPort
//если расширить окно в design ржиме, можно увидеть дебаг MEMO куда считывается массив данных
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
  I : Integer; // для массива в который будет заноситься data(указывает строки массива Data);

implementation

{$R *.dfm}

procedure TForm1.array_read_buttonClick(Sender: TObject);//кнопка для считывания массива в дебаг MEMO
var                                                      //массив считывается со страшим и младшим байтом
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

procedure TForm1.read_data_buttonClick(Sender: TObject);//кнопка посылает 1 младший байт из числа типа INTEGER
var                                                    //отправляет число 3, контроллером воспринимается как команда отправки данных из памяти
number: integer;

begin
  timer_connect_timeout.Enabled := false;//пока читаются данных, таймаут таймер отключен
  number := 3;
  ComPort.Write(number,1);//посылается в порядке little-endian, то есть младшим байтом вперед;
  I:=0;//обнуляем переменную для DATA или процента слайдера
end;



procedure TForm1.resetTime_buttonClick(Sender: TObject); //дебаг кнопка для установки времени в 0 значения
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

  ComPort.Write(value,1);//посылается число 4 одним байтом, это команда установки времени с ПК

  ComPort.WriteStr(date);
  //Memo1.Lines.Add(date);

end;
procedure TForm1.set_date_buttonClick(Sender: TObject);//кнопка для установки реального времени с ПК
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

procedure TForm1.timer_connect_timeoutTimer(Sender: TObject);//при истечении времени таймера будет происходитт следующее
begin
  if read_progress_bar.Position > 0 then//если заполнение прогресс бара загрузки идет то отключаем это таймер и выходим из процедуры
    begin
      timer_connect_timeout.Enabled := false;
      exit
    end
  else if (read_progress_bar.Position = 0)//если загрузка данных не идет и время и датта не устанавливается
       and not (text_label.Caption = 'Устанавливается дата и время с пк...') then // но таймер сработал то от весов нет ответа
    begin
      text_label.Font.Size := 20;
      text_label.Caption := 'НЕТ ОТВЕТА ОТ ВЕСОВ';
      text_label.Font.Color := clRed;
    end;
end;


procedure TForm1.timer_smenaTimer(Sender: TObject);//запуск события таймера по нажатию на копку заверешния смены
begin
  text_label.Caption := '';
  timer_connect_timeout.Enabled := true;
  timer_smena.Enabled := false;
end;

procedure TForm1.timer_tableTimer(Sender: TObject);//событие по таймеру которое убирает индикационную надпись ком порта
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

procedure TForm1.disconect_buttonClick(Sender: TObject);//дисконектим ком порт и блокируем кнопки
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

procedure TForm1.drop_cycle_buttonClick(Sender: TObject); //запасная команда для выхода из цикла соединения без очистки памяти
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

procedure TForm1.FormCreate(Sender: TObject);//создание формы, изначально все эелементы заблокированны
begin
  read_data_button.Enabled := false;
  XML_button.Enabled := false;
  set_date_button.Enabled :=false;
  ClearMemory_button.Enabled :=false;
  read_progress_bar.Enabled :=false;
  disconect_button.Enabled := false;

end;

procedure TForm1.close_connection_buttonClick(Sender: TObject);//кнопка освобождение ком порта
begin
 ComPort.Close;
 Memo1.Lines.add('соединение принудительно разорвано приложением');
end;

procedure TForm1.ClearMemory_buttonClick(Sender: TObject);//кнопка завершение смены, стирает память в весах
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



procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: string);//процедура принятия пакетов данных
var
recievedValue : string;//переменная которая служит для хранения количества данных получаемых с микроконтроллера
cutNum : Integer;//переменная хранящая кол-во данных но в INT типе
subStrings: TArray<string>;//массив стринг для в котором хранятся числа из пакетов типа стринг
J: Integer; //переменная служащая для индексирования ячейки массива куда класть интовое значения с substring в массив Data(указывает столбец массива)
hilowInt :SmallInt; //переменная в которую заносится совмещенный старший и младший байт
proc, z:  integer;//переменные для заполнения прогресс бара

byteArray : array[0..1] of byte;//массив байт который хранит старший и младший байт из которого потом совместим эти байты
begin

    case Str[2] of//принимаем первый пакет состоящий из 5и байт "<@>\n". \n - шлется автоматом так как обозначает конец строки
    '@' : begin
              recievedValue := Copy(Str, 3, Length(Str) - 3);// делаем - 3 потому что в str существует символы окончания str в виде \n;
              cutNum := StrToInt(recievedValue);//конвертируем кол во данных из стринг в инт
              SetLength(Data,cutNum,7);//меняем размерность массива согласно количеству поступаемых пакетов
              Memo1.Lines.Add(IntToStr(Length(Data)));
              text_label.Caption := 'Идет считывание';
          end;

    '+' : begin//в  пакете есть символ +, служит для определения того что это пакет с сырыми данными из контроллера
             hilowInt := 0;
             recievedValue := Str;
             recievedValue := StringReplace(recievedValue, '<', '', [rfReplaceAll]);//убираем ненужные символы
             recievedValue := StringReplace(recievedValue, '>', '', [rfReplaceAll]);
             recievedValue := StringReplace(recievedValue, #10, '', [rfReplaceAll]);

             subStrings := SplitString(recievedValue, ' ');//сплитим всю строку по пробелам, и записываем значения в массив стригов, остается значения в виде строк

             byteArray[0] := Byte(StrToInt(subStrings[6]));  //старший
             byteArray[1] := Byte(StrToInt(subStrings[7]));  //младший

             hilowInt:= (byteArray[0] shl 8) or byteArray[1];//совмещаем старший и младший байт

             SetLength(subStrings,7);//сокращаем массив на 1 элемент, чтобы убрать младший байт в виде стринг

             subStrings[6] := IntToStr(hilowInt);//вместо старшего байта записывает целое число в конвертацией в стринг

             recievedValue := '';//очищаем переменную получения

             for J := 0 to 6 do// заносим каждое значение из substring в столбцы DATA
              begin
               Data[I,J] :=StrToInt(SubStrings[J]);
               recievedValue := recievedValue + IntToStr(Integer(Data[I,J])) +' ';
              end;

             I := I+1;//увеличиваем количество строк массива DATA, которые в свою очередь равняются количеству пакетов

             proc:= ((I*100) div Length(Data));//высчитываем процент заполнения статус бара исходя из количества данных
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

    '*' : begin //ответный байт от весов от что соединение с весами идет упешноб если в течении секунды
            Memo1.Lines.add(Str); //от таймера информации, то считается что соединения с весами нет.
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

    '&' : begin//ответный байт от весов означающий что время и дата установлены
            timer_connect_timeout.Enabled:= false;
            Memo1.Lines.Add(Str + ' Время установлено');
            text_label.Font.Color := clGreen;
            text_label.Font.Size := 14;
            text_label.Caption := 'Дата и время с пк установлены';
          end;

    '!' : begin//ответный байт от весов означающий что завершение с очисткой памяти завершено, СМЕНА ЗАВЕРШЕНА
            Memo1.Lines.Add(Str + ' Завершение подключения С очисткой памяти выполнено');
            connect_indicator.Color := clRed;
            connect_indicator_2.Color := clRed;
          end;

    '#' : begin//ответный байт от весов означающий что завершение работы без очистки памяти выполнено успешно
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

procedure TForm1.XML_buttonClick(Sender: TObject);//кнопка для генерации XML файла
var
  Doc: IXMLDocument;//сощдаем экзмепляр класса XML документа
  RootNode, CatalogNode, DateNode,TimeNode,WeightNode :IXMLNode;

  commaString : string; //переменная которая вставляет запятную в значение веса,перед разрядом едениц
  temp_symbol : string; //временная переменная
  I: Integer;

  today : TDateTime; //переменнаая экзмепляр класса TDateTime(хранит в себе время и датту)
  date : string; // хранит в себе форматированные время и дату но в типе string(используется как имя файла)

Begin

  today := Now;//получает текущее время и дату с пк
  date := FormatDateTime('dd-mm-yy\hh:mm:ss',today) +'.xml';//
  Doc:=NewXMLDocument(); //создаем новый XML документ
  RootNode := Doc.AddChild('data');//присваиваем корневую ноду
  for I := 0 to Length(Data)-1 do
    Begin

       CatalogNode:=RootNode.AddChild('Catalog');//добавляем ноду каталога

       DateNode := CatalogNode.AddChild('Date');//добавляем таблицу даты
       TimeNode := CatalogNode.AddChild('Time');//добавляем таблицу времени
       WeightNode := CatalogNode.AddChild('Weight');//добавляем таблицу веса

       DateNode.Text := Format('%d-%d-%d',[Data[I,3],Data[I,4],Data[I,5]]);//форматируем значения в определенный вид
       TimeNode.Text := Format('%d:%d:%d',[Data[I,0],Data[I,1],Data[I,2]]);

       commaString := IntToStr(Integer(Data[I,6]));//присваиваем занчение веса переменной чтобы потом вставить ее после запятой

       if Length(commaString) = 1 then//если число имеет только еденичный разряд
         begin
           commaString := '0,' + IntToStr(Integer(Data[I,6]));//добавляем "0," к этому числу
         end
       else //если число состоит например их 3х, или 2х разрядов то запятую ставм после первого разряда
        begin
         temp_symbol := ',';
         temp_symbol := temp_symbol + commaString[Length(commaString)];//берем последний разрдят и добавляем к нему запятую

         delete(commaString, length(commaString),1);//удаляем послений разряд из основного числа

         commaString := commaString + temp_symbol;//и добавляем к основному числу еденичный разряд но уже с запятой


         Memo1.Lines.Add(commaString);

        end;
        WeightNode.Text := commaString;//присвиваем столбцу все число с запятой
    End;

  Doc.SaveToFile(date);//сохраянем файл с именем date

  timer_table.Enabled := true;

  text_label.Caption := 'таблица сохранена в корневом каталоге';
  text_label.Font.Color := clGreen;
  text_label.Font.Size := 12;
End;

procedure TForm1.Connect_buttonClick(Sender: TObject);//кнопка для соединения с ком портом
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

