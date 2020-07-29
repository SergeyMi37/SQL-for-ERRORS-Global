/// make ^ERROR visible in SQL
Class zrcc.ERRORStack Extends %Persistent [ Final, SqlRowIdPrivate, StorageStrategy = global ]
{

Property Day As %Date [ ReadOnly ];

Property Seq As %Integer [ ReadOnly ];

Property StackLevel As %Integer [ ReadOnly ];

Property Type As %String [ ReadOnly ];

Property Item As %String [ ReadOnly ];

Property Value As %String(MAXLEN = "") [ ReadOnly ];

Index idx On (Day, Seq, StackLevel, Type, Item) [ IdKey ];

Storage global
{
<SQLMap name="Map1">
<Data name="Value">
<Delimiter>$c(0)</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ERRORS</Global>
<Subscript name="1">
<Expression>{Day}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Seq}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"*STACK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{StackLevel}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Item}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^zrcc.ERORRSS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

Query Dump(Day As %Date, Seq As %Integer, Segment As %String) As %Query(ROWSPEC = "Ref:%String(MAXLEN=255),Value:%String(MAXLEN="""")") [ SqlProc ]
{
}

ClassMethod DumpExecute(ByRef qHandle As %Binary, Day As %Date = "", Seq As %Integer = "", Segment As %String(VALUELIST=",*LEVEL,*NAMES,*STACK,*VARS,") = "*STACK") As %Status
{
    if $l(Day),'(Day\1=Day) set Day=$ZDH(Day,3)  
    set ok=$d(^ERRORS)
        ,Segment=$tr(Segment,$c(0))
        ,Day=$tr(Day,$c(0))
        ,Seq=$tr(Seq,$c(0))
    if ok,Day]"" set ok=$d(^ERRORS(Day))
    else  set (Segment,Seq)="" 
    if ok,Day]"",Seq]"" set ok=$d(^ERRORS(Day,Seq))
    else  set Segment=""    
    if ok,Day]"",Seq]"",Segment]"" set ok=$d(^ERRORS(Day,Seq,Segment))
    set qHandle=$ZR
        ,qHandle(1)=Day
        ,qHandle(2)=Seq
        ,qHandle(3)=Segment
    Quit ''ok
}

ClassMethod DumpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DumpExecute ]
{
    kill qHandle
    Quit $$$OK
}

ClassMethod DumpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DumpExecute ]
{
    set qHandle=$q(@qHandle,1,value)
        ,AtEnd=(qHandle="")
    if 'AtEnd,qHandle(1)]"" set AtEnd='($qs(qHandle,1)=qHandle(1))
    if 'AtEnd,qHandle(1)]"",qHandle(2)]"" set AtEnd='($qs(qHandle,2)=qHandle(2))
    if 'AtEnd,qHandle(3)]"" set AtEnd='($qs(qHandle,3)=qHandle(3))
    set subs=$ZD($p($p(qHandle,","),"(",2),3)_","_$p(qHandle,",",2,99)
    set Row=$s(AtEnd:"",1:$lb(subs,value))   
    Quit $$$OK
}

}
