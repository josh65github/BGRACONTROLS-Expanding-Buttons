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
  Classes,{ SysUtils,} LResources, Forms, typinfo, Controls, Graphics,BCPanel,{ Dialogs,}BCButton, BCTypes,BGRABitmap,BGRABitmapTypes, BGRAShape;

const SubButtonName='_SubButton_';
      SubButtonPanelName=SubButtonName+'Panel';
      SubButtonPanelShapeName=SubButtonName+'Panel_Shape';
      SubButtonOuterShapeName=SubButtonName+'Outer_Shape';

type
  TMsgData = record
    APan: tbcpanel;
  end;
  TBCExpButState=TBCButtonState;
  PMsgData = ^TMsgData;
  TBCExpandedButtonAllignStyle = (alLeft,alRight,alCenter);
  TBCExpandedButtonStyle = (btnOriginal,btnSquare);
  TBCExpandedButtonLayout = (layHorizontal,layVertical);
  TBCExpandedPanelStyle = (styBox,styHeaded,StyCallOut);
  TBCExpandedCallOutPosition = (StyAbove,styBelow,StyAuto);
  TBCExpandedButtonSelectionChangedEvent = procedure(Sender: TObject; Value: Integer) of object;
  TBCExpandingButtonOptions = class(TPersistent)
  private
    FDelimeter:String;
    FExpanedButtonCaptions,FExpanedButtonAnswers,FExpanedButtonHints:String;
    FBorderWidth:integer;
    FButtonGap:Integer;
    FButtonHeight:Integer;
    FButtonWidth:Integer;
    FMaxWidth:Integer;
    FSelected:Integer;
    FAnswerText:String;
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
    FCustomState:Boolean;
    FCallOutPositionTop:Boolean;
    FAutoExpand:Boolean;
    FUpdateCaptionWithAnswer:Boolean;
    FCustomStateNormal,FCustomStateClicked,FCustomStateHover:TBCExpButState;
  private
    procedure setFAutoExpand(const AValue: boolean);
    procedure setFCustomState(const AValue: boolean);
    procedure setFCustomStateNormal(const AValue: TBCExpButState);
    procedure setFCustomStateClicked(const AValue: TBCExpButState);
    procedure setFCustomStateHover(const AValue: TBCExpButState);
    procedure setFDelimeter(const AValue: string);
    procedure setFExpanedButtonCaptions(const AValue: string);
    procedure setFExpanedButtonAnswers(const AValue: string);
    procedure setFExpanedButtonHints(const AValue: string);
    procedure setFBorderWidth(const AValue: Integer);
    procedure setFButtonGap(const AValue: Integer);
    procedure setFButtonHeight(const AValue: Integer);
    procedure setFButtonWidth(const AValue: Integer);
    procedure setFMaxWidth(const AValue: Integer);
    procedure SetFCloseOnSelection(const AValue: Boolean);
    procedure setFPanelColor(const AValue:TColor);
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
    procedure setFSelected(const AValue: Integer);
    procedure setFAnswerText(const AValue: String);
  public
    { Assign the properties from Source to this instance }
    procedure Assign(Source: TPersistent); override;
  published
    {When true the expanded menu appears/dissappears on entry/exit}
    Property AutoExpand : Boolean Read FAutoExpand Write setFAutoExpand;
    {Delimeter used to split button captions, answers and hints, ie ","}
    Property ButtonCSVDelimterString : String Read FDelimeter Write setFDelimeter;
    {CSV list of Button Texts ie "Button 1","Button 2"}
    Property ButtonCSVCaptions : String Read FExpanedButtonCaptions Write setFExpanedButtonCaptions;
    {CSV list of Button Answers ie "Button 1","Button 2"}
    Property ButtonCSVAnswers : String Read FExpanedButtonAnswers Write setFExpanedButtonAnswers;
    {CSV list of Button Hints  ie "Button 1 hint message","Button 2 hint message"}
    Property ButtonCSVHints : String Read FExpanedButtonHints Write setFExpanedButtonHints;
    {Width of the border around the Panel}
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
    {Color of the Border around the Panel}
    property PanelBorderColor: TColor Read FPanelBorderColor Write setFPanelBorderColor;
    {Allows you to have custom normal,hover and clicked states for the buttons}
    property CustomState: Boolean Read FCustomState Write setFCustomState;
    {Custom StateNormal parameters}
    property CustomStateNormal:TBCExpButState Read FCustomStateNormal Write setFCustomStateNormal;
    {Custom StateClicked parameters}
    property CustomStateClicked:TBCExpButState Read FCustomStateClicked Write setFCustomStateClicked;
    {Custom StateHover parameters}
    property CustomStateHover:TBCExpButState Read FCustomStateHover Write setFCustomStateHover;
    {Style of Panel (styBox,styHeaded,StyCallOut)}
    property PanelStyle:TBCExpandedPanelStyle Read FPanelStyle Write setFPanelStyle;
    {Height of the Callout when PanStyle=StyCallOut}
    property PanelStyleCallOutHeight:Integer Read FPanelStyleCallOutHeight Write setFPanelStyleCallOutHeight;
    {Allows you to specify the callout position (StyAbove,styBelow,StyAuto)}
    property PanelStyleCalloutPosition:TBCExpandedCallOutPosition read FPanelStyleCallOutPosition Write setFPanelStyleCallOutPosition;
    {Draw a Shadow around the Panel}
    property PanelShadow:Boolean Read FPanelShadow Write setFPanelShadow;
    {Color of the Shadow for the panel}
    property PanelShadowColor:TColor Read FPanelShadowColor Write setFPanelShadowColor;
    {Size of the Panel Shadow in pixels}
    property PanelShadowSize:Integer Read FPanelShadowSize Write setFPanelShadowSize;
    property UpdateCaptionWithAnswer:boolean read FUpdateCaptionWithAnswer write SetFUpdateCaptionWithAnswer;
    {Will Hold the Selected Value in the list when button clicked}
    Property Selected : Integer Read FSelected Write setFSelected;
    {Will Hold the text of the answer when button clicked}
    Property AnswerText: String Read FAnswerText Write setFAnswerText;

  end;

  TBCExpandingButton = class(TBCButton)
  private
    FOwner: TComponent;
    FButtonHoldingPanel:TBCpanel;
   // FHowManyButtons:integer;
  //  FSelected:Integer;
  //  FAnswerText:String;
    FBackGroundBmp:TBitmap;
    FButtonCaptions,FButtonAnswers,FButtonHints:Array of AnsiString;
    FExpandingButtonOptions: TBCExpandingButtonOptions;
    FOnSelectionChange: TBCExpandedButtonSelectionChangedEvent;
    FremovingPanel:Boolean;
    FPanelCreated:Boolean;
    procedure SetExpandingButtonOptions(Value: TBCExpandingButtonOptions);
    procedure AutoCreateCloseExpandingButtons(AData: PtrInt);
    function IntToStringZeroPad(av,le:Integer):String;
    function MyIntToStr(AValue:Integer):String;
    function MyStrToIntDef(AValue:string;adef:integer):integer;
    procedure SubButtonMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SubButtonOnClick(Sender:TObject);
    procedure SetSelectedAsDown;
    procedure GenerateExpandingButtonsControl;
    procedure CloseExpandingButtonsCode;
    procedure BCPanelAfterRender(Sender: TObject; const ABGRA: TBGRABitmap; ARect: TRect);
    procedure BCPanelMouseLeave(Sender: TObject);
  protected
  //  FHowManyButtons:integer;
    function CountDelimeters(var st:ansistring):Integer;
    procedure StringToArray(var SA:Array of AnsiString;St:AnsiString;GenerateText:Boolean);
    function GetOwnerForm(AComponent: TComponent): TCustomForm;
    function FindFormByName(const AName: string): TForm;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;MX, MY: integer); override;
    procedure ButMouseDown(Button: TMouseButton; Shift: TShiftState; MX, MY: integer);
    function TBCChangeColor(AColor:TColor; Lighten: Boolean; n: integer): TColor;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  public
    FHowManyButtons:integer;
    { The passed string must be a var, as it can be changed by this routine }
    function VerifyCSVString(Var AString:AnsiString):Boolean;
    { Constructor }
    constructor Create(AOwner: TComponent); override;
    { Destructor }
    destructor Destroy; override;
    procedure paint; override;
  published
    property ExpandingButOptions: TBCExpandingButtonOptions read FExpandingButtonOptions write SetExpandingButtonOptions;
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

