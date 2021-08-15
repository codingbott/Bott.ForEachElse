program CliDemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Classes,
  Bott.ForEachElse in '..\Bott.ForEachElse.pas';

procedure machmal(sl: TStringList);
begin
  TForEachElse<string>.All(sl,
    function(s: string): boolean
    begin
      Writeln(s);
      result:=true;
    end,
    procedure()
    begin
      Writeln('empty');
    end);
end;

var
  sl: TStringList;

  s: string;
  b: boolean;
begin
  try
    sl:=TStringList.Create;
    try
      Writeln('empty list:');
      machmal(sl);

      sl.add('a');
      sl.add('b');
      sl.add('c');
      Writeln('filled list:');
      machmal(sl);

      Writeln('classic way:');
      b:=false;
      for s in sl do
      begin
        writeln(s);
        b:=true;
      end;
      if not b then
        writeln('else');

      sl.clear;
      Writeln('classic empty:');
      b:=false;
      for s in sl do
      begin
        writeln(s);
        b:=true;
      end;
      if not b then
        writeln('else');
    finally
      sl.free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.
