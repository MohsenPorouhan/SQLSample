
DECLARE
   TYPE TimeRecTyp IS RECORD (
      hour   SMALLINT := 0, 
      minute VARCHAR(20) := 0,
      second INTEGER := 0);
   TYPE TimeTabTyp IS TABLE OF TimeRecTyp
      INDEX BY BINARY_INTEGER;
      
      testt2 TimeRecTyp;
      testt  TimeTabTyp;
      
      i BINARY_INTEGER :=0;
      j BINARY_INTEGER :=0;
BEGIN
testt2.hour:=222;
testt2.minute:=33;
testt2.second:=444;

testt(0):=testt2;

testt2.hour:=77;
testt2.minute:=888;
testt2.second:=99;

testt(1):=testt2;

dbms_output.put_line('Hello Record!     ' || testt2.hour); 

dbms_output.put_line('Hello Table!     ' || testt(0).minute); 

dbms_output.put_line('Hello Table!     ' || testt(1).minute); 

i:=testt.FIRST;
WHILE i IS NOT NULL LOOP
dbms_output.put_line('hour!     ' || 'index of ' || i || ' : ' || testt(i).hour); 
dbms_output.put_line('minute!     ' || 'index of ' || i || ' : ' || testt(i).minute); 
dbms_output.put_line('second!     ' || 'index of ' || i || ' : ' || testt(i).second); 
i:=testt.NEXT(i);
END LOOP;
END;