procedure TBCExpandingButtonOptions.Assign(Source: TPersistent);
begin
  if Source is TBCExpandingButtonOptions then
  begin
    with TBCExpandingButtonOptions(Source) do
    begin
      FSelected:=Selected;
      FAutoExpand:=AutoExpand;
      FDelimeter :=ButtonCSVDelimterString;
      FExpanedButtonCaptions := ButtonCSVCaptions;
      FExpanedButtonAnswers := ButtonCSVAnswers;
      FExpanedButtonHints := ButtonCSVHints;
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
      FCustomState:= CustomState;
      FCustomStateNormal.Assign(FCustomStateNormal);
      FCustomStateClicked.Assign(FCustomStateClicked);
      FCustomStateHover.Assign(FCustomStateHover);
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
    FAutoExpand:=false;
    FBorderWidth:=2;
    FButtonHeight:=24;
    FButtonGap:=4;
    FButtonWidth:=120;
    FMaxWidth:=600;
    fdelimeter:='","';
    FAlignPanel:=AlLeft;
    FPanelColor:=$00755435;
    FPanelBorderColor:=$00ffffff;
    FSubButtonStyle:=btnOriginal;
    FSubButtonLayout:=layHorizontal;
    FCloseOnSelection:=False;
    PanelShadow:=True;
    PanelShadowColor:=clGray;
    FPanelShadowSize:=4;
    PanelStyle:=styHeaded;
    PanelStyleCallOutHeight:=10;
    PanelStyleCalloutPosition:=styAuto;
    FCustomStateNormal:= TBCButtonState.Create(Self);
    FCustomStateClicked:= TBCButtonState.Create(Self);
    FCustomStateHover:= TBCButtonState.Create(Self);
    FUpdateCaptionWithAnswer:=false;
    FSelected:=0;
    FAnswerText:='';
  end;

  FButtonHoldingPanel:=nil;
  FremovingPanel:=false;
  FPanelCreated:=false;
