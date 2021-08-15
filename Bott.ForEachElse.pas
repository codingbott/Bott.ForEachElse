unit Bott.ForEachElse;

interface

uses
  System.Generics.Collections,
  System.SysUtils;

type
  TForEachElse<TSource> = class
  public
    class procedure All(obj: TObject; each: TFunc<TSource, boolean>;
      _else: TProc);
  end;

implementation

uses
  System.Rtti;

{ TForEachElse<TSource> }

class procedure TForEachElse<TSource>.All(obj: TObject;
  each: TFunc<TSource, boolean>; _else: TProc);
var
  context: TRttiContext;
  objectWithGetEnumeratorType,
  enumeratorType: TRttiType;

  getEnumeratorMethod,
  moveNextMethod: TRttiMethod;

  enumeratorValue: TValue;

  isLooped: boolean;
  currentElement: TSource;
begin
  context:=TRttiContext.Create;
  objectWithGetEnumeratorType:=context.GetType(obj.ClassInfo);
  getEnumeratorMethod:=objectWithGetEnumeratorType.GetMethod('GetEnumerator');

  enumeratorValue:=getEnumeratorMethod.Invoke(obj, []);
  try
    enumeratorType:=context.GetType(enumeratorValue.TypeInfo);
    moveNextMethod:=enumeratorType.GetMethod('MoveNext');

    isLooped:=false;

    while (moveNextMethod.Invoke(enumeratorValue.AsObject, []).AsBoolean) do
    begin
      isLooped:=true;
      enumeratorType.GetProperty('Current').GetValue(enumeratorValue.AsObject).TryAsType<TSource>(currentElement);
      if not each(currentElement) then
        break;
    end;
    if not isLooped then
      _else();
  finally
    enumeratorValue.AsObject.Free;
  end;
end;

end.
