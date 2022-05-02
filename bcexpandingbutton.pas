// SPDX-License-Identifier: LGPL-3.0-linking-exception
{ Written in 2022 by User Josh on Lazarus Forum.

  Expanding button, that creates on the fly buttons to create selections,
  various styles callout
  button captions, answers and hints are in a csv line of text.
  callout can be above, below, or auto
  layout can be horizontal or vertical.
  a border can be set arount the callout buttons, and also around the calling button.


  This Component uses the BGRABITMAP and BGRACONTROLS Framework to implement
  the Button's Functionality
}


unit BCExpandingButton;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,{ SysUtils,} LResources, Forms, Controls, Graphics,BCPanel, Dialogs,BCButton, BCTypes,BGRABitmap,BGRABitmapTypes, BGRAShape;

const SubButtonName='_SubButton_';
      SubButtonPanelName=SubButtonName+'Panel';
      SubButtonPanelShapeName=SubButtonName+'Panel_Shape';
      SubButtonOuterShapeName=SubButtonName+'Outer_Shape';

type
  TBCExpandedButtonAllignStyle = (alLeft,alRight,alCenter);
  TBCExpandedButtonStyle = (btnOriginal,btnSquare);
  TBCExpandedButtonLayout = (layHorizontal,layVertical);
  TBCExpandedPanelStyle = (styBox,styHeaded,StyCallOut);
  TBCExpandedCallOutPosition = (StyAbove,styBelow,StyAuto);
  TBCExpandedButtonSelectionChangedEvent = procedure(Sender: TObject; Value: Integer) of object;
  TBCExpandingButtonOptions = class(TPersistent)
  private
    FDelimeter:String;
    FQuestions,FAnswers,FHints:String;
    FBorderWidth:integer;
    FButtonGap:Integer;
    FButtonHeight:Integer;
    FButtonWidth:Integer;
    FMaxWidth:Integer;
    FCloseOnSelection:Boolean;
    FAlignPanel:TBCExpandedButtonAllignStyle;
    FSubButtonStyle:TBCExpandedButtonStyle;
    FSubButtonLayout:TBCExpandedButtonLayout;
    FPanelColor,FPanelBorderColor,FPanelShadowColor:TColor;
    FPanelStyleCallOutPosition:TBCExpandedCallOutPosition;
    FPanelStyle:TBCExpandedPanelStyle;
    FPanelStyleCallOutHeight:Integer;
    FPanelShadow:Boolean;
    FPanelShadowSize:Integer;
    FPanelOpacity:Byte;
    FCustomState:Boolean;
    FCallOutPositionTop:Boolean;
    FUpdateCaptionWithAnswer:Boolean;
    FCustomStateNormal,FCustomStateClicked,FCustomStateHover:TBCButtonState;
  public
    procedure setFCustomState(const AValue: boolean);
    procedure setFCustomStateNormal(const AValue: TBCButtonState);
    procedure setFCustomStateClicked(const AValue: TBCButtonState);
    procedure setFCustomStateHover(const AValue: TBCButtonState);
    procedure setFDelimeter(const AValue: string);
    procedure setFQuestions(const AValue: string);
    procedure setFAnswers(const AValue: string);
    procedure setFHints(const AValue: string);
    procedure setFBorderWidth(const AValue: Integer);
    procedure setFButtonGap(const AValue: Integer);
    procedure setFButtonHeight(const AValue: Integer);
    procedure setFButtonWidth(const AValue: Integer);
    procedure setFMaxWidth(const AValue: Integer);
    procedure SetFCloseOnSelection(const AValue: Boolean);
    procedure setFPanelColor(const AValue:TColor);
    procedure setFPanelOpacity(const AValue:Byte);
    procedure setFPanelBorderColor(const AValue:TColor);
    procedure setFPanelStyle(const AValue:TBCExpandedPanelStyle);
    procedure setFPanelStyleCallOutHeight(const AValue:Integer);
    procedure setFPanelShadow(const AValue:Boolean);
    procedure setFPanelShadowSize(const AValue:Integer);
    procedure setFPanelShadowColor(const AValue:TColor);
    procedure setFUpdateCaptionWithAnswer(const AValue:Boolean);
    procedure setFAlignPanel(const AValue:TBCExpandedButtonAllignStyle);
    procedure setFSubButtonStyle(const AValue:TBCExpandedButtonStyle);
    procedure setFPanelStyleCallOutPosition(const AValue:TBCExpandedCallOutPosition);
    procedure setFSubButtonLayout(const AValue:TBCExpandedButtonLayout);
    procedure Assign(Source: TPersistent); override;
  published
    {Delimeter used to split button questions, answers and hints, ie ","}
    Property ButtonCSVDelimterString : String Read FDelimeter Write setFDelimeter;
    {CSV list of Button Texts ie "Button 1","Button 2"}
    Property ButtonCSVQuestions : String Read FQuestions Write setFQuestions;
    {CSV list of Button Answers ie "Button 1","Button 2"}
    Property ButtonCSVAnswers : String Read FAnswers Write setFAnswers;
    {CSV list of Button Hints  ie "Button 1 hint message","Button 2 hint message"}
    Property ButtonCSVHints : String Read FHints Write setFHints;
    {Width of the border arounf the Panel}
    Property PanelBorderWidth : Integer Read FBorderWidth Write setFBorderWidth;
    {Gap in pixels between each button}
    Property ButtonGap : Integer Read FButtonGap Write setFButtonGap;
    {Height of the Generated Buttons}
    Property ButtonHeight : Integer Read FButtonHeight Write setFButtonHeight;
    {Width of the Generated Buttons}
    Property ButtonWidth : Integer Read FButtonWidth Write setFButtonWidth;
    {Maximum size of the Panel to hold buttons}
    Property PanelMaxWidth : Integer Read FMaxWidth Write setFMaxWidth;
    {Set to true to make the panel close on clicking of a button}
    property CloseOnSelection: Boolean read FCloseOnSelection write setFCloseOnSelection;
    {Allows you to Allign the Exapnding Panel, to the Left,Right or Center of The Button}
    property PanelAllign: TBCExpandedButtonAllignStyle read FAlignPanel write setFAlignPanel;
    {btnOriginal buttons shape same as original, btnSquare the created buttons have square corners}
    property ButtonStyle: TBCExpandedButtonStyle read FSubButtonStyle write setFSubButtonStyle;
    {buttons are either created horizontal or vertical}
    property ButtonLayout: TBCExpandedButtonLayout read FSubButtonLayout write setFSubButtonLayout;
    {Color of the panel holding the Buttons}
    property PanelColor: TColor Read FPanelColor Write setFPanelColor;
    {Opacity of the panel holding the Buttons}
    property PanelOpacity: Byte Read FPanelOpacity Write setFPanelOpacity;
    {Color of the Border around the Panel}
    property PanelBorderColor: TColor Read FPanelBorderColor Write setFPanelBorderColor;
    {Allows you to have custom normal,hover and clicked states for the buttons}
    property CustomState: Boolean Read FCustomState Write setFCustomState;
    {Custom StateNormal parameters}
    property CustomStateNormal:TBCButtonState Read FCustomStateNormal Write setFCustomStateNormal;
    {Custom StateClicked parameters}
    property CustomStateClicked:TBCButtonState Read FCustomStateClicked Write setFCustomStateClicked;
    {Custom StateHover parameters}
    property CustomStateHover:TBCButtonState Read FCustomStateHover Write setFCustomStateHover;
    {Style of Panel (styBox,styHeaded,StyCallOut)}
    property PanelStyle:TBCExpandedPanelStyle Read FPanelStyle Write setFPanelStyle;
    {Height of the Callout when PanStyle=StyCallOut}
    property PanelStyleCallOutHeight:Integer Read FPanelStyleCallOutHeight Write setFPanelStyleCallOutHeight;
    {Allows you to specify the callout positiio (StyAbove,styBelow,StyAuto)}
    property PanelStyleCalloutPosition:TBCExpandedCallOutPosition read FPanelStyleCallOutPosition Write setFPanelStyleCallOutPosition;
    {Draw a Shadow around the Panel}
    property PanelShadow:Boolean Read FPanelShadow Write setFPanelShadow;
    {Color of the Shadow for the panel}
    property PanelShadowColor:TColor Read FPanelShadowColor Write setFPanelShadowColor;
    {Size of the Panel Shadow in pixels}
    property PanelShadowSize:Integer Read FPanelShadowSize Write setFPanelShadowSize;
    property UpdateCaptionWithAnswer:boolean read FUpdateCaptionWithAnswer write SetFUpdateCaptionWithAnswer;
  end;

  TBCExpandingButton = class(TBCButton)
  private
    FOwner: TComponent;
    FButtonHoldingPanel:tbcpanel;
    FHowManyButtons:integer;
    FSelected:Integer;
    FAnswerText:String;
    FBackGroundBmp:tbitmap;
    FButtonQuestions,FButtonAnswers,FButtonHints:Array of AnsiString;
    FExpandingButtonOptions: TBCExpandingButtonOptions;
    FOnButtonClick: TNotifyEvent;
    FOnSelectionChange: TBCExpandedButtonSelectionChangedEvent;
    procedure SetExpandingButtonOptions(Value: TBCExpandingButtonOptions);
    procedure expandoptions;
    function IntToStringZeroPad(av,le:Integer):String;
    function MyIntToStr(AValue:Integer):String;
    function MyStrToIntDef(AValue:string;adef:integer):integer;
    procedure SubButtonOnClick(Sender:TObject);
    procedure SetSelectedAsDown;
    procedure GenerateControl;
    procedure CloseCode;
    procedure BCPanelAfterRender(Sender: TObject; const ABGRA: TBGRABitmap; ARect: TRect);
  protected
    function countdelimeters(var st:ansistring):Integer;
    procedure stringtoarray(var SA:Array of AnsiString;St:AnsiString;GenerateText:Boolean);
    function GetOwnerForm(AComponent: TComponent): TCustomForm;
    procedure FFreeAndNil(var obj);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;MX, MY: integer); override;
    procedure ButMouseDown(Button: TMouseButton; Shift: TShiftState; MX, MY: integer);
    function TBCChangeColor(AColor:TColor; Lighten: Boolean; n: integer): TColor;
  public
    procedure setFSelected(const AValue: Integer);
    procedure setFAnswerText(const AValue: String);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure paint; override;
  published
    property ExpandingButOptions: TBCExpandingButtonOptions read FExpandingButtonOptions write SetExpandingButtonOptions;
    Property Selected : Integer Read FSelected Write setFSelected;
    {Will Hold the text of the answer when button clicked}
    Property AnswerText: String Read FAnswerText Write setFAnswerText;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property ParentColor;
    property PopupMenu;
    property OnSelectionChanged: TBCExpandedButtonSelectionChangedEvent read FOnSelectionChange write FOnSelectionChange;
  end;


