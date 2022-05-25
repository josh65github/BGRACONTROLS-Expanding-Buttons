unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  BCExpandingButton;

type

  { TForm1 }

  TForm1 = class(TForm)
    BCExpandingButton1: TBCExpandingButton;
    BCExpandingButton2: TBCExpandingButton;
    BCExpandingButton3: TBCExpandingButton;
    BCExpandingButton4: TBCExpandingButton;
    BCExpandingButton5: TBCExpandingButton;
    BCExpandingButton6: TBCExpandingButton;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure BCExpandingButton1MouseLeave(Sender: TObject);
    procedure BCExpandingButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BCExpandingButton1SelectionChanged(Sender: TObject; Value: Integer
      );
    procedure BCExpandingButton2SelectionChanged(Sender: TObject; Value: Integer
      );
    procedure BCExpandingButton3SelectionChanged(Sender: TObject; Value: Integer
      );
    procedure BCExpandingButton4SelectionChanged(Sender: TObject; Value: Integer
      );
    procedure BCExpandingButton5SelectionChanged(Sender: TObject; Value: Integer
      );
  private

  public
     procedure updatelabels(l1,l2:TLabel;T1,T2:String);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.updatelabels(l1,l2:TLabel;T1,T2:String);
begin
  l1.Caption:=t1;
  l2.Caption:=t2;
end;

procedure TForm1.BCExpandingButton1SelectionChanged(Sender: TObject;
  Value: Integer);
begin
  updatelabels(label1,label2,TBCExpandingButton(sender).ExpandingButOptions.Selected.ToString,TBCExpandingButton(sender).ExpandingButOptions.answertext);
end;

procedure TForm1.BCExpandingButton1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.BCExpandingButton1MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.BCExpandingButton2SelectionChanged(Sender: TObject;
  Value: Integer);
begin
  updatelabels(label3,label4,TBCExpandingButton(sender).ExpandingButOptions.Selected.ToString,TBCExpandingButton(sender).ExpandingButOptions.answertext);
end;

procedure TForm1.BCExpandingButton3SelectionChanged(Sender: TObject;
  Value: Integer);
begin
  updatelabels(label5,label6,TBCExpandingButton(sender).ExpandingButOptions.Selected.ToString,TBCExpandingButton(sender).ExpandingButOptions.answertext);
end;

procedure TForm1.BCExpandingButton4SelectionChanged(Sender: TObject;
  Value: Integer);
begin
  updatelabels(label7,label8,TBCExpandingButton(sender).ExpandingButOptions.Selected.ToString,TBCExpandingButton(sender).ExpandingButOptions.answertext);
end;

procedure TForm1.BCExpandingButton5SelectionChanged(Sender: TObject;
  Value: Integer);
begin
  updatelabels(label9,label10,TBCExpandingButton(sender).ExpandingButOptions.Selected.ToString,TBCExpandingButton(sender).ExpandingButOptions.answertext);
end;


end.