end;

destructor TBCExpandingButton.Destroy;
begin
//  CloseExpandingButtonsCode;
  If FPanelCreated then
  begin
    FremovingPanel:=true;
    FBackGroundBmp.Free;
    FBackGroundBmp:=nil;
  end;
  FExpandingButtonOptions.FCustomStateNormal.free;
  FExpandingButtonOptions.FCustomStateHover.free;
  FExpandingButtonOptions.FCustomStateClicked.free;
  FExpandingButtonOptions.Free;
  inherited Destroy;
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

procedure TBCExpandingButtonOptions.setFAutoExpand(const AValue: boolean);
begin
  if FAutoExpand<> AValue then FAutoExpand:=AValue;
end;

procedure TBCExpandingButtonOptions.setFCustomState(const AValue: boolean);
begin
  if FCustomState<> AValue then FCustomState:=AValue;
end;

procedure TBCExpandingButtonOptions.setFCustomStateNormal(const AValue: TBCExpButState);
begin
  if FCustomStateNormal<> AValue then FCustomStateNormal.Assign(AValue);
end;

procedure TBCExpandingButtonOptions.setFCustomStateClicked(const AValue: TBCExpButState);
begin
  if FCustomStateClicked<> AValue then FCustomStateClicked.Assign(AValue);
end;

procedure TBCExpandingButtonOptions.setFCustomStateHover(const AValue: TBCExpButState);
begin
  if FCustomStateHover<> AValue then FCustomStateHover.Assign(AValue);
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
  Result:=MyIntToStr(av);
  while length(Result)<le do Result:='0'+Result;
end;

procedure TBCExpandingButton.Paint;
begin
  inherited Paint;
end;

procedure TBCExpandingButtonOptions.setFAnswerText(const AValue: String);
begin
  if FAnswerText<> AValue then FAnswerText:=AValue;
end;

procedure TBCExpandingButtonOptions.setFSelected(const AValue: Integer);
begin
  if FSelected<> AValue then If AValue>=0 then FSelected:=AValue;
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

procedure TBCExpandingButtonOptions.setFExpanedButtonCaptions(const AValue: string);
begin
  if fExpanedButtonCaptions<> AValue then If AValue<>'' then fExpanedButtonCaptions:=AValue;
end;

procedure TBCExpandingButtonOptions.setFExpanedButtonAnswers(const AValue: string);
begin
  if fExpanedButtonAnswers<> AValue then If AValue<>'' then fExpanedButtonAnswers:=AValue;
end;