procedure Register;

implementation

procedure TBCExpandingButton.Assign(Source: TPersistent);
begin
  if Source is TBCExpandingButton then
  begin
    FSelected:=TBCExpandingButton(source).Selected;
  end
  else inherited;
end;

procedure TBCExpandingButtonOptions.Assign(Source: TPersistent);
begin
  if Source is TBCExpandingButtonOptions then
  begin
    with TBCExpandingButtonOptions(Source) do
    begin
      FDelimeter :=ButtonCSVDelimterString;
      FQuestions := ButtonCSVQuestions;
      FAnswers := ButtonCSVAnswers;
      FHints := ButtonCSVHints;
      FBorderWidth := PanelBorderWidth;
      FButtonGap:=ButtonGap;
      FButtonHeight := ButtonHeight;
      FButtonWidth := ButtonWidth;
      FMaxWidth := PanelMaxWidth;
      FCloseOnSelection := CloseOnSelection;
      FAlignPanel := PanelAllign;
      FSubButtonStyle := ButtonStyle;
      FSubButtonLayout := ButtonLayout;
      FPanelBorderColor := PanelBorderColor;
      FPanelColor := PanelColor;
      FPanelOpacity := PanelOpacity;
      FCustomState:= CustomState;
      FCustomStateNormal:= CustomStateNormal;
      FCustomStateClicked:= CustomStateClicked;
      FCustomStateHover:= CustomStateHover;
      FPanelStyle:=PanelStyle;
      FPanelStyleCallOutHeight:=PanelStyleCallOutHeight;
      FPanelShadow:=PanelShadow;
      FPanelShadowColor:=PanelShadowColor;
      FPanelShadowSize:=PanelShadowSize;
      FPanelStyleCallOutPosition:=PanelStyleCalloutPosition;
      FUpdateCaptionWithAnswer:=UpdateCaptionWithAnswer;
    end;
  end
  else inherited Assign(Source);
