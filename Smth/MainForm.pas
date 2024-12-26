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
    GameFrame1: TGameFrame;
    procedure Frame21Button2Click(Sender: TObject);
    procedure Frame31Button2Click(Sender: TObject);
    procedure Frame11Button4Click(Sender: TObject);
    procedure Frame21Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GameStarted: boolean;

implementation

{$R *.fmx}
procedure GameStart();
begin

end;

procedure TForm1.Frame11Button4Click(Sender: TObject);
begin
  Frame21.Visible := True;
  Frame11.Visible := False;
end;

procedure TForm1.Frame21Button1Click(Sender: TObject);
begin
  Frame11.Visible := True;
  Frame21.Visible := False;
end;

procedure TForm1.Frame21Button2Click(Sender: TObject);
begin
  Frame31.Visible := True;
  Frame21.Visible := False;
end;

procedure TForm1.Frame31Button2Click(Sender: TObject);
begin
  Frame21.Visible := True;
  Frame31.Visible := False;
end;

end.
