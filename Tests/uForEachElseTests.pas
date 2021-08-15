unit uForEachElseTests;

interface

uses
  Bott.ForEachElse,
  Classes,
  system.Generics.Collections,
  DUnitX.TestFramework;

type
  TTest = class(TCollectionItem)
  private
    ftest: string;
  public
    property test: string read ftest write ftest;
  end;

  [TestFixture]
  TForEachElseTests = class
  private
  public
    [Test]
    procedure ForEach;
    [Test]
    procedure _Else;
    [Test]
    procedure All;
    [Test]
    procedure Break;
    [Test]
    procedure GenericTEnum;
  end;


implementation

{ TForEachElseTests }

procedure TForEachElseTests.All;
var
  a: TList;
  i: integer;
begin
  a:=TList.Create;
  try
    a.add(pointer(1));
    a.add(pointer(2));

    i:=0;
    TForEachElse<pointer>.All(a,
      function(x: Pointer): Boolean
      begin
        i:=i+integer(x);
        result:=true;
      end,
      procedure()
      begin
      end
    );
    Assert.AreEqual(3, i);
  finally
    a.Free;
  end;
end;

procedure TForEachElseTests.Break;
var
  a: TCollection;
  i: integer;
  x: TTest;
begin
  a:=TCollection.Create(TTest);
  try
    x:=a.add() as TTest;
    x.test:='bla';
    a.add();
    i:=0;

    TForEachElse<TTest>.All(a,
      function(x: TTest): Boolean
      begin
        inc(i);
        result:=false;
      end,
      procedure()
      begin
      end
    );
    Assert.AreEqual(1, i);
  finally
    a.Free;
  end;
end;

procedure TForEachElseTests.ForEach;
var
  a: TStringList;
begin
  a:=TStringList.Create;
  try
    a.add('a1');

    TForEachElse<string>.All(a,
      function(x: string): Boolean
      begin
        assert.Pass('for called');
        result:=false;
      end,
      procedure()
      begin
        assert.Fail('else called');
      end
    );
  finally
    a.Free;
  end;
end;

procedure TForEachElseTests.GenericTEnum;
var
  a: TList<string>;
begin
  a:=TList<string>.Create;
  try
    a.add('hallo');

    TForEachElse<string>.All(a,
      function(x: string): Boolean
      begin
        assert.AreEqual('hallo', x);
        result:=false;
      end,
      procedure()
      begin
      end
    );
  finally
    a.Free;
  end;
end;

procedure TForEachElseTests._Else;
var
  a: TStringList;
begin
  a:=TStringList.Create;
  try
    TForEachElse<string>.All(a,
      function(x: string): Boolean
      begin
        assert.Fail('foreach called');
        result:=false;
      end,
      procedure()
      begin
        assert.Pass('else called');
      end
    );
  finally
    a.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TForEachElseTests);

end.