end;

Constructor TBCExpandingButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOwner := AOwner;
  FExpandingButtonOptions:=TBCExpandingButtonOptions.Create;
  with FExpandingButtonOptions do
  begin
    FBorderWidth:=2;
    FButtonHeight:=24;
    FButtonGap:=4;
    FButtonWidth:=120;
    FMaxWidth:=600;
    fdelimeter:='","';
    FAlignPanel:=AlLeft;
    FPanelColor:=$00755435;
    FPanelBorderColor:=$00ffffff;
    FPanelOpacity:=255;
    FSubButtonStyle:=btnOriginal;
    FSubButtonLayout:=layHorizontal;
    FCloseOnSelection:=False;
    PanelShadow:=True;
    PanelShadowColor:=clGray;
    FPanelShadowSize:=4;
    PanelStyle:=styHeaded;
    PanelStyleCallOutHeight:=10;
    PanelStyleCalloutPosition:=styAuto;
    FCustomStateNormal:= self.StateNormal;
    FCustomStateClicked:= self.StateClicked;
    FCustomStateHover:= self.StateHover;
    FUpdateCaptionWithAnswer:=false;
  end;
  FSelected:=0;
  FAnswerText:='';
end;

destructor TBCExpandingButton.Destroy;
begin
  if assigned(FButtonHoldingPanel) then
  begin
    ffreeandnil(FBackGroundBmp);
    FButtonHoldingPanel.Visible:=false;
    FButtonHoldingPanel.Invalidate;
    FButtonHoldingPanel.Update;
    ffreeandnil(FButtonHoldingPanel);
  end;
  FExpandingButtonOptions.Free;
  inherited Destroy;
end;

function TBCExpandingButton.TBCChangeColor(AColor:TColor; Lighten: Boolean; n: integer): TColor;
var
  r,g,b: integer;

function minmax(avalue,amin,amax:integer):byte;
begin
  if avalue<amin then avalue:=amin;
  if avalue>amax then avalue:=amax;
  result:=byte(avalue);
end;

begin
  if n<1 then exit(AColor);
  AColor:=ColorToRGB (AColor);
  R := AColor and $ff;
  G := (AColor shr 8) and $ff;
  B := (AColor shr 16) and $ff;
  if Lighten then
  begin
    r:=r+round((r*n)/100);
    g:=g+round((g*n)/100);
    b:=b+round((b*n)/100);
  end
  else
  begin
    r:=r-round((r*n)/100);
    g:=g-round((g*n)/100);
    b:=b-round((b*n)/100);
  end;
  Result := minmax(r,0,255) or (minmax(g,0,255) shl 8) or (minmax(b,0,255) Shl 16);
end;

procedure TBCExpandingButton.FFreeAndNil(var obj);
var
  temp: tobject;
begin
  temp:=tobject(obj);
  pointer(obj):=nil;
  temp.free;
end;

procedure TBCExpandingButtonOptions.setFPanelShadowSize(const AValue:Integer);
begin
  if FPanelShadowSize<> AValue then FPanelShadowSize:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelStyleCallOutPosition(const AValue:TBCExpandedCallOutPosition);
