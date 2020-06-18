/*
 1
 */
proc univariate data=mydata.Adult_Processed normal;
	var HoursPerWeek;
	class EduLevel;
	histogram/normal nrows=3;
	qqplot/normal(mu=est sigma=est) nrows=3;
	ods select  histogram qqplot testsfornormality;
run;
proc univariate data=mydata.Adult_Processed normal;
	var HoursPerWeek;
	class Sex;
	histogram/normal;
	qqplot/normal(mu=est sigma=est);
	ods select moments histogram qqplot testsfornormality;
	run;
proc univariate data=mydata.Adult_Processed normal;
	var HoursPerWeek;
	class Income;
	histogram/normal ;
	qqplot/normal(mu=est sigma=est);
	ods select moments histogram qqplot testsfornormality;
	run;
	
data data_transf; /* Creating transformed data */
	set mydata.Adult_Processed;
	log_HoursPerWeek= log(HoursPerWeek);
	sqrt_HoursPerWeek= sqrt(HoursPerWeek);
	cube_HoursPerWeek= HoursPerWeek**(1/3);
run;

proc univariate data=data_transf normal;
	var log_HoursPerWeek sqrt_HoursPerWeek cube_HoursPerWeek;
	histogram/normal;
	qqplot/normal(mu=est sigma=est);
	ods select moments histogram qqplot testsfornormality;
run;
	
title 'HoursPerWeek vs EduLevel';
proc npar1way data=mydata.Adult_Processed wilcoxon dscf;
	var HoursPerWeek;
	class EduLevel;
	run;
title 'HoursPerWeek vs Sex';
proc npar1way data=mydata.Adult_Processed wilcoxon dscf;
	var HoursPerWeek;
	class Sex;
	run;
title 'HoursPerWeek vs Income';
proc npar1way data=mydata.Adult_Processed wilcoxon dscf;
	var HoursPerWeek;
	class Income;
	run;
/*
 2
 */
title 'Income vs EduLevel';
proc freq data=mydata.Adult_Processed;
	table Income*EduLevel/expected chisq cellchi2 nocol norow nopercent plots=mosaic;
run;
title 'Income vs Marital';
proc freq data=mydata.Adult_Processed;
	table Income*Marital/expected chisq cellchi2 nocol norow nopercent plots=mosaic;
run;
title 'Income vs OccType';
proc freq data=mydata.Adult_Processed;
	table Income*OccType/expected chisq cellchi2 nocol norow nopercent plots=mosaic;
run;
/*
 3
 */
title 'Income vs OccType';
proc glm data=mydata.Adult_Processed;
	class Sex;
	model HoursPerWeek=Sex/ solution;
	run;

proc logistic data=mydata.Adult_Processed;
	class EduLevel(ref='Pro-School') Marital(ref='Widowed') OccType(ref='White-collar')/ param=reference;
	model Income(event='>50K')= EduLevel Marital OccType/ clodds=pl;
	oddsratio OccType;
	run;
	
	
	
title 'Logistic model without interaction terms';
proc logistic data=mydata.Adult_Processed;
	class EduLevel(ref='Pro-School') Marital(ref='Widowed') 
	OccType(ref='White-collar') 
	EmployerType(ref='Self-Employed')  Race(ref='White') 
	Region(ref='other') Sex(ref='Male') / param=reference;
	model Income(event='>50K')= EduLevel Marital OccType EmployerType
								Race Region Sex HoursPerWeek Age/ clodds=pl ;
	run;

title 'Backward selection';
proc logistic data=mydata.Adult_Processed;
	class EduLevel(ref='Pro-School') Marital(ref='Widowed') 
	OccType(ref='White-collar') 
	EmployerType(ref='Self-Employed')  Race(ref='White') 
	Region(ref='other') Sex(ref='Male') / param=reference;
	model Income(event='>50K')= Marital EduLevel | OccType EmployerType
								Race Region | Sex | HoursPerWeek | Age/ clodds=pl selection=backward;
	oddsratio EduLevel;
	oddsratio Marital;
	oddsratio OccType;
	oddsratio EmployerType;
	oddsratio Race;
	oddsratio Region;
	oddsratio Sex;
	oddsratio HoursPerWeek;
	oddsratio Age;
	run;
	
title 'Logistic model with interaction terms';
proc logistic data=mydata.Adult_Processed;
	class EduLevel(ref='Pro-School') Marital(ref='Widowed') 
	OccType(ref='White-collar') 
	EmployerType(ref='Self-Employed')  Race(ref='White') 
	Region(ref='other') Sex(ref='Male') / param=reference;
	model Income(event='>50K')= EduLevel Marital OccType EduLevel*OccType 
								EmployerType Race Region Sex HoursPerWeek
								HoursPerWeek*Sex Age Age*Region HoursPerWeek*Age/ clodds=pl;
								
	oddsratio EduLevel;
	oddsratio Marital;
	oddsratio OccType;
	oddsratio EmployerType;
	oddsratio Race;
	oddsratio Region;
	oddsratio Sex;
	oddsratio HoursPerWeek;
	oddsratio Age;
	oddsratio HoursPerWeek;
	
	run;
	


























