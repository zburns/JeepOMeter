// JeepOMeter by Zachary Burns //

unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Sensors,
  System.Sensors.Components, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, Math, DateUtils, FMX.Media, System.IOUtils, FMX.Edit,
  FMX.EditBox, FMX.SpinBox;

type
  TForm1 = class(TForm)
    Image1: TImage;
    LabelBigRate: TLabel;
    LocationSensor1: TLocationSensor;
    LabelTitle: TLabel;
    Panel1: TPanel;
    Longitude: TLabel;
    Latitude: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelTime: TLabel;
    LabelDistance: TLabel;
    LabelRate: TLabel;
    MediaPlayer1: TMediaPlayer;
    Panel2: TPanel;
    Label5: TLabel;
    SpinBox1: TSpinBox;
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  lasttime: TDateTime;
  updatedots: Integer;
  currimage: String;

implementation

{$R *.fmx}

procedure TForm1.FormShow(Sender: TObject);
begin
  currimage:='JpgImage_1';
  updatedots := 0;
  lasttime := System.SysUtils.Now;
  LabelTime.Text:=System.SysUtils.TimeToStr(lasttime);
  MediaPlayer1.FileName := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath) + 'toofast.mp3';
end;


procedure TForm1.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
var
  Rate: Double;
begin

  //Get New Lat and Lon
  Latitude.Text := Format('%n', [NewLocation.Latitude]);
  Longitude.Text := Format('%n', [NewLocation.Longitude]);

  //Get Speed and convert to miles per hour instead of meters per second
  Rate:=RoundTo(LocationSensor1.Sensor.Speed * 2.23694, 0);

  if (Rate > SpinBox1.Value) then
    begin
      labelBigRate.FontColor:=TAlphaColors.Red;
      labelBigRate.Text:=Rate.ToString();
      if (MediaPlayer1.State = TMediaState.Stopped) then
          MediaPlayer1.Play;
    end
  else if (Rate < 0) then
    begin
      MediaPlayer1.Stop;
      labelBigRate.FontColor:=TAlphaColors.Black;
      labelBigRate.Text:='0';
    end
  else
    begin
      MediaPlayer1.Stop;
      labelBigRate.FontColor:=TAlphaColors.Black;
      labelBigRate.Text:=Rate.ToString();
    end;
end;

procedure TForm1.Image1Click(Sender: TObject);
var
    InStream: TResourceStream;
begin
  if (currimage='JpgImage_1') then
     currimage:='JpgImage_2'
  else if (currimage='JpgImage_2') then
       currimage:='JpgImage_3'
  else if (currimage='JpgImage_3') then
       currimage:='JpgImage_4'
  else
     currimage:='JpgImage_1';

  InStream := TResourceStream.Create(HInstance, currimage, RT_RCDATA);
  try
    Image1.Bitmap:=TBitmap.CreateFromStream(InStream);
  finally
    InStream.Free;
  end;
end;

end.
