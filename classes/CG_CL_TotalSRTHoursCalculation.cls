/**********************************************************************
Name:CG_CL_TotalSRTHoursCalculation
======================================================
======================================================
Purpose:                                                            
-------  
We are using this class for calculation of Total SRT Hours based on Extended hours of selected SRTs.
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR            DATE                DETAIL  
1.0 -   Anvesh Reddy Sama    3/10/2019      Added code as part of user story 177459
/**********************************************************************/

public class CG_CL_TotalSRTHoursCalculation
{
    public CG_CL_TotalSRTHoursCalculation()
    {
    }

     public static void CalcualteExthrs(List<CSS_SRT__c> SRTHrsExtendedJob, List<CSS_SRT__c> SRTHrsExtendedClaims, Id JobID, Id ClaimId ){    
        try
          {
            system.debug('Inside CalcualteExthrs Method call JobID>>'  + JobID + 'ClaimId>> ' + ClaimId);
            system.debug('SRTHrsExtendedJob>>' + SRTHrsExtendedJob);
            system.debug('SRTHrsExtendedClaims>>' + SRTHrsExtendedClaims);
            
            CSS_Job_Order__c JobCalSRTExtHrs = new CSS_Job_Order__c();
            CSS_Claims__c ClaimsCalSRTExtHrs = new CSS_Claims__c();
           
           //Jobs 
            if(SRTHrsExtendedJob != null && SRTHrsExtendedJob.size()>0){
               if(JobID!=null) {
                      JobCalSRTExtHrs.id=JobID;
                      JobCalSRTExtHrs.DiagTimeExtendedHrsCalculation__c =0.0;
                      JobCalSRTExtHrs.TotalSRTExtendedHours__c =0.0;
                      
                      for(CSS_SRT__c queryLoopExtHrs : SRTHrsExtendedJob){
                           if(queryLoopExtHrs.type__c!=null && ((queryLoopExtHrs.type__c.equalsIgnorecase('Diagnosis') && queryLoopExtHrs.SRT_Category__c!='AdditionalRep' && queryLoopExtHrs.SRT_Category__c!='Campaign' && queryLoopExtHrs.SRT_Category__c!='TRP' && queryLoopExtHrs.SRT_Category__c!='ATC') 
                           || queryLoopExtHrs.type__c.equalsIgnorecase('Diag Access') 
                           || (queryLoopExtHrs.type__c.equalsIgnorecase('Admin') && queryLoopExtHrs.SRT_Category__c!='AdditionalRep' && queryLoopExtHrs.SRT_Category__c!='Campaign' && queryLoopExtHrs.SRT_Category__c!='TRP' && queryLoopExtHrs.SRT_Category__c!='ATC')
                           || queryLoopExtHrs.SRT_Category__c=='AdditionalDiag'))
                        	{
                        		if(queryLoopExtHrs.Extended_Hours__c!=null){
                        			JobCalSRTExtHrs.DiagTimeExtendedHrsCalculation__c += queryLoopExtHrs.Extended_Hours__c;
                        		}
                        	}
                    
                            if(queryLoopExtHrs.Extended_Hours__c!=null){
                                JobCalSRTExtHrs.TotalSRTExtendedHours__c += queryLoopExtHrs.Extended_Hours__c;
                            }
                      }
                    update JobCalSRTExtHrs;
                    system.debug('JobCalSRTExtHrs>>' + JobCalSRTExtHrs);
               }
            }
           
            else if(JobID!=null) {
               system.debug('inside else for SRTHrsExtendedJob 0 records');
               JobCalSRTExtHrs.id=JobID;
               JobCalSRTExtHrs.TotalSRTExtendedHours__c = 0.0;
               update JobCalSRTExtHrs;
            }
          
          //Claims    
           if(SRTHrsExtendedClaims != null && SRTHrsExtendedClaims.size()>0){
                if(ClaimId != null) {
                      ClaimsCalSRTExtHrs.id=ClaimId;
                      ClaimsCalSRTExtHrs.TotalSRTExtendedHours__c =0.0;
                      Boolean flexErrorFlag = false;//GSSC-24
                      for(CSS_SRT__c queryLoopExtHrs : SRTHrsExtendedClaims){
                          system.debug('Before Flex_Flag__c:' + queryLoopExtHrs.Flex_Flag__c+' queryLoopExtHrs.SRT_Time__c:'+queryLoopExtHrs.SRT_Time__c+' queryLoopExtHrs:'+queryLoopExtHrs);
                          //GSSC-24 changes start
                          if((queryLoopExtHrs.isPerformed__c == true || queryLoopExtHrs.SRT_AccessiblityCheck__c) && queryLoopExtHrs.Flex_Flag__c == true && queryLoopExtHrs.SRT_Time__c <= 0){
                              flexErrorFlag = true;
                              System.debug('after flexErrorFlag:'+flexErrorFlag);
                          }
                          //GSSC-24 changes end
                           if(queryLoopExtHrs.Extended_Hours__c!=null){
                               system.debug('**queryLoopExtHrs.Extended_Hours__c***' + queryLoopExtHrs.Extended_Hours__c);
                               ClaimsCalSRTExtHrs.TotalSRTExtendedHours__c += queryLoopExtHrs.Extended_Hours__c;
                           }
                      }
                      //GSSC-24 changes start
                      if(flexErrorFlag == true){
                           ClaimsCalSRTExtHrs.SRT_FlexTime_Error__c = true;
                      }else{
                            ClaimsCalSRTExtHrs.SRT_FlexTime_Error__c = false;
                      }
                      //GSSC-24 changes end
                      system.debug('ClaimsCalSRTExtHrs>>' + ClaimsCalSRTExtHrs);
                      update ClaimsCalSRTExtHrs;
                      system.debug('***Aftyer ClaimsCalSRTExtHrs.TotalSRTExtendedHours__c****' + ClaimsCalSRTExtHrs.TotalSRTExtendedHours__c);
                 }
           }
           else if(ClaimId != null){
               ClaimsCalSRTExtHrs.id=ClaimId;
               ClaimsCalSRTExtHrs.TotalSRTExtendedHours__c =0.0;
               system.debug('Testhour'+ClaimsCalSRTExtHrs.TotalSRTExtendedHours__c);
               update ClaimsCalSRTExtHrs;
           }
        }
        
       catch(Exception e){
            system.debug('in catch of exception in CG_SRTExtendedHrsCalculation CalcualteExthrs method line number ' + e.getLineNumber() + '    Message' + e.getMessage());
        }
    }
}