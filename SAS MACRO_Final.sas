PROC IMPORT OUT=flowersales 
	DATAFILE= '\flowersales_data_set.csv' 
	DBMS=csv REPLACE; 
	GETNAMES=yes; 
	DATAROW=2; 
	guessingrows=20; 
RUN;
 
* Print the report using a macro variable; 
PROC PRINT DATA = flowersales;        
RUN;

proc means data=flowersales mean;
    var quantity;
    output out=avg mean=meanquantity;
    run; 

data _null_;
    set avg;
    call symput('AVG',trim(left(meanquantity)));
run; 

data flowersales;
    set flowersales;
    AVG=&avg;
    run; 

proc chart data = flowersales; 
	vbar variety / type=mean sumvar=quantity ref=&avg; 
run;

%Macro randomorder (input=, nsets=, seed=, output=);
Data new; 
	set old; 
	&index=RANUNI(&seed); 
Run; 

Proc sort data=new; 
	By &index; 
Run; 

Data new; 
	set new; 
	drop &index;  
run; 

Proc print data=new; 
Run; 

%Mend randomorder;

%randomorder(input=old, nsets=5, seed=0, output=new);


%Macro randomorder (input=, nsets=, seed=, output=);

%do i = 1 %to &nsets;
Data &output; 
	set &input; 
	index=RANUNI(&seed); 
Run; 

Proc sort data=&output; 
	By index; 
Run; 

Data &output; 
	set &output; 
	drop index;  
run; 

Proc print data=&output; 
Run;
%end;

%Mend randomorder;

PROC IMPORT OUT=cork
	DATAFILE= '\cork_data_set.csv' 
	DBMS=csv REPLACE; 
	GETNAMES=yes; 
	DATAROW=2;  
RUN;

%randomorder(input=cork, nsets=5, seed=0, output=outdata);

Proc print data=outData; 
Run;
