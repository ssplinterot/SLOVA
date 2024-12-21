program Words;

uses SysUtils;

const
  DictSize = 1532629;

var
  S, Source: string;
  PlayerCount, WordCount, Max: integer;
  Score, CurrScore: array [1 .. 4] of integer;
  DictionaryArray, UsedWords: array of string;

const
  alphabet =
    'јаЅб¬в√гƒд≈е®Є∆ж«з»и…й кЋлћмЌнќоѕп–р—с“т”у‘ф’х÷ц„чЎшўщЏъ№ьџыЁэёюя€-';

function GetScore(S, Source: string; var UsedWords: array of string;
  var WordCount: integer): integer;
var
  Flag: boolean;
  i: integer;
begin
  i := 0;
  Flag := true;
  repeat
    if UsedWords[i] = S then
      Flag := false;
    Inc(i);
  until (not Flag) or (i = WordCount);
  if Flag then
  begin
    result := 0;
    for i := 1 to Length(S) do
      if Pos(S[i], Source) <> 0 then
        Delete(Source, Pos(S[i], Source), 1)
      else
        Dec(result);
    if result = 0 then
    begin
      result := Length(S);
      UsedWords[WordCount] := S;
      Inc(WordCount);
    end;
  end
  else
    result := -Length(S);

end;

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
  Dictionary := Dictionary;
end;

function ChangeRegister(S: string): string;
begin
  for var i := 1 to Length(S) do
    if (S[i] >= 'ј') and (S[i] <= 'я') then
      S[i] := Chr(Ord(S[i]) + 32);
  result := S;
end;

function CheckWord(var Dictionary: array of string; Word: string): boolean;
var
  Place, Step: integer;
  DebugWord: string;
begin
  result := false;
  Step := Length(Dictionary) div 2;
  Place := Step;
  repeat
    if Dictionary[Place] = Word then
      result := true
    else
    begin
      Step := (Step div 2) + 1;
      DebugWord := Dictionary[Place];
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
      DebugWord := Dictionary[Place];
      if ChangeRegister(Dictionary[Place]) > Word then
        Place := Place - Step
      else
        Place := Place + Step;
    end;
    if Dictionary[Place] = Word then
      result := true
  end;
end;

function checking_correct(S: string): boolean;
var
  counter: integer;
begin
  counter := 0;

  begin
    for var index := 1 to Length(S) do
    begin
      if Pos(S[index], alphabet) > 0 then
        Inc(counter);
    end;
    if counter = Length(S) then
      result := true
    else
    begin
      result := false;
    end;
  end;
end;

begin
  var
    i: integer;
  PlayerCount := 0;
  repeat
    Write('¬ведите количество игроков (2-4): ');
    try
      Readln(PlayerCount);
    except
    end
  until PlayerCount in [2 .. 4];
  SetLength(DictionaryArray, DictSize);
  GetDictionary(DictionaryArray, 'Dictionary.txt');
  while true do
  begin
    repeat
      Write('¬ведите исходную строку:                               ');
      Readln(Source);
      Source := Trim(Source);
    until (Source <> '') and (checking_correct(Source));
    Source := ChangeRegister(Source);
    Writeln(CheckWord(DictionaryArray, Source));
  end;
  SetLength(UsedWords, PlayerCount * Length(Source));
  UsedWords[0] := Source;
  WordCount := 1;
  for i := 1 to PlayerCount do
    CurrScore[i] := 1;
  repeat
    i := 1;
    while (i <= PlayerCount) and not((CurrScore[1] = 0) and (CurrScore[2] = 0)
      and (CurrScore[3] = 0) and (CurrScore[4] = 0)) do
    begin
      Write('—лово игрока ', i, ': ');
      Readln(S);
      S := Trim(S);
      if checking_correct(S) then
      begin
        S := ChangeRegister(S);
        CurrScore[i] := GetScore(S, Source, UsedWords, WordCount);
      end
      else
        CurrScore[i] := -Length(S);
      Score[i] := Score[i] + CurrScore[i];
      Writeln('»грок ', i:3, ' получает ', CurrScore[i], ' очков');
      Writeln('”     ', i:3, ' игрока   ', Score[i], ' очков');
      if i < PlayerCount then
        Inc(i)
      else
        i := 1;
    end;
  until (CurrScore[1] = 0) and (CurrScore[2] = 0) and (CurrScore[3] = 0) and
    (CurrScore[4] = 0);
  Max := 0;
  for i := 1 to PlayerCount do
    if Score[i] > Max then
      Max := Score[i];
  for i := 1 to PlayerCount do
    if Score[i] = Max then
      Writeln('»грок ', i, ' победил!');
  Readln;

end.
