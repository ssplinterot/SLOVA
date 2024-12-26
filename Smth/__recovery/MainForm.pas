unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  startGame, PlayersSelector, GameMenu, Help, FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Frame21: TFrame2;
    Frame31: TFrame3;
    Frame11: TPlayersFrame;
    Timer: TTimer;
    GameFrame1: TGameFrame;
    procedure GameStart;
    procedure Frame21Button2Click(Sender: TObject);
    procedure Frame31Button2Click(Sender: TObject);
    procedure Frame11Button4Click(Sender: TObject);
    procedure Frame21Button1Click(Sender: TObject);
    procedure Frame11Button2Click(Sender: TObject);
    procedure Frame11Button1Click(Sender: TObject);
    procedure Frame11Button3Click(Sender: TObject);
    procedure GameFrame1Edit1KeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  DictSize = 1532629;

var
  Form1: TForm1;
  GameStarted: boolean;
  PlayerCount, WordCount, Max, CurrPlayer: integer;
  S, Source: string;
  Score, CurrScore: array [1 .. 4] of integer;
  Dictionary, UsedWords: array of string;
  ScoreLabels: array [1 .. 4] of TLabel;
  Code: byte;

implementation

{$R *.fmx}

procedure GetDictionary(var Dictionary: array of string; Name: string);
var
  Txt: TextFile;
  i: integer;
begin
  AssignFile(Txt, Name);
  Reset(Txt);
  i := 0;
  while not EOF(Txt) do
  begin
    Readln(Txt, Dictionary[i]);
    Inc(i);
  end;
end;

function GetRandomWord(const Dictionary: array of string;
  MinLength: integer): string;
var
  Number, i: integer;
begin
  if MinLength < 30 then
  begin
    Number := Random(Length(Dictionary));
    if Number > Length(Dictionary) then
      i := -1
    else
      i := 1;
    while Length(Dictionary[Number]) < MinLength do
      Number := Number + i;
    result := Dictionary[Number];
  end
  else
    result := 'Нет-таких-больших-слов-кринжуля';
end;

function ChangeRegister(S: string): string;
begin
  for var i := 1 to Length(S) do
  begin
    if (S[i] >= 'А') and (S[i] <= 'Я') then
      S[i] := Chr(Ord(S[i]) + 32)
    else if (S[i] = 'ё') or (S[i] = 'Ё') then
      S[i] := 'е';

  end;
  result := S;
end;

function CheckWord(const Dictionary: array of string; Word: string): boolean;
var
  Place, Step: integer;
begin
  result := false;
  Step := Length(Dictionary) div 2;
  Place := Step;
  repeat
    if ChangeRegister(Dictionary[Place]) = Word then
      result := true
    else
    begin
      Step := (Step div 2) + 1;
      if ChangeRegister(Dictionary[Place]) > Word then
        Place := Place - Step
      else
        Place := Place + Step;
    end;
  until result or (Step = 2);
  if not result then
  begin
    Step := 1;
    if Dictionary[Place] = Word then
      result := true
    else
    begin
      if ChangeRegister(Dictionary[Place]) > Word then
        Place := Place - Step
      else
        Place := Place + Step;
    end;
    if Dictionary[Place] = Word then
      result := true
  end
end;

function GetScore(var S: string; Source: string; var UsedWords: array of string;
  // Коды: 0 - всё ок, 1 - пустая строка, 2 - слова не существует, 3 - повторка, 4 - изначальное, 5 - не те буквы
  var WordCount: integer; var Code: byte): integer;
var
  Flag: boolean;
  i: integer;
begin
  Flag := true;
  if S = '' then
  begin
    result := 0;
    Code := 1;
  end
  else
  begin
    i := 1;
    if UsedWords[0] = S then
    begin
      Flag := false;
      Code := 4;
    end
    else
      while Flag and (i <= WordCount) do
      begin
        if UsedWords[i] = S then
        begin
          Flag := false;
          Code := 3;
        end;
        Inc(i);
      end;
    if Flag and CheckWord(Dictionary, S) then
    begin
      result := 0;
      for i := 1 to Length(S) do
        if Pos(S[i], Source) <> 0 then
        begin
          Delete(Source, Pos(S[i], Source), 1);
          S[i] := Chr(Ord(S[i]) - 32);
        end
        else
        begin
          Dec(result);
          Code := 5;
        end;
      if result = 0 then
      begin
        result := Length(S);
        UsedWords[WordCount] := ChangeRegister(S);
        Inc(WordCount);
      end;
    end
    else
    begin
      result := -Length(S);
      if Flag then
        Code := 2;
    end;
  end;
end;

