/*---------------------------------------------------------------
* NAME: Chart_AutoRegression.sas
*
* PURPOSE: Creates a series of auto-regression charts for analysis using a returns data set.
*		   This macro is in tandem with chart.ACFplus from the R Performance Analytics Library.
*		   Therefore, the default options are set to plot only ACF and PACF charts, with user discretion that
*		   there are many more plots for analysis available which have been included in this macro.
*
* MACRO OPTIONS:
* returns - required.  Data Set containing returns.
* asset- required.  Specifies the variable or asset to be plotted.
* lag- required.  Specifies the amount of lags to plot in each chart.
* title- required.  Title for Charts. [Default= AutoRegression Analysis for &asset]
* all- option.  Option to plot all charts available via Proc Timeseries for analysis. [Default= FALSE]
* ACF- option. Option to plot an ACF chart for the specified lag. [Default= TRUE]
* PACF- option.  Option to plot a PACF chart for the specified lag. [Default= TRUE]
* WN- option.  Option to plot White Noise charts for the specified lag. [Default= FALSE]
* IACF- option.  Option to plot Inverse ACF charts for the specified lag. [Default= FALSE]
* Residual- option.  Option to plot Residual charts for the specified lag. [Default= FALSE]
* SeasonalAdjusted- option.  Option to plot a Seasonal adjusted chart for the specified lag. [Default= FALSE]
* SeasonalComponent- option.  Option to plot a Seasonal component chart for the specified lag. [Default= FALSE]
* SeasonalCycle- option.  Option to plot a Seasonal cycle chart for the specified lag. [Default= FALSE]
* TrendComponent- option.  Option to plot a trend component chart for the specified lag. [Default= FALSE]
* TrendCycleComponent- option.  Option to plot a trend cycle component chart for the specified lag. [Default= FALSE]
* TrendCycleSeasonal- option.  Option to plot a Seasonally adjusted trend cycle chart for the specified lag. [Default= FALSE]
* dateColumn- specifies the date column for returns in the data set. [Default= Date]
*
* MODIFIED:
* 1/25/2016 � CJ - Initial Creation
*
* Copyright (c) 2016 by The Financial Risk Group, Cary, NC, USA.
*-------------------------------------------------------------*/

%macro Chart_AutoRegression(returns,
								   asset=,
								   lag=,
								   title= AutoRegression Analysis for &asset,
								   ALL= FALSE, 
								   ACF= TRUE, 
								   PACF= TRUE, 
								   WN= FALSE,
								   IACF= FALSE,
								   RESIDUAL= FALSE,
								   SeasonalAdjusted= FALSE,
								   SeasonalComponent= FALSE,
								   SeasonalCycle= FALSE,
								   TrendComponent= FALSE,
								   TrendCycleComponent= FALSE,
								   TrendCycleSeasonal= FALSE,
								   dateColumn= Date);

%local autoreg;
/*Find all variable names excluding the date column and risk free variable*/
%let autoreg= %get_number_column_names(_table= &returns, _exclude= &dateColumn); 
%put AUTOREG IN return_calculate: (&autoreg);

title "&title";
ods graphics on;
proc timeseries data= &returns 
plots= (
%if &All= TRUE %then %do;
ALL
%end;

%else %do;
	%if &ACF= TRUE %then %do;
	ACF
	%end;

	%if &PACF= TRUE %then %do;
	PACF
	%end;

	%if &WN= TRUE %then %do;
	WN
	%end;

	%if &IACF= TRUE %then %do;
	IACF
	%end;

	%if &Residual= TRUE %then %do;
	RESIDUAL
	%end;

	%if &SeasonalAdjusted= TRUE %then %do;
	SA
	%end;

	%if &SeasonalComponent= TRUE %then %do;
	SC
	%end;

	%if &SeasonalCycle= TRUE %then %do;
	CYCLES
	%end;

	%if &TrendComponent= TRUE %then %do;
	TC
	%end;

	%if &TrendCycleComponent= TRUE %then %do;
	TCC
	%end;

	%if &TrendCycleSeasonal= TRUE %then %do;
	TCS
	%end;
%end;
);
var &asset ;
corr/ nlag= &lag;
run; 

ods graphics off;

proc datasets lib= work nolist kill;
quit;

%mend chart_autoregression;

