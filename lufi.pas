program lufi_vadasz;
uses dos, crt, graph;
type score = record
          nev : string[10];
          pont : longint;
    end;
     gcursor = record
            screenmask,
            cursormask : array [0..15] of word;
            hotx,hoty : integer;
    end;
const
   CROSS : GCursor =
   (  ScreenMask : ( $F01F, $E00F, $C007, $8003,
                     $0441, $0C61, $0381, $0381,
                     $0381, $0C61, $0441, $8003,
                     $C007, $E00F, $F01F, $FFFF );
      CursorMask : ( $0000, $07C0, $0920, $1110,
                     $2108, $4004, $4004, $783C,
                     $4004, $4004, $2108, $1110,
                     $0920, $07C0, $0000, $0000 );
      hotX : $0007; hotY : $0007 );
var regs : registers;
    rekord : score;
    highs : array[1..3] of score;
    f : file of score;
    ch : char;
    nincs_lufi, nincs_lufi2, nincs_lufi3, nincs_lufi4, nincs_lufi5 : boolean;
    lufi_x, lufi_y, lufi2_x, lufi2_y, lufi3_x, lufi3_y, lufi4_x, lufi4_y, lufi5_x, lufi5_y : integer;
    lufi_szin, lufi2_szin, lufi3_szin, lufi4_szin, lufi5_szin : byte;
    tolteny : shortint;
    leesett, uzemmod, meghajto, kereszt_x, kereszt_y, kereszt_kozep_x, kereszt_kozep_y : integer;
    pont : longint;
    nev: string[10];

procedure setcursor(cursor:gcursor); forward;
procedure egerkezeles; forward;
procedure lufi_rajzolas; forward;
procedure uj_lufi; forward;
procedure lufi_mozog; forward;
procedure kereszt; forward; (*megoldva egerrel*)
procedure lufi_torol(var x,y :integer); forward;
procedure loves; forward;
procedure kezdes; forward;
procedure statusz; forward;
procedure leeses; forward;
procedure jatek; forward;
procedure legjobb; forward;
procedure legjobb1; forward;
procedure legjobb2; forward;
procedure legjobb3; forward;

procedure setcursor(cursor:gcursor);
BEGIN
     regs.ax:=$09;
     regs.bx:=cursor.hotx;
     regs.cx:=cursor.hoty;
     regs.dx:=ofs (cursor.screenmask);
     regs.es:=seg (cursor.screenmask);
     intr($33,regs);
END;

procedure egerkezeles;
BEGIN
     regs.ax:=0;
     intr($33,regs);
     if regs.ax=0 then outtextxy(10,10,'Nincs eger telepitve.');
     setcursor(CROSS);
     intr($33,regs);
     setcursor(CROSS);
     regs.ax:=1;
     intr($33,regs);
END;

procedure lufi_rajzolas;
BEGIN
     if (nincs_lufi) or (nincs_lufi2) or (nincs_lufi3) or (nincs_lufi4) or (nincs_lufi5) then
        begin
             uj_lufi;
        end;
     lufi_mozog;
END;

procedure uj_lufi;
var veletlen : integer;
BEGIN
     if (nincs_lufi) then
        begin
             veletlen:=random(100)+1;
             if (veletlen=10) then
                begin
                     nincs_lufi:=FALSE;
                     lufi_szin:=random(14)+1;
                     lufi_x:=random(470)+16;
                     lufi_y:=26;
                end;
        end;
     if (nincs_lufi2) then
        begin
             veletlen:=random(100)+1;
             if (veletlen=20) then
                begin
                     nincs_lufi2:=FALSE;
                     lufi2_szin:=random(14)+1;
                     lufi2_x:=random(470)+16;
                     lufi2_y:=26;
                end;
        end;
     if (nincs_lufi3) then
        begin
             veletlen:=random(100)+1;
             if (veletlen=30) then
                begin
                     nincs_lufi3:=FALSE;
                     lufi3_szin:=random(14)+1;
                     lufi3_x:=random(470)+16;
                     lufi3_y:=26;
                end;
        end;
     if (nincs_lufi4) then
        begin
             veletlen:=random(100)+1;
             if (veletlen=40) then
                begin
                     nincs_lufi4:=FALSE;
                     lufi4_szin:=random(14)+1;
                     lufi4_x:=random(470)+16;
                     lufi4_y:=26;
                end;
        end;
     if (nincs_lufi5) then
        begin
             veletlen:=random(100)+1;
             if (veletlen=50) then
                begin
                     nincs_lufi5:=FALSE;
                     lufi5_szin:=random(14)+1;
                     lufi5_x:=random(470)+16;
                     lufi5_y:=26;
                end;
        end;
