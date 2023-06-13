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
    timer_date: TTimer;
    timer_table: TTimer;
    procedure read_data_buttonClick(Sender: TObject);
    procedure Connect_buttonClick(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure array_read_buttonClick(Sender: TObject);
    procedure XML_buttonClick(Sender: TObject);
    procedure ClearMemory_buttonClick(Sender: TObject);
    procedure set_date_buttonClick(Sender: TObject);
    procedure timer_smenaTimer(Sender: TObject);
    procedure timer_dateTimer(Sender: TObject);
    procedure timer_tableTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Data: array of array of Integer;
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
  number := 3;
  ComPort.Write(number,1);//посылается в порядке little-endian, то есть младшим байтом вперед;
  I:=0;
end;



procedure TForm1.set_date_buttonClick(Sender: TObject);
Var
today : TDateTime;
date : string;
value : integer;
begin
  today := Now;
  value := 4;
//  date := (DateToStr(today) + '\'+ TimeToStr(today));
  date := FormatDateTime('dd-mm-yy\hh:mm:ss',today) +'\';
  //date := '09-15-23\12:33:48\';

  ComPort.Write(value,1);

  ComPort.WriteStr(date);
  Memo1.Lines.Add(date);

end;

procedure TForm1.timer_dateTimer(Sender: TObject);
begin
  timer_date.Enabled := false;
  set_date_button.Caption := 'Задать дату и время с ПК';
  set_date_button.Font.Color := clBlack;
end;

procedure TForm1.timer_smenaTimer(Sender: TObject);
begin
  timer_smena.Enabled := false;
  ClearMemory_button.Caption := 'Завершить смену';
  ClearMemory_button.Font.Color := clBlack;
end;

procedure TForm1.timer_tableTimer(Sender: TObject);
begin
  timer_table.Enabled := false;
  XML_button.Caption := 'Cгенерировать таблицу весов';
  XML_button.Font.Color := clBlack;
end;

procedure TForm1.ClearMemory_buttonClick(Sender: TObject);
var
clearValue : integer;
begin

  clearValue := 2;
  ComPort.Write(clearValue,1);
  connect_indicator.Color := clRed;
  connect_indicator_2.Color := clRed;

end;

procedure TForm1.ComDataPacket1Packet(Sender: TObject; const Str: string);
var
recievedValue : string;
cutNum : Integer;
subStrings: TArray<string>;
J: Integer;

hilowInt :Integer;

proc, z:  integer;//переменная для заполнения прогресс бара

byteArray : array[0..1] of byte;
begin
//    if Str[2] = '*' then //символ успешности соединения
//      begin
//        connect_indicator.Color := clGreen;
//        connect_indicator_2.Color := clGreen;
//        Memo1.Lines.add(Str);
//      end;
//    if Str[2] = '&' then   //символ для даты
//      begin
//        timer_date.Enabled := true;
//        set_date_button.Caption := 'Дата и время установлены';
//        set_date_button.Font.Color := clGreen;
//      end;
//
//    if Str[2] = '%' then  //Символ для смены
//      begin
//        timer_smena.Enabled := true;
//        ClearMemory_button.Caption := 'Смена завершена';
//        ClearMemory_button.Font.Color := clGreen;
//      end;

    if Str[2] = '@' then  //символ для количеств даных(длинна массива)
      Begin
      recievedValue := Copy(Str, 3, Length(Str) - 3);// делаем - 3 потому что в str существует символы окончания str в виде \n;
      cutNum := StrToInt(recievedValue);
      SetLength(Data,cutNum,7);
      Memo1.Lines.Add(IntToStr(Length(Data)));
      End

      else
      begin
        hilowInt := 0;
        recievedValue := Str;
        recievedValue := StringReplace(recievedValue, '<', '', [rfReplaceAll]);
        recievedValue := StringReplace(recievedValue, '>', '', [rfReplaceAll]);
        recievedValue := StringReplace(recievedValue, #10, '', [rfReplaceAll]);

        subStrings := SplitString(recievedValue, ' ');

        byteArray[0] := Byte(StrToInt(subStrings[6]));   //старший
        byteArray[1] := Byte(StrToInt(subStrings[7]));  //младший

        hilowInt:= (byteArray[0] shl 8) or byteArray[1];//совмещаем старший и младший байт

        SetLength(subStrings,7);//сокращаем массив на 1 элемент
                                                                  //ОСТАНОВИЛСЯ ТУТ, СДЕЛАТЬ АДЕКВАТНОЕ СОЕДИНЕНИЕ
        subStrings[6] := IntToStr(hilowInt);

        recievedValue := '';

      for J := 0 to 6 do
        begin
          Data[I,J] :=StrToInt(SubStrings[J]);
          recievedValue := recievedValue + IntToStr(Integer(Data[I,J])) +' ';
        end;;

      I := I+1;
    end;
      proc:= ((I*100) div Length(Data));
      read_progress_bar.Position :=proc;
      if proc < 100 then
        begin
          Connect_button.Enabled := false;
          read_data_button.Enabled := false;
          XML_button.Enabled := false;
          set_date_button.Enabled :=false;
          ClearMemory_button.Enabled :=false;
        end
        else
        begin
          Connect_button.Enabled := true;
          read_data_button.Enabled := true;
          XML_button.Enabled := true;
          set_date_button.Enabled :=true;
          ClearMemory_button.Enabled :=true;
        end

end;

procedure TForm1.XML_buttonClick(Sender: TObject);
var
  Doc: IXMLDocument;
  RootNode, CatalogNode, DateNode,TimeNode,WeightNode :IXMLNode;

  I: Integer;
Begin
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
       WeightNode.Text := IntToStr(Integer(Data[I,6]));
    End;

  Doc.SaveToFile('data.xml');

  timer_table.Enabled := true;
  XML_button.Caption := 'таблица сохранена в корневом каталоге';
  XML_button.Font.Color := clGreen;

End;

procedure TForm1.Connect_buttonClick(Sender: TObject);
var
command : integer;

begin
  command := 1;
  ComPort.ShowSetupDialog();
  ComPort.Open();
  ComPort.Write(command,1);
  if not ComPort.Connected then
  begin
    connect_indicator.Color := clRed;
    connect_indicator_2.Color := clRed;
  end
end;

end.
end.