begin
  if FPanelStyleCallOutPosition<> AValue then FPanelStyleCallOutPosition:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelStyleCallOutHeight(const AValue: Integer);
begin
  if FPanelStyleCallOutHeight<> AValue then FPanelStyleCallOutHeight:=AValue;
end;

procedure TBCExpandingButtonOptions.setFUpdateCaptionWithAnswer(const AValue: Boolean);
begin
  if FUpdateCaptionWithAnswer<> AValue then FUpdateCaptionWithAnswer:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelShadow(const AValue: boolean);
begin
  if FPanelShadow<> AValue then FPanelShadow:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelShadowColor(const AValue: TColor);
begin
  if FPanelShadowColor<> AValue then FPanelShadowColor:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelStyle(const AValue: TBCExpandedPanelStyle);
begin
  if FPanelStyle<> AValue then FPanelStyle:=AValue;
end;

procedure TBCExpandingButtonOptions.setFCustomState(const AValue: boolean);
begin
  if FCustomState<> AValue then FCustomState:=AValue;
end;

procedure TBCExpandingButtonOptions.setFCustomStateNormal(const AValue: TBCButtonState);
begin
  if FCustomStateNormal<> AValue then FCustomStateNormal:=AValue;
end;

procedure TBCExpandingButtonOptions.setFCustomStateClicked(const AValue: TBCButtonState);
begin
  if FCustomStateClicked<> AValue then FCustomStateClicked:=AValue;
end;

procedure TBCExpandingButtonOptions.setFCustomStateHover(const AValue: TBCButtonState);
begin
  if FCustomStateHover<> AValue then FCustomStateHover:=AValue;
end;

procedure TBCExpandingButtonOptions.setFCloseOnSelection(const AValue:Boolean);
begin
  if FCloseOnSelection<> AValue then FCloseOnSelection:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelColor(const AValue:TColor);
begin
  if FPanelColor<> AValue then FPanelColor:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelBorderColor(const AValue:TColor);
begin
  if FPanelBorderColor<> AValue then FPanelBorderColor:=AValue;
end;

procedure TBCExpandingButtonOptions.setFPanelOpacity(const AValue:Byte);
begin
  if FPanelOpacity<> AValue then FPanelOpacity:=AValue;
end;

procedure TBCExpandingButtonOptions.setFAlignPanel(const AValue:TBCExpandedButtonAllignStyle);
begin
  if FAlignPanel<> AValue then FAlignPanel:=AValue;
end;

procedure TBCExpandingButtonOptions.setFSubButtonStyle(const AValue:TBCExpandedButtonStyle);
begin
  if FSubButtonStyle<> AValue then FSubButtonStyle:=AValue;
end;

procedure TBCExpandingButtonOptions.setFSubButtonLayout(const AValue:TBCExpandedButtonLayout);
begin
  if FSubButtonLayout<> AValue then FSubButtonLayout:=AValue;
end;

function TBCExpandingButton.IntToStringZeroPad(av,le:Integer):String;
begin
  result:=myinttostr(av);
  while length(result)<le do result:='0'+result;
end;

function TBCExpandingButton.MyIntToStr(AValue:Integer):String;
var digits:shortstring='0123456789';
    sgn:Boolean;
begin
  result:='';
  sgn:=AValue<0;
  if AValue>=10 then
  begin
    repeat
      result:=digits[(AValue mod 10)+1]+result;
      AValue:=AValue div 10;
    until AValue<10;
  end;
  result:=digits[(AValue mod 10)+1]+result;
  if sgn then result:='-'+result;
end;

function TBCExpandingButton.MyStrToIntDef(AValue:string;adef:integer):integer;
var i:integer;
    s:string='';
    mulply:integer=1;
    v:integer;
begin
  result:=0;
  // validate and remove spaces
  for i:=1 to length(AValue) do
  begin
    if AValue[i] in ['0','1','2','3','4','5','6','7','8','9','-'] then s:=s+avalue[i]
    else
      if Avalue[i]<>' ' then
      begin
        exit(adef);
      end;
  end;
  if AValue='' then exit;
  for i:=length(AValue) downto 1 do
  begin
    v:=ord(AValue[i]);
    if ((v>=48) and (V<=57)) then
    begin
      // number
      result:=result+((v-48)*mulply);
      mulply:=mulply*10;
    end
      else
      if AValue[i]=' ' then
      begin
      end
       else
       if ((AValue[i]='-') and (i=1)) then result:=-1*result
         else
         begin
           result:=adef;
           break;
         end;
  end;
  begin
    result:=result;
  end;
end;


function TBCExpandingButton.countdelimeters(var st:ansistring):Integer;
var c:integer=1;
    dl:integer;
begin
  result:=0;
  if st='' then exit;
  result:=0;
  dl:=length(FExpandingButtonOptions.fdelimeter);
  for c:= 1 to length(st)-dl+1 do if copy(st,c,dl)=FExpandingButtonOptions.fdelimeter then inc(result)
end;

procedure TBCExpandingButton.stringtoarray(var SA:Array of AnsiString;St:AnsiString;GenerateText:Boolean);
var I_cnt,C_cnt:Integer;
    s:ansistring;