END;

procedure lufi_mozog;
BEGIN
     regs.ax:=2;
     intr($33,regs);
     setcolor(0);
     if (nincs_lufi=FALSE) then
        begin
             setfillstyle(1,lufi_szin);
             lufi_y:=lufi_y+1;
             fillellipse(lufi_x,lufi_y,15,25);
        end;
     if (nincs_lufi2=FALSE) then
        begin
             setfillstyle(1,lufi2_szin);
             lufi2_y:=lufi2_y+1;
             fillellipse(lufi2_x,lufi2_y,15,25);
        end;
     if (nincs_lufi3=FALSE) then
        begin
             setfillstyle(1,lufi3_szin);
             lufi3_y:=lufi3_y+1;
             fillellipse(lufi3_x,lufi3_y,15,25);
        end;
     if (nincs_lufi4=FALSE) then
        begin
             setfillstyle(1,lufi4_szin);
             lufi4_y:=lufi4_y+1;
             fillellipse(lufi4_x,lufi4_y,15,25);
        end;
     if (nincs_lufi5=FALSE) then
        begin
             setfillstyle(1,lufi5_szin);
             lufi5_y:=lufi5_y+1;
             fillellipse(lufi5_x,lufi5_y,15,25);
        end;
     regs.ax:=1;
     intr($33,regs);
END;

