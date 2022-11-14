public class CG_UpdateClaimType {
    
    
    @InvocableMethod(label='updateClaimType' description='update claimtype from Process Builder')
    public static void updateClaimType(List<Id> idList){
        //Code to check the Dealer user
        system.debug('User**'+userinfo.getUserId());
        String orgtype=css_utility.getOrgType(userinfo.getUserId());
        if (orgtype != null && orgtype != '' && orgtype != 'DLR'){            
        
        List<CSS_Parts_Options__c > partOptionList = new List<CSS_Parts_Options__c>();
        List<CSS_SRT__c> srtList = new List<CSS_SRT__c>();
        List<CSS_SRT__c> updateSrtList = new List<CSS_SRT__c>();
        List<CSS_Parts_Options__c> updatePartList = new List<CSS_Parts_Options__c>();
        
        //query parts Options record
        partOptionList =[Select id,Fail_Code__c,CSS_Claims__c,Get_Fail_Code_Formula__c, Claimtype__c,Service_Job__c,Account_Code__c from CSS_Parts_Options__c where Id IN:idList];
        system.debug('partOptionList'+partOptionList);
        //query srt record
        srtList = [select id,Job_Order__c,CSS_Claims__c,Claim_Type__c,Account_Code__c,AccountCode_Formula__c, FailCode__c from CSS_SRT__c where id IN:idList];
        system.debug('srtList'+srtList);
        //if request coming from part option object
        if(partOptionList.size()>0){
            Set<Id> jobIdList = new Set<Id>();
            Set<Id> claimIdList = new Set<Id>();
            for(CSS_Parts_Options__c part : partOptionList){
                if(part.Service_Job__c!=null)
                    jobIdList.add(part.Service_Job__c);
                if(part.CSS_Claims__c!=null) 
                    claimIdList.add(part.CSS_Claims__c);   
            }
            map<id,List<CSS_Solution_Component__c>> solutionListMap = new map<id,List<CSS_Solution_Component__c>>();
            system.debug('jobIdList-'+ jobIdList);
            system.debug('claimIdList-'+claimIdList);
            //if records are from service job
            if(jobIdList.size()>0 && claimIdList.size()==0){
                
                //create the map for solution Component
                for(CSS_Solution_Component__c sol : [Select id,Service_Job__c,Selected_Claim_Type__c,CSS_Account_Formula__c,Fail_Code__c,Claim_Type__c 
                                                     from CSS_Solution_Component__c 
                                                     where Service_Job__c IN :jobIdList]){
                                                         
                    if(!solutionListMap.containsKey(sol.Service_Job__c)){
                        solutionListMap.put(sol.Service_Job__c,new List<CSS_Solution_Component__c>{sol});    
                    }else{
                        solutionListMap.get(sol.Service_Job__c).add(sol);    
                    }                                     
                                                         
                }
                system.debug('from job-solutionListMap-'+solutionListMap);
                //loop through all the partOptions
                for(CSS_Parts_Options__c parts : partOptionList){
                    String fCode;
                    if(parts.Fail_Code__c != null && parts.Fail_Code__c != ''){
                        if(parts.Fail_Code__c.contains('-')){
                            List<String> lstTempStr = parts.Fail_Code__c.split('-');
                            if(lstTempStr.size() > 0){
                                fCode = lstTempStr[lstTempStr.size()-1];
                            }
                        }
                        else{
                            fCode = parts.Fail_Code__c;
                        }
                    }
                    else{
                        if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != ''){
                            List<String> lstTempStr = parts.Get_Fail_Code_Formula__c.split('-');
                            if(lstTempStr.size() > 0){
                                fCode = lstTempStr[lstTempStr.size()-1];
                            }
                        }
                    }
                    
                    //loop through all the solution component record of service job   
                    if(parts.Service_Job__c!=null &&  solutionListMap.containskey(parts.Service_Job__c)){
                        
                        for(CSS_Solution_Component__c solComp : solutionListMap.get(parts.Service_Job__c)){
                            
                            if(fCode == solComp.Fail_Code__c 
                                && parts.Account_Code__c == solComp.CSS_Account_Formula__c 
                                && (solComp.Claim_Type__c!=null || solComp.Selected_Claim_Type__c != null)){
                                system.debug('from job-solComp.Claim_Type__c'+solComp.Claim_Type__c);
                                //parts.  
                                //parts.Claimtype__c = solComp.Claim_Type__c;
                                if(solComp.Claim_Type__c != null && solComp.Claim_Type__c != ''){
                                    parts.Claimtype__c = solComp.Claim_Type__c;
                                }
                                else{
                                    if(solComp.Selected_Claim_Type__c != null && solComp.Selected_Claim_Type__c != '')
                                        parts.Claimtype__c = solComp.Selected_Claim_Type__c;
                                }
                                updatePartList.add(parts);
                                break;
                            }    
                        }
                    }
                    
                }
      
                
            }//if records are from claims
            else if(jobIdList.size()==0 && claimIdList.size()>0){
                
                //create the map for solution Component
                for(CSS_Solution_Component__c sol : [Select id,CSS_Claims__c,Selected_Claim_Type__c,CSS_Account_Formula__c,Fail_Code__c,Claim_Type__c
                                                     from CSS_Solution_Component__c 
                                                     where CSS_Claims__c IN :claimIdList]){
                                                         
                    if(!solutionListMap.containsKey(sol.CSS_Claims__c)){
                        solutionListMap.put(sol.CSS_Claims__c,new List<CSS_Solution_Component__c>{sol});    
                    }else{
                        solutionListMap.get(sol.CSS_Claims__c).add(sol);    
                    }                                     
                                                         
                }
                system.debug('from claim-solutionListMap-'+solutionListMap);
                //loop through all the partOptions 
                for(CSS_Parts_Options__c parts : partOptionList){
                    String fCodeClaims;
                    if(parts.Fail_Code__c != null && parts.Fail_Code__c != ''){
                        if(parts.Fail_Code__c.contains('-')){
                            List<String> lstTempStr = parts.Fail_Code__c.split('-');
                            if(lstTempStr.size() > 0){
                                fCodeClaims = lstTempStr[lstTempStr.size()-1];
                            }
                        }
                        else{
                            fCodeClaims = parts.Fail_Code__c;
                        }
                    }
                    else{
                        if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != ''){
                            List<String> lstTempStr = parts.Get_Fail_Code_Formula__c.split('-');
                            if(lstTempStr.size() > 0){
                                fCodeClaims = lstTempStr[lstTempStr.size()-1];
                            }
                        }
                    }
                    
                    //loop through all the solution component record of claims
                    if(parts.CSS_Claims__c!=null &&  solutionListMap.containskey(parts.CSS_Claims__c)){
                        
                        for(CSS_Solution_Component__c solComp : solutionListMap.get(parts.CSS_Claims__c)){
                            
                            if(fCodeClaims == solComp.Fail_Code__c 
                                && parts.Account_Code__c == solComp.CSS_Account_Formula__c 
                                && (solComp.Claim_Type__c!=null || solComp.Selected_Claim_Type__c != null)){
                                system.debug('from claim-solComp.Claim_Type__c'+solComp.Claim_Type__c);
                                if(solComp.Claim_Type__c != null && solComp.Claim_Type__c != ''){
                                    parts.Claimtype__c = solComp.Claim_Type__c;
                                }
                                else{
                                    if(solComp.Selected_Claim_Type__c != null && solComp.Selected_Claim_Type__c != '')
                                        parts.Claimtype__c = solComp.Selected_Claim_Type__c;
                                }
                                updatePartList.add(parts) ;    
                                break;    
                            }    
                        }
                        
                    }
                }
     
            }
            system.debug('from claim-updatePartList-'+ updatePartList);
            if(updatePartList.size()>0){
                update updatePartList;
            }
   
            
        }//if request comming from SRT object
        else if(srtList.size()>0){
            
            Set<Id> jobIdList = new Set<Id>();
            Set<Id> claimIdList = new Set<Id>();
            for(CSS_SRT__c srt : srtList){
                if(srt.Job_Order__c!=null)
                    jobIdList.add(srt.Job_Order__c);
                if(srt.CSS_Claims__c!=null) 
                    claimIdList.add(srt.CSS_Claims__c);   
            }
            system.debug('claimIdList-'+claimIdList);
            map<id,List<CSS_Solution_Component__c>> solutionListMap = new map<id,List<CSS_Solution_Component__c>>();
            //if records are from service job
            if(jobIdList.size()>0 && claimIdList.size()==0){
                
                //create the map for solution Component
                for(CSS_Solution_Component__c sol : [Select id,Service_Job__c,Selected_Claim_Type__c,CSS_Account_Formula__c,Fail_Code__c ,Claim_Type__c
                                                     from CSS_Solution_Component__c 
                                                     where Service_Job__c IN :jobIdList]){
                                                         
                    if(!solutionListMap.containsKey(sol.Service_Job__c)){
                        solutionListMap.put(sol.Service_Job__c,new List<CSS_Solution_Component__c>{sol});    
                    }else{
                        solutionListMap.get(sol.Service_Job__c).add(sol);    
                    }                                     
                                                         
                }
                system.debug('from job-solutionListMap-'+solutionListMap);
                //loop through all the srt records
                for(CSS_SRT__c srt : srtList){
                    
                    //loop through all the solution component record of service job   
                    if(srt.Job_Order__c!=null &&  solutionListMap.containskey(srt.Job_Order__c)){
                        
                        for(CSS_Solution_Component__c solComp : solutionListMap.get(srt.Job_Order__c)){
                            
                            //update the claimtype of srt record
                            if((solComp.Fail_Code__c != null && solComp.Fail_Code__c != '' && srt.FailCode__c == solComp.Fail_Code__c.left(4)) 
                                && srt.AccountCode_Formula__c == solComp.CSS_Account_Formula__c 
                                && (solComp.Claim_Type__c!=null || solComp.Selected_Claim_Type__c != null)){
                                system.debug('from job-solComp.Claim_Type__c-'+solComp.Claim_Type__c);
                                //srt.Claim_Type__c =  solComp.Claim_Type__c;
                                if(solComp.Claim_Type__c != null && solComp.Claim_Type__c != ''){
                                    srt.Claim_Type__c = solComp.Claim_Type__c;
                                }
                                else{
                                    if(solComp.Selected_Claim_Type__c != null && solComp.Selected_Claim_Type__c != '')
                                        srt.Claim_Type__c = solComp.Selected_Claim_Type__c;
                                }
                                updateSrtList.add(srt);
                                break;
                                    
                            }    
                        }
                    }
                    
                }
      
                
            }//if records are from claims
            else if(jobIdList.size()==0 && claimIdList.size()>0){
                
                //create the map for solution Component
                for(CSS_Solution_Component__c sol : [Select id,CSS_Claims__c,Selected_Claim_Type__c,CSS_Account_Formula__c,Fail_Code__c,Claim_Type__c 
                                                     from CSS_Solution_Component__c 
                                                     where CSS_Claims__c IN :claimIdList]){
                                                         
                    if(!solutionListMap.containsKey(sol.CSS_Claims__c)){
                        solutionListMap.put(sol.CSS_Claims__c,new List<CSS_Solution_Component__c>{sol});    
                    }else{
                        solutionListMap.get(sol.CSS_Claims__c).add(sol);    
                    }                                     
                                                         
                }
                system.debug('from claim-solutionListMap'+solutionListMap);
                //loop through all the partOptions 
                for(CSS_SRT__c srt : srtList){
                    
                    //loop through all the solution component record of claims
                    if(srt.CSS_Claims__c!=null &&  solutionListMap.containskey(srt.CSS_Claims__c)){
                        
                        for(CSS_Solution_Component__c solComp : solutionListMap.get(srt.CSS_Claims__c)){
                            
                            //update the claimtype of srt record
                            if((solComp.Fail_Code__c != null && solComp.Fail_Code__c != '' && srt.FailCode__c == solComp.Fail_Code__c.LEFT(4)) 
                                && srt.AccountCode_Formula__c == solComp.CSS_Account_Formula__c 
                                && (solComp.Claim_Type__c!=null || solComp.Selected_Claim_Type__c != null)){
                                system.debug('solComp.Claim_Type__c'+ solComp.Claim_Type__c);
                                //srt.Claim_Type__c =  solComp.Claim_Type__c;
                                if(solComp.Claim_Type__c != null && solComp.Claim_Type__c != ''){
                                    srt.Claim_Type__c = solComp.Claim_Type__c;
                                }
                                else{
                                    if(solComp.Selected_Claim_Type__c != null && solComp.Selected_Claim_Type__c != '')
                                        srt.Claim_Type__c = solComp.Selected_Claim_Type__c;
                                }
                                updateSrtList.add(srt);
                                break;    
                                    
                            }    
                        }
                        
                    }
                }
     
            }
            system.debug('from claim-updateSrtList-'+updateSrtList);
            if(updateSrtList.size()>0){
                update updateSrtList;
            }
     
        }
        
        
    }
    }//DLR If Loop END
}