begin
  s:='';
  if st<>'' then
  begin
    C_cnt:=0;
    I_cnt:=2;
    while I_cnt< length(st) do
    begin
      if copy(st,I_cnt,length(FExpandingButtonOptions.fdelimeter))=FExpandingButtonOptions.fdelimeter then
      begin
        sa[C_cnt]:=s;
        inc(C_cnt);
        s:='';
        inc(I_cnt,2);
      end
      else s:=s+st[I_cnt];
      inc(I_cnt);
      if C_cnt>FHowManyButtons then exit;
    end;
    sa[C_cnt]:=s;
  end
  else
  begin
    if GenerateText then for I_cnt:=0 to FHowManyButtons do SA[I_cnt]:=MyIntToStr(I_cnt);
  end;
  if C_Cnt<>FHowManyButtons then
  begin
    if GenerateText then for I_cnt:=C_Cnt to FHowManyButtons do SA[I_cnt]:=MyIntToStr(I_cnt);
  end;
end;

function TBCExpandingButton.GetOwnerForm(AComponent: TComponent): TCustomForm;
var AOwner: TComponent;
begin
  Result := nil;
  if Assigned(AComponent) then
  begin
    if (AComponent is TCustomForm) then
      Result := TCustomForm(AComponent)
    else
    begin
      AOwner := AComponent;
      repeat
        AOwner := AOwner.Owner;
      until (AOwner = nil) or (AOwner is TCustomForm);
      if Assigned(AOwner) then
        Result := TCustomForm(AOwner);
    end;
  end;
end;


procedure TBCExpandingButton.Paint;
begin
  inherited Paint;
end;

procedure TBCExpandingButton.SubButtonOnClick(Sender:TObject);
var v:integer;
    na:string;
begin
  na:=TBCButton(Sender).Name;
  v:=MyStrToIntDef(copy(na,length(na)-3,4),-999);
  if v>=0 then
  begin
    if FButtonAnswers[v]<>'' then AnswerText:=FButtonAnswers[v]
    else AnswerText:=FButtonQuestions[v];
    Selected:=v;
    SetSelectedAsDown;
    update;
  end;

  if assigned(self.OnSelectionChanged) then OnSelectionChanged(self,FSelected);
  if FExpandingButtonOptions.FCloseOnSelection then
  begin
    closecode;
  end;
end;

procedure TBCExpandingButton.SetSelectedAsDown;
var i:integer;
    na:string;
begin
  if FHowManyButtons>0 then
  begin
    for i:=0 to FHowManyButtons do
    begin
      na:=self.Name+SubButtonName+IntToStringZeroPad(i,4);
      tbcbutton(FButtonHoldingPanel.findcomponent(na)).down:=i=FSelected;
    end;
    if FExpandingButtonOptions.FUpdateCaptionWithAnswer then TBCButton(self).Caption:=AnswerText;
  end;
end;

procedure TBCExpandingButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  MX, MY: integer);
begin
  inherited MouseDown(Button, Shift, MX, MY);
  if csDesigning in ComponentState then
    exit;

  if (Button = mbLeft) and Enabled then
  begin
    expandoptions;
  end;
end;

procedure TBCExpandingButton.ButMouseDown(Button: TMouseButton; Shift: TShiftState;
  MX, MY: integer);
begin
  inherited MouseDown(Button, Shift, MX, MY);
  if csDesigning in ComponentState then
    exit;

  if (Button = mbLeft) and Enabled then
  begin

  end;
end;

procedure TBCExpandingButton.setFAnswerText(const AValue: String);
begin
  if FAnswerText<> AValue then FAnswerText:=AValue;
end;

procedure TBCExpandingButton.setFSelected(const AValue: Integer);
begin
  if csDesigning in ComponentState then
  begin
    FSelected:=AValue;
    exit;
  end;
  if FSelected<> AValue then If ((AValue>0) and (AValue<FHowManyButtons)) then FSelected:=AValue;
end;

procedure TBCExpandingButtonOptions.setFMaxWidth(const AValue: Integer);
begin
  if FMaxWidth<> AValue then If ((AValue>0) and (AValue<8000)) then FMaxWidth:=AValue;
end;

procedure TBCExpandingButtonOptions.setFButtonGap(const AValue: Integer);
begin
  if FButtonGap<> AValue then If ((AValue>0) and (AValue<40)) then FButtonGap:=AValue;
end;

procedure TBCExpandingButtonOptions.setFButtonHeight(const AValue: Integer);
begin
  if FButtonHeight<> AValue then If ((AValue>0) and (AValue<1000)) then FButtonHeight:=AValue;
end;

procedure TBCExpandingButtonOptions.setFButtonWidth(const AValue: Integer);
begin
  if FButtonWidth<> AValue then If ((AValue>0) and (AValue<1000)) then FButtonWidth:=AValue;
end;

procedure TBCExpandingButtonOptions.SetFBorderWidth(const AValue: Integer);
begin
  if FBorderWidth<> AValue then If ((AValue>0) and (AValue<100)) then FBorderWidth:=AValue;
end;

procedure TBCExpandingButtonOptions.setFDelimeter(const AValue: string);
begin
  if fdelimeter<> AValue then If AValue<>'' then fdelimeter:=AValue;
end;

procedure TBCExpandingButtonOptions.setFQuestions(const AValue: string);
begin
  if fQuestions<> AValue then If AValue<>'' then fQuestions:=AValue;
end;