procedure kereszt;
BEGIN
(*
     setcolor(0);
     line(kereszt_x-20,kereszt_y-10,kereszt_x-11,kereszt_y-10);
     line(kereszt_x-9,kereszt_y-10,kereszt_x,kereszt_y-10);
     line(kereszt_x-10,kereszt_y-20,kereszt_x-10,kereszt_y-11);
     line(kereszt_x-10,kereszt_y-9,kereszt_x-10,kereszt_y);
     if (ch=#75) then kereszt_x:=kereszt_x-10
        else if (ch=#77) then kereszt_x:=kereszt_x+10
             else if (ch=#72) then kereszt_y:=kereszt_y-10
                  else if (ch=#80) then kereszt_y:=kereszt_y+10;
     if (kereszt_x<10) then kereszt_x:=500
        else if (kereszt_x>500) then kereszt_x:=10;
     if (kereszt_y<10) then kereszt_y:=480
         else if (kereszt_y>480) then kereszt_y:=10;
     setcolor(15);
     kereszt_kozep_x:=kereszt_x-10;
     kereszt_kozep_y:=kereszt_y-10;
     line(kereszt_x-20,kereszt_y-10,kereszt_x-11,kereszt_y-10);
     line(kereszt_x-9,kereszt_y-10,kereszt_x,kereszt_y-10);
     line(kereszt_x-10,kereszt_y-20,kereszt_x-10,kereszt_y-11);
     line(kereszt_x-10,kereszt_y-9,kereszt_x-10,kereszt_y);
*)
END;

procedure lufi_torol(var x,y :integer);
BEGIN
     setcolor(0);
     setfillstyle(0,0);
     fillellipse(x,y,15,26);
     y:=26;
END;

procedure loves;
BEGIN
     regs.ax:=5;
     intr($33,regs);
     kereszt_kozep_x:=regs.cx;
     kereszt_kozep_y:=regs.dx;
     if (regs.bx<>0) then
        begin
	     regs.ax:=2;
             intr($33,regs);
             tolteny:=tolteny-1;
             if (tolteny<0) then tolteny:=0;
             setfillstyle(1,0);
             bar(502,180,638,190);
             if (lufi_x-15<=kereszt_kozep_x) and (lufi_x+15>=kereszt_kozep_x) and (lufi_y+25>=kereszt_kozep_y)
             and (lufi_y-25<=kereszt_kozep_y) and (getpixel(kereszt_kozep_x,kereszt_kozep_y)<>0) then
                 begin
                      if (tolteny>0) then
                         begin
                              tolteny:=tolteny+1;
                              lufi_torol(lufi_x,lufi_y);
                              nincs_lufi:=TRUE;
                              pont:=pont+lufi_szin;
                              setfillstyle(0,0);
                              bar(502,100,638,120);
                         end;
                 end;
             if (lufi2_x-15<=kereszt_kozep_x) and (lufi2_x+15>=kereszt_kozep_x) and (lufi2_y+25>=kereszt_kozep_y)
             and (lufi2_y-25<=kereszt_kozep_y) and (getpixel(kereszt_kozep_x,kereszt_kozep_y)<>0) then
                 begin
                      if (tolteny>0) then
                         begin
                              tolteny:=tolteny+1;
                              lufi_torol(lufi2_x,lufi2_y);
                              nincs_lufi2:=TRUE;
                              pont:=pont+lufi2_szin;
                              setfillstyle(0,0);
                              bar(502,100,638,120);
                         end;
                 end;
             if (lufi3_x-15<=kereszt_kozep_x) and (lufi3_x+15>=kereszt_kozep_x) and (lufi3_y+25>=kereszt_kozep_y)
             and (lufi3_y-25<=kereszt_kozep_y) and (getpixel(kereszt_kozep_x,kereszt_kozep_y)<>0) then
                 begin
                      if (tolteny>0) then
                         begin
                              tolteny:=tolteny+1;
                              lufi_torol(lufi3_x,lufi3_y);
                              nincs_lufi3:=TRUE;
                              pont:=pont+lufi3_szin;
                              setfillstyle(0,0);
                              bar(502,100,638,120);
                         end;
                 end;
             if (lufi4_x-15<=kereszt_kozep_x) and (lufi4_x+15>=kereszt_kozep_x) and (lufi4_y+25>=kereszt_kozep_y)
             and (lufi4_y-25<=kereszt_kozep_y) and (getpixel(kereszt_kozep_x,kereszt_kozep_y)<>0) then
                 begin
                      if (tolteny>0) then
                         begin
                              tolteny:=tolteny+1;
                              lufi_torol(lufi4_x,lufi4_y);
                              nincs_lufi4:=TRUE;
                              pont:=pont+lufi4_szin;
                              setfillstyle(0,0);
                              bar(502,100,638,120);
                         end;
                 end;
             if (lufi5_x-15<=kereszt_kozep_x) and (lufi5_x+15>=kereszt_kozep_x) and (lufi5_y+25>=kereszt_kozep_y)
             and (lufi5_y-25<=kereszt_kozep_y) and (getpixel(kereszt_kozep_x,kereszt_kozep_y)<>0) then
                 begin
                      if (tolteny>0) then
                         begin
                              tolteny:=tolteny+1;
                              lufi_torol(lufi5_x,lufi5_y);
                              nincs_lufi5:=TRUE;
                              pont:=pont+lufi5_szin;
                              setfillstyle(0,0);
                              bar(502,100,638,120);
                         end;
                 end;
	     regs.ax:=1;
             intr($33,regs);
	end;
END;

procedure kezdes;
var i : integer;
BEGIN
     pont:=0;
     tolteny:=10;
     clrscr;
     assign(f,'legjobb.pon');
     {$I-}
     reset(f);
     if ioresult<>0 then
        begin
             rekord.nev:='Nincs';
             rekord.pont:=0;
             for i:=1 to 3 do highs[i]:=rekord;
             rewrite(f);
             for i:=1 to 3 do write(f,highs[i]);
        end
     else
     for i:=1 to 3 do
         begin
              read(f,rekord);
              highs[i]:=rekord;
         end;
     close(f);
     nincs_lufi:=TRUE;
     nincs_lufi2:=TRUE;
     nincs_lufi3:=TRUE;
     nincs_lufi4:=TRUE;
     nincs_lufi5:=TRUE;
     leesett:=0;
     kereszt_x:=320;
     kereszt_y:=240;
     randomize;
     meghajto:=DETECT;
     initgraph(meghajto,uzemmod,'');
     egerkezeles;
END;

procedure statusz;
var st : string;
    verzio : string[5];
    x, y : integer;
    szin : byte;
BEGIN
     setcolor(15);
     verzio:='1.1';
     line(501,0,501,480);
     line(639,0,639,480);
     line(501,0,640,0);
     line(501,80,640,80);
     line(501,110,640,110);
     line(501,160,640,160);
     line(501,390,640,390);
     line(501,479,640,479);
     st:='Cs£cstart¢k:';
     outtextxy(510,10,st);
     st:='1. '+highs[1].nev;
     outtextxy(510,20,st);
     str(highs[1].pont,st);
     st:=st+' pont';
     outtextxy(540,30,st);
     st:='2. '+highs[2].nev;
     outtextxy(510,40,st);
     str(highs[2].pont,st);
     st:=st+' pont';
     outtextxy(540,50,st);
     st:='3. '+highs[3].nev;
     outtextxy(510,60,st);
     str(highs[3].pont,st);
     st:=st+' pont';
     outtextxy(540,70,st);
     st:='Pontod:';
     outtextxy(510,90,st);
     str(pont,st);
     st:=st+' pont';
     outtextxy(510,100,st);
     st:='Maximum 3 lufi';
     outtextxy(510,120,st);
     st:='eshet le.';
     outtextxy(510,130,st);
     st:='Leesett lufik:';
     outtextxy(510,140,st);
     str(leesett,st);
     outtextxy(510,150,st);
     st:='T”lt‚nyek sz ma:';
     outtextxy(510,170,st);
     str(tolteny,st);
     st:=st+' db';
     outtextxy(510,180,st);
     for szin:=1 to 14 do
         begin
              setfillstyle(1,szin);
              bar(510,190+(szin*10),515,195+(szin*10));
              str(szin,st);
              st:=st+' pont';
              outtextxy(520,190+(szin*10),st);
         end;
     st:='K‚sz¡tette:';
     outtextxy(510,400,st);
     st:='Szigecs n D vid';
     outtextxy(510,410,st);
     st:='Verzi¢: '+verzio;
     outtextxy(510,440,st);
END;

procedure leeses;
BEGIN
     if (lufi_y=505) then
        begin
             leesett:=leesett+1;
             nincs_lufi:=TRUE;
             lufi_y:=26;
             setfillstyle(0,0);
             bar(502,150,640,160);
        end;
     if (lufi2_y=505) then
        begin
             leesett:=leesett+1;
             nincs_lufi2:=TRUE;
             lufi2_y:=26;
             setfillstyle(0,0);
             bar(502,150,640,160);
        end;
     if (lufi3_y=505) then
        begin
             leesett:=leesett+1;
             nincs_lufi3:=TRUE;
             lufi3_y:=26;
             setfillstyle(0,0);
             bar(502,150,640,160);
        end;
     if (lufi4_y=505) then
        begin
             leesett:=leesett+1;
             nincs_lufi4:=TRUE;
             lufi4_y:=26;
             setfillstyle(0,0);
             bar(502,150,640,160);
        end;
     if (lufi5_y=505) then
        begin
             leesett:=leesett+1;
             nincs_lufi5:=TRUE;
             lufi5_y:=26;
             setfillstyle(0,0);
             bar(502,150,640,160);
        end;
END;

procedure jatek;
BEGIN
     kezdes;
     repeat
           statusz;
           loves;
           lufi_rajzolas;
           kereszt;
           leeses;
           if (keypressed) then ch:=readkey
           else ch:='0';
     until (ch=#27) or (leesett=3);
     legjobb;
END;

procedure legjobb;
var i : integer;
BEGIN
     if (pont>highs[1].pont) then legjobb1
        else if (pont>highs[2].pont) then legjobb2
             else if (pont>highs[3].pont) then legjobb3;
     assign(f,'legjobb.pon');
     rewrite(f);
     write(f,highs[1]);
     write(f,highs[2]);
     write(f,highs[3]);
     close(f);
END;

procedure legjobb1;
var i : integer;
BEGIN
     closegraph;
     clrscr;
     writeln('Cs£cstart¢k:');
     highs[3]:=highs[2];
     highs[2]:=highs[1];
     gotoxy(1,3);
     for i:=2 to 3 do
         begin
              write(i,'. ',highs[i].nev);
              gotoxy(15,i+1);
              writeln(highs[i].pont);
         end;
     gotoxy(1,2);
     write('1.            ',pont);
     gotoxy(4,2);
     readln(nev);
     highs[1].nev:=nev;
     highs[1].pont:=pont;
     gotoxy(1,5);
     delay(1000);
END;

procedure legjobb2;
BEGIN
     closegraph;
     clrscr;
     writeln('Cs£cstart¢k:');
     highs[3]:=highs[2];
     gotoxy(1,2);
     write('1. ',highs[1].nev);
     gotoxy(15,2);
     writeln(highs[1].pont);
     gotoxy(1,4);
     write('3. ',highs[3].nev);
     gotoxy(15,4);
     writeln(highs[3].pont);
     gotoxy(1,3);
     write('2.            ',pont);
     gotoxy(4,3);
     readln(nev);
     highs[2].nev:=nev;
     highs[2].pont:=pont;
     gotoxy(1,5);
     delay(1000);
END;

procedure legjobb3;
var i : integer;
BEGIN
     closegraph;
     clrscr;
     writeln('Cs£cstart¢k:');
     for i:=1 to 2 do
         begin
              write(i,'. ',highs[i].nev);
              gotoxy(15,i+1);
              writeln(highs[i].pont);
         end;
     write('3.            ',pont);
     gotoxy(4,4);
     readln(nev);
     highs[3].nev:=nev;
     highs[3].pont:=pont;
     gotoxy(1,5);
     delay(1000);
END;

BEGIN
     jatek;
END.