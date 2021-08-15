# ForEachElse
Small helper for a for each else implementation in Delphi

```
  TForEachElse<string>.All(enumAbleObject,
    // each callback - result=false will cancel the loop
    function(s: string): boolean
    begin
      Writeln(s);
      result:=true;
    end,
    // else - is called when empty
    procedure()
    begin
      Writeln('empty');
    end);
```    