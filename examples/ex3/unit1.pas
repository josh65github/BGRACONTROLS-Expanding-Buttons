unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ColorBox,
  ExtCtrls, ComCtrls, BCExpandingButton;

type

  { TExample3 }

  TExample3 = class(TForm)
    btn_Horiz: TBCExpandingButton;
    btn_Horiz_left: TBCExpandingButton;
    btn_Vert: TBCExpandingButton;
    btn_Horiz_Right: TBCExpandingButton;
    btn_VertUp: TBCExpandingButton;
    chk_autoexpand: TCheckBox;
    lb_square: TLabel;
    lb_maxsize: TLabel;
    chk_Close: TCheckBox;
    chk_callout: TCheckBox;
    chk_updatecaption: TCheckBox;
    chk_square: TCheckBox;
    lb_auto: TLabel;
    lb_close: TLabel;
    lb_callout: TLabel;
    lb_upcaption: TLabel;
    lb_captions: TLabel;
    lb_answers: TLabel;
    lb_buthints: TLabel;
    memo_Captions: TMemo;
    memo_Answers: TMemo;
    memo_Hints: TMemo;
    lower_panel: TPanel;
    btns_panel: TPanel;
    main_panel: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    tb_panelsize: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure chk_autoexpandChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memo_CaptionsEditingDone(Sender: TObject);
    procedure lower_panelPaint(Sender: TObject);
  private

  public
    procedure UpdateMyButton(var Abutton:TBCExpandingButton);
    procedure UpdateParams;
  end;

var
  Example3: TExample3;

implementation

{$R *.lfm}

{ TExample3 }

Procedure  TExample3.UpdateParams;
begin
  UpdateMyButton(btn_Horiz);
  UpdateMyButton(btn_Vert);
  UpdateMyButton(btn_Horiz_left);
  UpdateMyButton(btn_Horiz_Right);
  UpdateMyButton(btn_VertUp);
end;

procedure TExample3.UpdateMyButton(var Abutton:TBCExpandingButton);

begin
  with Abutton as TBCExpandingButton do
  begin
    ExpandingButOptions.ButtonCSVCaptions:=memo_Captions.text;
    ExpandingButOptions.ButtonCSVAnswers:=memo_Answers.text;
    ExpandingButOptions.ButtonCSVHints:=memo_Hints.text;
    ExpandingButOptions.AutoExpand:=chk_autoexpand.Checked;
    ExpandingButOptions.CloseOnSelection:=chk_Close.Checked;
    if chk_callout.Checked then ExpandingButOptions.PanelStyle:=styCallout
    else  ExpandingButOptions.PanelStyle:=styHeaded;
    ExpandingButOptions.UpdateCaptionWithAnswer:=chk_updatecaption.Checked;
    if chk_square.Checked then ExpandingButOptions.ButtonStyle:=btnSquare
    else  ExpandingButOptions.ButtonStyle:=btnOriginal;
    ExpandingButOptions.PanelMaxWidth:=tb_panelsize.Position;
  end;
end;

procedure TExample3.Button1Click(Sender: TObject);
begin
  UpdateParams;
end;

procedure TExample3.chk_autoexpandChange(Sender: TObject);
begin
  UpdateParams;
end;

procedure TExample3.FormCreate(Sender: TObject);
begin
  memo_Captions.Text:='"Button A","Button B","Button C","Button D","Button E","Button F","Button G","Button H","Button I"';
  memo_Answers.Text:='"Answer A","Answer B","Answer C","Answer D","Answer E","Answer F","Answer G","Answer H","Answer I"';
  memo_Hints.Text:='"Hint A","Hint B","Hint C","Hint D","Hint E","Hint F","Hint G","Hint H","Hint I"';
  UpdateParams;
end;

procedure TExample3.memo_CaptionsEditingDone(Sender: TObject);
var s1,s2,s3:AnsiString;
begin
  // verify if text are valid
  s1:=memo_Captions.Text;
  s2:=memo_Answers.Text;
  s3:=memo_Hints.Text;
  if not btn_Horiz.VerifyCSVString(s1) then
  begin
    showmessage('Caption text is not valid');
  end
  else
  if not btn_Horiz.VerifyCSVString(s2) then
  begin
    showmessage('Anser text is not valid');
  end
  else
  if not btn_Horiz.VerifyCSVString(s3) then
  begin
    showmessage('Hint text is not valid');
  end
  else
  begin
    memo_Captions.Text:=s1;
    memo_Answers.Text:=s2;
    memo_Hints.Text:=s3;

    UpdateParams;
  end;
end;

procedure TExample3.lower_panelPaint(Sender: TObject);
const z=16;
      c1:tcolor=$001B1B1B;
      c2:tcolor=$00555500;
var x,y:longint;
    c:tcolor;
    f:boolean=false;
    g:boolean=false;
begin
  x:=0;
  y:=0;
  with tpanel(sender).Canvas do
  begin
    Brush.Style:=bsSolid;
    repeat
      f:=g;
      repeat
        if f then Brush.Color:=c2 else Brush.Color:=c1;
        Ellipse(x,y,x+z,y+z);
        inc(x,z);
        f:=not f;
      until x>tpanel(sender).Width;
      x:=0;
      inc(y,z);
      g:=not g;
    until y>tpanel(sender).Height;
  end;
end;

end.

