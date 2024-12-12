program Words;

uses SysUtils;

var
  S: string;
  PlayerCount: integer;
  Scores: array [1 .. 4] of integer;

const
  alphabet =
    'АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЬьЫыЭэЮюЯя';

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