procedure TForm1.GameFrame1Edit1KeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    GameFrame1.Edit1.Enabled := false;
    S := GameFrame1.Edit1.Text;
    S := Trim(S);
    S := ChangeRegister(S);
    Code := 0;
    CurrScore[CurrPlayer] := GetScore(S, Source, UsedWords, WordCount, Code);
    Score[CurrPlayer] := Score[CurrPlayer] + CurrScore[CurrPlayer];
    ScoreLabels[CurrPlayer].Text := IntToStr(Score[CurrPlayer]);
    case Code of
      0:
        GameFrame1.MessageLabel.Text := 'Правильно! Вы получаете ' +
          IntToStr(CurrScore[CurrPlayer]) + ' очков';
          // Коды: 0 - всё ок, 1 - пустая строка, 2 - слова не существует, 3 - повторка, 4 - изначальное, 5 - не те буквы
      1:
        GameFrame1.MessageLabel.Text := 'Вы пропустили ход';
      2:
        GameFrame1.MessageLabel.Text :=
          'Такого слова не существует. Вы теряете ' +
          IntToStr(-CurrScore[CurrPlayer]) + ' очков';
      3:
        GameFrame1.MessageLabel.Text :=
          'Это слово уже использовалось. Вы теряете ' +
          IntToStr(-CurrScore[CurrPlayer]) + ' очков';
      4:
        GameFrame1.MessageLabel.Text := 'Это изначальное слово. Вы теряете ' +
          IntToStr(-CurrScore[CurrPlayer]) + ' очков';
      5:
        GameFrame1.MessageLabel.Text :=
          'Слово содержит неправильные буквы. Вы теряете ' +
          IntToStr(-CurrScore[CurrPlayer]) + ' очков';
    end;
    if CurrPlayer < PlayerCount then
      Inc(CurrPlayer)
    else
      CurrPlayer := 1;
    Timer.Enabled := true;
  end;
end;

procedure TForm1.GameStart;
var
  i, j: integer;
begin
  CurrPlayer := 1;
  ScoreLabels[1] := GameFrame1.Score1;
  ScoreLabels[2] := GameFrame1.Score2;
  ScoreLabels[3] := GameFrame1.Score3;
  ScoreLabels[4] := GameFrame1.Score4;
  SetLength(Dictionary, DictSize);
  GetDictionary(Dictionary, 'Dictionary.txt');
  Randomize;
  Source := GetRandomWord(Dictionary, 10);
  GameFrame1.SourceWord.Text := Source;
  Source := ChangeRegister(Source);
  SetLength(UsedWords, PlayerCount * Length(Source));
  UsedWords[0] := Source;
  WordCount := 1;
  for i := 1 to PlayerCount do
    ScoreLabels[i].Visible := true;
  for i := 1 to PlayerCount do
    CurrScore[i] := 1;
end;

procedure TForm1.TimerTimer(Sender: TObject);
var
  i: integer;
begin
  if (CurrScore[1] = 0) and (CurrScore[2] = 0) and (CurrScore[3] = 0) and
    (CurrScore[4] = 0) then
  begin
    for i := 1 to PlayerCount do
      if Score[i] > Max then
        Max := Score[i];
    GameFrame1.Player.Text := 'Игрок(-и) ';
    for i := 1 to PlayerCount do
      if Score[i] = Max then
      begin
        GameFrame1.Player.Text := GameFrame1.Player.Text + IntToStr(i)+'   ';
        GameFrame1.MessageLabel.Text := 'Победил(-и)!';
      end;
  end
  else
  begin
    Timer.Enabled := false;
    GameFrame1.Edit1.Text := '';
    GameFrame1.Player.Text := 'Игрок ' + IntToStr(CurrPlayer) + ':';
    GameFrame1.MessageLabel.Text := '';
    GameFrame1.Edit1.Enabled := true;
  end;

end;

procedure TForm1.Frame11Button1Click(Sender: TObject);
begin
  GameFrame1.Visible := true;
  Frame11.Visible := false;
  PlayerCount := 3;
  GameStart;
end;

procedure TForm1.Frame11Button2Click(Sender: TObject);
begin
  GameFrame1.Visible := true;
  Frame11.Visible := false;
  PlayerCount := 2;
  GameStart;
end;

procedure TForm1.Frame11Button3Click(Sender: TObject);
begin
  GameFrame1.Visible := true;
  Frame11.Visible := false;
  PlayerCount := 4;
  GameStart;
end;

procedure TForm1.Frame11Button4Click(Sender: TObject);
begin
  Frame21.Visible := true;
  Frame11.Visible := false;
end;

procedure TForm1.Frame21Button1Click(Sender: TObject);
begin
  Frame11.Visible := true;
  Frame21.Visible := false;
end;

procedure TForm1.Frame21Button2Click(Sender: TObject);
begin
  Frame31.Visible := true;
  Frame21.Visible := false;
end;

procedure TForm1.Frame31Button2Click(Sender: TObject);
begin
  Frame21.Visible := true;
  Frame31.Visible := false;
end;

end.
