unit Interface_PROJECT;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Edit;

type
  TForm1 = class(TForm)
    ������������: TImage;
    ���������: TImage;
    ��������������������X: TFloatAnimation;
    ��������������������Y: TFloatAnimation;
    ���������: TImage;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    ������������: TImage;
    FloatAnimation3: TFloatAnimation;
    FloatAnimation4: TFloatAnimation;
    ����������������: TLabel;
    ������������: TImage;
    �����: TLabel;
    ���������: TEdit;
    ShadowEffect1: TShadowEffect;
    procedure ���������Click(Sender: TObject);
    procedure ���������Click(Sender: TObject);
    procedure ������������Click(Sender: TObject);
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
  ������������.Visible := True; // ��������� ����� �����
  ������������.Visible := False; // ������ �������� ���� ��������
  ����������������.Text := '';
end;


procedure TForm1.���������Click(Sender: TObject);
begin
  UpdatePlayerCount(2);

end;

procedure TForm1.���������Click(Sender: TObject);
begin
    UpdatePlayerCount(3);
end;

procedure TForm1.������������Click(Sender: TObject);
begin
  UpdatePlayerCount(4);
end;

procedure TForm1.UpdatePlayerCount(PlayerCount: Integer);
begin
  ����������������.Text := PlayerCount.ToString;
  ������������.Visible := False; // ������ ����� �������
  ������������.Visible := True; // �������� ����� ���������
end;


end.