procedure TBCExpandingButtonOptions.setFExpanedButtonHints(const AValue: string);
begin
  if fExpanedButtonhints<> AValue then If AValue<>'' then fExpanedButtonhints:=AValue;
end;

function TBCExpandingButton.TBCChangeColor(AColor:TColor; Lighten: Boolean; n: integer): TColor;
var
  r,g,b: integer;

function minmax(avalue,amin,amax:integer):byte;
begin
  if avalue<amin then avalue:=amin;
  if avalue>amax then avalue:=amax;
  Result:=byte(avalue);
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

function TBCExpandingButton.MyIntToStr(AValue:Integer):String;
var digits:shortstring='0123456789';
    sgn:Boolean;
begin
  Result:='';
  sgn:=AValue<0;
  if AValue>=10 then
  begin
    repeat
      Result:=digits[(AValue mod 10)+1]+Result;
      AValue:=AValue div 10;
    until AValue<10;
  end;
  Result:=digits[(AValue mod 10)+1]+Result;
  if sgn then Result:='-'+Result;
end;

function TBCExpandingButton.MyStrToIntDef(AValue:string;adef:integer):integer;
var i:integer;
    s:string='';
    mulply:integer=1;
    v:integer;
begin
  Result:=0;
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
      Result:=Result+((v-48)*mulply);
      mulply:=mulply*10;
    end
      else
      if AValue[i]=' ' then
      begin
      end
       else
       if ((AValue[i]='-') and (i=1)) then Result:=-1*Result
         else
         begin
           Result:=adef;
           break;
         end;
  end;
  begin
    Result:=Result;
  end;
end;

function TBCExpandingButton.VerifyCSVString(Var AString:AnsiString):Boolean;
begin
  if FExpandingButtonOptions.FDelimeter='' then exit(false);
  if AString='' then exit(false);
  // remove start and end spaces
  while AString[1]=' ' do AString:=copy(AString,2,Length(AString));
  if AString='' then exit(false);
  while AString[Length(AString)]=' ' do AString:=copy(AString,1,Length(AString)-1);
  if AString='' then exit(false);
  //remove any line ending chars from end
  while AString[Length(AString)] in [chr(10),chr(13),','] do AString:=copy(AString,1,Length(AString)-1);
  if ((AString[1]<>FExpandingButtonOptions.FDelimeter[1])
   or (AString[Length(AString)]<>FExpandingButtonOptions.FDelimeter[length(FExpandingButtonOptions.FDelimeter)])) then exit(false);

  result:=true;
end;

function TBCExpandingButton.CountDelimeters(var st:ansistring):Integer;
var c:integer=1;
    dl:integer;
begin
  Result:=0;
  if st='' then exit;
  Result:=0;
  dl:=length(FExpandingButtonOptions.FDelimeter);
  for c:= 1 to length(st)-dl+1 do if copy(st,c,dl)=FExpandingButtonOptions.FDelimeter then inc(Result)
end;

procedure TBCExpandingButton.StringToArray(var SA:Array of AnsiString;St:AnsiString;GenerateText:Boolean);
var I_cnt,C_cnt:Integer;
    s:ansistring;
begin
  if VerifyCSVString(st)=false then st:='';
  s:='';
  if st<>'' then
  begin
    C_cnt:=0;
    I_cnt:=2;
    while I_cnt< length(st) do
    begin
      if copy(st,I_cnt,length(FExpandingButtonOptions.FDelimeter))=FExpandingButtonOptions.FDelimeter then
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
    if GenerateText then for I_cnt:=C_Cnt+1 to FHowManyButtons do SA[I_cnt]:=MyIntToStr(I_cnt);
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

function TBCExpandingButton.FindFormByName(const AName: string): TForm;
var
  i: Integer;
begin
  for i := 0 to Screen.FormCount - 1 do
  begin
    Result := Screen.Forms[i];
    if (Result.Name = AName) then Exit;
  end;
  Result := nil;
end;

procedure TBCExpandingButton.SubButtonMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var v:integer;
    na:string;
    MsgToSend: PMsgData;
