/**********************************************************************
Name:  OSM_SW_ProrationUtility
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to keep logic of Proration                                    
======================================================
======================================================
History                                                             
-------                                                             
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vineet            12/12/2018     INITIAL DEVELOPMENT          


*****************************************************/

public class OSM_SW_ProrationUtility {
    
    /**
	** getCalculatedProrationAmount is used for return prorated price 
	**/
    public static decimal getCalculatedProrationAmount(ccrz__E_Subscription__c subcription, String currentBillingFrequency){
            Date currDate = subcription.Purchase_Date__c!= null? subcription.Purchase_Date__c:Date.today();
           
        Decimal perDayPrice = 0;
        /*If condition for calculating one day price from current invoice due date 
        **to next installment due date when Subcription billing is Non - One Time
        */ 
        
        Decimal proratedAmount = 0;
        if(subcription.OneTimePerDayPrice__c != null){
                 subcription.OneTimePerDayPrice__c = subcription.OneTimePerDayPrice__c.setScale(5);
            }
        if(subcription.ccrz__SPT__c != null && subcription.ccrz__SPT__r.Billing_Display_Name__c != null && !subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
            proratedAmount = priceCalculationNonOneTimeSubscription(subcription, currentBillingFrequency, currDate);
        }
        
        if(subcription.ccrz__SPT__c != null && subcription.ccrz__SPT__r.Billing_Display_Name__c != null && subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
             proratedAmount = priceCalculationOneTimeSubscription(subcription, currentBillingFrequency, currDate);
        }
		
       	
       //prorated Ammount if Subprod billing frequency is Non-One Time
        /*if(subcription.ccrz__InstallmentNextDate__c != null && !currentBillingFrequency.containsIgnoreCase('One')){
                Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                Integer diffDays = currDate.daysBetween(nextInstDate);
                system.debug(nextInstDate+'===current date -->'+currDate);
                system.debug('perDayPrice for none One Time-->'+perDayPrice);
                System.debug('Days Between purchase date to Next Intallment Date==>'+currDate.daysBetween(nextInstDate));
                proratedAmount = (diffDays * perDayPrice);
                 system.debug('Prorated Price for None One Time-->'+proratedAmount);
                system.debug(currDate.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c)))+'==perDayPrice=='+perDayPrice+'==='+proratedAmount);
            }*/
        
           
        
        //this condition will be executing after alst intallment paid but still subscription is not yet expired
        system.debug('!!!!!'+subcription.ccrz__SPT__r.Billing_Display_Name__c); 
        system.debug('@@@@'+subcription.Last_Installment_Generated__c); 
         system.debug('####'+subcription.ccrz__InstallmentCountRemaining__c); 
         system.debug('%%%%'+subcription.OSM_Subscription_End_Date__c);
        if(!subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') && subcription.Last_Installment_Generated__c && subcription.ccrz__InstallmentCountRemaining__c < 1 && subcription.OSM_Subscription_End_Date__c > system.now()){
              Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),		subcription.OSM_Subscription_End_Date__c.Day());
					Integer diffDays = (currDate.daysBetween(subsendDate))+1;
					proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
            }
        system.debug('proratedAmount===>'+proratedAmount);
        return proratedAmount;
    }
    
    /**
	** getCalculatedProrationAmount is used for return prorated price 
	**/
    public static decimal getCalculatedProrationAmount(ccrz__E_Subscription__c subcription, String currentBillingFrequency, String prorationType){
            Date currDate = subcription.Purchase_Date__c!= null? subcription.Purchase_Date__c:System.today();
           
        Decimal perDayPrice = 0;
        /*If condition for calculating one day price from current invoice due date 
        **to next installment due date when Subcription billing is Non - One Time
        */ 
        
        Decimal proratedAmount = 0;
        if(subcription.OneTimePerDayPrice__c != null){
                 subcription.OneTimePerDayPrice__c = subcription.OneTimePerDayPrice__c.setScale(5);
            }
        if(subcription.ccrz__SPT__c != null && subcription.ccrz__SPT__r.Billing_Display_Name__c != null && !subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
            //proratedAmount = priceCalculationNonOneTimeSubscription(subcription, currentBillingFrequency, currDate);
            proratedAmount = priceCalculationNonOneTimeSubscription(subcription, currentBillingFrequency, currDate,prorationType);
        }
        
        if(subcription.ccrz__SPT__c != null && subcription.ccrz__SPT__r.Billing_Display_Name__c != null && subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One')){
             //proratedAmount = priceCalculationOneTimeSubscription(subcription, currentBillingFrequency, currDate);
            proratedAmount = priceCalculationOneTimeSubscription(subcription, currentBillingFrequency, currDate,prorationType);
        }
		
       	
       //prorated Ammount if Subprod billing frequency is Non-One Time
        /*if(subcription.ccrz__InstallmentNextDate__c != null && !currentBillingFrequency.containsIgnoreCase('One')){
                Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                Integer diffDays = currDate.daysBetween(nextInstDate);
                system.debug(nextInstDate+'===current date -->'+currDate);
                system.debug('perDayPrice for none One Time-->'+perDayPrice);
                System.debug('Days Between purchase date to Next Intallment Date==>'+currDate.daysBetween(nextInstDate));
                proratedAmount = (diffDays * perDayPrice);
                 system.debug('Prorated Price for None One Time-->'+proratedAmount);
                system.debug(currDate.daysBetween((date.valueOf(subcription.ccrz__InstallmentNextDate__c)))+'==perDayPrice=='+perDayPrice+'==='+proratedAmount);
            }*/
        
           
        
        //this condition will be executing after alst intallment paid but still subscription is not yet expired
         if(!subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') && subcription.Last_Installment_Generated__c && subcription.ccrz__InstallmentCountRemaining__c < 1 && subcription.OSM_Subscription_End_Date__c > system.now()){
              Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),		subcription.OSM_Subscription_End_Date__c.Day());
					Integer diffDays = (currDate.daysBetween(subsendDate))+1;
					proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
            }
        system.debug('proratedAmount===>'+proratedAmount);
        return proratedAmount;
    }
    
    /**
	** priceCalculationNonOneTimeSubscription is used for calculate prorated price for Non OneTime billings  
	**/
    public static decimal priceCalculationNonOneTimeSubscription(ccrz__E_Subscription__c subcription, String currentBillingFrequency,Date currDate){
        system.debug('Start priceCalculationNonOneTimeSubscription called ');
        system.debug('ccrz__E_Subscription__c '+subcription);
        Decimal proratedAmount = 0;
        	/*Date subsStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.Year(),subcription.ccrz__SubscriptionStartDate__c.Month(),subcription.ccrz__SubscriptionStartDate__c.Day());
            for(Integer ii=1;ii<=12; ii++){
                
            }*/
        	map<String, Object> recInvoiceStartEndDate = getReccInvoiceStartEndDate(subcription,'Monthly');
        	map<integer,Date>startDate = (map<integer, Date>)recInvoiceStartEndDate.get('startDate'); 
        	map<integer,Date>endDate = (map<integer, Date>)recInvoiceStartEndDate.get('endDate'); 
        	system.debug('recInvoiceStartEndDate '+recInvoiceStartEndDate);
            for(Integer ii : startDate.keySet()){
                Date invStart = startDate.get(ii);	
                Date invEnd = endDate.get(ii);	
                system.debug('currDate '+currDate +'>='+invStart+'&&  currDate < '+invEnd);
                system.debug(currDate >=invStart &&  currDate < invEnd);
                if(currDate >=invStart &&  currDate < invEnd){
                    
                    Integer diffDays = (currDate.daysBetween(invEnd));
                    if(currentBillingFrequency.containsIgnoreCase('One') && subcription.OSM_Subscription_End_Date__c>=system.now()){ 
                        Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                        Integer monthsDiff = (invEnd.monthsBetween(subsendDate));
                        proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c)+(monthsDiff * subcription.Monthly_Price__c);
                    }
                   
                    if(!currentBillingFrequency.containsIgnoreCase('One') && subcription.ccrz__InstallmentNextDate__c != null && subcription.OneTimePerDayPrice__c != null){
            			Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                		Integer monthsDiff = (invEnd.monthsBetween(nextInstDate));
                        proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c)+(monthsDiff * subcription.Monthly_Price__c);
                    
                    }
                }	    				            
            }
        /*
            if(currentBillingFrequency.containsIgnoreCase('One') && subcription.OSM_Subscription_End_Date__c>=system.now()){ 
                    Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                    Integer diffDays = (currDate.daysBetween(subsendDate))+1;
                    proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                	//map<String, Object> recInvoiceStartEndDate = getReccInvoiceStartEndDate(subcription,'Monthly');
                	Integer monthsDiff = currDate.monthsBetween(subsendDate);
                    if(monthsDiff > 1){
                        
                    }
                
            	} 
            if(!currentBillingFrequency.containsIgnoreCase('One') && subcription.ccrz__InstallmentNextDate__c != null && subcription.OneTimePerDayPrice__c != null){
            	    Date currInvoiceDate = Date.newInstance(subcription.Current_Invoice_Due_Date__c.Year(),subcription.Current_Invoice_Due_Date__c.Month(),subcription.Current_Invoice_Due_Date__c.Day());
                    Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                	Integer numberDays = currDate.daysBetween(nextInstDate);
                	proratedAmount = subcription.OneTimePerDayPrice__c * numberDays;
            }
          */    
        system.debug('End priceCalculationNonOneTimeSubscription called ');
        return proratedAmount;
    }
	
	
    
    /**
	** priceCalculationNonOneTimeSubscription is used for calculate prorated price for Non OneTime billings  
	**/
    public static decimal priceCalculationNonOneTimeSubscription(ccrz__E_Subscription__c subcription, String currentBillingFrequency,Date currDate, String prorationType){
        system.debug('Start priceCalculationNonOneTimeSubscription called ');
        system.debug('ccrz__E_Subscription__c '+subcription);
        Decimal proratedAmount = 0;
        	/*Date subsStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.Year(),subcription.ccrz__SubscriptionStartDate__c.Month(),subcription.ccrz__SubscriptionStartDate__c.Day());
            for(Integer ii=1;ii<=12; ii++){
                
            }*/
        	map<String, Object> recInvoiceStartEndDate = getReccInvoiceStartEndDate(subcription,'Monthly');
        	map<integer,Date>startDate = (map<integer, Date>)recInvoiceStartEndDate.get('startDate'); 
        	map<integer,Date>endDate = (map<integer, Date>)recInvoiceStartEndDate.get('endDate'); 
        	system.debug('recInvoiceStartEndDate '+recInvoiceStartEndDate);
            for(Integer ii : startDate.keySet()){
                Date invStart = startDate.get(ii);	
                Date invEnd = endDate.get(ii);	
                system.debug('currDate '+currDate +'>='+invStart+'&&  currDate < '+invEnd);
                system.debug(currDate >=invStart &&  currDate < invEnd);
                if(currDate >=invStart &&  currDate < invEnd){
                    
                    Integer diffDays = (currDate.daysBetween(invEnd));
                    if(currentBillingFrequency.containsIgnoreCase('One') && subcription.OSM_Subscription_End_Date__c>=system.now()){ 
                        Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                        Integer monthsDiff = (invEnd.monthsBetween(subsendDate));
                        proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c)+(monthsDiff * subcription.Monthly_Price__c);
                        if(prorationType == Label.OSM_ProrationType_DnPrice){
                        	proratedAmount = (diffDays * subcription.PerDayDnPrice__c)+(monthsDiff * subcription.Monthly_Dn_Price__c);
                        }
                    }
                   
                    if(!currentBillingFrequency.containsIgnoreCase('One') && subcription.ccrz__InstallmentNextDate__c != null && subcription.OneTimePerDayPrice__c != null){
            			Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                		Integer monthsDiff = (invEnd.monthsBetween(nextInstDate));
                        proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c)+(monthsDiff * subcription.Monthly_Price__c);
                    	if(prorationType == Label.OSM_ProrationType_DnPrice){
                        	proratedAmount = (diffDays * subcription.PerDayDnPrice__c)+(monthsDiff * subcription.Monthly_Dn_Price__c);
                        }
                    }
                }	    				            
            }
        /*
            if(currentBillingFrequency.containsIgnoreCase('One') && subcription.OSM_Subscription_End_Date__c>=system.now()){ 
                    Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                    Integer diffDays = (currDate.daysBetween(subsendDate))+1;
                    proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                	//map<String, Object> recInvoiceStartEndDate = getReccInvoiceStartEndDate(subcription,'Monthly');
                	Integer monthsDiff = currDate.monthsBetween(subsendDate);
                    if(monthsDiff > 1){
                        
                    }
                
            	} 
            if(!currentBillingFrequency.containsIgnoreCase('One') && subcription.ccrz__InstallmentNextDate__c != null && subcription.OneTimePerDayPrice__c != null){
            	    Date currInvoiceDate = Date.newInstance(subcription.Current_Invoice_Due_Date__c.Year(),subcription.Current_Invoice_Due_Date__c.Month(),subcription.Current_Invoice_Due_Date__c.Day());
                    Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                	Integer numberDays = currDate.daysBetween(nextInstDate);
                	proratedAmount = subcription.OneTimePerDayPrice__c * numberDays;
            }
          */    
        system.debug('End priceCalculationNonOneTimeSubscription called ');
        return proratedAmount;
    }
    
    /**
	** priceCalculationNonOneTimeSubscription is used for calculate prorated price for OneTime billing subscription 
	**/
	public static decimal priceCalculationOneTimeSubscription(ccrz__E_Subscription__c subcription, String currentBillingFrequency, Date currDate){
        Decimal proratedAmount = 0;
            if(currentBillingFrequency.containsIgnoreCase('One') && subcription.OSM_Subscription_End_Date__c>=system.now()){ 
                    Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                    Date subsStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.Year(),subcription.ccrz__SubscriptionStartDate__c.Month(),subcription.ccrz__SubscriptionStartDate__c.Day());
                    //subsStartDate = subsendDate.addDays(-364);
                	Integer diffDays = (currDate.daysBetween(subsendDate))+1;
                	Integer diffMoths = (currDate.monthsBetween(subsendDate));
                	Integer monthsInSubsc = (subsStartDate.monthsBetween(subsendDate));
                    proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                	map<String, Object> monthlyStartEndDate = getReccInvoiceStartEndDate(subcription,'Monthly');
                	system.debug('recInvoiceStartEndDate--->'+monthlyStartEndDate);
        			map<integer,Date>monthStartDate = (map<integer, Date>)monthlyStartEndDate.get('startDate'); 
        			map<integer,Date>monthEndDate = (map<integer, Date>)monthlyStartEndDate.get('endDate'); 
        			for(Integer ii : monthStartDate.keySet()){
                         Date invStart = monthStartDate.get(ii);	
                         Date invEnd = monthEndDate.get(ii);	
                        if(currDate >=invStart &&  currDate < invEnd){
                            diffDays = (currDate.daysBetween(invEnd));
                            //diffMoths = monthsInSubsc - (ii+1);
                            proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c)+(diffMoths * subcription.Monthly_Price__c);
                            break;
                        }
                    }
            	} 
            if(!currentBillingFrequency.containsIgnoreCase('One') && subcription.OneTimePerDayPrice__c != null){
            	  /*  Date currInvoiceDate = Date.newInstance(subcription.Current_Invoice_Due_Date__c.Year(),subcription.Current_Invoice_Due_Date__c.Month(),subcription.Current_Invoice_Due_Date__c.Day());
                    //Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                	Integer numberDays = currInvoiceDate.daysBetween(nextInstDate);
                	proratedAmount = subcription.OneTimePerDayPrice__c * numberDays;
                */
                	map<String, Object> recInvoiceStartEndDate = getReccInvoiceStartEndDate(subcription,currentBillingFrequency);
                	system.debug('recInvoiceStartEndDate--->'+recInvoiceStartEndDate);
        			map<integer,Date>startDate = (map<integer, Date>)recInvoiceStartEndDate.get('startDate'); 
        			map<integer,Date>endDate = (map<integer, Date>)recInvoiceStartEndDate.get('endDate'); 
        
                    for(Integer ii : startDate.keySet()){
                         Date invStart = startDate.get(ii);	
                         Date invEnd = endDate.get(ii);	
                        system.debug(invStart+'=='+currDate+'===='+invEnd);
                        system.debug(currDate >=invStart &&  currDate < invEnd);
                        system.debug('currDate >=invStart &&  currDate < invEnd');
                        if(currDate >=invStart &&  currDate < invEnd && currDate.daysBetween(invEnd) >15){
                            Integer diffDays = (currDate.daysBetween(invEnd));
                            proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                            Integer monthsDiff = invStart.monthsBetween(invEnd);
                            system.debug('monthsDiff---->'+monthsDiff);
                            if(monthsDiff > 0 ){
                                
                                 diffDays = returnDaysAmongCurrentToMonthEnd( monthsDiff,  currDate,  invStart);
                                system.debug('diffDays---->'+diffDays);
                                Integer MonthDiffCurr = getMonthsAmongCurrentToInvoiceEnd( monthsDiff,  currDate,  invStart);
                                system.debug('MonthDiffCurr---->'+MonthDiffCurr);
                                proratedAmount = (MonthDiffCurr * subcription.Monthly_Price__c) + (diffDays * subcription.OneTimePerDayPrice__c); 
                            }
                            system.debug(invStart+'======'+invEnd);
                            system.debug('diffDays--->'+diffDays);
                            system.debug('subcription.OneTimePerDayPrice__c--->'+subcription.OneTimePerDayPrice__c);
                            break;
                        }
                        
                         if(currDate >=invStart &&  currDate < invEnd && currDate.daysBetween(invEnd) <=15){
                             Date nextInvStart = startDate.get(ii+1) != null ? startDate.get(ii+1):null;	
                             Date nextInvEnd = endDate.get(ii+1) != null ? endDate.get(ii+1):null;	
                             if(nextInvStart == null && nextInvEnd == null){
                                Integer diffDays = (currDate.daysBetween(invEnd));
                                proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                                system.debug(invStart+'======'+invEnd);
                                system.debug('diffDays--->'+diffDays);
                                system.debug('subcription.OneTimePerDayPrice__c--->'+subcription.OneTimePerDayPrice__c);
                                break;
                             }
                             
                             if(nextInvStart != null && nextInvEnd != null){
                                Integer diffDays = (currDate.daysBetween(invEnd));
                                Decimal proratedDaysAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                                Decimal proratedMontsAmount =  (nextInvStart.monthsBetween(nextInvEnd))*subcription.Monthly_Price__c;
                             	proratedAmount =  (proratedDaysAmount + proratedMontsAmount);   
                                system.debug(nextInvStart+'======'+nextInvEnd);
                                system.debug('monthsDifferences--->'+(nextInvStart.monthsBetween(nextInvEnd)));
                                system.debug('subcription.OneTimePerDayPrice__c--->'+subcription.OneTimePerDayPrice__c);
                                break;
                             }
                        }
                    }
            }
              
        return proratedAmount;
    }
    
    
    /**
	** priceCalculationNonOneTimeSubscription is used for calculate prorated price for OneTime billing subscription 
	**/
	public static decimal priceCalculationOneTimeSubscription(ccrz__E_Subscription__c subcription, String currentBillingFrequency, Date currDate, String prorationType){
        Decimal proratedAmount = 0;
        Integer monthsInSubsc;
            if(currentBillingFrequency.containsIgnoreCase('One') && subcription.OSM_Subscription_End_Date__c>=system.now()){ 
                    Date subsendDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
                    Date subsStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.Year(),subcription.ccrz__SubscriptionStartDate__c.Month(),subcription.ccrz__SubscriptionStartDate__c.Day());
                    
                    Integer diffDays = (currDate.daysBetween(subsendDate))+1;
                    Integer diffMoths = (currDate.monthsBetween(subsendDate)-1);
                    //MP-481 Added below if condition
		    if(label.OSM_SubsLengths.contains(subcription.ccrz__SPT__r.ccrz__DisplayName__c)){
                        monthsInSubsc = 1*(Integer)subcription.ccrz__SPT__r.ccrz__OrderFrequency__c;
                    }else
                        monthsInSubsc = 12*(Integer)subcription.ccrz__SPT__r.ccrz__OrderFrequency__c;//(subsStartDate.monthsBetween(subsendDate));
                    
                    if(diffMoths == 1){
                        Integer currentDay = currDate.day();
                        Integer endDay = subsendDate.day();
                        diffMoths = 0;
                        if(endDay>=currentDay){
                            diffMoths = 1;
                        }
                    }
                    proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                    //MP-629 Code Start 07-Feb-2022
                    if(prorationType == Label.OSM_ProrationType_DnPrice){
                        proratedAmount = (diffDays * subcription.PerDayDnPrice__c);
                    }//MP-629 Code End 07-Feb-2022
                    //Integer numberOfDays = Date.daysInMonth(currDate.year(), currDate.month());
                    //if(diffDays > numberOfDays){
                    if(diffMoths >= 1){
                        map<String, Object> monthlyStartEndDate = getReccInvoiceStartEndDate(subcription,'Monthly');
                        system.debug('recInvoiceStartEndDate--->'+monthlyStartEndDate);
                        
                        map<integer,Date>monthStartDate = (map<integer, Date>)monthlyStartEndDate.get('startDate'); 
                        map<integer,Date>monthEndDate = (map<integer, Date>)monthlyStartEndDate.get('endDate'); 
                        for(Integer ii : monthStartDate.keySet()){
                             System.debug(ii +'===>'+ monthStartDate.get(ii));	
                            System.debug(ii +'===>'+monthEndDate.get(ii));
                            
                        }
                        for(Integer ii : monthStartDate.keySet()){
                             Date invStart = monthStartDate.get(ii);	
                             Date invEnd = monthEndDate.get(ii);	
                            if(currDate >=invStart &&  currDate < invEnd){
                                diffDays = (currDate.daysBetween(invEnd));
                                diffMoths = monthsInSubsc - (ii+1);
                                system.debug(currDate +'>='+invStart+' && '+ currDate+' < '+invEnd);
                                system.debug('diffMoths==>'+diffMoths);
                        		system.debug('diffDays==>'+diffDays);
                                proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c)+(diffMoths * subcription.Monthly_Price__c);
                                if(prorationType == Label.OSM_ProrationType_DnPrice){
                                    proratedAmount = (diffDays * subcription.PerDayDnPrice__c)+(diffMoths * subcription.Monthly_Dn_Price__c);
                                }
                                break;
                            }
                        }
                    }
            	} 
            if(!currentBillingFrequency.containsIgnoreCase('One') && subcription.OneTimePerDayPrice__c != null){
            	  /*  Date currInvoiceDate = Date.newInstance(subcription.Current_Invoice_Due_Date__c.Year(),subcription.Current_Invoice_Due_Date__c.Month(),subcription.Current_Invoice_Due_Date__c.Day());
                    //Date nextInstDate = Date.newInstance(subcription.ccrz__InstallmentNextDate__c.Year(),subcription.ccrz__InstallmentNextDate__c.Month(),subcription.ccrz__InstallmentNextDate__c.Day());
                	Integer numberDays = currInvoiceDate.daysBetween(nextInstDate);
                	proratedAmount = subcription.OneTimePerDayPrice__c * numberDays;
                */
                	map<String, Object> recInvoiceStartEndDate = getReccInvoiceStartEndDate(subcription,currentBillingFrequency);
                	system.debug('recInvoiceStartEndDate--->'+recInvoiceStartEndDate);
        			map<integer,Date>startDate = (map<integer, Date>)recInvoiceStartEndDate.get('startDate'); 
        			map<integer,Date>endDate = (map<integer, Date>)recInvoiceStartEndDate.get('endDate'); 
        
                    for(Integer ii : startDate.keySet()){
                         Date invStart = startDate.get(ii);	
                         Date invEnd = endDate.get(ii);	
                        system.debug(invStart+'=='+currDate+'===='+invEnd);
                        system.debug(currDate >=invStart &&  currDate < invEnd);
                        system.debug('currDate >=invStart &&  currDate < invEnd');
                        if(currDate >=invStart &&  currDate < invEnd && currDate.daysBetween(invEnd) >15){
                            Integer diffDays = (currDate.daysBetween(invEnd));
                            proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                            Integer monthsDiff = invStart.monthsBetween(invEnd);
                            system.debug('monthsDiff---->'+monthsDiff);
                            if(monthsDiff > 0 ){
                                diffDays = returnDaysAmongCurrentToMonthEnd( monthsDiff,  currDate,  invStart);
                                system.debug('diffDays---->'+diffDays);
                                Integer MonthDiffCurr = getMonthsAmongCurrentToInvoiceEnd( monthsDiff,  currDate,  invStart);
                                system.debug('MonthDiffCurr---->'+MonthDiffCurr);
                                proratedAmount = (MonthDiffCurr * subcription.Monthly_Price__c) + (diffDays * subcription.OneTimePerDayPrice__c); 
                            	if(prorationType == Label.OSM_ProrationType_DnPrice){
                                    proratedAmount = (diffDays * subcription.PerDayDnPrice__c)+(MonthDiffCurr * subcription.Monthly_Dn_Price__c);
                                }
                            }
                            system.debug(invStart+'======'+invEnd);
                            system.debug('diffDays--->'+diffDays);
                            system.debug('subcription.OneTimePerDayPrice__c--->'+subcription.OneTimePerDayPrice__c);
                            break;
                        }
                        
                         if(currDate >=invStart &&  currDate < invEnd && currDate.daysBetween(invEnd) <=15){
                             Date nextInvStart = startDate.get(ii+1) != null ? startDate.get(ii+1):null;	
                             Date nextInvEnd = endDate.get(ii+1) != null ? endDate.get(ii+1):null;	
                             if(nextInvStart == null && nextInvEnd == null){
                                Integer diffDays = (currDate.daysBetween(invEnd));
                                proratedAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                                 if(prorationType == Label.OSM_ProrationType_DnPrice){
                                    proratedAmount = (diffDays * subcription.PerDayDnPrice__c);//+(MonthDiffCurr * subcription.Monthly_Dn_Price__c);
                                }
                                system.debug(invStart+'======'+invEnd);
                                system.debug('diffDays--->'+diffDays);
                                system.debug('subcription.OneTimePerDayPrice__c--->'+subcription.OneTimePerDayPrice__c);
                                break;
                             }
                             
                             if(nextInvStart != null && nextInvEnd != null){
                                Integer diffDays = (currDate.daysBetween(invEnd));
                                Decimal proratedDaysAmount = (diffDays * subcription.OneTimePerDayPrice__c);
                                Decimal proratedMontsAmount =  (nextInvStart.monthsBetween(nextInvEnd))*subcription.Monthly_Price__c;
                             	proratedAmount =  (proratedDaysAmount + proratedMontsAmount);   
                                 if(prorationType == Label.OSM_ProrationType_DnPrice){
                                    proratedAmount = (diffDays * subcription.PerDayDnPrice__c)+((nextInvStart.monthsBetween(nextInvEnd)) * subcription.Monthly_Dn_Price__c);
                                }
                                system.debug(nextInvStart+'======'+nextInvEnd);
                                system.debug('monthsDifferences--->'+(nextInvStart.monthsBetween(nextInvEnd)));
                                system.debug('subcription.OneTimePerDayPrice__c--->'+subcription.OneTimePerDayPrice__c);
                                break;
                             }
                        }
                    }
            }
              
        return proratedAmount;
    }
    
    
    /**
	** getReccInvoiceStartDate is used for calculate future invoices start & end date based on that proration can performed  
	**/
    public static map<Integer, Date> getReccInvoiceStartDate(ccrz__E_Subscription__c subcription, String currentBillingFrequency){
        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') 
           && currentBillingFrequency.containsIgnoreCase('Monthly')){
            
            
        }
        
        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') 
           && currentBillingFrequency.containsIgnoreCase('Quarterly')){
            
            
        }
        
        if(subcription.ccrz__SPT__r.Billing_Display_Name__c.containsIgnoreCase('One') 
           && currentBillingFrequency.containsIgnoreCase('Yearly')){
            
            
        }
        return null;
    }
    
    /**
	** getReccInvoiceStartEndDate is used for calculate future invoices start & end date based on that proration can performed  
	**/
    public static map<String, Object> getReccInvoiceStartEndDate(ccrz__E_Subscription__c subcription, String currentBillingFrequency){
        
        map<String, Object> recInvoiceStartEnd = new map<String, Object>();
        map<integer,Date>startDate = new map<integer, Date>(); 
        map<integer,Date>endDate = new map<integer, Date>();
        
        Date subStartDate = Date.newInstance(subcription.ccrz__SubscriptionStartDate__c.Year(),subcription.ccrz__SubscriptionStartDate__c.Month(),subcription.ccrz__SubscriptionStartDate__c.Day());  
        Date subEndDate = Date.newInstance(subcription.OSM_Subscription_End_Date__c.Year(),subcription.OSM_Subscription_End_Date__c.Month(),subcription.OSM_Subscription_End_Date__c.Day());
       /*if(subcription.ccrz__SubscriptionProduct__r.Group_Name__c == 'SES'){		
			//subStartDate =subEndDate.addDays(-364);
	   }*/
        system.debug('Subs Start Date :'+ subStartDate);
        system.debug('Subs End Date :'+ subEndDate);
        if(String.isNotBlank(subcription.ccrz__SPT__r.Billing_Display_Name__c)){
        	if(currentBillingFrequency.containsIgnoreCase('Monthly') && subcription.ccrz__SPT__r.ccrz__OrderFrequency__c != null){
            Integer months = 12 * Integer.valueOf(subcription.ccrz__SPT__r.ccrz__OrderFrequency__c);
             
               for(Integer ii = 0; ii<months; ii++ ){
                    Date invStartDate = subStartDate.addMonths(ii);
                   Date invEndDate = invStartDate.addMonths(1);//.addDays(-1); 
                   startDate.put(ii,invStartDate);
                   endDate.put(ii,invEndDate);
               }   
            
        }
        
        	if(currentBillingFrequency.containsIgnoreCase('Quarterly') && subcription.ccrz__SPT__r.ccrz__OrderFrequency__c != null){
            
            Integer quarters = 4 * Integer.valueOf(subcription.ccrz__SPT__r.ccrz__OrderFrequency__c);
             
               for(Integer ii = 0; ii<quarters; ii++ ){
                    Date invStartDate = subStartDate.addMonths(ii);
                   Date invEndDate = invStartDate.addMonths(3);//.addDays(-1); 
                   startDate.put(ii,invStartDate);
                   endDate.put(ii,invEndDate);
               }   
            
        }
        
            if(currentBillingFrequency.containsIgnoreCase('Yearly') && subcription.ccrz__SPT__r.ccrz__OrderFrequency__c != null){
            
               Integer years = 1 * Integer.valueOf(subcription.ccrz__SPT__r.ccrz__OrderFrequency__c);
             
               for(Integer ii = 0; ii<years; ii++ ){
                    Date invStartDate = subStartDate.addMonths(ii);
                   Date invEndDate = invStartDate.addMonths(12);//.addDays(-1); 
                   startDate.put(ii,invStartDate);
                   endDate.put(ii,invEndDate);
               }
            }
        }
        
        recInvoiceStartEnd.put('startDate',startDate);
        recInvoiceStartEnd.put('endDate',endDate);
        return recInvoiceStartEnd;
    }
    
    public static integer returnDaysAmongCurrentToMonthEnd(Integer monthsDiff, Date currDate, Date invStart){
        integer days = 0;
        for(Integer jj = 0; jj<monthsDiff; jj++ ){
            Date monthStartDate = invStart.addMonths(jj);
            Date montEndDate = monthStartDate.addMonths(1).addDays(-1); 
            if(currDate >=monthStartDate &&  currDate <= montEndDate){
                //diffDays = (currDate.daysBetween(montEndDate)) + 1;
                days = currDate.daysBetween(montEndDate)+1;
                //proratedAmount = (MonthDiffCurr * subcription.Monthly_Price__c) + (diffDays * subcription.OneTimePerDayPrice__c); 
            }
        }
        
        return days;
    }
    
     public static integer getMonthsAmongCurrentToInvoiceEnd(Integer monthsDiff, Date currDate, Date invStart){
        integer months = 0;
        for(Integer jj = 0; jj<monthsDiff; jj++ ){
            Date monthStartDate = invStart.addMonths(jj);
            Date montEndDate = monthStartDate.addMonths(1).addDays(-1); 
            if(currDate >=monthStartDate &&  currDate <= montEndDate){
                //diffDays = (currDate.daysBetween(montEndDate)) + 1;
                months = monthsDiff-(jj+1);
                //proratedAmount = (MonthDiffCurr * subcription.Monthly_Price__c) + (diffDays * subcription.OneTimePerDayPrice__c); 
            }
        }
        
        return months;
    }
}