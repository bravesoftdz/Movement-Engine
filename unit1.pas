unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Proba1: TTimer;
    Proba2: TTimer;
    procedure Button1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Proba1Timer(Sender: TObject);
    procedure Proba2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Gravity: Real;
  MovementRL: Real;
  Jump: Real;
  Slide: integer;
  P1U: integer;
  P1D: integer;
  P1R: integer;
  P1L: integer;
  Counter: Integer;
  Grounded: Boolean;
  KFU: Boolean;
  KFR: Boolean;
  KFL: Boolean;

implementation
{$R *.lfm}
{ TForm1 }

procedure TForm1.FormActivate(Sender: TObject);
begin
  Gravity:=2;
  MovementRL:=4;
  Jump:=24;
  Slide:=2;
  Grounded:= False
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Proba1Timer(Sender: TObject);
begin
  //Giving Momentum form keyboard controls

  //Giving Momentum UP to P1 from Keyboard key(s): W (87) OR Space (32)
  if (edit5.text = '32') AND (P1D = 0) OR (edit5.text = '87') AND (P1D = 0) then
    begin
      P1U:=Round(Jump);
      edit5.text:='';
    end;
  //Giving Momentum RIGHT to P1 from Keyboard key(s): D (68)
  if (edit9.text = '68') then P1R:=Round(MovementRL);

  //Giving Momentum LEFT to P1 from Keyboard key(s): A (65)
  if (edit8.text = '65') then P1L:=Round(MovementRL);


  //Checking if P1 is on a Platform
  if (Shape1.Left > Shape2.Left + shape2.Width) OR
     (Shape1.Left + Shape1.Width < shape2.Left)
     OR
     (Shape1.Left > Shape3.Left + shape3.Width) OR
     (Shape1.Left + Shape1.Width < shape3.Left)
     then
     if (shape1.top + shape1.Height < Form1.Height) then
         Grounded:=False else Grounded:=True;

  //Gravity

  //Giving Momentum DOWN(GRAVITY) to P1
  if (shape1.top + shape1.Height < Form1.Height) AND (Grounded = False) then
         P1D:=P1D + round(Gravity) else P1D:=0;

  //HelpFull DeBug Info
  Edit4.text:=IntToStr(P1L);
  Edit3.text:=IntToStr(P1R);
  Edit2.text:=IntToStr(P1D);
  Edit1.text:=IntToStr(P1U);
  edit6.text:=IntToStr(shape1.Left) + ', ' + IntToStr(shape1.top + shape1.Height);
  edit7.text:=IntToStr(shape1.Left + shape1.Width) + ', ' + IntToStr(shape1.top);
  edit13.text:=IntToStr(shape1.Left) + ', ' + IntToStr(shape1.top);
  edit14.text:=IntToStr(shape1.Left + shape1.Width) + ', ' + IntToStr(shape1.top + shape1.Height);
  if Grounded = True then edit12.text:='True' else edit12.text:='False';


  //Momentum Hander
  if P1U >= P1D
  then
    begin
      P1U:= P1U - P1D;
      P1D:=0
    end
  else
    begin
      P1D:= P1D - P1U;
      P1U:=0;
    end;

  if P1R >= P1L
  then
    begin
      P1R:= P1R - P1L;
      P1L:=0
    end
  else
    begin
      P1L:= P1L - P1R;
      P1R:=0;
    end;

  //Movement

  //Moving P1 UP
  if P1U > 0 then
    begin
      for Counter:=1 to P1U do
        if (shape1.left + shape1.width < shape2.Left + 1) OR
           (shape1.left > shape2.left + shape2.width - 1) OR
           (Shape1.top + shape1.Height <= shape2.top + 1) OR
           (shape1.top > Shape2.top + shape2.Height - 1)
           AND
           (shape1.left + shape1.width < shape3.Left + 1) OR
           (shape1.left > shape3.left + shape3.width - 1) OR
           (Shape1.top + shape1.Height <= shape3.top + 1) OR
           (shape1.top > Shape3.top + shape3.Height - 1)
          then
            begin
              shape1.top:=shape1.top - 1;
              Grounded:= False;
              edit10.text:='True'
            end
          else
            begin
              P1U:= 0;
              edit10.text:='False';
            end;
    end;

  //Moving P1 DOWN
  if P1D > 0 then
    begin
      for Counter:=1 to P1D do
        if (shape1.left + shape1.width < shape2.Left + 1) OR
           (shape1.left > shape2.left + shape2.width - 1) OR
           (Shape1.top + shape1.Height < shape2.top + 1) OR
           (shape1.top >= Shape2.top + shape2.Height - 1)
           AND
           (shape1.left + shape1.width < shape3.Left + 1) OR
           (shape1.left > shape3.left + shape3.width - 1) OR
           (Shape1.top + shape1.Height < shape3.top + 1) OR
           (shape1.top >= Shape3.top + shape3.Height - 1)
          then
            begin
            shape1.top:=shape1.top + 1;
            edit11.text:='True'
            end
          else
          begin
            if (shape1.top > Shape2.top + shape2.Height + 1) then
              Grounded:= True;
            P1D:= 0;
            edit11.text:='False';
          end;
    end;

  //Moving P1 RIGHT
  if P1R > 0 then
  Begin
    for Counter:=1 to P1R do
      if (shape1.left + shape1.width <= shape2.Left - 1) OR
         (shape1.left > shape2.left + shape2.width - 1) OR
         (Shape1.top + shape1.Height <= shape2.top + 1) OR
         (shape1.top >= Shape2.top + shape2.Height - 1)
         AND
         (shape1.left + shape1.width <= shape3.Left - 1) OR
         (shape1.left > shape3.left + shape3.width - 1) OR
         (Shape1.top + shape1.Height <= shape3.top + 1) OR
         (shape1.top >= Shape3.top + shape3.Height - 1)
         then
           shape1.Left:= shape1.Left + 1
         else
           Grounded:=False;


    if (edit5.text <> '68') AND (Counter = P1R) OR
       (edit5.text <> '68') AND (Counter = P1R) then
         P1R:=P1R - round(P1R / Slide + 0.5);
  end;

  //Moving P1 LEFT
  if P1L > 0 then
  begin
      for Counter:=1 to P1L do
        if (shape1.left + shape1.width < shape2.Left + 1) OR
           (shape1.left >= shape2.left + shape2.width + 1) OR
           (Shape1.top + shape1.Height <= shape2.top + 1) OR
           (shape1.top >= Shape2.top + shape2.Height - 1)
           AND
           (shape1.left + shape1.width < shape3.Left + 1) OR
           (shape1.left >= shape3.left + shape3.width + 1) OR
           (Shape1.top + shape1.Height <= shape3.top + 1) OR
           (shape1.top >= Shape3.top + shape3.Height - 1)
           then
             shape1.Left:= shape1.Left - 1;

      if (edit5.text <> '65') AND (Counter = P1L) OR
         (edit5.text <> '65') AND (Counter = P1L) then
           P1L:=P1L - round(P1L / Slide + 0.5);
  end;