begin
  if not (sender is tbcbutton) then exit;
  na:=TBCButton(Sender).Name;
  v:=MyStrToIntDef(copy(na,length(na)-3,4),-999);
  if v>=0 then
  begin
    if FButtonAnswers[v]<>'' then FExpandingButtonOptions.AnswerText:=FButtonAnswers[v]
    else FExpandingButtonOptions.AnswerText:=FButtonCaptions[v];
    TBCExpandingButton(self).ExpandingButOptions.Selected:=v;
    SetSelectedAsDown;
  end;
  FButtonHoldingPanel.Refresh;
  if FExpandingButtonOptions.FCloseOnSelection then
  begin
    new(MsgToSend);
    MsgToSend^.APan:= FButtonHoldingPanel;
    Application.QueueAsyncCall(@AutoCreateCloseExpandingButtons,PtrInt(MsgToSend));
  end;
  if assigned(self.OnSelectionChanged) then OnSelectionChanged(self,TBCExpandingButton(self).ExpandingButOptions.FSelected);
end;

procedure TBCExpandingButton.SubButtonOnClick(Sender:TObject);
var v:integer;
    na:string;
    MsgToSend: PMsgData;
begin
  if not (sender is tbcbutton) then exit;
  na:=TBCButton(Sender).Name;
  v:=MyStrToIntDef(copy(na,length(na)-3,4),-999);
  if v>=0 then
  begin
    if FButtonAnswers[v]<>'' then TBCExpandingButton(self).ExpandingButOptions.AnswerText:=FButtonAnswers[v]
    else TBCExpandingButton(self).ExpandingButOptions.AnswerText:=FButtonCaptions[v];
    TBCExpandingButton(self).ExpandingButOptions.Selected:=v;
    SetSelectedAsDown;
    refresh;
  end;
  FButtonHoldingPanel.Refresh;
  if assigned(self.OnSelectionChanged) then OnSelectionChanged(self,TBCExpandingButton(self).ExpandingButOptions.FSelected);
  if FExpandingButtonOptions.FCloseOnSelection then
  begin
    new(MsgToSend);
    MsgToSend^.APan:= FButtonHoldingPanel;
    Application.QueueAsyncCall(@AutoCreateCloseExpandingButtons,PtrInt(MsgToSend));
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
      tbcbutton(FButtonHoldingPanel.FindComponent(na)).Down:=i=TBCExpandingButton(self).ExpandingButOptions.FSelected;
      tbcbutton(FButtonHoldingPanel.FindComponent(na)).Refresh;
    end;
    if FExpandingButtonOptions.FUpdateCaptionWithAnswer then TBCButton(self).Caption:=TBCExpandingButton(self).ExpandingButOptions.AnswerText;
 //   application.ProcessMessages;
  end;
end;

procedure TBCExpandingButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  MX, MY: integer);
var MsgToSend: PMsgData;
begin
  inherited MouseDown(Button, Shift, MX, MY);
  if csDesigning in ComponentState then
    exit;

  if (Button = mbLeft) and Enabled then
  begin
    New(MsgToSend);
    if FPanelCreated then MsgToSend^.APan:=FButtonHoldingPanel
    else MsgToSend^.APan:=nil;
    Application.QueueAsyncCall(@AutoCreateCloseExpandingButtons,PtrInt(MsgToSend));
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

procedure TBCExpandingButton.CloseExpandingButtonsCode;
begin
  FremovingPanel:=true;
  If FPanelCreated then
  begin
    self.Down:=false;
    FButtonHoldingPanel.Free;
    FButtonHoldingPanel:=nil;
    FBackGroundBmp.Free;
    FBackGroundBmp:=nil;
    FPanelCreated:=false;
  end;
  FremovingPanel:=false;
end;

procedure TBCExpandingButton.BCPanelMouseLeave(Sender: TObject);
var
    ctrl: TControl;
    MsgToSend: PMsgData;
    n:string='';
    n1:string='';
begin
  if csDesigning in ComponentState then exit;

  inherited MouseLeave;
  if (csDestroying in ComponentState) then  EXIT;
  if not assigned(FButtonHoldingPanel) then exit;
  if FExpandingButtonOptions.FAutoExpand then
  begin
    ctrl := FindDragTarget(Mouse.CursorPos,true);
    if Assigned(ctrl) then
    begin
      n:=ctrl.Name;
      if ctrl is tbcbutton then
      if ctrl.Parent.Name=FButtonHoldingPanel.name then n:=ctrl.Parent.Name;
    end;
    if ((Assigned(ctrl)) and (ctrl is tbcbutton) and (ctrl.Name=self.name)) then self.MouseEnter
    else
    if n<>FButtonHoldingPanel.Name then
    begin
      New(MsgToSend);
      MsgToSend^.APan:=FButtonHoldingPanel;
      Application.QueueAsyncCall(@AutoCreateCloseExpandingButtons,PtrInt(MsgToSend));
    end;
  end;
  //application.ProcessMessages;
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
  if FremovingPanel then exit;
