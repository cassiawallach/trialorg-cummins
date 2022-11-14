/**********************************************************************
Name:CG_BL_BMS
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is the Business Layer for BMS End points. 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Krishnamoorthi      12/20/2017      INITIAL DEVELOPMENT  
1.1 - Surender M          05/15/2018      Added Code for Customer Credit Messages & Private SRTs functionality
***********************************************************************/
public class CG_BL_BMS {

    //Fetching BMS Private SRTs
    public static List<CSS_srt__c> getBMSPrivateSRTs(String jobId) {
        List<CSS_srt__c> privateSRTList =new List<CSS_srt__c>();
        String distributorCode;
        String branchCode;
        String locationId;
        String engineFamilyCode;
        try{
            //Id wId = ApexPages.CurrentPage().getParameters().get('JobOrderId');
            System.debug('jobId>>>>:'+jobId);
            if(jobId == null)
                return privateSRTList;
            css_job_order__c workJob = [Select Id,Creator_Location__c,Qsol_Engine_Family_Code__c,AccessCode__c from CSS_Job_Order__c where id= :jobId limit 1];
            System.debug('workJob>>>>:'+workJob);
            System.debug('workJob>>>>:'+workJob+' workJob.Creator_Location__c>>>:'+workJob.Creator_Location__c+' workJob.Qsol_Engine_Family_Code__c'+workJob.Qsol_Engine_Family_Code__c);
            if (workJob.Creator_Location__c != null){
                distributorCode = workJob.Creator_Location__c.LEFT(5);
                branchCode = workJob.Creator_Location__c.RIGHT(5);
                locationId = workJob.Creator_Location__c;
                engineFamilyCode = workJob.Qsol_Engine_Family_Code__c;
            }
            CG_OP_OAGWrapper resWrapper = CG_SL_BMS.getBMSPrivateSRTs(distributorCode, branchCode, engineFamilyCode, locationId);
            
            if(Test.isRunningTest()){
                resWrapper.response.setStatusCode(200);
                //resWrapper.response.setBody('{"Header":{"Sender":{"ServiceName":"GetBMSPrivateSRTs","SenderID":"CSS","MessageID":"2e748cff-d31e-48ac-9f1e-475a98399c19"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"Distributor Not Setup","Location":{"LocationID":"02466-19134"}}}');
           //resWrapper.response.setBody('{"Header":{"Sender":{"ServiceName":"GetBMSPrivateSRTs","SenderID":"CSS","MessageID":"2e748cff-d31e-48ac-9f1e-475a98399c19"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"Distributor Not Setup","Location":{"LocationID":"02466-19134"}}},"DataArea": [{"EngineFamily": "","SRTGroup": "","SRTProcedure": "","SRTStep": "","Title": "","AccessCode": "","Hours": 2.3,"Troubleshoot": "","Flexible": "","Private": "","Special":"","RegionCode": ""}]');
            //resWrapper.response.setBody('{"Header":{"Sender":{"ServiceName":"GetBMSPrivateSRTs","SenderID":"CSS","MessageID":"2e748cff-d31e-48ac-9f1e-475a98399c19"},"Status":"SUCCESS","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"Distributor Not Setup","Location":{"LocationID":"02466-19134"}}},"DataArea": [{"EngineFamily": "","SRTGroup": "T","SRTProcedure": "T","SRTStep": "","Title": "Test","AccessCode": "R","Hours": 2.3,"Troubleshoot": "Y","Flexible": "Y","Private": "Y","Special":"Y","RegionCode": ""}]');
            //resWrapper.response.setBody('{"Header":{"Sender":{"ServiceName":"GetBMSPrivateSRTs","SenderID":"CSS","MessageID":"2e748cff-d31e-48ac-9f1e-475a98399c19"},"Status":"SUCCESS","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"Distributor Not Setup","Location":{"LocationID":"02466-19134"}}},"DataArea": [{"EngineFamily": "","SRTGroup": "T","SRTProcedure": "T","SRTStep": "","Title": "Test","AccessCode": "R","Hours": 2.3,"Troubleshoot": "Y","Flexible": "Y","Private": "Y","Special":"Y","RegionCode": ""},{"EngineFamily": "","SRTGroup": "T","SRTProcedure": "T","SRTStep": "","Title": "Test","AccessCode": "C","Hours": 2.3,"Troubleshoot": "Y","Flexible": "Y","Private": "Y","Special":"Y","RegionCode": ""}]');
            resWrapper.response.setBody('{"DataArea": [{"Special": "N","SRTProcedure": "990","Hours": "0","EngineFamily": "02","SRTStep": "","SRTGroup": "01","Flexible": "Y","AccessCode": "C","Title": "TRAVEL","RegionCode": "CENTRAL","Troubleshoot": "N","Private": "Y"},{"Special": "N","SRTProcedure": "990","Hours": "0","EngineFamily": "02","SRTStep": "","SRTGroup": "01","Flexible": "Y","AccessCode": "A","Title": "TRAVEL","RegionCode": "CENTRAL","Troubleshoot": "N","Private": "Y"},{"Special": "N","SRTProcedure": "990","Hours": "0","EngineFamily": "02","SRTStep": "","SRTGroup": "02","Flexible": "Y","AccessCode": "R","Title": "TRAVEL","RegionCode": "CENTRAL","Troubleshoot": "N","Private": "Y"},{"Special": "N","SRTProcedure": "990","Hours": "0","EngineFamily": "02","SRTStep": "","SRTGroup": "02","Flexible": "Y","AccessCode": "D","Title": "TRAVEL","RegionCode": "CENTRAL","Troubleshoot": "N","Private": "Y"},{"Special": "N","SRTProcedure": "990","Hours": "0","EngineFamily": "02","SRTStep": "","SRTGroup": "02","Flexible": "Y","AccessCode": "C","Title": "TRAVEL","RegionCode": "CENTRAL","Troubleshoot": "N","Private": "Y"},{"Special": "N","SRTProcedure": "990","Hours": "0","EngineFamily": "02","SRTStep": "","SRTGroup": "99","Flexible": "Y","AccessCode": "D","Title": "TRAVEL","RegionCode": "CENTRAL","Troubleshoot": "N","Private": "Y"}],"Header": {"Status": "SUCCESS","Sender": {"ServiceName": "GetBMSPrivateSRTs","MessageID": "471afdc7-72ed-498a-b5fe-bbd44eed6d8f","SenderID": "CSS"},"Target": {"TargetID": "BMS"},"Location": {"LocationID": "03520-03525"}}}');
            }
            //system.debug('resWrapper>>'+resWrapper);
            //system.debug('resWrapper.response>>'+resWrapper.response);
            //system.debug('resWrapper.response.getBody()>>'+resWrapper.response.getBody());
            if(resWrapper !=null && resWrapper.exceptionFlag != true && resWrapper.response !=null && resWrapper.response.getBody() !=null){
                //insertBMSPrivateSRTs(resWrapper.response.getBody(), 'BMSPrivateSRTs');
                System.debug('resWrapper.response.getBody>>:'+resWrapper.response.getBody());
                //String hardCodeRes = '{"DataArea":[{"Special":"N","SRTProcedure":"850","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"00","Flexible":"Y","AccessCode":"B","Title":"PM FULL SERVICE","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"},{"Special":"N","SRTProcedure":"850","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"00","Flexible":"Y","AccessCode":"C","Title":"PM FULL SERVICE","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"},{"Special":"N","SRTProcedure":"TRN","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"99","Flexible":"Y","AccessCode":"B","Title":"TECHNICIAN TRAINING","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"}],"Header":{"Status":"SUCCESS","Sender":{"ServiceName":"GetBMSPrivateSRTs","MessageID":"72497242-d5fe-4d73-904a-cee23845a929","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"03520-04892"}}}';
                //CG_OP_BMSPrivateSRTsResJSON resWrap = (CG_OP_BMSPrivateSRTsResJSON)JSON.deserialize(hardCodeRes, CG_OP_BMSPrivateSRTsResJSON.class);
                CG_OP_BMSPrivateSRTsResJSON resWrap = (CG_OP_BMSPrivateSRTsResJSON)JSON.deserialize(resWrapper.response.getBody(), CG_OP_BMSPrivateSRTsResJSON.class);
                //System.debug('after deserializa...'+resWrap);
                //System.debug('before workJob>>>>:'+resWrap.DataArea);
                   // System.debug('before workJob>>>>:'+resWrap.DataArea.size());
                if (resWrap.Header !=null && resWrap.Header.Status.contains('SUCCESS') && resWrap.DataArea != null && resWrap.DataArea.size() > 0)  {
                    //System.debug('before workJob>>>>:'+workJob);
                    
                    for (integer i=0;i<resWrap.DataArea.size();i++){
                        if(resWrap.DataArea[i].AccessCode != workJob.AccessCode__c){
                            continue;
                        }
                        CSS_srt__c privateSRT = new CSS_srt__c();
                        if(resWrap.DataArea[i].SRTStep ==null || resWrap.DataArea[i].SRTStep.trim() == '')
                            privateSRT.SRT_Id__c = resWrap.DataArea[i].SRTGroup+'-'+resWrap.DataArea[i].SRTProcedure;
                        else
                            privateSRT.SRT_Id__c = resWrap.DataArea[i].SRTGroup+'-'+resWrap.DataArea[i].SRTProcedure+'-'+resWrap.DataArea[i].SRTStep;
                        privateSRT.SRT_Title__c = resWrap.DataArea[i].Title;
                        privateSRT.Type__c ='Private';
                        privateSRT.SRT_Type__c = 'Private';
                        privateSRT.SRT_Category__c = '';//AdditionalDiag/AdditionalRep
                        privateSRT.Access_Code__c = resWrap.DataArea[i].AccessCode;
                        privateSRT.SRT_Family__c = resWrap.DataArea[i].EngineFamily;

                        if(resWrap.DataArea[i].AccessCode !=null && resWrap.DataArea[i].AccessCode !='' && resWrap.DataArea[i].AccessCode =='A'){
                            privateSRT.Access_Code_A__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;//*60;
                        }else if(resWrap.DataArea[i].AccessCode !=null && resWrap.DataArea[i].AccessCode !='' && resWrap.DataArea[i].AccessCode =='B'){
                            privateSRT.Access_Code_B__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;//*60;
                        }else if(resWrap.DataArea[i].AccessCode !=null && resWrap.DataArea[i].AccessCode !='' && resWrap.DataArea[i].AccessCode =='C'){
                            privateSRT.Access_Code_C__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;//*60;
                        }else if(resWrap.DataArea[i].AccessCode !=null && resWrap.DataArea[i].AccessCode !='' && resWrap.DataArea[i].AccessCode =='D'){
                            privateSRT.Access_Code_D__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;//*60;
                        }else if(resWrap.DataArea[i].AccessCode !=null && resWrap.DataArea[i].AccessCode !='' && resWrap.DataArea[i].AccessCode =='R'){
                            privateSRT.Access_Code_R__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;//*60;
                        }
                        
                        if(workJob.AccessCode__c =='A'){
                            privateSRT.SRT_Time__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;
                        }else if(workJob.AccessCode__c =='B'){
                            privateSRT.SRT_Time__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;
                        }else if(workJob.AccessCode__c =='C'){
                            privateSRT.SRT_Time__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;
                        }else if(workJob.AccessCode__c =='D'){
                            privateSRT.SRT_Time__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;
                        }else if(workJob.AccessCode__c =='R'){
                            privateSRT.SRT_Time__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;
                        }
                        
                        if(resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours.trim() !=''){
                            try{
                                //privateSRT.Hours_BMS__c = Decimal.valueOf(resWrap.DataArea[i].Hours);
                                privateSRT.Hours_BMS__c = resWrap.DataArea[i].Hours !=null && resWrap.DataArea[i].Hours !='' ? Double.valueof(resWrap.DataArea[i].Hours) : 0;
                            }catch(Exception ex){
                                System.debug('in catch of convertion getBMSPrivateSRTs--CG_BL_BMS >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }
                        }
                        if(resWrap.DataArea[i].Special !=null && resWrap.DataArea[i].Special.trim() !='' && resWrap.DataArea[i].Special=='Y')
                            privateSRT.Special_BMS__c = true;
                        else
                            privateSRT.Special_BMS__c = false;
                        if(resWrap.DataArea[i].Flexible !=null && resWrap.DataArea[i].Flexible.trim() !='' && resWrap.DataArea[i].Flexible=='Y')
                            privateSRT.Flexible_BMS__C = true;
                        else
                            privateSRT.Flexible_BMS__C = false;
                        if(resWrap.DataArea[i].Troubleshoot !=null && resWrap.DataArea[i].Troubleshoot.trim() !='' && resWrap.DataArea[i].Troubleshoot=='Y')
                            privateSRT.Troubleshoot_BMS__c = true;
                        else
                            privateSRT.Troubleshoot_BMS__c = false;
                        if(resWrap.DataArea[i].PrivateFlag !=null && resWrap.DataArea[i].PrivateFlag.trim() !='' && resWrap.DataArea[i].PrivateFlag=='Y')
                            privateSRT.Private_BMS__c = true;
                        else
                            privateSRT.Private_BMS__c = false;
                        privateSRT.isPerformed__c = false;
                        privateSRT.SRT_Notes__c ='';
                        privateSRT.Job_Order__c = jobId;
                        privateSRTList.add(privateSRT);

                    }
                }
            }
        }catch(Exception ex){
            System.debug('in catch of getBMSPrivateSRTs--CG_BL_BMS >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return privateSRTList;
    }

    //Fetching BMS Customer Details.
    public static CG_OP_OAGWrapper fetchBMSCustomerDetails(String custName,String custCode,String Location) {
        return CG_SL_BMS.fetchBMSCustomerDetails(custName, custCode, Location);
    }

    //Create BMS Account.
    public static CG_OP_OAGWrapper createBMSAccount(String custName, String custAddr1, String custAddr2, String custAddr3, String AreaCode, String Phone, String city, String state, String postCode, String postalcodesuffix, String cusContact, String countryCd, String lang, String application, string location) {
        return CG_SL_BMS.createBMSAccount(custName, custAddr1, custAddr2, custAddr3, AreaCode, Phone, city, state, postCode, postalcodesuffix, cusContact, countryCd, lang, application, location);
    }

    //Get Misc Charge LOV's Details.
    public static CG_OP_OAGWrapper getMISCChargeLOVs(String HQCode,String BranchCode,String location) {
        return CG_SL_BMS.getMISCChargeLOVs(HQCode, BranchCode, location);
    }

    //Send Request to BMS to delete Job in BMS System
    public static CG_OP_OAGWrapper DeleteBMSJob(string JobId,string location,string CustomerCode,string OrderType,string BMSRefNum,string JobStatus){
        system.debug('****insidedeleteBMSJob_CG_BL');
        return CG_SL_BMS.deleteBMSJob(JobId,location,CustomerCode,OrderType,BMSRefNum,JobStatus);
    }
    //Failure code Inbound Super girl Story 
    /* public static CG_OP_OAGWrapper sendFailurecode(String Location,String CSSJobID,String DistributorCode,String BranchCode,String CustomerCode, String OrderType, String BMSReferenceNumber,List<CSS_Solution_Component__c> FailuresList) 
      {
           return CG_SL_BMS.sendFailurecode(Location,CSSJobID,DistributorCode,BranchCode,CustomerCode,OrderType,BMSReferenceNumber,FailuresList);
      }*/

    //Send Claim Header to BMS
   /* public static CG_OP_OAGWrapper sendClaimHeadertoBMS(){
        String Location;
        //Parse with ********CG_sendClaimHeadertoBMSResJSON******** after WS Call when functionality story comes up
        return CG_SL_BMS.sendClaimHeadertoBMS(Location);
    }*/

    /*
    public static void insertBMSPrivateSRTs(String responseBody, String eventType){
        List<CSS_JobEventTemporary__c> jobEventList;
        CSS_JobEventTemporary__c jobEventObj;
        try{
            jobEventList = new List<CSS_JobEventTemporary__c>([Select Id, Reason__c, Attribute13__c from CSS_JobEventTemporary__c where Name=:eventType limit 1]);
            if(jobEventList.size()>0){
                jobEventObj = jobEventList.get(0);
                jobEventObj.Reason__c = responseBody;
                jobEventObj.Attribute13__c = Date.today();
                update jobEventObj;
            }else{
                jobEventObj = new CSS_JobEventTemporary__c();
                jobEventObj.Reason__c = responseBody;
                jobEventObj.Attribute13__c = Date.today();
                jobEventObj.Attribute1__c = eventType;  
                jobEventObj.Name = eventType;
                insert jobEventObj;
            }
        }catch(Exception ex){
            System.debug('in catch of insertBMSPrivateSRTs--CG_BL_BMS >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    } */

}