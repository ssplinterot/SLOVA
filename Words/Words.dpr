program Words;

uses SysUtils;

var
  S: string;
  PlayerCount: integer;
  Scores: array [1 .. 4] of integer;

const
  alphabet =
    'АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЬьЫыЭэЮюЯя';

function GetScore(S, Source: string): integer;
begin
  result := 0;
  for var i := 1 to Length(S) do
    if Pos(S[i], Source) <> 0 then
      Delete(Source, Pos(S[i], Source), 1)
    else
      Dec(result);
  if result >= 0 then
    result := Length(S);

end;

function checking_correct(S: string): boolean;
var
  counter: integer;
begin
  counter := 0;
  if S = '' then
  begin
    result := false;
  end
  else
  begin
    for var index := 1 to length(S) do
    begin
      if pos(S[index], alphabet) > 0 then
        inc(counter);
    end;
    if counter = length(S) then
      result := true
    else
    begin
      result := false;
    end;
  end;
end;

begin
  repeat
    try
      Write('Введите количество игроков: ');
      readLn(PlayerCount);
    except
    end;
  until PlayerCount in [2 .. 4];
  repeat
    for var i := 1 to PlayerCount do
    begin
      Readln(S);
      S:=checking_correct(S);
      Writeln(S);


    end;
  until true;
  readLn;

// Change
end.
