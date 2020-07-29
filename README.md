 ~~~
 This is a coding example working on IRIS 2020.1 and on Caché 2018.1.3 
 It will not be kept in sync with new versions      
 It is also NOT serviced by InterSystems Support !   
~~~ 

Standard error logs in IRIS / Caché / Ensemble are written global ^ERRORS.  
As this piece dates back some decades back to previous millenium its structure  
is far from the typical SQL storage structures.  
The global is written by routine %ETN.int and the content becomes visible from   
terminmal command line by routine %ERN or in Mgmt Portal as Application Error Log.   

It is just not available to SQL as there is no Class wrapped around.
For several reasons:  
- When it was designed it was good practice to have index like structures in the  
same globals as the data. If I say 'like', this means it is of no use for SQL.   
- As next the content of objects are going to deeper levels than the rest. As a   
consequence the depth of subscripts (typically IdKey) varies from 3 to 11.  

^ERRORS is indpendent in every namespace    
It is  stuctured by Day,SequenceByDay, Type, ItemName (Variable, OREF),Value   
__zrcc.ERRORStack__  covers this a SQL table.    
Deeper content of the objects becomes visible by the included custom query.  
The SQL procedure __zrcc.ERRORStac_Dump(Day,Sequence)__ returns all available  
content and presents subscripts and values as you see in global listing.  

How to make best use of both components: 
- first find your day and sequence number using SQL

Example: __SELECT * FROM zrcc.ERRORStack where item='$ZE'__
~~~
    Day	 Seq	Stk Type	Item	Value
2020-07-02	1	 0	   V	  $ZE	<WRITE>zSend+204^%Net.HttpRequest.1
2020-07-07	1	 0	   V	  $ZE	<WRITE>zSend+204^%Net.HttpRequest.1
2020-07-15	1	 0	   V	  $ZE	<WRITE>zSend+204^%Net.HttpRequest.1
2020-07-20	1	 0	   V	  $ZE	<LOG ENTRY>
2020-07-26	1	 0	   V	  $ZE	<WRITE>zSend+204^%Net.HttpRequest.1
~~~
Then: __call zrcc.ERRORStack_Dump('2020-07-26',1)__
~~~
Row count: 541 Performance: 0.026 seconds  6557 global references
Ref	                                Value

2020-07-26,1,"*STACK",0,"V","Routine")	zSend+204^%Net.HttpRequest.1
2020-07-26,1,"*STACK",1,"I")	1^S^^^0^
2020-07-26,1,"*STACK",1,"L")	1 SIGN ON
2020-07-26,1,"*STACK",1,"S")	
2020-07-26,1,"*STACK",1,"T")	SIGN ON
2020-07-26,1,"*STACK",1,"V","%dsTrackingKeys","N","""Analyzer""")	6
2020-07-26,1,"*STACK",1,"V","%dsTrackingKeys","N","""Architect""")	7
2020-07-26,1,"*STACK",1,"V","%dsTrackingKeys","N","""DashboardViewer""")	8
2020-07-26,1,"*STACK",1,"V","%dsTrackingKeys","N","""ResultSet""")	9
2020-07-26,1,"*STACK",1,"V","%objcn")	2
2020-07-26,1,"*STACK",3,"V","Task")	<OBJECT REFERENCE>[1@%SYS.Task]
2020-07-26,1,"*STACK",3,"V","Task","OREF",1)	142
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,0)	3671
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,1)	+----------------- general information ---------------
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,2)	| oref value: 1
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,3)	| class name: %SYS.Task
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,4)	| %%OID: $lb("13","%SYS.Task")
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,5)	| reference count: 5
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,6)	+----------------- attribute values ------------------
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,7)	| %Concurrency =
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,8)	4 <Set>
- - - 
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,53)	| EmailOutput =
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,54)	0
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,55)	| EndDate =
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,56)	""
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,57)	| Error =
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,58)	"<WRITE>zSend+204^%Net.HttpRequest.1"
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,59)	| Expires =
- - -
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,111)	| Status =
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,112)	"0 "_$lb($lb(5002,"POST to Server Failed",,,,,,,,$lb(,"%SYS",$lb("$^zSend+204^%Net.HttpRequest.1 +1","$^zPost+1^%Net.HttpRequest.1 +1","$^zSendData+20^FT.Collector.1 +1","$^zTransfer+12^FT.Collector.1 +1","$^zOnTask+3^%SYS.Task.FeatureTracker.1 +1","D^zRunTask+74^%SYS.TaskSuper.1 +1","$^zRunTask+54^%SYS.TaskSuper.1 +1","D^zRun+26^%SYS.TaskSuper.1 +1"))),$lb(6085,"ISC.FeatureTracker.SSL.Config","SSL/TLS error in SSL_connect(), SSL_ERROR_SSL: protocol error, error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed",,,,,,,$lb(,"%SYS",$lb("e^zSend+303^%Net.HttpRequest.1^1","e^zPost+1^%Net.HttpRequest.1^1","e^zSendData+20^FT.Collector.1^1","e^zTransfer+12^FT.Collector.1^1","e^zOnTask+3^%SYS.Task.FeatureTracker.1^1","e^zRunTask+74^%SYS.TaskSuper.1^1","d^zRunTask+54^%SYS.TaskSuper.1^1","e^zRun+26^%SYS.TaskSuper.1^1","d^^^0"))))/* ERROR #5002: Cache error: POST to Server Failed- ERROR #6085: Unable to write to socket with SSL/TLS configuration 'ISC.FeatureTracker.SSL.Config', error reported 'SSL/TLS error in SSL_connect(), SSL_ERROR_SSL: protocol error, error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed' */
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,113)	| SuspendOnError =
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,114)	0
2020-07-26,1,"*STACK",3,"V","Task","OREF",1,115)	| Suspended =
- - -
2020-07-26,1,"*STACK",6,"V","Status1")	1
2020-07-26,1,"*STACK",6,"V","Task")	<OBJECT REFERENCE>[1@%SYS.Task]
2020-07-26,1,"*STACK",6,"V","Task","OREF",1)	142
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,0)	3671
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,1)	+----------------- general information ---------------
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,2)	| oref value: 1
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,3)	| class name: %SYS.Task
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,4)	| %%OID: $lb("13","%SYS.Task")
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,5)	| reference count: 5
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,6)	+----------------- attribute values ------------------
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,7)	| %Concurrency =
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,8)	4 <Set>
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,9)	| DailyEndTime =
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,10)	0
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,11)	| DailyFrequency =
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,12)	0
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,13)	| DailyFrequencyTime =
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,14)	""
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,15)	| DailyIncrement =
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,16)	""
2020-07-26,1,"*STACK",6,"V","Task","OREF",1,17)	| DailyStartTime =
- - - 
2020-07-26,1,"*STACK",12,"V","%00000","N","""JournalState""")	12
2020-07-26,1,"*STACK",13,"I")	13^Z^ETNERRB^%ETN^0
2020-07-26,1,"*STACK",13,"L")	13 ERROR TRAP S $ZTRAP="ETNERRB^%ETN"
2020-07-26,1,"*STACK",13,"S")	S $ZTRAP="ETNERRB^%ETN"
2020-07-26,1,"*STACK",13,"T")	ERROR TRAP

541 row(s) affected

~~~
