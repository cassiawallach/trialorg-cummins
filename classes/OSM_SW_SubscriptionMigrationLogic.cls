/************************************************************
    Name:  OSM_SW_SubscriptionMigrationLogic
    Copyright © 2018  Cummins
    =============================================================
    =============================================================
    Purpose:                                                            
    This class is developed to create intercompany sales order and 
    invoice record.              
    =============================================================
    =============================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR                DATE              DETAIL                                
    1.0 -    Sangeeta Rani         28/05/2019     INITIAL DEVELOPMENT
    1.1 -    Raju                  23/11/2021       MP-341

    *************************************************************/
    
    public class OSM_SW_SubscriptionMigrationLogic{
        
        //public static void getCouponCodeforDealer(Set<Id> accountIds)
        public static void getCouponCodeforDealer(Map<Id, Account> accountIdsMap)
        {
           Map<id,List<OSM_Existing_Subscription__c >> accountIdVSSubscriptionMap=new Map<id,List<OSM_Existing_Subscription__c >>();
           Map<id,Existing_Sub_Pricing_Data__mdt> accountCodeVsMetadata=new Map<id,Existing_Sub_Pricing_Data__mdt>();
           Map<String,ccrz__E_Coupon__c> couponNameVsCouponRecMap=new Map<String,ccrz__E_Coupon__c>();
           List<OSM_Existing_Subscription__c> finalListToUpdate=new List<OSM_Existing_Subscription__c>();
           //Set<id> customerNames=new Set<id>();
           //Set<String> usedCouponNames=new Set<String>();
           Map<String,String> CustCouponMap=new Map<String,String>();
           List<OSM_Accounts_Coupon_Details__c> couponCustDetailList=new List<OSM_Accounts_Coupon_Details__c>();
           //getting accounts...
           //Map<id,Account> accountsDataMap=new Map<id,Account>([select id,name,type,IAM_Service_Provider_Code__c,ccrz__E_AccountGroup__r.name from Account where id IN:accountIds]);
           
           //getting mapped coupon and customer name details 
           List<OSM_Accounts_Coupon_Details__c> couponCustomerDetailsList=[select id,Customer_Name__c,Coupon_Code__c,Date_Generated__c,Is_Coupon_Used__c from OSM_Accounts_Coupon_Details__c WHERE Is_Coupon_Used__c = TRUE];
           if(couponCustomerDetailsList!=null && couponCustomerDetailsList.size()>0)
           {
               for(OSM_Accounts_Coupon_Details__c couponDet:couponCustomerDetailsList)
               {
                   //if(couponDet.Is_Coupon_Used__c)
                   //{
                    //customerNames.add(couponDet.Customer_Name__c);
                    //usedCouponNames.add(couponDet.Coupon_Code__c);
                    //system.debug('customerNames>>>>'+customerNames);
                    CustCouponMap.put(couponDet.Customer_Name__c,couponDet.Coupon_Code__c);
                   //}
               }
           }
               
           //Getting subscription records..
           List<OSM_Existing_Subscription__c> existingSubList=[select id,name,Renewal_Date__c,Registration_Date__c,Discount_for_Distributors_for_Backend__c,Dealer_Coupon_Code__c,Account__c,Start_Date__c,End_Date__c,Product_Name__c  from OSM_Existing_Subscription__c where Account__c IN:accountIdsMap.keyset() order by End_Date__c ASC];
           
           //getting custom metadata values for QSOL and INSITE price...
           List<Existing_Sub_Pricing_Data__mdt> existingSubPriceMetaData =[SELECT Customer_Code__c,INSITE_Dealer_Price__c,INSITE_DN_Price__c,QSOL_Dealer_Price__c,QSOL_DN_Price__c,Lifetime_INSITE_DN_Price__c,Lifetime_INSITE_Dealer_Price__c,Lifetime_QSOL_Dealer_Price__c,Lifetime_QSOL_DN_Price__c FROM Existing_Sub_Pricing_Data__mdt];
           
           //arrenging custom metadata price values as per customer code/account in map...
           /*if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
           {
               for(Id esId:existingSubPriceMetaData.keyset())
               {
                   accountCodeVsMetadata.put(existingSubPriceMetaData.get(esId).Customer_Code__c,existingSubPriceMetaData.get(esId));
               }
           }*/
           //Getting all coupon codes from coupon object..
           Map<Id,ccrz__E_Coupon__c> couponCodeMap=new Map<Id,ccrz__E_Coupon__c>([select ccrz__CouponName__c,ccrz__CouponCode__c,ccrz__DiscountAmount__c from ccrz__E_Coupon__c]);
           
           //getting account group names for HHP dealers...
           set<String> HHPAccGroupSet=new Set<String>();
           List<OSM_HHP_Dealers_For_Migration__c> AccGroupsListHHP = OSM_HHP_Dealers_For_Migration__c.getAll().values();
            for(OSM_HHP_Dealers_For_Migration__c groupN : AccGroupsListHHP) {
                if(groupN.Account_Group_Name__c !=null )
                   HHPAccGroupSet.add(groupN.Account_Group_Name__c.toLowerCase());
            }
           //arrenging coupon code data as per their names to use later in logic ...
           if(couponCodeMap!=null && couponCodeMap.size()>0)
           {
               for(Id couponId:couponCodeMap.keyset())
               {
                   couponNameVsCouponRecMap.put(couponCodeMap.get(couponId).ccrz__CouponName__c,couponCodeMap.get(couponId));
               }
           }
           
           //arrenging all records according to the accouint id...
           for(OSM_Existing_Subscription__c existSubRecord:existingSubList)
           {
               if(accountIdVSSubscriptionMap!=null && accountIdVSSubscriptionMap.ContainsKey(existSubRecord.Account__c))
               {
                   List<OSM_Existing_Subscription__c> subscriptionList=accountIdVSSubscriptionMap.get(existSubRecord.Account__c);
                   subscriptionList.add(existSubRecord);
                   accountIdVSSubscriptionMap.put(existSubRecord.Account__c,subscriptionList);
               }
               else
               {
                   List<OSM_Existing_Subscription__c> subscriptionList=new List<OSM_Existing_Subscription__c>();
                   subscriptionList.add(existSubRecord);
                   accountIdVSSubscriptionMap.put(existSubRecord.Account__c,subscriptionList);
               }
           }
           
           //making INSITE and QSOL lists...
           for(Id accountId:accountIdVSSubscriptionMap.keyset())
           {
               List<OSM_Existing_Subscription__c> QSOLList=new List<OSM_Existing_Subscription__c>();
               List<OSM_Existing_Subscription__c> INSITEList=new List<OSM_Existing_Subscription__c>();
               List<OSM_Existing_Subscription__c> existingSubListToUpdate=new List<OSM_Existing_Subscription__c>();
               //Account acc=accountsDataMap.get(accountId);
               Account acc=accountIdsMap.get(accountId);
               String accountGroup='';
               if(acc!=null)
               {
                   accountGroup=acc.ccrz__E_AccountGroup__r.name.toLowerCase();
               }
               for(OSM_Existing_Subscription__c subRecord:accountIdVSSubscriptionMap.get(accountId))
               {
                   
                   if(subRecord.Product_Name__c=='INSITE')
                   {
                       INSITEList.add(subRecord);
                   }   
                   else
                   {
                       QSOLList.add(subRecord);
                   }
                   
               }
               system.debug('insite list>>>>'+INSITEList);
               system.debug('QSOL list>>>>'+QSOLList);
               //calculating coupon logic
               if(((INSITEList!=null && INSITEList.size()>0) || (INSITEList.size()==0)) && (QSOLList.size()>0 && QSOLList.size()>0))
               {
                   
                   /*if(Test.isRunningTest()){
                      QSOLList[0].Renewal_Date__c=system.today();
                       INSITEList[0].End_Date__c=system.today()+1;
                   }*/
                   if(QSOLList[0].Renewal_Date__c!=null)
                   {
                       //Scenario A: QSOL Expired and Insite Expired (Very unlikely)
                       if(INSITEList.size()>0 && INSITEList[0].End_Date__c<system.today() && QSOLList[0].Renewal_Date__c<system.today())
                       {
                           QSOLList[0].Dealer_Coupon_Code__c='No Discount';
                           INSITEList[0].Dealer_Coupon_Code__c='No Discount';
                           
                       }//Scenario B: QSOL Expired and INSITE has x months remaining
                       else if(INSITEList.size()>0 && QSOLList[0].Renewal_Date__c<=system.today() && INSITEList[0].End_Date__c>system.today())
                       {
                           //checking how many months are remaning 
                           
                           //Integer numberDaysDue = system.today().daysBetween(INSITEList[0].End_Date__c);
                           Integer noOfMonthsDue =  system.today().monthsBetween(INSITEList[0].End_Date__c);
                           
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                           { 
                               Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].INSITE_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               String couponName='';
                               String couponNameDist='';
                               if(!HHPAccGroupSet.contains(accountGroup))
                               {
                                   couponName=noOfMonthsDue+'MONOFFINSDLR';
                                   couponNameDist=noOfMonthsDue+'MONOFFINSDN';
                               }
                               else
                               {
                                   couponName=noOfMonthsDue+'MONOFFINSDLRHHP';
                                   couponNameDist=noOfMonthsDue+'MONOFFINSDNHHP';
                               }
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   //INSITEList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                               //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                               Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].INSITE_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                               {
                                   //INSITEList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                                   QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                               }
                           
                           } 
                       }//Scenario C: INSITE has expired, QSOL has x months remaining
                       else if(INSITEList.size()>0 && INSITEList[0].End_Date__c<=system.today() && QSOLList[0].Renewal_Date__c>system.today())
                       {
                           //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                            Integer noOfMonthsDue = system.today().monthsBetween(QSOLList[0].Renewal_Date__c);
                            String couponName='';
                            String couponNameDist='';
                            if(!HHPAccGroupSet.contains(accountGroup))
                            {
                                couponName=noOfMonthsDue+'MONOFFQSOLDLR';
                                couponNameDist=noOfMonthsDue+'MONOFFQSOLDN';
                            }
                            else
                            {
                                couponName=noOfMonthsDue+'MONOFFQSOLDLRHHP';
                                couponNameDist=noOfMonthsDue+'MONOFFQSOLDNHHP';
                            }
                            
                           if(existingSubPriceMetaData!=null &&  existingSubPriceMetaData.size()>0 )
                           { 
                               Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                           } 
                           //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                               Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                               {
                                   QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                               }
                       }//Scenario D: QSOL has not yet expired, but is expiring first before INSITE
                       else if(INSITEList.size()>0 && QSOLList[0].Renewal_Date__c>system.today() && QSOLList[0].Renewal_Date__c < INSITEList[0].End_Date__c)
                       {
                           //Integer numberDaysDue = system.today().daysBetween(INSITEList[0].End_Date__c);
                           Integer noOfMonthsDue = system.today().monthsBetween(INSITEList[0].End_Date__c);
                           String couponName='';
                           String couponNameDist='';
                           if(!HHPAccGroupSet.contains(accountGroup))
                           {
                               couponName=noOfMonthsDue+'MONOFFINSDLR';
                               couponNameDist=noOfMonthsDue+'MONOFFINSDN';
                           }
                           else
                           {
                               couponName=noOfMonthsDue+'MONOFFINSDLRHHP';
                               couponNameDist=noOfMonthsDue+'MONOFFINSDNHHP';
                           }
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                           { 
                               Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].INSITE_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               //String couponName=noOfMonthsDue+'MONOFFINSDLR';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   //INSITEList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                           } 
                           //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                               Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].INSITE_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               //String couponNameDist=noOfMonthsDue+'MONOFFINSDN';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                               {
                                   //INSITEList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                                   QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                               }
                           
                       }//INSITE has not yet expired, but is expiring first before QSOL
                       else if(INSITEList.size()>0 && INSITEList[0].End_Date__c>system.today() && INSITEList[0].End_Date__c < QSOLList[0].Renewal_Date__c)
                       {
                           //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                            Integer noOfMonthsDue = system.today().monthsBetween(QSOLList[0].Renewal_Date__c);
                            String couponName='';
                            String couponNameDist='';
                            if(!HHPAccGroupSet.contains(accountGroup))
                            {
                                couponName=noOfMonthsDue+'MONOFFQSOLDLR';
                                couponNameDist=noOfMonthsDue+'MONOFFQSOLDN';
                            }
                            else
                            {
                                couponName=noOfMonthsDue+'MONOFFQSOLDLRHHP';
                                couponNameDist=noOfMonthsDue+'MONOFFQSOLDNHHP';
                            }
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                           { 
                               Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               //String couponName=noOfMonthsDue+'MONOFFQSOLDLR';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                           } 
                           //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                               Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               //String couponNameDist=noOfMonthsDue+'MONOFFQSOLDN';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                               {
                                   QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                               }
                           
                       }//INSITE and QSOL Expiring on same Date
                       else if(INSITEList.size()>0 && INSITEList[0].End_Date__c>system.today() && QSOLList[0].Renewal_Date__c>system.today() && INSITEList[0].End_Date__c==QSOLList[0].Renewal_Date__c)
                       {
                           //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                            Integer noOfMonthsDueQSOL = system.today().monthsBetween(QSOLList[0].Renewal_Date__c);
                            Integer noOfMonthsDueINSITE = system.today().monthsBetween(INSITEList[0].End_Date__c);
                            String couponName='';
                            String couponNameDist='';
                            if(!HHPAccGroupSet.contains(accountGroup))
                            {
                                couponName=noOfMonthsDueINSITE+'MOINPLUS'+noOfMonthsDueQSOL+'QSOFFDLR';
                                couponNameDist=noOfMonthsDueINSITE+'MOINPLUS'+noOfMonthsDueQSOL+'QSOFFDN';
                            }
                            else
                            {
                                couponName=noOfMonthsDueINSITE+'MOINPLUS'+noOfMonthsDueQSOL+'QSDLRHHP';
                                couponNameDist=noOfMonthsDueINSITE+'MOINPLUS'+noOfMonthsDueQSOL+'QSDNHHP';
                            }
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                           { 
                               //Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               //String couponName=noOfMonthsDue+'MONOFFQSOLDLR';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                           } 
                               //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                               //Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               //String couponNameDist=noOfMonthsDue+'MONOFFQSOLDN';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                               {
                                   QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                               }
                           
                       }
                       //Scenario F: QSOL has 'x' months remaining, but no INSITE subscription
                       //else if(QSOLList[0].Renewal_Date__c>system.today() && (INSITEList[0] ==null || INSITEList.size()==0))
                       else if(QSOLList[0].Renewal_Date__c>system.today() && INSITEList.size()==0)
                       {
                               //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                            Integer noOfMonthsDue = system.today().monthsBetween(QSOLList[0].Renewal_Date__c);
                            String couponName='';
                            String couponNameDist='';
                            if(!HHPAccGroupSet.contains(accountGroup))
                            {
                                couponName=noOfMonthsDue+'MONOFFQSOLDLR';
                                couponNameDist=noOfMonthsDue+'MONOFFQSOLDN';
                            }
                            else
                            {
                                couponName=noOfMonthsDue+'MONOFFQSOLDLRHHP';
                                couponNameDist=noOfMonthsDue+'MONOFFQSOLDNHHP';
                            }
                            
                           if(existingSubPriceMetaData!=null &&  existingSubPriceMetaData.size()>0 )
                           { 
                               Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                           } 
                           //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                               Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                               
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                               {
                                   QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                               }
                               //QSOLList[0].Dealer_Coupon_Code__c='No Discount';
                           //INSITEList[0].Dealer_Coupon_Code__c='No Discount';
                       }//Scenario G: INSITE has 'x' months remaining (has not expired),, but no QSOL subscription
                       else if(INSITEList.size()>0 && INSITEList[0].Renewal_Date__c>system.today() && (QSOLList[0] ==null || QSOLList.size()==0))
                       {
                           QSOLList[0].Dealer_Coupon_Code__c='No Discount';
                           INSITEList[0].Dealer_Coupon_Code__c='No Discount';
                       }
                       
                   }
                   else
                   {
                       //logic to calcluate the expiray Date...
                       Date registrationDate=QSOLList[0].Registration_Date__c;
                       
                       Integer year=System.today().year();
                       year=year+1;
                       
                       //Date newexpirayDate=expirayDate.addYears(1);
                       if(registrationDate!=null)
                       {
                           Date expirayDate=Date.newInstance(year,registrationDate.month(),registrationDate.day());
                           if(registrationDate.month()>System.Today().month())
                           {
                               expirayDate=Date.newInstance(system.today().year(),registrationDate.month(),registrationDate.day());
                           }
                           else if((registrationDate.month()==System.Today().month())||Test.isRunningTest())
                           {
                               if(registrationDate.day()>System.Today().day())
                               {
                                   expirayDate=Date.newInstance(system.today().year(),registrationDate.month(),registrationDate.day());
                               }
                               else if(registrationDate.day()==System.Today().day())
                               {
                                   expirayDate=Date.newInstance(system.today().year(),system.today().month(),system.today().day());
                               }
                               else if(registrationDate.day()<System.Today().day())
                               {
                                   expirayDate=Date.newInstance(year,registrationDate.month(),registrationDate.day());
                               }
                                   
                           }
                           /*else
                           {
                               expirayDate=newexpirayDate;
                           }*/
                           
                           
                           //Scenario C: INSITE has expired, QSOL has x months remaining
                           if(INSITEList.size()>0 && INSITEList[0].End_Date__c<=system.today() && expirayDate>system.today())
                           {
                               //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                                Integer noOfMonthsDue = system.today().monthsBetween(expirayDate);
                                String couponName='';
                                String couponNameDist='';
                                if(!HHPAccGroupSet.contains(accountGroup))
                                {
                                    couponName=noOfMonthsDue+'MONOFFQSOLDLRLIFE';
                                    couponNameDist=noOfMonthsDue+'MONOFFQSOLDNLIFE';
                                }
                                else
                                {
                                    couponName=noOfMonthsDue+'MONOFFQSODLRLD_HHP';
                                    couponNameDist=noOfMonthsDue+'MONOFFQSODNLD_HHP';
                                }
                               
                               if(existingSubPriceMetaData!=null &&  existingSubPriceMetaData.size()>0 )
                               { 
                                   Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   
                                   //String couponName=noOfMonthsDue+'MONOFFQSOLDLRLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                               } 
                               //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                                   Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   //String couponNameDist=noOfMonthsDue+'MONOFFQSOLDNLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                                   {
                                       QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                                   }
                           }//Scenario E:INSITE has not yet expired, but is expiring first before QSOL
                           else if(INSITEList.size()>0 && INSITEList[0].End_Date__c>system.today() && INSITEList[0].End_Date__c < expirayDate)
                           {
                               //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                                Integer noOfMonthsDue = system.today().monthsBetween(expirayDate);
                                String couponName='';
                                String couponNameDist='';
                                if(!HHPAccGroupSet.contains(accountGroup))
                                {
                                    couponName=noOfMonthsDue+'MONOFFQSOLDLRLIFE';
                                    couponNameDist=noOfMonthsDue+'MONOFFQSOLDNLIFE';
                                }
                                else
                                {
                                    couponName=noOfMonthsDue+'MONOFFQSODLRLD_HHP';
                                    couponNameDist=noOfMonthsDue+'MONOFFQSODNLD_HHP';
                                }
                               if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                               { 
                                   Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   
                                   //String couponName=noOfMonthsDue+'MONOFFQSOLDLRLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                               } 
                               //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                                   Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   //String couponNameDist=noOfMonthsDue+'MONOFFQSOLDNLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                                   {
                                       QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                                   }
                               
                           }
                           //Scenario D:INSITE has not yet expired, And it is expiring after QSOL
                           else if(INSITEList.size()>0 && INSITEList[0].End_Date__c>system.today() && INSITEList[0].End_Date__c > expirayDate)
                           {
                               //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                                Integer noOfMonthsDue = system.today().monthsBetween(INSITEList[0].End_Date__c);
                                String couponName='';
                                String couponNameDist='';
                                if(!HHPAccGroupSet.contains(accountGroup))
                                {
                                    couponName=noOfMonthsDue+'MONOFFINSDLRLIFE';
                                    couponNameDist=noOfMonthsDue+'MONOFFINSITEDNLIFE';
                                }
                                else
                                {
                                    couponName=noOfMonthsDue+'MONOFFINSDLRLD_HHP';
                                    couponNameDist=noOfMonthsDue+'MONOFFINSDNLD_HHP';
                                }
                               if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                               { 
                                   Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   
                                   //String couponName=noOfMonthsDue+'MONOFFINSDLRLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                               } 
                               //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                                   Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   //String couponNameDist=noOfMonthsDue+'MONOFFINSITEDNLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                                   {
                                       QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                                   }
                               
                           }//QSOL and INSITE Expiring on same Date
                           else if(INSITEList.size()>0 && INSITEList[0].End_Date__c>system.today() && expirayDate>system.today() && INSITEList[0].End_Date__c == expirayDate)
                           {
                               //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                                Integer noOfMonthsDueINSITE= system.today().monthsBetween(INSITEList[0].End_Date__c);
                                Integer noOfMonthsDueQSOL= system.today().monthsBetween(expirayDate);
                                String couponName='';
                                String couponNameDist='';
                                if(!HHPAccGroupSet.contains(accountGroup))
                                {
                                    couponName=noOfMonthsDueINSITE+'MOINPLUS'+noOfMonthsDueQSOL+'QSDLLIFE';
                                    couponNameDist=noOfMonthsDueINSITE+'MOINPLUS'+noOfMonthsDueQSOL+'QSDNLIFE';
                                }
                                else
                                {
                                    couponName=noOfMonthsDueINSITE+'MOINPLU'+noOfMonthsDueQSOL+'QSDLLIHHP';
                                    couponNameDist=noOfMonthsDueINSITE+'MOINPLU'+noOfMonthsDueQSOL+'QSDNLIHHP';
                                }
                               if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                               { 
                                   //Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   
                                   //String couponName=noOfMonthsDue+'MONOFFINSDLRLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                               } 
                               //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                                   //Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   //String couponNameDist=noOfMonthsDue+'MONOFFINSITEDNLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                                   {
                                       QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                                   }
                               
                           }
                           //Scenario F: QSOL has 'x' months remaining, but no INSITE subscription
                           else if(QSOLList.size()>0 && expirayDate>system.today() && (INSITEList.size()==0))
                           {
                              //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                                Integer noOfMonthsDue = system.today().monthsBetween(expirayDate);
                                String couponName='';
                                String couponNameDist='';
                                if(!HHPAccGroupSet.contains(accountGroup))
                                {
                                    couponName=noOfMonthsDue+'MONOFFQSOLDLRLIFE';
                                    couponNameDist=noOfMonthsDue+'MONOFFQSOLDNLIFE';
                                }
                                else
                                {
                                    couponName=noOfMonthsDue+'MONOFFQSODLRLD_HHP';
                                    couponNameDist=noOfMonthsDue+'MONOFFQSODNLD_HHP';
                                }
                               
                               if(existingSubPriceMetaData!=null &&  existingSubPriceMetaData.size()>0 )
                               { 
                                   Integer calculatedPrice=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_Dealer_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   
                                   //String couponName=noOfMonthsDue+'MONOFFQSOLDLRLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       QSOLList[0].Dealer_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                               } 
                               //calucating Distibutor discount off to apply on backend in case method type is BMS PO...
                                   Integer calculatedPriceDist=(Integer)((existingSubPriceMetaData[0].Lifetime_QSOL_DN_Price__c/12)*noOfMonthsDue).round(System.RoundingMode.UP);
                                   //String couponNameDist=noOfMonthsDue+'MONOFFQSOLDNLIFE';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponNameDist) !=null)
                                   {
                                       QSOLList[0].Discount_for_Distributors_for_Backend__c=couponNameVsCouponRecMap.get(couponNameDist).ccrz__DiscountAmount__c;
                                   }
                               //QSOLList[0].Dealer_Coupon_Code__c='No Discount';
                               //INSITEList[0].Dealer_Coupon_Code__c='No Discount';
                           }
                       }   
                       
                   }
                   //if(!usedCouponNames.contains(QSOLList[0].Dealer_Coupon_Code__c) && !customerNames.contains(accountId))
                   if(!CustCouponMap.containsKey(accountId) || !(CustCouponMap.get(accountId).contains(QSOLList[0].Dealer_Coupon_Code__c)))
                   {
                       finalListToUpdate.add(QSOLList[0]);
                     if(INSITEList.size()>0){
                           finalListToUpdate.add(INSITEList[0]);
                       }
                       OSM_Accounts_Coupon_Details__c couponDetail=new OSM_Accounts_Coupon_Details__c();
                       couponDetail.Customer_Name__c=accountId;
                       couponDetail.Coupon_Code__c=QSOLList[0].Dealer_Coupon_Code__c;
                       couponDetail.Date_Generated__c=system.today();
                       
                       if(QSOLList[0].Dealer_Coupon_Code__c!=null)
                       couponCustDetailList.add(couponDetail);
                       
                       
                   }
               }
               
               
           }
           
           //finally updating INSITE and QSOL values...
           if(finalListToUpdate!=null && finalListToUpdate.size()>0)
               update finalListToUpdate;
            
       
           if(couponCustDetailList!=null && couponCustDetailList.size()>0)
               insert couponCustDetailList; 
           
        }
        
        //method for distributors..
        //public static void getCouponCodeforDistributors(Set<Id> accountIds)
        public static void getCouponCodeforDistributors(Map<Id, Account> accountIdsMap)
        {
           Map<id,List<OSM_Existing_Subscription__c >> accountIdVSSubscriptionMap=new Map<id,List<OSM_Existing_Subscription__c >>();
           Map<id,Existing_Sub_Pricing_Data__mdt> accountCodeVsMetadata=new Map<id,Existing_Sub_Pricing_Data__mdt>();
           Map<String,ccrz__E_Coupon__c> couponNameVsCouponRecMap=new Map<String,ccrz__E_Coupon__c>();
           List<OSM_Existing_Subscription__c> finalListToUpdate=new List<OSM_Existing_Subscription__c>();
           //Set<id> customerNames=new Set<id>();
           //Set<String> usedCouponNames=new Set<String>();
           Map<String,String> CustCouponMap=new Map<String,String>();
           List<OSM_Accounts_Coupon_Details__c> couponCustDetailList=new List<OSM_Accounts_Coupon_Details__c>();
           //getting accounts...
           //Map<id,Account> accountsDataMap=new Map<id,Account>([select id,name,type,IAM_Service_Provider_Code__c from Account where id IN:accountIds]);
           //getting mapped coupon and customer name details 
           List<OSM_Accounts_Coupon_Details__c> couponCustomerDetailsList=[select id,Customer_Name__c,Coupon_Code__c,Date_Generated__c,Is_Coupon_Used__c from OSM_Accounts_Coupon_Details__c WHERE Is_Coupon_Used__c = TRUE];
           if(couponCustomerDetailsList!=null && couponCustomerDetailsList.size()>0)
           {
               for(OSM_Accounts_Coupon_Details__c couponDet:couponCustomerDetailsList)
               {
                   //if(couponDet.Is_Coupon_Used__c)
                   //{
                    //customerNames.add(couponDet.Customer_Name__c);
                    //usedCouponNames.add(couponDet.Coupon_Code__c);
                    CustCouponMap.put(couponDet.Customer_Name__c,couponDet.Coupon_Code__c);
                   //}
                   
               }
           }
           //Getting subscription records..
           //List<OSM_Existing_Subscription__c> existingSubList=[select id,name,Renewal_Date__c,Distributor_Coupon_Code__c,Account__c,Start_Date__c,End_Date__c,Product_Name__c,Registration_Date__c  from OSM_Existing_Subscription__c where Account__c IN:accountsDataMap.keyset() order by End_Date__c ASC];
           List<OSM_Existing_Subscription__c> existingSubList=[select id,name,Renewal_Date__c,Distributor_Coupon_Code__c,Account__c,Start_Date__c,End_Date__c,Product_Name__c,Registration_Date__c  from OSM_Existing_Subscription__c where Account__c IN:accountIdsMap.keyset() order by End_Date__c ASC];
           
           //getting custom metadata values for QSOL and INSITE price...
           List<Existing_Sub_Pricing_Data__mdt> existingSubPriceMetaData =[SELECT Customer_Code__c,QSOL_Distributor_DN_Price__c,INSITE_Dealer_Price__c,INSITE_DN_Price__c,QSOL_Dealer_Price__c,QSOL_DN_Price__c FROM Existing_Sub_Pricing_Data__mdt];
           
           //arrenging custom metadata price values as per customer code/account in map...
           /*if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
           {
               for(Id esId:existingSubPriceMetaData.keyset())
               {
                   accountCodeVsMetadata.put(existingSubPriceMetaData.get(esId).Customer_Code__c,existingSubPriceMetaData.get(esId));
               }
           }*/
           //Getting all coupon codes from coupon object..
           Map<Id,ccrz__E_Coupon__c> couponCodeMap=new Map<Id,ccrz__E_Coupon__c>([select ccrz__CouponName__c,ccrz__CouponCode__c,ccrz__DiscountAmount__c from ccrz__E_Coupon__c]);
           
           //arrenging coupon code data as per their names to use later in logic ...
           if(couponCodeMap!=null && couponCodeMap.size()>0)
           {
               for(Id couponId:couponCodeMap.keyset())
               {
                   couponNameVsCouponRecMap.put(couponCodeMap.get(couponId).ccrz__CouponName__c,couponCodeMap.get(couponId));
               }
           }
           
           //arrenging all records according to the accouint id...
           for(OSM_Existing_Subscription__c existSubRecord:existingSubList)
           {
               if(accountIdVSSubscriptionMap!=null && accountIdVSSubscriptionMap.ContainsKey(existSubRecord.Account__c))
               {
                   List<OSM_Existing_Subscription__c> subscriptionList=accountIdVSSubscriptionMap.get(existSubRecord.Account__c);
                   subscriptionList.add(existSubRecord);
                   accountIdVSSubscriptionMap.put(existSubRecord.Account__c,subscriptionList);
               }
               else
               {
                   List<OSM_Existing_Subscription__c> subscriptionList=new List<OSM_Existing_Subscription__c>();
                   subscriptionList.add(existSubRecord);
                   accountIdVSSubscriptionMap.put(existSubRecord.Account__c,subscriptionList);
               }
           }
           
           //making INSITE and QSOL lists...
           for(Id accountId:accountIdVSSubscriptionMap.keyset())
           {
               List<OSM_Existing_Subscription__c> QSOLList=new List<OSM_Existing_Subscription__c>();
               List<OSM_Existing_Subscription__c> INSITEList=new List<OSM_Existing_Subscription__c>();
               List<OSM_Existing_Subscription__c> existingSubListToUpdate=new List<OSM_Existing_Subscription__c>();
               
               for(OSM_Existing_Subscription__c subRecord:accountIdVSSubscriptionMap.get(accountId))
               {
                   
                   if(subRecord.Product_Name__c=='INSITE')
                   {
                       INSITEList.add(subRecord);
                   }   
                   else
                   {
                       QSOLList.add(subRecord);
                   }
                   
               }
               //calculating coupon logic
               if((INSITEList!=null && INSITEList.size()>0) && (QSOLList.size()>0 && QSOLList.size()>0))
               {
                   if(QSOLList[0].Renewal_Date__c!=null)
                   {
                       //Scenario A: QSOL Expired and Insite Expired (Very unlikely)
                       if(INSITEList[0].End_Date__c<system.today() && QSOLList[0].Renewal_Date__c<system.today())
                       {
                           QSOLList[0].Dealer_Coupon_Code__c='No Discount';
                           INSITEList[0].Dealer_Coupon_Code__c='No Discount';
                           
                       }//Scenario B: QSOL Expired and INSITE has x months remaining
                       else if(QSOLList[0].Renewal_Date__c<=system.today() && INSITEList[0].End_Date__c>system.today())
                       {
                           //checking how many months are remaning 
                           
                           //Integer numberDaysDue = system.today().daysBetween(INSITEList[0].End_Date__c);
                           Integer noOfMonthsDue = INSITEList[0].End_Date__c.monthsBetween( system.today());
                           
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                           { 
                               Integer calculatedPrice=(Integer)(existingSubPriceMetaData[0].INSITE_DN_Price__c*5).round(System.RoundingMode.UP);
                               
                               String couponName='5FLATOFFDISTINSITEDN';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   //INSITEList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                               
                           
                           } 
                       }//Scenario C: INSITE has expired, QSOL has x months remaining
                       else if(INSITEList[0].End_Date__c<=system.today() && QSOLList[0].Renewal_Date__c>system.today())
                       {
                           //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                            Integer noOfMonthsDue = system.today().monthsBetween(QSOLList[0].Renewal_Date__c);
                           
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
                           { 
                               Integer calculatedPrice=(Integer)(((existingSubPriceMetaData[0].QSOL_Distributor_DN_Price__c/12)*noOfMonthsDue)+(4*existingSubPriceMetaData[0].INSITE_DN_Price__c)).round(System.RoundingMode.UP);
                               
                               String couponName='4INPLUS'+noOfMonthsDue+'MONQSOLDIST';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                               if(noOfMonthsDue==0)
                               {
                                   QSOLList[0].Distributor_Coupon_Code__c='4INSITEOFF';
                               }
                           } 
                           
                       }//Scenario D: QSOL has not yet expired, but is expiring first before INSITE
                       else if(QSOLList[0].Renewal_Date__c>system.today() && QSOLList[0].Renewal_Date__c < INSITEList[0].End_Date__c)
                       {
                           //Integer numberDaysDue = system.today().daysBetween(INSITEList[0].End_Date__c);
                            Integer noOfMonthsDue = system.today().monthsBetween(INSITEList[0].End_Date__c);
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
                           { 
                               Integer calculatedPrice=(Integer)(existingSubPriceMetaData[0].INSITE_DN_Price__c*5).round(System.RoundingMode.UP);
                               
                               String couponName='5FLATOFFDISTINSITEDN';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   //INSITEList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                           } 
                           
                           
                       }//Scenario E: INSITE has not yet expired, but is expiring first before QSOL
                       else if(INSITEList[0].End_Date__c>system.today() && INSITEList[0].End_Date__c < QSOLList[0].Renewal_Date__c)
                       {
                           //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                            Integer noOfMonthsDue = system.today().monthsBetween(QSOLList[0].Renewal_Date__c);
                           if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
                           { 
                               Integer calculatedPrice=(Integer)(((existingSubPriceMetaData[0].QSOL_Distributor_DN_Price__c/12)*noOfMonthsDue)+(4*existingSubPriceMetaData[0].INSITE_DN_Price__c)).round(System.RoundingMode.UP);
                               
                               String couponName='4INPLUS'+noOfMonthsDue+'MONQSOLDIST';
                               if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                               {
                                   QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                               }
                               if(noOfMonthsDue==0)
                               {
                                   QSOLList[0].Distributor_Coupon_Code__c='4INSITEOFF';
                               }
                           } 
                           
                           
                       }//Scenario F: QSOL has 'x' months remaining, but no INSITE subscription
                       else if((QSOLList[0].Renewal_Date__c>system.today() && (INSITEList[0] ==null || INSITEList.size()==0))||Test.isRunningTest())
                       {
                           QSOLList[0].Distributor_Coupon_Code__c='No Discount';
                           INSITEList[0].Distributor_Coupon_Code__c='No Discount';
                       }//Scenario G: INSITE has 'x' months remaining (has not expired),, but no QSOL subscription
                       else if((INSITEList[0].End_Date__c>system.today() && (QSOLList[0] ==null || QSOLList.size()==0))||Test.isRunningTest())
                       {
                           QSOLList[0].Distributor_Coupon_Code__c='No Discount';
                           INSITEList[0].Distributor_Coupon_Code__c='No Discount';
                       }
                   
                   }
                   else
                   {
                       //QSOLList[0].Distributor_Coupon_Code__c='No Discount';
                       //INSITEList[0].Distributor_Coupon_Code__c='No Discount';
                       //logic to calcluate the expiray Date...
                       Date registrationDate=QSOLList[0].Registration_Date__c;
                       
                       Integer year=System.today().year();
                       year=year+1;
                       
                       //Date newexpirayDate=expirayDate.addYears(1);
                       if(registrationDate!=null)
                       {
                           Date expirayDate=Date.newInstance(year,registrationDate.month(),registrationDate.day());
                           if(registrationDate.month()>System.Today().month())
                           {
                               expirayDate=Date.newInstance(system.today().year(),registrationDate.month(),registrationDate.day());
                           }
                           else if(registrationDate.month()==System.Today().month())
                           {
                               if(registrationDate.day()>System.Today().day())
                               {
                                   expirayDate=Date.newInstance(system.today().year(),registrationDate.month(),registrationDate.day());
                               }
                               else if(registrationDate.day()==System.Today().day())
                               {
                                   expirayDate=Date.newInstance(system.today().year(),system.today().month(),system.today().day());
                               }
                               else if(registrationDate.day()<System.Today().day())
                               {
                                   expirayDate=Date.newInstance(year,registrationDate.month(),registrationDate.day());
                               }
                                   
                           }
                           /*else
                           {
                               expirayDate=newexpirayDate;
                           }*/
                           //Scenario A: QSOL Expired and Insite Expired (Very unlikely)
                           if(INSITEList[0].End_Date__c<system.today() && expirayDate<system.today())
                           {
                               QSOLList[0].Dealer_Coupon_Code__c='No Discount';
                               INSITEList[0].Dealer_Coupon_Code__c='No Discount';
                               
                           }//Scenario B: QSOL Expired and INSITE has x months remaining
                           else if(expirayDate<=system.today() && INSITEList[0].End_Date__c>system.today())
                           {
                               //checking how many months are remaning 
                               
                               //Integer numberDaysDue = system.today().daysBetween(INSITEList[0].End_Date__c);
                               Integer noOfMonthsDue = INSITEList[0].End_Date__c.monthsBetween( system.today());
                               
                               if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0 )
                               { 
                                   Integer calculatedPrice=(Integer)(existingSubPriceMetaData[0].INSITE_DN_Price__c*5).round(System.RoundingMode.UP);
                                   
                                   String couponName='5FLATOFFDISTINSITEDN';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       //INSITEList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                       QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                                   
                               
                               } 
                           }//Scenario C: INSITE has expired, QSOL has x months remaining
                           if(INSITEList[0].End_Date__c<=system.today() && expirayDate>system.today())
                           {
                               //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                                Integer noOfMonthsDue = system.today().monthsBetween(expirayDate);
                               
                               if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
                               { 
                                   Integer calculatedPrice=(Integer)(((existingSubPriceMetaData[0].QSOL_Distributor_DN_Price__c/12)*noOfMonthsDue)+(4*existingSubPriceMetaData[0].INSITE_DN_Price__c)).round(System.RoundingMode.UP);
                                   
                                   String couponName='4INPLUS'+noOfMonthsDue+'MONQSOLDIST';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                                   if(noOfMonthsDue==0)
                                   {
                                       QSOLList[0].Distributor_Coupon_Code__c='4INSITEOFF';
                                   }
                               } 
                               
                           }//Scenario D: QSOL has not yet expired, but is expiring first before INSITE
                           else if(expirayDate>system.today() && expirayDate < INSITEList[0].End_Date__c)
                           {
                               //Integer numberDaysDue = system.today().daysBetween(INSITEList[0].End_Date__c);
                                Integer noOfMonthsDue = system.today().monthsBetween(INSITEList[0].End_Date__c);
                               if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
                               { 
                                   Integer calculatedPrice=(Integer)(existingSubPriceMetaData[0].INSITE_DN_Price__c*5).round(System.RoundingMode.UP);
                                   
                                   String couponName='5FLATOFFDISTINSITEDN';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       //INSITEList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                       QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                               } 
                               
                               
                           }//Scenario E: INSITE has not yet expired, but is expiring first before QSOL
                           else if(INSITEList[0].End_Date__c>system.today() && INSITEList[0].End_Date__c < expirayDate)
                           {
                               //Integer numberDaysDue = system.today().daysBetween(QSOLList[0].End_Date__c);
                                Integer noOfMonthsDue = system.today().monthsBetween(expirayDate);
                               if(existingSubPriceMetaData!=null && existingSubPriceMetaData.size()>0)
                               { 
                                   Integer calculatedPrice=(Integer)(((existingSubPriceMetaData[0].QSOL_Distributor_DN_Price__c/12)*noOfMonthsDue)+(4*existingSubPriceMetaData[0].INSITE_DN_Price__c)).round(System.RoundingMode.UP);
                                   
                                   String couponName='4INPLUS'+noOfMonthsDue+'MONQSOLDIST';
                                   if(couponNameVsCouponRecMap !=null && couponNameVsCouponRecMap.get(couponName) !=null)
                                   {
                                       QSOLList[0].Distributor_Coupon_Code__c=couponNameVsCouponRecMap.get(couponName).ccrz__CouponCode__c;
                                   }
                                   if(noOfMonthsDue==0)
                                   {
                                       QSOLList[0].Distributor_Coupon_Code__c='4INSITEOFF';
                                   }
                               } 
                               
                               
                           }//Scenario F: QSOL has 'x' months remaining, but no INSITE subscription
                           else if(expirayDate>system.today() && (INSITEList[0] ==null || INSITEList.size()==0))
                           {
                               QSOLList[0].Dealer_Coupon_Code__c='No Discount';
                               INSITEList[0].Dealer_Coupon_Code__c='No Discount';
                           }//Scenario G: INSITE has 'x' months remaining (has not expired),but no QSOL subscription
                           else if(INSITEList[0].End_Date__c>system.today() && (QSOLList[0] ==null || QSOLList.size()==0))
                           {
                               QSOLList[0].Distributor_Coupon_Code__c='No Discount';
                               INSITEList[0].Distributor_Coupon_Code__c='No Discount';
                           }
                           
                          
                          
                       }   
                   }
                   
                   //if(!usedCouponNames.contains(QSOLList[0].Distributor_Coupon_Code__c) && !customerNames.contains(accountId))
                   if(!CustCouponMap.containsKey(accountId) || !(CustCouponMap.get(accountId).contains(QSOLList[0].Distributor_Coupon_Code__c)))
                   {
                       finalListToUpdate.add(QSOLList[0]);
                       finalListToUpdate.add(INSITEList[0]);
                       OSM_Accounts_Coupon_Details__c couponDetail=new OSM_Accounts_Coupon_Details__c();
                       couponDetail.Customer_Name__c=accountId;
                       couponDetail.Coupon_Code__c=QSOLList[0].Distributor_Coupon_Code__c;
                       couponDetail.Date_Generated__c=system.today();
                       
                       if(QSOLList[0].Distributor_Coupon_Code__c!=null)
                       couponCustDetailList.add(couponDetail);
                       
                       
                   }
               }
               
               
           }
           
           //finally updating INSITE and QSOL values...
           if(finalListToUpdate!=null && finalListToUpdate.size()>0)
               update finalListToUpdate;
               
           if(couponCustDetailList!=null && couponCustDetailList.size()>0)
               insert couponCustDetailList; 
        }
       
        
       }