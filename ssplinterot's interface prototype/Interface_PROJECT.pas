unit Interface_PROJECT;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Edit;

type
  TForm1 = class(TForm)
    выборигроков: TImage;
    дваигрока: TImage;
    анимаци€принаведенииX: TFloatAnimation;
    анимаци€принаведенииY: TFloatAnimation;
    триигрока: TImage;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    четыреигрока: TImage;
    FloatAnimation3: TFloatAnimation;
    FloatAnimation4: TFloatAnimation;
    количествобаллов: TLabel;
    основна€игра: TImage;
    слово: TLabel;
    ввод—лова: TEdit;
    ShadowEffect1: TShadowEffect;
    procedure дваигрокаClick(Sender: TObject);
    procedure триигрокаClick(Sender: TObject);
    procedure четыреигрокаClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  procedure UpdatePlayerCount(PlayerCount: Integer);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TForm1.FormCreate(Sender: TObject);
begin
  выборигроков.Visible := True; // Ќачальный экран видим
  основна€игра.Visible := False; // ѕанель основной игры невидима
  количествобаллов.Text := '';
end;


procedure TForm1.дваигрокаClick(Sender: TObject);
begin
  UpdatePlayerCount(2);

end;

procedure TForm1.триигрокаClick(Sender: TObject);
begin
    UpdatePlayerCount(3);
end;

procedure TForm1.четыреигрокаClick(Sender: TObject);
begin
  UpdatePlayerCount(4);
end;

procedure TForm1.UpdatePlayerCount(PlayerCount: Integer);
begin
  количествобаллов.Text := PlayerCount.ToString;
  выборигроков.Visible := False; // —крыть выбор игроков
  основна€игра.Visible := True; // ѕоказать новый интерфейс
end;


end.