procedure TBCExpandingButtonOptions.setFAnswers(const AValue: string);
begin
  if fAnswers<> AValue then If AValue<>'' then fAnswers:=AValue;
end;

procedure TBCExpandingButtonOptions.setFHints(const AValue: string);
begin
  if fhints<> AValue then If AValue<>'' then fhints:=AValue;
end;

procedure TBCExpandingButton.CloseCode;
begin
  if assigned(FButtonHoldingPanel) then
  begin
    self.Down:=false;
    FButtonHoldingPanel.Visible:=false;
    FButtonHoldingPanel.Invalidate;
    self.Update;
    ffreeandnil(FBackGroundBmp);
    ffreeandnil(FButtonHoldingPanel);
  end;
end;

procedure TBCExpandingButton.BCPanelAfterRender(Sender: TObject; const ABGRA: TBGRABitmap; ARect: TRect);
const calloutdivposition=4;
var HalfBorderWidth,x1,x2,y1,y2,CalloutBubbleX,PanelHeight,PanelWidth,i,yoff:integer;
    pts:array of tpoint;
    offset:integer=0;
    ColorStepPercent:integer=0;
    ystart,yend:integer;

procedure addpoint(i,x,y:integer);
begin
  pts[i].X:=x;
  pts[i].Y:=y;
end;

begin
  PanelHeight:=tbcpanel(sender).height;
  PanelWidth:=tbcpanel(sender).width;
  HalfBorderWidth:=FExpandingButtonOptions.FBorderWidth div 2;
  x1:=HalfBorderWidth;
  x2:=PanelWidth-HalfBorderWidth-1;
  y1:=HalfBorderWidth;
  y2:=PanelHeight-HalfBorderWidth-1;
  if ExpandingButOptions.PanelShadow then
  begin
    //draw shadow
    with FBackGroundBmp.Canvas do
    begin
      offset:=FExpandingButtonOptions.FPanelShadowSize;
      Pen.Style:=psSolid;
      Pen.Width:=1;
      brush.Style:=bsclear;
      yoff:=0;
      if ExpandingButOptions.PanelStyle=styCallout then
        yoff:=ExpandingButOptions.PanelStyleCallOutHeight-ExpandingButOptions.FPanelShadowSize;
      if ExpandingButOptions.FCallOutPositionTop then
      begin
        ystart:=offset+offset;
        yend:=PanelHeight;
      end
      else
      begin
        ystart:=0;
        yend:=PanelHeight-ExpandingButOptions.PanelStyleCallOutHeight;
      end;
      ColorStepPercent:=80 div (offset);
      for i:=0 to offset do
      begin
        Pen.Color:=TBCChangeColor(ExpandingButOptions.FPanelShadowColor,false,(ColorStepPercent*i));
        MoveTo(PanelWidth-i,ystart+yoff);
        Lineto(PanelWidth-i,yend-i);
        Lineto(offset,yend-i);
      end;
    end;
  end else offset:=0;
  with ABGRA.Canvas do
  begin
    Draw(0,0,FBackGroundBmp);
    Pen.Color:=FExpandingButtonOptions.FPanelBorderColor;
    Pen.Style:=psSolid;
    Pen.Width:=FExpandingButtonOptions.FBorderWidth;
    Pen.JoinStyle:=pjsMiter;
    Pen.EndCap:=pecSquare;
  end;
  x1:=HalfBorderWidth;
  x2:=PanelWidth-HalfBorderWidth-1;
  y1:=HalfBorderWidth;
  y2:=PanelHeight-HalfBorderWidth-1;
  if ((FExpandingButtonOptions.FBorderWidth>1) and (x2+HalfBorderWidth<PanelWidth)) then inc(x2);
  if ((FExpandingButtonOptions.FBorderWidth>1) and (y2+HalfBorderWidth<PanelHeight)) then inc(y2);
  if ExpandingButOptions.FPanelStyle<>StyCallOut then
  begin
    with ABGRA.Canvas do
    begin
      brush.Color:=ExpandingButOptions.FPanelColor;
      brush.Style:=bsSolid;
      setlength(pts,5);
      addpoint(0,x1,y1);
      addpoint(1,x2-offset,y1);
      addpoint(2,x2-offset,y2-offset);
      addpoint(3,x1,y2-offset);
      addpoint(4,x1,y1+offset);
      polygon(pts);
    end;
  end
  else
  begin
    // call out panel
    with ABGRA.Canvas do
    begin
      case ExpandingButOptions.PanelAllign of
        alLeft:  begin
                   CalloutBubbleX:=x1+(ExpandingButOptions.ButtonWidth div calloutdivposition)-ExpandingButOptions.FPanelStyleCallOutHeight;
                 end;
        alRight: begin
                   CalloutBubbleX:=PanelWidth-((ExpandingButOptions.ButtonWidth div calloutdivposition)+ExpandingButOptions.FPanelStyleCallOutHeight);
                 end;
        alCenter:begin
                   CalloutBubbleX:=x1+((PanelWidth-offset) div 2)-(ExpandingButOptions.FPanelStyleCallOutHeight);
                 end;
      end;
      brush.Color:=ExpandingButOptions.FPanelColor;
      brush.Style:=bsSolid;
      setlength(pts,8);
      if ExpandingButOptions.FCallOutPositionTop then
      begin
        addpoint(0,x1,y1+ExpandingButOptions.FPanelStyleCallOutHeight);
        addpoint(1,CalloutBubbleX,y1+ExpandingButOptions.FPanelStyleCallOutHeight);
        addpoint(2,CalloutBubbleX+ExpandingButOptions.FPanelStyleCallOutHeight,y1);
        addpoint(3,CalloutBubbleX+ExpandingButOptions.FPanelStyleCallOutHeight+ExpandingButOptions.FPanelStyleCallOutHeight,
                 y1+ExpandingButOptions.FPanelStyleCallOutHeight);
        addpoint(4,x2-offset,y1+ExpandingButOptions.FPanelStyleCallOutHeight);
        addpoint(5,x2-offset,y2-offset);
        addpoint(6,x1,y2-offset);
        addpoint(7,x1,y1+ExpandingButOptions.FPanelStyleCallOutHeight+offset);
      end
      else
      begin
        addpoint(0,x1,y1);
        addpoint(1,x2-offset,y1);
        addpoint(2,x2-offset,y2-ExpandingButOptions.FPanelStyleCallOutHeight-offset);
        addpoint(3,CalloutBubbleX+ExpandingButOptions.FPanelStyleCallOutHeight,y2-ExpandingButOptions.FPanelStyleCallOutHeight-offset);
        addpoint(4,CalloutBubbleX,y2-offset);
        addpoint(5,CalloutBubbleX-ExpandingButOptions.FPanelStyleCallOutHeight,y2-ExpandingButOptions.FPanelStyleCallOutHeight-offset);
        addpoint(6,x1,y2-ExpandingButOptions.FPanelStyleCallOutHeight-offset);
        addpoint(7,x1,y1);
      end;
      polygon(pts);
    end;
  end;
