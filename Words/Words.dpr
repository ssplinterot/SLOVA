program Words;

uses SysUtils;

const
  DictSize = 1532629;

var
  S, Source: string;
  PlayerCount, WordCount, Max: integer;
  Score, CurrScore: array [1 .. 4] of integer;
  Dictionary, UsedWords: array of string;

const
  alphabet =
    'јаЅб¬в√гƒд≈е®Є∆ж«з»и…й кЋлћмЌнќоѕп–р—с“т”у‘ф’х÷ц„чЎшўщЏъ№ьџыЁэёюя€-';

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
  begin
    if (S[i] >= 'ј') and (S[i] <= 'я') then
      S[i] := Chr(Ord(S[i]) + 32)
    else if (S[i] = 'Є') or (S[i] = '®') then
      S[i] := 'е';

  end;
  result := S;
end;

function CheckWord(const Dictionary: array of string; Word: string): boolean;
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
  end
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
    result := 'Ќет-таких-больших-слов-кринжул€';
end;

function GetScore(var S: string; Source: string; var UsedWords: array of string;
  var WordCount: integer): integer;
var
  Flag: boolean;
  i: integer;
begin
  i := 0;
  Flag := true;
  if S = '' then
  begin
    result := 0;
  end
  else
  begin
    repeat
      if UsedWords[i] = S then
        Flag := false;
      Inc(i);
    until (not Flag) or (i = WordCount);
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
  SetLength(Dictionary, DictSize);
  GetDictionary(Dictionary, 'Dictionary.txt');
  Randomize;
  Source := GetRandomWord(Dictionary, 10);
  Writeln('¬аше исходное слово: ', Source);
  Source := ChangeRegister(Source);
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
      CurrScore[i] := GetScore(S, Source, UsedWords, WordCount);
      Score[i] := Score[i] + CurrScore[i];
      if CurrScore[i] > 0 then
        Writeln('»грок ', i:3, ' получает ', CurrScore[i], ' очков')
      else
        Writeln('»грок ', i:3, ' получает ', CurrScore[i], ' очков  ', S);
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
