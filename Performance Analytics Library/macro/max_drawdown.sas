/*---------------------------------------------------------------
* NAME: max_drawdown.sas
*
* PURPOSE: Calculate the maximum drawdown from peak equity
*
* NOTES: 
*
* MACRO OPTIONS:
* returns - Required.  Data Set containing returns with option to include risk free rate variable.
* scale - Optional. Number of periods in a year {any positive integer, ie daily scale= 252, monthly scale= 12, quarterly scale= 4}.    
*         Default=1
* invert - Optional. Specify whether to invert the drawdown measure.  Default=TRUE.
* dateColumn - Optional. Date column in Data Set. Default=DATE
* outData - Optional. Output Data Set with maximum drawdowns.  Default="max_dd".
*
* Later modifications of max_drawdown may include an option for weights.
*
* MODIFIED:
* 5/27/2016 � QY - Initial Creation
*
* Copyright (c) 2015 by The Financial Risk Group, Cary, NC, USA.
*-------------------------------------------------------------*/
%macro max_drawdown(returns,
							method= DISCRETE,
							invert= TRUE,
							dateColumn= DATE,
							outData= max_dd);
							
%local vars drawdown i;

%let vars= %get_number_column_names(_table= &returns, _exclude= &dateColumn); 
%put VARS IN max_drawdown: (&vars);

%let drawdown= %ranname();
%let i = %ranname();

%Drawdowns(&returns, method=&method, outdata=&drawdown)

proc means data= &drawdown min noprint;
output out= &outData;
run;

data &outData(drop=&i);
	format _stat_ $32.;
	set &outData;
	drop _freq_  _type_ &dateColumn;
	where _stat_= 'MIN';
	if _stat_='MIN' then
		_stat_='Worst Drawdowns';
	%if %upcase(&invert) = TRUE %then %do;
		array ret[*] &vars;
		do &i=1 to dim(ret);
			ret[&i]=-ret[&i];
		end;
	%end;
run;

proc datasets lib=work nolist;
	delete &drawdown;
run;
quit;

%mend;