end;

procedure TForm1.Proba2Timer(Sender: TObject);
begin
  //Giving Momentum form keyboard controls

  //Giving Momentum UP to P1 from Keyboard key(s): W (87) OR Space (32)
  if (edit5.text = '87') AND (Grounded = True) then
    begin
      P1U:=Round(Jump);
      edit5.text:='';
    end;

  //Giving Momentum RIGHT to P1 from Keyboard key(s): D (68)
  if (edit9.text = '68') then P1R:=Round(MovementRL);

  //Giving Momentum LEFT to P1 from Keyboard key(s): A (65)
  if (edit8.text = '65') then P1L:=Round(MovementRL);

  //Gravity

  //Giving Momentum DOWN(GRAVITY) to P1
  if (shape1.top + shape1.Height < Form1.Height) AND (Grounded = False) then
         P1D:=P1D + round(Gravity) else P1D:=0;

  //HelpFull DeBug Info
  Edit4.text:=IntToStr(P1L);
  Edit3.text:=IntToStr(P1R);
  Edit2.text:=IntToStr(P1D);
  Edit1.text:=IntToStr(P1U);
  edit6.text:=IntToStr(shape1.Left) + ', ' + IntToStr(shape1.top + shape1.Height);
  edit7.text:=IntToStr(shape1.Left + shape1.Width) + ', ' + IntToStr(shape1.top);
  edit13.text:=IntToStr(shape1.Left) + ', ' + IntToStr(shape1.top);
  edit14.text:=IntToStr(shape1.Left + shape1.Width) + ', ' + IntToStr(shape1.top + shape1.Height);
  if Grounded = True then edit12.text:='True' else edit12.text:='False';

  //Momentum Hander
  if P1U >= P1D
  then
    begin
      P1U:= P1U - P1D;
      P1D:=0
    end
  else
    begin
      P1D:= P1D - P1U;
      P1U:=0;
    end;

  if P1R >= P1L
  then
    begin
      P1R:= P1R - P1L;
      P1L:=0
    end
  else
    begin
      P1L:= P1L - P1R;
      P1R:=0;
    end;


    //Movement Handler

    //UP
    Counter:= 1;
    While (Counter <= P1U) AND (P1U > 0) DO
      if   ((shape1.left + shape1.width < shape2.Left + 1) OR
           (shape1.left > shape2.left + shape2.width - 1) OR
           (Shape1.top + shape1.Height <= shape2.top + 1) OR
           (shape1.top > Shape2.top + shape2.Height - 1))
           AND
           ((shape1.left + shape1.width < shape3.Left + 1) OR
           (shape1.left > shape3.left + shape3.width - 1) OR
           (Shape1.top + shape1.Height <= shape3.top + 1) OR
           (shape1.top > shape3.top + shape3.Height - 1)) then
        Begin
          Shape1.Top:= Shape1.Top - 1;
          Counter:= Counter + 1;
          Grounded:= False;
        end
        else
        Begin
          Counter:= P1U + 1;
          P1U:= 0;
          Grounded:= False;
        end;

      //Down
      Counter:= 1;
      While (Counter <= P1D) AND (P1D > 0) DO
        if ((shape1.left + shape1.width < shape2.Left + 1) OR
           (shape1.left > shape2.left + shape2.width - 1) OR
           (Shape1.top + shape1.Height < shape2.top) OR
           (shape1.top >= Shape2.top + shape2.Height - 1))
           AND
           ((shape1.left + shape1.width < shape3.Left + 1) OR
           (shape1.left > shape3.left + shape3.width - 1) OR
           (Shape1.top + shape1.Height < shape3.top) OR
           (shape1.top >= Shape3.top + shape3.Height - 1)) then
        Begin
          Shape1.Top:= Shape1.Top + 1;
          Counter:= Counter + 1;
          Grounded:= False;
        end
        else
        Begin
          Counter:= P1D + 1;
          P1D:= 0;
          Grounded:= True;
        end;

      //RIGHT
      Counter:= 1;
      While (Counter <= P1R) AND (P1R > 0) DO
        begin
          if ((shape1.left + shape1.width <= shape2.Left - 1) OR
             (shape1.left > shape2.left + shape2.width - 1) OR
             (Shape1.top + shape1.Height <= shape2.top + 1) OR
             (shape1.top >= Shape2.top + shape2.Height - 1))
             AND
             ((shape1.left + shape1.width <= shape3.Left - 1) OR
             (shape1.left > shape3.left + shape3.width - 1) OR
             (Shape1.top + shape1.Height <= shape3.top + 1) OR
             (shape1.top >= Shape3.top + shape3.Height - 1)) then
          Begin
            Shape1.Left:= Shape1.Left + 1;
            Counter:= Counter + 1;
          end
          else
          Begin
            Counter:= P1R + 1;
            P1R:= 0;
          end;
        end;

        if (edit5.text <> '68') then
          P1R:=P1R - round(P1R / Slide + 0.5);

      //Left
      Counter:= 1;
      While (Counter <= P1L) AND (P1L > 0) DO
        begin
          if ((shape1.left + shape1.width < shape2.Left + 1) OR
             (shape1.left >= shape2.left + shape2.width + 1) OR
             (Shape1.top + shape1.Height <= shape2.top + 1) OR
             (shape1.top >= Shape2.top + shape2.Height - 1))
             AND
             ((shape1.left + shape1.width < shape3.Left + 1) OR
             (shape1.left >= shape3.left + shape3.width + 1) OR
             (Shape1.top + shape1.Height <= shape3.top + 1) OR
             (shape1.top >= Shape3.top + shape3.Height - 1))then
          Begin
            Shape1.Left:= Shape1.Left - 1;
            Counter:= Counter + 1;
          end
          else
          Begin
            Counter:= P1L + 1;
            P1L:= 0;
          end;
        end;

        if (edit5.text <> '65') then
          P1L:=P1L - round(P1L / Slide + 0.5);
end;

procedure TForm1.Button1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //Input Handler
  case Key of
  87 : edit5.text:='';
  68 : edit9.text:='';
  65 : edit8.text:='';
  end;
end;

procedure TForm1.Button1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //Input Handler
  case Key of
    87 : edit5.text:=IntToStr(Key);
    68 : edit9.text:=IntToStr(Key);
    65 : edit8.text:=IntToStr(Key);
    end;
  end;
end.