end;

procedure TBCExpandingButton.GenerateControl;
var x,y,i,w:integer;
    ButtonPoint: TPoint;
    PanelX,PanelY,PanelWidth,PanelHeight:Integer;
    TempButton:tbcbutton;
    xstart:integer;
    CalculatingMaxX:integer=0;
    OwnerFormWidth,OwnerFormHeight:integer;
    na:string;
begin
  FBackGroundBmp:=tbitmap.Create;
  ExpandingButOptions.FCallOutPositionTop:=true;
  OwnerFormWidth:=GetOwnerForm(self).Width;
  OwnerFormHeight:=GetOwnerForm(self).height;
  xstart:=FExpandingButtonOptions.FBorderWidth+FExpandingButtonOptions.FButtonGap;
  w:=0;
  ButtonPoint:=self.ClientToParent(TPoint.Create(0,0), GetOwnerForm(self));
  PanelX:=ButtonPoint.X;
  PanelY:=ButtonPoint.Y;
  self.Down:=true;
  FButtonHoldingPanel:=tbcpanel.Create(nil);
  with FButtonHoldingPanel do
  begin
    Parent:=GetOwnerForm(self);
    Background.Color:=FExpandingButtonOptions.FPanelColor;
    Background.ColorOpacity:=255;
    Background.Style:=bbsColor;
    ParentBackground:=false;
    visible:=false;
    BevelOuter:=bvNone;
    Border.Style:=bboNone;
    DoubleBuffered:=true;
    Rounding.RoundX:=1;
    Rounding.RoundY:=1;
    Rounding.RoundOptions:=[rrBottomLeftSquare,rrBottomRightSquare,rrTopLeftSquare,rrTopRightSquare];
    OnAfterRenderBCPanel:=@BCPanelAfterRender;
  end;
  y:=xstart;
  x:=xstart;
  if ExpandingButOptions.FPanelStyle=StyCallOut then y:=y+ ExpandingButOptions.FPanelStyleCallOutHeight;
  FButtonHoldingPanel.Visible:=false;
  FButtonHoldingPanel.Name:=self.Name+SubButtonPanelName;
  FButtonHoldingPanel.Caption:='';
  FButtonHoldingPanel.BeginUpdateBounds;
  for i:=0 to FHowManyButtons do
  begin
    TempButton:=tbcbutton.Create(FButtonHoldingPanel);
    with TempButton do
    begin
      Parent:=FButtonHoldingPanel;
      MemoryUsage:=bmuLow;
      if FExpandingButtonOptions.CustomState then
      begin
        StateClicked:=FExpandingButtonOptions.CustomStateClicked;
        StateHover:=FExpandingButtonOptions.CustomStateHover;
        StateNormal:=FExpandingButtonOptions.CustomStateNormal;
      end
      else
      begin
        StateClicked:=self.StateClicked;
        StateHover:=self.StateHover;
        StateNormal:=self.StateNormal;
      end;
      case FExpandingButtonOptions.FSubButtonStyle of
        btnOriginal:Rounding:=self.Rounding;
        btnSquare  :Begin
                      Rounding.RoundX:=0;
                      Rounding.RoundY:=0;
                    end;
      end;
      SetBounds(x,y,FExpandingButtonOptions.FButtonWidth,FExpandingButtonOptions.FButtonHeight);
      CalculatingMaxX:=x+FExpandingButtonOptions.FButtonWidth;
      Cursor:=self.Cursor;
      Down:=fselected=i;
      Caption:=FButtonQuestions[i];
      OnClick:=@self.SubButtonOnClick;
      visible:=true;
      Hint:=FButtonHints[i];
      ShowHint:=Hint<>'';
      Name:=self.Name+SubButtonName+IntToStringZeroPad(i,4);
      if FExpandingButtonOptions.FSubButtonLayout=layHorizontal then
      begin
        inc(x,FExpandingButtonOptions.FButtonWidth+FExpandingButtonOptions.FButtonGap);
        if x+FExpandingButtonOptions.FButtonWidth>FExpandingButtonOptions.FMaxWidth then
        begin
          x:=xstart;
          if i<>FHowManyButtons then inc(y,FExpandingButtonOptions.FButtonHeight+FExpandingButtonOptions.FButtonGap);
        end;
      end
      else
      begin
        // vertical
        inc(y,FExpandingButtonOptions.FButtonHeight+FExpandingButtonOptions.FButtonGap);
      end;
      if CalculatingMaxX>w then w:=CalculatingMaxX;
    end;
  end;
  if  ExpandingButOptions.PanelShadow then
  begin
    inc(y,FExpandingButtonOptions.FPanelShadowSize);
    inc(w,FExpandingButtonOptions.FPanelShadowSize);
  end;
  if FExpandingButtonOptions.FSubButtonLayout=layHorizontal then inc(y,FExpandingButtonOptions.FButtonHeight)
  else dec(y,FExpandingButtonOptions.FButtonGap);
  //draw outer border
  FButtonHoldingPanel.Invalidate;
  FButtonHoldingPanel.EndUpdateBounds;
  case FExpandingButtonOptions.FAlignPanel of
    alLeft  :begin
               if FExpandingButtonOptions.FPanelStyle=styHeaded then Dec(PanelX,FExpandingButtonOptions.FBorderWidth)
               else Inc(PanelX,0);
             end;
    alRight :begin
               if FExpandingButtonOptions.FPanelStyle=styHeaded then PanelX:=PanelX-w+self.width
               else PanelX:=PanelX-w+self.width;
             end;
    AlCenter:PanelX:=PanelX-((w-self.Width) div 2);
  end;
  if PanelX+w>OwnerFormWidth then PanelX:=OwnerFormWidth-w;
  if PanelX<0 then PanelX:=FExpandingButtonOptions.FBorderWidth;
  // check to see if appears above or below
  case FExpandingButtonOptions.FPanelStyleCallOutPosition of
    styAbove:ExpandingButOptions.FCallOutPositionTop:=false;
    styBelow:ExpandingButOptions.FCallOutPositionTop:=true;
    styAuto :ExpandingButOptions.FCallOutPositionTop:=PanelY+y+SELF.Height+FExpandingButtonOptions.FBorderWidth+FExpandingButtonOptions.FButtonGap<=OwnerFormHeight
  end;
  if ExpandingButOptions.FCallOutPositionTop=false then
  begin
    PanelY:=PanelY-y-FExpandingButtonOptions.FBorderWidth-FExpandingButtonOptions.FButtonGap;
    if FExpandingButtonOptions.FPanelStyle=StyCallOut then
    begin;
      // move buttons up
      for i:=0 to FHowManyButtons do
      begin
        na:=self.Name+SubButtonName+IntToStringZeroPad(i,4);
        tbcbutton(FButtonHoldingPanel.findcomponent(na)).Top:=tbcbutton(FButtonHoldingPanel.findcomponent(na)).top-FExpandingButtonOptions.FPanelStyleCallOutHeight;
      end;
    end;
  end
  else PanelY:=PanelY+SELF.Height;
  PanelWidth:=w+FExpandingButtonOptions.FButtonGap+FExpandingButtonOptions.FBorderWidth;
  PanelHeight:=y+FExpandingButtonOptions.FButtonGap+FExpandingButtonOptions.FBorderWidth;
  FButtonHoldingPanel.SetBounds(PanelX,PanelY+1,PanelWidth,PanelHeight);
  FBackGroundBmp.SetSize(PanelWidth, PanelHeight);
  FBackGroundBmp.Canvas.CopyRect(Rect(0,0,PanelWidth,PanelHeight),
                                 GetOwnerForm(self).Canvas, rect(PanelX,PanelY+1,PanelX+PanelWidth,PanelY+1+PanelHeight));
  FButtonHoldingPanel.Visible:=true;
end;

procedure TBCExpandingButton.SetExpandingButtonOptions(Value: TBCExpandingButtonOptions);
begin
  FExpandingButtonOptions.Assign(Value);
end;

procedure TBCExpandingButton.expandoptions;
begin
  FHowManyButtons:=countdelimeters(FExpandingButtonOptions.fquestions);
  if FHowManyButtons=0 then
  begin
    exit;
  end;
  setlength(FButtonQuestions,FHowManyButtons+1);
  setlength(FButtonAnswers,FHowManyButtons+1);
  setlength(FButtonHints,FHowManyButtons+1);
  stringtoarray(FButtonQuestions,FExpandingButtonOptions.fquestions,true);
  stringtoarray(FButtonAnswers,FExpandingButtonOptions.fanswers,true);
  stringtoarray(FButtonHints,FExpandingButtonOptions.fhints,false);
  if assigned(FButtonHoldingPanel) then
  begin
    CloseCode;
  end
  else
  begin
    GenerateControl;
  end;
end;


procedure Register;
begin
  {$I TBCExpandingButton.lrs}
  RegisterComponents('BGRA Button Controls',[TBCExpandingButton]);
end;

end.
