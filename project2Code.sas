
/*--Import csv file--*/

FILENAME REFFILE '/folders/myfolders/studyfolder/NEIPM25SCC.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=STUDY.PM25Baltimore;
	GETNAMES=YES;
RUN;


/*--Subset dataset--*/

proc sql noprint;
	create table STUDY.PM25BalVeh as select * from STUDY.PM25Baltimore 
	where(Short_Name like '%Vehicle%') 
	or (Short_Name like '%Motor%');


/*--Generate vline Plot: Plot 1--*/

proc sgplot data=STUDY.PM25Baltimore;
	/*--TITLE and FOOTNOTE--*/
	title 'Total Vehicle Emissions from PM2.5 in Baltimore';

	/*--Line chart settings--*/
	vline year / response=Emissions lineattrs=(thickness=3 color=CX003399) 
		stat=Sum;

	/*--Response Axis--*/
	yaxis grid;
run;

/*--Generate vline Plot: Plot 2 & 3--*/

proc sgplot data=STUDY.PM25BalVeh;
	/*--TITLE and FOOTNOTE--*/
	title 'Emissions from Motor Vehicles by Fuel Type in Baltimore';

	/*--Line chart settings--*/
	vline year / response=Emissions group=SCC_Level_Two lineattrs=(thickness=3) 
		stat=Sum;

	/*--Response Axis--*/
	yaxis grid;
run;

proc sgplot data=STUDY.PM25BalVeh;
	/*--TITLE and FOOTNOTE--*/
	title 'Emissions from Motor Vehicles by Fuel Type by Vehicle Type in Baltimore';

	/*--Line chart settings--*/
	vline year / response=Emissions group=SCC_Level_Three lineattrs=(thickness=3) 
		stat=Sum;

	/*--Response Axis--*/
	yaxis grid;
run;

/* Split a column by delimiter*/

data STUDY.PM25BalVehSplit;
	set STUDY.PM25BalVeh;
	
	SCC_Level_Four_Area = scan (SCC_Level_Four,1,':');
	SCC_Level_Four_Origin = scan (SCC_Level_Four2,':');

run;data 

/*--Generate vline Plot: Plot 4 & 5--*/

proc sgplot data=STUDY.PM25BALVEH;
	/*--TITLE and FOOTNOTE--*/
	title 'Emissions from Motor Vehicles by Area in Baltimore';

	/*--Line chart settings--*/
	vline year / response=Emissions group=SCC_Level_Four_Area 
		lineattrs=(thickness=3) stat=Sum;

	/*--Response Axis--*/
	yaxis grid;
run;

proc sgplot data=STUDY.PM25BALVEH;
	/*--TITLE and FOOTNOTE--*/
	title 'Emissions from Motor Vehicles by Origin in Baltimore';

	/*--Line chart settings--*/
	vline year / response=Emissions group=SCC_Level_Four_Origin 
		lineattrs=(thickness=3) stat=Sum;

	/*--Response Axis--*/
	yaxis grid;
run;