//  if (csDestroying in ComponentState) then  EXIT;
  PanelHeight:=tbcpanel(sender).height;
  PanelWidth:=tbcpanel(sender).width;
  HalfBorderWidth:=FExpandingButtonOptions.FBorderWidth div 2;
  x1:=HalfBorderWidth;
  x2:=PanelWidth-HalfBorderWidth-1;
  y1:=HalfBorderWidth;
  y2:=PanelHeight-HalfBorderWidth-1;
  if ExpandingButOptions.PanelShadow then
  begin
    if assigned(FBackGroundBmp) then
    begin
    //draw shadow
      with FBackGroundBmp.Canvas do
      begin
        offset:=FExpandingButtonOptions.FPanelShadowSize;
        Pen.Style:=psSolid;
        Pen.Width:=1;
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
    end;
  end else offset:=0;
  if assigned(FBackGroundBmp) then abgra.PutImage(0,0,fbackgroundbmp,dmSet);
  with ABGRA.Canvas do
  begin
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
      polyGon(pts);
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
      with  ExpandingButOptions do
      begin
      if FCallOutPositionTop then
      begin
        addpoint(0,x1,y1+FPanelStyleCallOutHeight);
        addpoint(1,CalloutBubbleX,y1+FPanelStyleCallOutHeight);
        addpoint(2,CalloutBubbleX+FPanelStyleCallOutHeight,y1);
        addpoint(3,CalloutBubbleX+FPanelStyleCallOutHeight+FPanelStyleCallOutHeight,
                 y1+FPanelStyleCallOutHeight);
        addpoint(4,x2-offset,y1+FPanelStyleCallOutHeight);
        addpoint(5,x2-offset,y2-offset);
        addpoint(6,x1,y2-offset);
        addpoint(7,x1,y1+FPanelStyleCallOutHeight);
      end
      else
      begin
        addpoint(0,x1,y1);
        addpoint(1,x2-offset,y1);
        addpoint(2,x2-offset,y2-FPanelStyleCallOutHeight-offset);
        addpoint(3,CalloutBubbleX+FPanelStyleCallOutHeight+FPanelStyleCallOutHeight,y2-FPanelStyleCallOutHeight-offset);
        addpoint(4,CalloutBubbleX+FPanelStyleCallOutHeight,y2-offset);
        addpoint(5,CalloutBubbleX,y2-FPanelStyleCallOutHeight-offset);
        addpoint(6,x1,y2-FPanelStyleCallOutHeight-offset);
        addpoint(7,x1,y1);
      end;
      end;
      polyGon(pts);
    end;
  end;
  setlength(pts,0);
end;

procedure TBCExpandingButton.GenerateExpandingButtonsControl;
var x,y,i,w:integer;
    ButtonPoint: TPoint;
    PanelX,PanelY,PanelWidth,PanelHeight:Integer;
    TempButton:tbcbutton;
    xstart:integer;
    CalculatingMaxX:integer=0;
    OwnerFormWidth,OwnerFormHeight:integer;
    na:string;
begin
  FPanelCreated:=true;
  FBackGroundBmp:=TBitmap.Create;
  ExpandingButOptions.FCallOutPositionTop:=true;
  OwnerFormWidth:=GetOwnerForm(self).Width;
  OwnerFormHeight:=GetOwnerForm(self).height;
  xstart:=FExpandingButtonOptions.FBorderWidth+FExpandingButtonOptions.FButtonGap;
  w:=0;
  ButtonPoint:=self.ClientToParent(TPoint.Create(0,0), GetOwnerForm(self));
  PanelX:=ButtonPoint.X;
  PanelY:=ButtonPoint.Y;
  self.Down:=true;
  FButtonHoldingPanel:=tbcpanel.Create(GetOwnerForm(self));
  with FButtonHoldingPanel do
  begin
    Parent:=GetOwnerForm(self);
    Background.Color:=FExpandingButtonOptions.PanelColor;
    Background.Style:=bbsColor;
    Background.ColorOpacity:=255;
    ParentBackground:=false;
    visible:=false;
    BevelOuter:=bvNone;
    Border.Style:=bboNone;
    DoubleBuffered:=true;
    Rounding.RoundX:=1;
    Rounding.RoundY:=1;
    Rounding.RoundOptions:=[rrBottomLeftSquare,rrBottomRightSquare,rrTopLeftSquare,rrTopRightSquare];
    OnAfterRenderBCPanel:=@BCPanelAfterRender;
    onMouseLeave:=@BCPanelMouseLeave;
    refresh;
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
      Down:=TBCExpandingButton(self).ExpandingButOptions.fselected=i;
      Caption:=FButtonCaptions[i];
      OnMouseUp:=@self.SubButtonMouseUp;//SubButtonOnClick;      SubButtonMouseUp
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
      refresh;
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
  FButtonHoldingPanel.update;
  FButtonHoldingPanel.Refresh;
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
  FButtonHoldingPanel.SetBounds(PanelX,PanelY,PanelWidth,PanelHeight);
  FBackGroundBmp.SetSize(PanelWidth, PanelHeight);
  FBackGroundBmp.Canvas.CopyRect(Rect(0,0,PanelWidth,PanelHeight),
                                 GetOwnerForm(self).Canvas, Rect(PanelX,PanelY,PanelX+PanelWidth,PanelY+PanelHeight));
  FButtonHoldingPanel.Visible:=true;
  FButtonHoldingPanel.Refresh;
end;

procedure TBCExpandingButton.SetExpandingButtonOptions(Value: TBCExpandingButtonOptions);
begin
  FExpandingButtonOptions.Assign(Value);
end;

procedure TBCExpandingButton.AutoCreateCloseExpandingButtons(AData: PtrInt);
var ReceivedMsg: TMsgData;
begin
  try
    ReceivedMsg := PMsgData(AData)^;
    If not FPanelCreated then
    begin
      FHowManyButtons:=countdelimeters(FExpandingButtonOptions.FExpanedButtonCaptions);
      if FHowManyButtons=0 then
      begin
        exit;
      end;
      setlength(FButtonCaptions,FHowManyButtons+1);
      setlength(FButtonAnswers,FHowManyButtons+1);
      setlength(FButtonHints,FHowManyButtons+1);
      stringtoarray(FButtonCaptions,FExpandingButtonOptions.FExpanedButtonCaptions,true);
      stringtoarray(FButtonAnswers,FExpandingButtonOptions.FExpanedButtonAnswers,true);
      stringtoarray(FButtonHints,FExpandingButtonOptions.FExpanedButtonHints,false);
      GenerateExpandingButtonsControl;
    end
    else
    begin
      CloseExpandingButtonsCode;
    end;
  finally
    Dispose(PMsgData(AData));
  end;
end;

procedure TBCExpandingButton.MouseEnter;
var MsgToSend: PMsgData;
begin
  if csDesigning in ComponentState then exit;

  inherited MouseEnter;
  if FExpandingButtonOptions.FAutoExpand then
  begin
   if not FPanelCreated then
    begin
      New(MsgToSend);
      MsgToSend^.APan:=nil;
      Application.QueueAsyncCall(@AutoCreateCloseExpandingButtons,PtrInt(MsgToSend));
    end;
  end;
end;

procedure TBCExpandingButton.MouseLeave;
var
    ctrl: TControl;
    MsgToSend: PMsgData;
    n:string='';
begin
  if csDesigning in ComponentState then exit;

  inherited MouseLeave;
  if (csDestroying in ComponentState) then  EXIT;
  if FExpandingButtonOptions.FAutoExpand then
  begin
    ctrl := FindDragTarget(Mouse.CursorPos,true);
    if not FPanelCreated then exit;
    if Assigned(ctrl) then  n:=ctrl.Name;
    begin
      if n<>FButtonHoldingPanel.Name then
      begin
        New(MsgToSend);
        MsgToSend^.APan:=FButtonHoldingPanel;
        Application.QueueAsyncCall(@AutoCreateCloseExpandingButtons,PtrInt(MsgToSend));
      end;
    end;
  end;
  //application.ProcessMessages;
end;


procedure Register;
begin
  {$I TBCExpandingButton.lrs}
  RegisterComponents('BGRA Button Controls',[TBCExpandingButton]);
end;

end.
