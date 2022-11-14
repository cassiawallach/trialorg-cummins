/**********************************************************************
Name: CG_BL_Campaigns
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used as a fuctionality class for Business layer 
and to navigate to Service layer by passing required parameters
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        12/11/2017     INITIAL DEVELOPMENT
1.1     Vignesh S         12/27/2017     Added Logic to insert Campaign to Solution Component/Parts object
1.2     Rajkumar BT       02/13/2017     Added Logic to make field Action SRT callout and insert response
***********************************************************************/
public class CG_BL_Campaigns {
    
   
    public static CG_OP_OAGWrapper callGetCampaignsWS(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, String JobNumber, Id JobId){
        system.debug('entered into CG_BL_Campaigns callGetCampaignsWS esn>>>:'+esn);
        CG_OP_OAGWrapper resWrapper = null;
        try{
            //Call service Layer to make Webservice Call
            system.debug('in CG_BL_Campaigns before calling callGetCampaignsWS esn>>>:'+esn);
            CSS_Job_Order__c rJobOrd = new CSS_Job_Order__c();
            rJobOrd = [SELECT Id,Name, ESN__c, FieldActionWebServiceResult__c,CSS_Hours__c, ReconEngineFlag__c, Creator_Location__c, Failure_Date__c, Mileage__c, Mileage_Measure__c, ApplicationCode__c, Warranty_Start_Date__c FROM CSS_Job_Order__c WHERE Id =: jobId];
            system.debug('rJobOrd**'+rJobOrd);
            resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDate, region, territory, senderID, serviceName, messageID, target);
            system.debug('resWrapper>>>:'+resWrapper);
            //185628 start
            string exceptionMessage = resWrapper.exceptionMessage;
            system.debug('***exceptionMessage***'+exceptionMessage);
            list<string> resReqBody;
            if(exceptionMessage!=null){
                resReqBody=exceptionMessage.split('---');
            }
             //185628 END
            HttpResponse httpRes = resWrapper.response;
            system.debug('httpRes--'+httpRes);            
            list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
            if(httpRes == null || httpRes.getStatusCode() != 200) {
            // start coding as per story #185628,-By RAJESH 17th june 2019
                if(!exceptionMessage.contains('200')){
                    system.debug('***Going to insert a record into CSS_Integration_Error__c when web service is down from Job****');
                    CSS_Integration_Error__c intDetails  = new CSS_Integration_Error__c();
                        intDetails.Auth_Call_Time__c     = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
                        intDetails.Processed_Data__c     =  resReqBody[2];
                        intDetails.Response_Body__c      =  resReqBody[1];
                        intDetails.Service_Call_Time__c  = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
                        intDetails.Service_Job_Number__c = rJobOrd.name;
                        intDetails.Service_Name__c       = 'GetFieldActions/Campaigns';
                        intDetails.Source__c             = 'campaignJob';                
                      lstIntDetails.add(intDetails); 
                }
                if(lstIntDetails.size()!=null){
                 system.debug('**insert a record into CSS_Integration_Error__c object when lstIntDetails size morethen Zero in Job**');
                insert lstIntDetails;
                }
                // End coding as per story #185628,-By RAJESH 17th june 2019
                if(rJobOrd!=null){
                    rJobOrd.FieldActionWebServiceResult__c='Error';
                    system.debug('Inside One.0');
                }
                /*else{
                    rJobOrd.FieldActionWebServiceResult__c='Success';
                    system.debug('Inside One.2');
                }*/
            }
            else{
                if(rJobOrd!=null){
                    rJobOrd.FieldActionWebServiceResult__c='Success';
                    system.debug('Inside not null'+rJobOrd.FieldActionWebServiceResult__c);
                }
            }
            CG_OP_CampaignsResJSON outputRes;
            if(resWrapper.response != null)
                outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            system.debug('outputRes**'+outputRes);
            Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: 'Parts'].Id;
            List<CSS_Parts_Options__c> allPartsOptionList = new List<CSS_Parts_Options__c>();
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            Map<String,List<CSS_Parts_Options__c>> wsDataMap = new Map<String,List<CSS_Parts_Options__c>>();
            list<CampaignsWrapper> CampaignsWrapperList = new list<CampaignsWrapper>();
            if(outputRes!=null && outputRes.DataArea != null){
                system.debug('outputRes.DataArea ' + outputRes.DataArea);

                List<CSS_Parts_Options__c> partsOptionList;
               
                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    //Added below condition as per story 118800
                    system.debug('det.Status ' + det.Status);
                    //Here check Siebel Campaigns are meeting required criteria
                    if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                        continue;
                    if(det.Status == 'Approved' ){
                        CSS_Solution_Component__c campaignComp = new CSS_Solution_Component__c();
                        if(det.InShopSrtLimitFlag == 'Y')
                            campaignComp.In_Shop_SRT_Limit_Flag__c = true;
                        else
                            campaignComp.In_Shop_SRT_Limit_Flag__c = false;
                        campaignComp.Campaign_Description__c = det.CampaignDesc; 
                        if(det.CampaignEndDate != null && det.CampaignEndDate != '')
                            campaignComp.Campaign_End_Date__c = date.valueof(det.CampaignEndDate);
                        if(det.CampaignStartDate != null && det.CampaignStartDate != '')
                            campaignComp.Campaign_Start_Date__c = date.valueof(det.CampaignStartDate);
                        if(det.CampaignNumber != null)
                            campaignComp.Component_Id__c = string.valueof(det.CampaignNumber);
                        campaignComp.Failure_Mode__c = det.FailMode;
                        if(det.FailCode != null && det.FailCode != ''){
                            campaignComp.System_Code__c = (det.FailCode).substring(0,2);
                            campaignComp.Component_Code__c = (det.FailCode).substring(2);
                        }
                        campaignComp.Status__c = det.Status;
                        if(det.MultipleTimes == 'Y')
                            campaignComp.Multiple_Times__c = true;
                        else
                            campaignComp.Multiple_Times__c = false;
                        campaignComp.Business_Unit__c = det.BusinessUnit;
                        campaignComp.Type__c = det.CampaignType;
                        campaignComp.Name = det.CampaignType+' '+det.CampaignNumber;
                        campaignComp.Status__c = det.Status;
                        if(det.CompleteIndicator == 'Y')
                            campaignComp.Complete_Indicator__c = true;
                        else
                            campaignComp.Complete_Indicator__c = false;
                        campaignComp.Service_Job__c = JobId;     
                        //campaignComp.css_claims__c = ClaimId; 

                        //calling detail coverage as per story 184437 to check coverage before fieldaction insert

                        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();


                        if(rJobOrd.ApplicationCode__c=='130' || rJobOrd.ApplicationCode__c=='210' || rJobOrd.ApplicationCode__c=='220' || rJobOrd.ApplicationCode__c=='310' || rJobOrd.ApplicationCode__c=='320' || rJobOrd.ApplicationCode__c=='410'){
                            
                            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', rJobOrd.ReconEngineFlag__c, false,rJobOrd.Name);
                        }else{
                            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.CSS_Hours__c),'Hours',rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', rJobOrd.ReconEngineFlag__c, false,rJobOrd.Name); // karthik G sending Hours and product hours based on application code as part of defect #191326
                        }
                        System.debug('comp****' + comp);
                        system.debug('comp.AccountCode__c'+comp.AccountCode__c);
                        if(comp.AccountCode__c!=null && comp.AccountCode__c!=''){
                            system.debug('campaignComp ' + campaignComp);
                            solCompList.add(campaignComp);
                        }
                        //insert campaignComp; 

                        partsOptionList = new List<CSS_Parts_Options__c>();
                        if(det.PartList != null){
                            for(CG_OP_CampaignsResJSON.PartList partlst : det.PartList){
                                CSS_Parts_Options__c campaignPart = new CSS_Parts_Options__c();
                                campaignPart.Quantity__c = partlst.PartQuantity;
                                campaignPart.BMS_Quantity__c = partlst.PartQuantity;
                                if(partlst.PartNumber != null)
                                    campaignPart.Service_partnumber__c = string.valueof(partlst.PartNumber);
                                campaignPart.Part_Name__c = partlst.PartDescription;
                                campaignPart.Part_Description__c = partlst.PartDescription;
                                campaignPart.FailurepartId__c = campaignComp.Id;
                                campaignPart.Service_Job__c = JobId;
                                // campaignPart.css_claims__c = ClaimId;
                                campaignPart.Replacement_Reason__c = 'Campaign-TRP-ATC';
                                campaignPart.RecordTypeId = recTypeId;
                                
                                campaignPart.selected_part__c = false;
                                partsOptionList.add(campaignPart);
                            }
                        }
                        wsDataMap.put(campaignComp.Component_Id__c, partsOptionList);
                    }
                }
                system.debug('solCompList'+solCompList);
            }
            
            if(rJobOrd!=null){
                update rJobOrd;
            }
            //Delete old saved solution comp & parts data for the job
            List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>([Select Id from CSS_Solution_Component__c where Service_Job__c=:JobId and Type__c in ('CAMPAIGN','TRP','ATC')]);                
            system.debug('solCompListTemp'+solCompListTemp);
            if(solCompListTemp !=null && solCompListTemp.size()>0){
                system.debug('solCompListTemp'+solCompListTemp);
                List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>([Select Id, Name from CSS_Parts_Options__c where Service_Job__c=:JobId and RecordTypeId=:recTypeId and FailurepartId__c in :solCompListTemp]);                     
                System.debug('partsListTemp>>>:'+partsListTemp);
                if(partsListTemp !=null && partsListTemp.size() > 0)
                    delete partsListTemp;
                List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where Job_Order__c =: JobId and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);
                if(srtsListTemp != null && srtsListTemp.size() > 0)
                    delete srtsListTemp;                    
                delete solCompListTemp;
                system.debug('solCompListTemp'+solCompListTemp);
            }
            if(solCompList !=null && solCompList.size() > 0){
                system.debug('solCompList>>>'+solCompList);
                insert solCompList;
                for(CSS_Solution_Component__c sc : solCompList) {
                    CampaignsWrapperList.add(new CampaignsWrapper(JobId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
                }
            }
            for(CSS_Solution_Component__c campObj : solCompList){
                for(CSS_Parts_Options__c partObj : wsDataMap.get(campObj.Component_Id__c)){
                    partObj.FailurepartId__c = campObj.Id;
                    allPartsOptionList.add(partObj);
                }
            }
            //Commenting Parts Delete as part of story 190513 & Implemented Parts Delete when Field Actions unselected
            //if(allPartsOptionList !=null && allPartsOptionList.size() > 0) 
                //insert allPartsOptionList;
            
            system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
            system.debug('START QUEUEABLE SOLUTION COMPONENT');
           system.debug('CampaignsWrapperList ' + CampaignsWrapperList);
            ID jobIDs = System.enqueueJob(new CG_ServiceJobQueueable(CampaignsWrapperList));
            System.debug('END QUEUEABLE SOLUTION COMPONENT');
            system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );


        }catch(Exception ex){
            System.debug('in catch of callGetCampaignsWS of CG_BL_Campaigns >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{

        }
        return resWrapper;
    }
    
    
    public static CG_OP_OAGWrapper callGetCampaignsWSforClaims(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, Id ClaimId){
        system.debug('entered into CG_BL_Campaigns callGetCampaignsWS esn>>>:'+esn);
        
        CG_OP_OAGWrapper resWrapper = null;
        try{
            //Call service Layer to make Webservice Call
            system.debug('in CG_BL_Campaigns before calling callGetCampaignsWS esn>>>:'+esn);
            resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDate, region, territory, senderID, serviceName, messageID, target);
            system.debug('****resWrapper****'+resWrapper);
             //185628 start
            system.debug('****ClaimId****'+ClaimId);
            CSS_Claims__c claimsRecord = new CSS_Claims__c();
            claimsRecord = [SELECT Id,Name FROM CSS_Claims__c  WHERE Id =: ClaimId];
            system.debug('***claimsRecord**'+claimsRecord.name);
            system.debug('****resWrapper******'+resWrapper);
            HttpResponse httpRes = resWrapper.response;
            system.debug('****httpRes****'+httpRes);
            string exceptionMessage = resWrapper.exceptionMessage;
            system.debug('***exceptionMessage***'+exceptionMessage);
            //system.debug('***httpRes.getStatusCode()***'+httpRes.getStatusCode());
            list<string> resReqBody;
            if(exceptionMessage!=null){
                resReqBody=exceptionMessage.split('---');
            }
            list<CSS_Integration_Error__c> lstIntDetails1 = new list<CSS_Integration_Error__c>();
            if(httpRes == null || httpRes.getStatusCode() != 200){ 
                if(!exceptionMessage.contains('200') || httpRes.getStatusCode()!=200){
                    system.debug('***Going to insert a record into CSS_Integration_Error__c when web service is down from claim****');
                    CSS_Integration_Error__c intDetails1  = new CSS_Integration_Error__c();
                        intDetails1.Auth_Call_Time__c     = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
                        intDetails1.Processed_Data__c     =  resReqBody[2];
                        intDetails1.Response_Body__c      = resReqBody[1];
                        intDetails1.Service_Call_Time__c  = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
                        intDetails1.Service_Job_Number__c = claimsRecord.name;
                        intDetails1.Service_Name__c       = 'GetFieldActions/Campaigns';
                        intDetails1.Source__c             = 'campaignClaim';                
                      lstIntDetails1.add(intDetails1);
                }
            }
            if(lstIntDetails1!=null && lstIntDetails1.size()>0){
                system.debug('**insert a record into CSS_Integration_Error__c object when lstIntDetails size morethen Zero**');
                insert lstIntDetails1;
            }
     //185628 end
            //system.debug('ResBody>>>:'+resWrapper.response.getBody());
            //System.debug('#####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            CG_OP_CampaignsResJSON outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            system.debug('outputRes**'+outputRes);
            list<CampaignsWrapper> CampaignsWrapperList = new list<CampaignsWrapper>();
            CSS_Claims__c  claimsRec = new CSS_Claims__c(); 
            CSS_PSN__c  psnRec = new CSS_PSN__c();
            
            system.debug('****outputRes.DataArea****'+outputRes.DataArea);
            if(outputRes.DataArea != null){
                system.debug('outputRes.DataArea ' + outputRes.DataArea);
                List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
                List<CSS_Parts_Options__c> partsOptionList;
                Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: 'Parts'].Id;
                Map<String,List<CSS_Parts_Options__c>> wsDataMap = new Map<String,List<CSS_Parts_Options__c>>();
                
                claimsRec =[Select Id,Location_Code__c,ReconEngineFlag__c,Name, ESN__c,createdDate,Region__c,Territory__c, 
                            (Select Id,Name,PSN__c,Application__c,ApplicationCode__c,Failure_Date__c,Mileage_Measure__c,
                             Warranty_Start_Date__c,Product_Hours__c,Mileage__c,Failure_Point__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                            from CSS_Claims__c where id= :ClaimId];
                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);}
                system.debug('claimsRec'+claimsRec);
                
                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    //Added below condition as per story 118800
                    system.debug('det.Status ' + det.Status);
                    //Here check Siebel Campaigns are meeting required criteria
                    if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                        continue;
                    if(det.Status == 'Approved' ){
                        CSS_Solution_Component__c campaignComp = new CSS_Solution_Component__c();
                        if(det.InShopSrtLimitFlag == 'Y')
                            campaignComp.In_Shop_SRT_Limit_Flag__c = true;
                        else
                            campaignComp.In_Shop_SRT_Limit_Flag__c = false;
                        campaignComp.Campaign_Description__c = det.CampaignDesc; 
                        if(det.CampaignEndDate != null && det.CampaignEndDate != '')
                            campaignComp.Campaign_End_Date__c = date.valueof(det.CampaignEndDate);
                        if(det.CampaignStartDate != null && det.CampaignStartDate != '')
                            campaignComp.Campaign_Start_Date__c = date.valueof(det.CampaignStartDate);
                        if(det.CampaignNumber != null)
                            campaignComp.Component_Id__c = string.valueof(det.CampaignNumber);
                        campaignComp.Failure_Mode__c = det.FailMode;
                        if(det.FailCode != null && det.FailCode != ''){
                            campaignComp.System_Code__c = (det.FailCode).substring(0,2);
                            campaignComp.Component_Code__c = (det.FailCode).substring(2);
                        }
                        //Uncommented as part of defect fix - 165273
                        //campaignComp.Selected_Component__c = true;
                        campaignComp.Status__c = det.Status;
                        if(det.MultipleTimes == 'Y')
                            campaignComp.Multiple_Times__c = true;
                        else
                            campaignComp.Multiple_Times__c = false;
                        campaignComp.Business_Unit__c = det.BusinessUnit;
                        campaignComp.Type__c = det.CampaignType;
                        campaignComp.Name = det.CampaignType+' '+det.CampaignNumber;
                        campaignComp.Status__c = det.Status;
                        if(det.CompleteIndicator == 'Y')
                            campaignComp.Complete_Indicator__c = true;
                        else
                            campaignComp.Complete_Indicator__c = false;
                        //campaignComp.Service_Job__c = JobId;     
                        campaignComp.css_claims__c = ClaimId; 

                        //calling detail coverage as per story 184437 to check coverage before fieldaction insert

                        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                       // comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', rJobOrd.ReconEngineFlag__c, false);
                        if(psnRec.ApplicationCode__c=='130' || psnRec.ApplicationCode__c=='210' || psnRec.ApplicationCode__c=='220' || psnRec.ApplicationCode__c=='310' || psnRec.ApplicationCode__c=='320' || psnRec.ApplicationCode__c=='410'){
                            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,String.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', claimsRec.ReconEngineFlag__c,false,claimsRec.Name);
                        }else{
                            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,String.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', claimsRec.ReconEngineFlag__c,false,claimsRec.Name);// karthik G sending Hours and product hours based on application code as part of defect #191326
                        }
                        System.debug('comp****' + comp);
                        system.debug('comp.AccountCode__c'+comp.AccountCode__c);
                        if(comp.AccountCode__c!=null && comp.AccountCode__c!=''){
                            solCompList.add(campaignComp);
                            system.debug('campaignComp ' + campaignComp);
                        }
                        //insert campaignComp; 

                        partsOptionList = new List<CSS_Parts_Options__c>();
                        if(det.PartList != null){
                            for(CG_OP_CampaignsResJSON.PartList partlst : det.PartList){
                                CSS_Parts_Options__c campaignPart = new CSS_Parts_Options__c();
                                campaignPart.Quantity__c = partlst.PartQuantity;
                                campaignPart.BMS_Quantity__c = partlst.PartQuantity;
                                if(partlst.PartNumber != null)
                                    campaignPart.Service_partnumber__c = string.valueof(partlst.PartNumber);
                                campaignPart.Part_Name__c = partlst.PartDescription;
                                campaignPart.Part_Description__c = partlst.PartDescription;
                                campaignPart.FailurepartId__c = campaignComp.Id;
                                //campaignPart.Service_Job__c = JobId;
                                campaignPart.css_claims__c = ClaimId;
                                campaignPart.Replacement_Reason__c = 'Campaign-TRP-ATC';
                                campaignPart.RecordTypeId = recTypeId;
                                campaignPart.selected_part__c = false;
                                partsOptionList.add(campaignPart);
                            }
                        }
                        wsDataMap.put(campaignComp.Component_Id__c, partsOptionList);
                    }
                }

                //Delete old saved solution comp & parts data for the job
                List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>([Select Id from CSS_Solution_Component__c where css_claims__c=:ClaimId and Type__c in ('CAMPAIGN','TRP','ATC')]);                

                if(solCompListTemp !=null && solCompListTemp.size()>0){
                    List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>([Select Id, Name from CSS_Parts_Options__c where CSS_Claims__c=:ClaimId and RecordTypeId=:recTypeId and FailurepartId__c in :solCompListTemp]);                     
                    System.debug('partsListTemp>>>:'+partsListTemp);
                    if(partsListTemp !=null && partsListTemp.size() > 0)
                        delete partsListTemp; 
                    //story 166107
                    List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where CSS_Claims__c =: ClaimId and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);
                    if(srtsListTemp != null && srtsListTemp.size() > 0)
                        delete srtsListTemp; 
                    delete solCompListTemp;
                }

                if(solCompList !=null && solCompList.size() > 0){
                    insert solCompList;
                    for(CSS_Solution_Component__c sc : solCompList) {
                        CampaignsWrapperList.add(new CampaignsWrapper(ClaimId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
                    }
                }
                system.debug('solCompList'+solCompList.size());

                List<CSS_Parts_Options__c> allPartsOptionList = new List<CSS_Parts_Options__c>();
                for(CSS_Solution_Component__c campObj : solCompList){
                    for(CSS_Parts_Options__c partObj : wsDataMap.get(campObj.Component_Id__c)){
                        partObj.FailurepartId__c = campObj.Id;
                        allPartsOptionList.add(partObj);
                    }
                }

                //if(allPartsOptionList !=null && allPartsOptionList.size() > 0) //Commented here since call out is again made on selection in F&C page
                //insert allPartsOptionList;

                

                system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
                system.debug('START QUEUEABLE SOLUTION COMPONENT');
                //getAccountCodes(JobId,campaignComp.System_Code__c,campaignComp.Component_Code__c,campaignComp.Id,campaignComp.Component_Id__c);
                //ID jobIDs = System.enqueueJob(new CG_ServiceJobQueueable(JobId,campaignComp.System_Code__c,campaignComp.Component_Code__c,campaignComp.Id,campaignComp.Component_Id__c));
                system.debug('Claims**CampaignsWrapperList ' + CampaignsWrapperList);
                ID jobIDs = System.enqueueJob(new CG_ClaimsQueueable(CampaignsWrapperList));
                //System.debug('jobIDs ' + jobIDs);
                System.debug('END QUEUEABLE SOLUTION COMPONENT');
                system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );

            }                        


        }catch(Exception ex){
            System.debug('in catch of callGetCampaignsWS of CG_BL_Campaigns >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{

        }
        return resWrapper;
    }
    //CG_OP_OAGWrapper
    public static HttpResponse callGetCampaignsWSforClaimsRetrigger(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, Id ClaimId){
        system.debug('entered into CG_BL_Campaigns callGetCampaignsWSforClaimsRetrigger esn>>>:'+esn);
        
        CG_OP_OAGWrapper resWrapper = null;
        try{
            //Call service Layer to make Webservice Call
            system.debug('in CG_BL_Campaigns before calling callGetCampaignsWS esn>>>:'+esn);
            resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDate, region, territory, senderID, serviceName, messageID, target);
            system.debug('****resWrapper****'+resWrapper);
            system.debug('****ClaimId****'+ClaimId);
            CSS_Claims__c claimsRecord = new CSS_Claims__c();
            claimsRecord = [SELECT Id,Name FROM CSS_Claims__c  WHERE Id =: ClaimId];
            system.debug('***claimsRecord**'+claimsRecord.name);
            system.debug('****resWrapper******'+resWrapper);
            HttpResponse httpRes = resWrapper.response;
            system.debug('****httpRes****'+httpRes);
            string exceptionMessage = resWrapper.exceptionMessage;
            system.debug('***exceptionMessage***'+exceptionMessage);
            list<string> resReqBody;
            if(exceptionMessage!=null){
                resReqBody=exceptionMessage.split('---');
            }
            list<CSS_Integration_Error__c> lstIntDetails1 = new list<CSS_Integration_Error__c>();
            if(httpRes == null || httpRes.getStatusCode() != 200){ 
                if(!exceptionMessage.contains('200') || httpRes.getStatusCode()!=200){
                    system.debug('***Going to insert a record into CSS_Integration_Error__c when web service is down from claim****');
                    CSS_Integration_Error__c intDetails1  = new CSS_Integration_Error__c();
                        intDetails1.Auth_Call_Time__c     = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
                        intDetails1.Processed_Data__c     =  resReqBody[2];
                        intDetails1.Response_Body__c      = resReqBody[1];
                        intDetails1.Service_Call_Time__c  = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
                        intDetails1.Service_Job_Number__c = claimsRecord.name;
                        intDetails1.Service_Name__c       = 'GetFieldActions/Campaigns';
                        intDetails1.Source__c             = 'campaignClaim';                
                      lstIntDetails1.add(intDetails1);
                }
            }
            if(lstIntDetails1!=null && lstIntDetails1.size()>0){
                system.debug('**insert a record into CSS_Integration_Error__c object when lstIntDetails size morethen Zero**');
                insert lstIntDetails1;
            }
        }catch(Exception ex){
            System.debug('in catch of callGetCampaignsWS of CG_BL_Campaigns >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{

        }
        return resWrapper.response;
    }
    
    public static void callPSNAfterInsert(List<CSS_PSN__c> newList){
        try{
            system.debug('in callPSNAfterInsert method...newList>>:'+newList);
            for( CSS_PSN__c PsnRec: newList) {
                if(PsnRec.css_claims__c !=null && PsnRec.psn__c !=null && PsnRec.Failure_Date__c !=null){
                    CSS_Claims__c claimRec = [select Id, Name, Region__c, CSS_Job__c, Dealer_Service_Job__c,IsCopyclaim__c from CSS_Claims__c where Id=:PsnRec.CSS_Claims__c];
                    if(claimRec.CSS_Job__c !=null ){
                        return;
                    }
                    system.debug('in callPSNAfterInsert  PsnRec.PSN__c>>>:'+PsnRec.PSN__c+' PsnRec.Failure_Date__c>>>:'+PsnRec.Failure_Date__c+' claimRec.Region__c>>>:'+claimRec.Region__c);
                    //Insert records into CampTsbTrp Object with claim id - START
                    User u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
                    CSS_accountLanguage__c aLan = css_utility.getLanguage(u3.LanguageLocaleKey);
                    system.debug('userinfo.getUserid**'+userinfo.getUserId());
                    system.debug('User**'+u3);
                    system.debug('aLan**'+aLan);
                    system.debug('aLan**'+aLan.CSS_QsolLanguage__c);
                    //list for Campaigns to insert.

                    CSS_QuickServe.getQsolDocSaveforClaims(PsnRec.css_claims__c,PsnRec.pSN__c, aLan.CSS_QsolLanguage__c);
                    System.debug('in insert $$$$$$$$...'+PsnRec.Failure_Date__c);
                    string FailureDateString;
                    //if(PsnRec.Failure_Date__c != null){
                    System.debug('in insert before calling $$$$$$$$...');
                    FailureDateString = DateTime.newInstance(PsnRec.Failure_Date__c.year(),PsnRec.Failure_Date__c.month(),PsnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                    if(claimRec.Dealer_Service_Job__c == null && claimRec.CSS_Job__c == null && !claimRec.IsCopyclaim__c){
                        CG_BL_Campaigns.callGetCampaignsWebServiceforClaims(PsnRec.PSN__c, FailureDateString, claimRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', PsnRec.CSS_Claims__c);
                    }
                }
            }//End of FOR
        }catch(Exception ex){
            System.debug('in catch of callPSNAfterInsert of CG_BL_Campaigns >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }
    public static void callPSNAfterUpdate(List<CSS_PSN__c> newList,Map<id,CSS_PSN__c> oldMap){
        try{
            system.debug('in callPSNAfterUpdate method...newList>>:'+newList+' oldMap>>:'+oldMap);
            list<CSS_CampTsbTrp__c> campListToInsert = new list<CSS_CampTsbTrp__c>();
            set<string> oldEsnNums = new set<string>();
            set<Id> jobIds = new set<Id>();
            for( css_psn__c PsnRec: newList) {
                //Added condition of Mileage__c,Product_Hours__c,Application__c for the story#189951
                if(PsnRec.PSN__c!=oldMap.get(PsnRec.Id).PSN__c || PsnRec.Failure_Date__c!=oldMap.get(PsnRec.Id).Failure_Date__c || PsnRec.Mileage__c!=oldMap.get(PsnRec.Id).Mileage__c || PsnRec.ApplicationCode__c!=oldMap.get(PsnRec.Id).ApplicationCode__c || PsnRec.Mileage_Measure__c!=oldMap.get(PsnRec.Id).Mileage_Measure__c || PsnRec.Product_Hours__c!=oldMap.get(PsnRec.Id).Product_Hours__c) {
                    CSS_Claims__c claimRec = [select Id, Name, Region__c, CSS_Job__c, IsCopyclaim__c from CSS_Claims__c where Id=:PsnRec.CSS_Claims__c];
                    system.debug('in callPSNAfterUpdate PsnRec.PSN__c>>>:'+PsnRec.PSN__c+' PsnRec.Failure_Date__c>>>:'+PsnRec.Failure_Date__c+' claimRec.Region__c>>>:'+claimRec.Region__c);
                    if(PsnRec.Failure_Date__c != null && !claimRec.IsCopyclaim__c){
                        User u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
                        CSS_accountLanguage__c aLan = css_utility.getLanguage(u3.LanguageLocaleKey);

                        CSS_QuickServe.getQsolDocSaveforClaims(PsnRec.css_claims__c,PsnRec.pSN__c, aLan.CSS_QsolLanguage__c);

                        System.debug('in update $$$$$$$$...'+PsnRec.Failure_Date__c);
                        string FailureDateString;
                        System.debug('in update before calling $$$$$$$$...');
                        FailureDateString = DateTime.newInstance(PsnRec.Failure_Date__c.year(),PsnRec.Failure_Date__c.month(),PsnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                        CG_BL_Campaigns.callGetCampaignsWebServiceforClaims(PsnRec.PSN__c, FailureDateString, claimRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', PsnRec.CSS_Claims__c);
                    }
                }
                if(PsnRec.psn__c!=null && PsnRec.psn__c != oldMap.get(PsnRec.Id).psn__c){
                    System.debug('The id is'+PsnRec.Id);
                    //esnNums.add(cjb.esn__c);
                    if(oldMap.get(PsnRec.Id).psn__c != null){
                        oldEsnNums.add(oldMap.get(PsnRec.Id).psn__c);
                    }                
                    jobIds.add(PsnRec.Id);
                }else if(PsnRec.psn__c==null){
                    jobIds.add(PsnRec.Id);
                }      
            }

            if(jobIds != null && !jobIds.isEmpty() && oldEsnNums != null && !oldEsnNums.isEmpty()){
                system.debug('Deleting***');
                list<CSS_CampTsbTrp__c> campTsTrList = [Select Id from CSS_CampTsbTrp__c where css_claims__c IN :jobIds and ESN__c IN :oldEsnNums];
                if(campTsTrList != null && !campTsTrList.isEmpty()){
                    delete campTsTrList;
                }

            }
        }catch(Exception ex){
            System.debug('in catch of callPSNAfterUpdate of CG_BL_Campaigns >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }

    @future(callout=true)
    public static void callGetCampaignsWebService(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, String JobNumber, Id JobId){
        System.debug('END QUEUEABLE SOLUTION COMPONENT');
        callGetCampaignsWS(esn, failureDate, region, territory, senderID, serviceName, messageID, target, JobNumber, JobId);
    }
    
    //Immediate call method of above method to call on chevron change from Job to retrigger the service
    public static void callGetCampaignsWebServiceOnChevronChangeJob(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, String JobNumber, Id JobId){
        callGetCampaignsWS(esn, failureDate, region, territory, senderID, serviceName, messageID, target, JobNumber, JobId);
    }

    @future(callout=true)
    public static void callGetCampaignsWebServiceforClaims(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target,Id ClaimId){
        System.debug('END QUEUEABLE SOLUTION COMPONENT');
        callGetCampaignsWSforClaims(esn, failureDate, region, territory, senderID, serviceName, messageID, target, ClaimId);
    }
    
    //Immediate call method of above method to call on chevron change from Job to retrigger the service
    public static String callGetCampaignsWebServiceforClaimsOnChevronChangeClaim(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target,Id ClaimId){
        CG_OP_OAGWrapper resWrapper = callGetCampaignsWSforClaims(esn, failureDate, region, territory, senderID, serviceName, messageID, target, ClaimId);
        HttpResponse httpRes = resWrapper.response;
        system.debug('****httpRes****'+httpRes);
        String returnVal = '';
		if(httpRes == null || httpRes.getStatusCode() != 200){
		    returnVal = 'Error';
		}
		else if(httpRes != null && httpRes.getStatusCode() == 200){
		    returnVal = 'Success';
		}
		return returnVal;
    }


    @Future(callout=true)
    public static void getAccountCodes(Id jobId, String sysCode, String compCode, Id compId, String campNum){
        system.debug('enetered into first getaccmethod');
        CSS_Job_Order__c rJobOrd = new CSS_Job_Order__c();
        rJobOrd = [SELECT Id,Name,CSS_Hours__c, ESN__c, ReconEngineFlag__c, Creator_Location__c, Failure_Date__c, Mileage__c, Mileage_Measure__c, ApplicationCode__c, Warranty_Start_Date__c FROM CSS_Job_Order__c WHERE Id =: jobId];
        system.debug('jobId**'+jobId);
        system.debug('rJobOrd**'+rJobOrd);
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();

        //  comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,sysCode,compCode,'','',compId,true,campNum,'','Second Call', rJobOrd.ReconEngineFlag__c, false);    


        if(rJobOrd.ApplicationCode__c=='130' || rJobOrd.ApplicationCode__c=='210' || rJobOrd.ApplicationCode__c=='220' || rJobOrd.ApplicationCode__c=='310' || rJobOrd.ApplicationCode__c=='320' || rJobOrd.ApplicationCode__c=='410'){
            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,sysCode,compCode,'','',compId,true,campNum,'','Second Call', rJobOrd.ReconEngineFlag__c, false,rJobOrd.Name);    
        }
        else{
            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.CSS_Hours__c),'Hours',rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,sysCode,compCode,'','',compId,true,campNum,'','Second Call', rJobOrd.ReconEngineFlag__c, false,rJobOrd.Name);
        }






        System.debug('comp****' + comp);
        //comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,sysCode,compCode,'','',compId,true,campNum,'','Second Call', rJobOrd.ReconEngineFlag__c, false);
        if(comp != null)
            update comp;
    }

    @Future(callout=true)
    public static void getAccountCodes(string temp){
        try {
            system.debug('enteredintogetaccodesmethod');
            List<CampaignsWrapper> srtCompWrapper_lst = new List<CampaignsWrapper>();
            srtCompWrapper_lst = (List<CampaignsWrapper>)JSON.deserializeStrict(temp,List<CampaignsWrapper>.class); 
            @TestVisible
            Id jobId;
            jobId = srtCompWrapper_lst[0].jobId;
            //for(CampaignsWrapper compWrap:srtCompWrapper_lst)
                //jobId = compWrap.jobId;

            CSS_Job_Order__c rJobOrd = new CSS_Job_Order__c();
            rJobOrd = [SELECT Id, ESN__c, Name, ReconEngineFlag__c, Creator_Location__c, Failure_Date__c, Mileage__c, CSS_Hours__c, Mileage_Measure__c, ApplicationCode__c, Warranty_Start_Date__c FROM CSS_Job_Order__c WHERE Id =: jobId];
            system.debug('jobId**'+jobId);
            system.debug('rJobOrd**'+rJobOrd);
         

            List<CSS_Solution_Component__c> compListUpd = new List<CSS_Solution_Component__c>();
            for(CampaignsWrapper compWrap:srtCompWrapper_lst) {
                CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                // comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','',compWrap.compId,false,compWrap.campNum,'','Second Call', rJobOrd.ReconEngineFlag__c, false); 
                if(rJobOrd.ApplicationCode__c=='130' || rJobOrd.ApplicationCode__c=='210' || rJobOrd.ApplicationCode__c=='220' || rJobOrd.ApplicationCode__c=='310' || rJobOrd.ApplicationCode__c=='320' || rJobOrd.ApplicationCode__c=='410'){
                    comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','',compWrap.compId,false,compWrap.campNum,'','Second Call', rJobOrd.ReconEngineFlag__c, false,rJobOrd.Name); 
                }
                else{
                    comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.CSS_Hours__c),'Hours',rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','',compWrap.compId,false,compWrap.campNum,'','Second Call', rJobOrd.ReconEngineFlag__c, false,rJobOrd.Name); 
                }
                system.debug('comp-->'+comp);
                if(comp != null)
                    compListUpd.add(comp);  
            }
            if(compListUpd != null && compListUpd.size()>0)
                update compListUpd;
            
            system.debug('compListUpd-->'+compListUpd);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Campaigns getAccountCodes method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }            
    }

    @Future(callout=true)
    public static void getAccountCodesforClaims(string temp){
        try {
            system.debug('getaccountcodeclaims>>>>');
            List<CampaignsWrapper> srtCompWrapper_lst = new List<CampaignsWrapper>();
            srtCompWrapper_lst = (List<CampaignsWrapper>)JSON.deserializeStrict(temp,List<CampaignsWrapper>.class); 
            @TestVisible
            Id claimid;
            for(CampaignsWrapper compWrap:srtCompWrapper_lst)
                claimid = compWrap.jobId;

            css_psn__C rJobOrd = new css_psn__c();
            rJobOrd = [SELECT Id, Name, PSN__c, Product_Hours__c, Failure_Date__c, css_claims__r.Name, ApplicationCode__c,css_claims__r.Information_Only_Claim__c, css_claims__r.ReconEngineFlag__c,Mileage__c, Mileage_Measure__c, Application__c, Warranty_Start_Date__c FROM css_psn__c WHERE css_claims__c =: claimid and Primary__c=true limit 1];
            //css_claims__C ClaimRec = new css_claims__C();
            string CreatorLocation = [select id,location_code__c from css_claims__C where id = :claimId].location_code__C;

            system.debug('claimid**'+claimid);
            system.debug('rJobOrd**'+rJobOrd);
            system.debug('CreatorLocation**'+CreatorLocation);

            List<CSS_Solution_Component__c> compListUpd = new List<CSS_Solution_Component__c>();
            for(CampaignsWrapper compWrap:srtCompWrapper_lst) {
                CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                //Boolean compParentChkbox; 
                //System.debug('compParentChkbox>>>>:'+compParentChkbox);
                if(rJobOrd.css_claims__r.ReconEngineFlag__c=='Y'){

                    if(rJobOrd.ApplicationCode__c=='130' || rJobOrd.ApplicationCode__c=='210' || rJobOrd.ApplicationCode__c=='220' || rJobOrd.ApplicationCode__c=='310' || rJobOrd.ApplicationCode__c=='320' || rJobOrd.ApplicationCode__c=='410'){
                        comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.PSN__c,CreatorLocation.right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','98',compWrap.compId,compWrap.selComp,compWrap.campNum,'','Second Call', '',true,rJobOrd.css_claims__r.Name);
                    }
                    else{
                        comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.PSN__c,CreatorLocation.right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Product_Hours__c),'Hours',rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','98',compWrap.compId,compWrap.selComp,compWrap.campNum,'','Second Call', '',true,rJobOrd.css_claims__r.Name);
                    }
                    system.debug('compWrap.compId'+compWrap.compId);
                    system.debug(' compWrap.selComp'+ compWrap.selComp);
                }
                else{
                    if(rJobOrd.ApplicationCode__c=='130' || rJobOrd.ApplicationCode__c=='210' || rJobOrd.ApplicationCode__c=='220' || rJobOrd.ApplicationCode__c=='310' || rJobOrd.ApplicationCode__c=='320' || rJobOrd.ApplicationCode__c=='410'){
                        comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.PSN__c,CreatorLocation.right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','',compWrap.compId,compWrap.selComp,compWrap.campNum,'','Second Call', '',true,rJobOrd.css_claims__r.Name);
                    }
                    else{
                        comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.PSN__c,CreatorLocation.right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Product_Hours__c),'Hours',rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','',compWrap.compId,compWrap.selComp,compWrap.campNum,'','Second Call', '',true,rJobOrd.css_claims__r.Name);
                    }
                    system.debug('compWrap.compId'+compWrap.compId);
                    system.debug(' compWrap.selComp'+ compWrap.selComp);


                    //comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(rJobOrd.PSN__c,CreatorLocation.right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,compWrap.sysCode,compWrap.compCode,'','',compWrap.compId,compWrap.selComp,compWrap.campNum,'','Second Call', '',true);
                }
                system.debug('WarrantyCoverageOP**'+comp);
                if(comp != null){
                    if(rJobOrd.css_claims__r.Information_Only_Claim__c)
                    {
                        comp.Pay_Code__c='A';
                        comp.AccountCode__c ='67';
                        comp.AccountCodeEdit__C ='67';
                    }
                    compListUpd.add(comp);  
                }
            }
            if(compListUpd != null && compListUpd.size()>0)
                update compListUpd;
            system.debug('compListUpd ' + compListUpd);
            Map<Id, string> ComponentAccMap = new Map<Id, string>();
            Map<Id, String> ComponentCoveredMap = new Map<Id, String>();
            if(compListUpd != null && compListUpd.size() > 0) {
                for(CSS_Solution_Component__c comp : compListUpd) {
                    if(comp.AccountCodeEdit__c != null && comp.AccountCodeEdit__c != '')
                        ComponentAccMap.put(comp.Id, comp.AccountCodeEdit__c);
                    if(comp.CampaignPartsPercentage__c != null && comp.CampaignPartsPercentage__c != '')
                        ComponentCoveredMap.put(comp.Id, comp.CampaignPartsPercentage__c);
                }
            }

            list<CSS_Parts_Options__c> partsList = [select Id, Name, Account_Code__c, FailurepartId__c from CSS_Parts_Options__c where FailurepartId__c = : ComponentAccMap.keyset()];
            for(CSS_Parts_Options__c parts : partsList) {
                if(ComponentAccMap != null)
                    parts.Account_Code__c = ComponentAccMap.get(parts.FailurepartId__c);
                if(ComponentCoveredMap != null)
                    parts.Covered__c = decimal.valueof(ComponentCoveredMap.get(parts.FailurepartId__c));
            }

            system.debug('partsList ' + partsList);
            if(partsList != null && partsList.size()>0)
                update partsList;

        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Campaigns getAccountCodes method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }            
    }


    public class CampaignsWrapper {
        public Id jobId; 
        public String sysCode;
        public String compCode; 
        public Id compId; 
        public String campNum;
        public Boolean selComp;
        //public string partsOptions;

        public CampaignsWrapper(Id jobId, String sysCode, String compCode, Id compId, String campNum, Boolean selComp) {
            this.jobId = jobId;
            this.sysCode = sysCode;
            this.compCode = compCode;
            this.compId = compId;
            this.campNum = campNum; 
            this.selComp = selComp;
            //this.partsOptions = partsOptions;
        }
    }

    public static void callFieldActionSRT(List<CSS_Solution_Component__c> solCompList, Id jobID){
        system.debug('***********Inside callFieldActionSRT method**************');
        try{
            CG_FieldActionSRTResponse fieldActionSRTResponse;
            CSS_Job_Order__c servJob = new CSS_Job_Order__c();
            servJob = [Select id, Service_Model__c, Qsol_Engine_Family_Code__c,CSS_Job_Location_Code__c,ESN__c, Region__c, Territory__c, Equipment_ID__c, Failure_Date__c,FieldActionWebServiceResult__c, Name from CSS_Job_Order__c where id=:jobID];
            //Account Regionterritory = css_utility.getRegionTerritory(servJob.CSS_Job_Location_Code__c);
            if(solCompList !=null && solCompList.size() > 0) {
                //Call Field Actions SRT web service to get SRT's
                fieldActionSRTResponse = CSS_FN_SRT.getFieldActionSRT(servJob.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList);
            }

            system.debug('fieldActionSRTResponse--'+fieldActionSRTResponse);            

            List<CSS_SRT__c> lstFASRT = new List<CSS_SRT__c>();
            Map<String,ID> mapCompID = new Map<String,ID>();
            //Fetch id from solution component
            for(CSS_Solution_Component__c solcomp: solCompList){
                mapCompID.put(solcomp.Component_Id__c,solcomp.Id);
            }


            integer sortValue;
            /*if((servJob.Service_Model__c != null && servJob.Service_Model__c !='') && (servJob.Qsol_Engine_Family_Code__c!= null && servJob.Qsol_Engine_Family_Code__c!= '') && (servJob.Equipment_ID__c != null && servJob.Equipment_ID__c!= '') && (fieldActionSRTResponse == null ))
            {
                servJob.FieldActionWebServiceResult__c = 'Error';
                system.debug('servJob.FieldActionWebServiceResult__c*****' + servJob.FieldActionWebServiceResult__c);
            }*/

            //Loop through the web service response and insert into SRT object
            if(fieldActionSRTResponse!=null){
                //servJob.FieldActionWebServiceResult__c = 'Success';
                system.debug('servJob.FieldActionWebServiceResult__c*****' + servJob.FieldActionWebServiceResult__c);
                for(CG_FieldActionSRTResponse.FieldAction d : fieldActionSRTResponse.DataArea.FieldAction){
                    sortValue = 0;
                    for(CG_FieldActionSRTResponse.FieldActionSRTTime s : d.FieldActionSRTTime){
                        if(!(s.SRTDetails.contains('00-901') || s.SRTDetails.contains('00-902') || s.SRTDetails.contains('00-904')))
                        {
                            CSS_SRT__c insertFASRT = new CSS_SRT__c();                        
                            insertFASRT.Component_Id__c = mapCompID.get(d.FieldActionNumber);
                            insertFASRT.Job_Order__c = JobId;
                            insertFASRT.Type__c = 'Field Action';//d.FieldActionType;
                            insertFASRT.SRT_Type__c = d.FieldActionType;
                            insertFASRT.SRT_ID__c = s.SRTDetails;
                            insertFASRT.SRT_Title__c = s.SRTTitle;
                            insertFASRT.SRT_Order__c = sortValue + 1;
                            insertFASRT.Step_Id__c = string.valueof(s.StepID);
                            insertFASRT.Step_Description__c = s.StepDescription;
                            insertFASRT.Access_Code_R__c = s.RTIME;
                            insertFASRT.Access_Code_A__c = s.ATIME;
                            insertFASRT.Access_Code_B__c = s.BTIME;
                            insertFASRT.Access_Code_C__c = s.CTIME;
                            insertFASRT.Access_Code_D__c = s.DTIME;
                            insertFASRT.Access_Code_S1__c = s.S1TIME;
                            insertFASRT.S1_Description__c = s.S1DESCRIPTION;
                            insertFASRT.Access_Code_S2__c = s.S2TIME;
                            insertFASRT.S2_Description__c = s.S2DESCRIPTION;
                            insertFASRT.Access_Code_S3__c = s.S3TIME;
                            insertFASRT.S3_Description__c = s.S3DESCRIPTION;
                            insertFASRT.Access_Code_S4__c = s.S4TIME;
                            insertFASRT.S4_Description__c = s.S4DESCRIPTION;
                            insertFASRT.Access_Code_S5__c = s.S5TIME;
                            insertFASRT.S5_Description__c = s.S5DESCRIPTION;
                            insertFASRT.Access_Code_S6__c = s.S6TIME;
                            insertFASRT.S6_Description__c = s.S6DESCRIPTION;
                            insertFASRT.Access_Code_S7__c = s.S7TIME;
                            insertFASRT.S7_Description__c = s.S7DESCRIPTION;
                            insertFASRT.Access_Code_S8__c = s.S8TIME;
                            insertFASRT.S8_Description__c = s.S8DESCRIPTION;
                            insertFASRT.Access_Code_S9__c = s.S9TIME;
                            insertFASRT.S9_Description__c = s.S9DESCRIPTION;
                            insertFASRT.SRT_Quantity__c = s.SRTQuantity;
                            insertFASRT.SRT_Message__c = s.SRTMessage;
                            insertFASRT.Assignment__c = s.Assignment;
                            insertFASRT.Access_Code__c = s.SRTAccessCode;
                            insertFASRT.SRT_Access_Code__c = s.SRTAccessCode;//Added for the stroy#172627
                            insertFASRT.SRT_Time__c = s.SRTTime;
                            insertFASRT.Quote_ID__c = s.QuoteID;
                            insertFASRT.SRT_Warrantable__c = '100';
                            insertFASRT.SRT_Type__c = d.FieldActionType;  //Kalpana: 10/05/2018: Added to distinguish among the Field Action SRTs, with the type
                            if(s.Assignment.equalsIgnoreCase('PRIMARY')){
                                system.debug('s.Assignment'+s.Assignment);
                                insertFASRT.SRT_Select__c = true;
                                insertFASRT.isPerformed__c = true;
                                system.debug('s.SRT_Select__c'+insertFASRT.SRT_Select__c);
                                system.debug('s.isPerformed__c'+insertFASRT.isPerformed__c);
                            }
                            
                            //Added as part of story - GSSC-125
                            if(s.ECMFlag != null && s.ECMFlag !=''){
                                if(s.ECMFlag == 'Y'){
                                    insertFASRT.ECM_Flag__c = true;
                                    }
                                else{
                                    insertFASRT.ECM_Flag__c = false;
                                    }
                            }
                            
                            lstFASRT.add(insertFASRT);
                        }
                    }
                }
                if(lstFASRT != null && lstFASRT.size() > 0){
                    insert lstFASRT;
                }
            }
            /*if(servJob !=null){
                update servJob;
            }*/
        }
        catch (exception e){
            system.debug('***********Inside catch of callFieldActionSRT method**************error at '+e.getLineNumber()+' with the error '+e.getMessage());
        }
    } 
    //story - 166107
    public static void callFieldActionSRTClaims(List<CSS_Solution_Component__c> solCompList, Id jobID){
        system.debug('***********Inside callFieldActionSRTClaims method**************');
        try{
            CG_FieldActionSRTResponse fieldActionSRTResponse;
            CSS_Claims__c claim = new CSS_Claims__c();
            CSS_PSN__c psn=new CSS_PSN__c();
            claim = [Select id, Service_Model__c,SP_INSHOP_LABOR_RATE__c,Location_Code__c, EngineFamilyCode__c, ESN__c, Region__c, Territory__c,Name from CSS_Claims__c where id=:jobID];
            system.debug('claim-->' + claim);
            psn=[Select id,Service_Model__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,CSS_Claims__c from CSS_PSN__c where CSS_Claims__c =:claim.id];
            system.debug('psn-->' + psn);
            //  Account Regionterritory = css_utility.getRegionTerritory(claim.Location_Code__c);
            if(solCompList !=null && solCompList.size() > 0) {
                //Call Field Actions SRT web service to get SRT's
                fieldActionSRTResponse = CSS_FN_SRT.getFieldActionSRT(psn.Service_Model__c, psn.Qsol_Engine_Family_Code__c, 'en', psn.Equipment_ID__c, solCompList);
            }

            system.debug('fieldActionSRTResponse--'+fieldActionSRTResponse);            

            List<CSS_SRT__c> lstFASRT = new List<CSS_SRT__c>();
            Map<String,ID> mapCompID = new Map<String,ID>();
            Map<String,String> failCodeMap = new Map<String,String>();
            Map<String,String> accountCodeMap = new Map<String,String>();
            //Fetch id from solution component
            for(CSS_Solution_Component__c solcomp: solCompList){
                mapCompID.put(solcomp.Component_Id__c,solcomp.Id);
                if(solcomp.CampaignLaborPercentage__c != null && solcomp.CampaignLaborPercentage__c != '' && integer.valueof(solcomp.CampaignLaborPercentage__c) > 0){
                    failCodeMap.put(solcomp.Component_Id__c,solcomp.FailCode_Formula__c);
                    accountCodeMap.put(solcomp.Component_Id__c,solcomp.CSS_Account_Formula__c);
                }
            }

            integer sortValue;
            String failCode;
            //GSSC-297 - START
            Map<String, String> accCodeFailCodeMap = new Map<String, String>();
            List<CSS_Solution_Component__c> newSolCompLst = new List<CSS_Solution_Component__c>();
            newSolCompLst = [SELECT Id, CSS_Claims__c, Type__c, Fail_Code__c, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c FROM CSS_Solution_Component__c WHERE 
                                        CSS_Claims__c =: jobID AND Type__c IN ('TRP','ATC','Campaign')
                                        AND Fail_Code__c != null AND Fail_Code__c != '' AND Fail_Code__c != 'Select One' AND
                                        CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND CSS_Account_Formula__c != 'Select One' 
                                        ORDER BY CSS_Failure_Sequence_Number__c ASC];
            for(CSS_Solution_Component__c sc : newSolCompLst){
                if(!accCodeFailCodeMap.containsKey(sc.CSS_Account_Formula__c)){
                    accCodeFailCodeMap.put(sc.CSS_Account_Formula__c, sc.Fail_Code__c);
                }
            }
            //GSSC-297 - END
            //Loop through the web service response and insert into SRT object
            if(fieldActionSRTResponse!=null){
                for(CG_FieldActionSRTResponse.FieldAction d : fieldActionSRTResponse.DataArea.FieldAction){
                    sortValue = 0;
                    for(CG_FieldActionSRTResponse.FieldActionSRTTime s : d.FieldActionSRTTime){
                        //if(!(s.SRTDetails.contains('00-901') || s.SRTDetails.contains('00-902') || s.SRTDetails.contains('00-904'))){
                            CSS_SRT__c insertFASRT = new CSS_SRT__c();                        
                            insertFASRT.Component_Id__c = mapCompID.get(d.FieldActionNumber);
                            //GSSC-297 - START
                            String tempFailCode;
                            if(accCodeFailCodeMap != null){
                                tempFailCode = accCodeFailCodeMap.get(accountCodeMap.get(d.FieldActionNumber));
                            }
                            if(tempFailCode != null && tempFailCode != ''){
                                failCode = tempFailCode;
                            }
                            else{ //GSSC-297 - END
                                failCode = failCodeMap.get(d.FieldActionNumber);
                            }
                            insertFASRT.FailCode__c = (failCode != null && failCode != '' ? failCode.trim().right(6) : '');
                            insertFASRT.Account_Code__c = (claim.SP_INSHOP_LABOR_RATE__c != null && claim.SP_INSHOP_LABOR_RATE__c != '0' && claim.SP_INSHOP_LABOR_RATE__c != '' ? accountCodeMap.get(d.FieldActionNumber) : '');
                            insertFASRT.CSS_Claims__c = JobId;
                            insertFASRT.Type__c = 'Field Action';//d.FieldActionType;
                            insertFASRT.SRT_Type__c = d.FieldActionType;
                            insertFASRT.SRT_ID__c = s.SRTDetails;
                            insertFASRT.SRT_Title__c = s.SRTTitle;
                            insertFASRT.SRT_Order__c = sortValue + 1;
                            insertFASRT.Step_Id__c = string.valueof(s.StepID);
                            insertFASRT.Step_Description__c = s.StepDescription;
                            insertFASRT.Access_Code_R__c = s.RTIME;
                            insertFASRT.Access_Code_A__c = s.ATIME;
                            insertFASRT.Access_Code_B__c = s.BTIME;
                            insertFASRT.Access_Code_C__c = s.CTIME;
                            insertFASRT.Access_Code_D__c = s.DTIME;
                            insertFASRT.Access_Code_S1__c = s.S1TIME;
                            insertFASRT.S1_Description__c = s.S1DESCRIPTION;
                            insertFASRT.Access_Code_S2__c = s.S2TIME;
                            insertFASRT.S2_Description__c = s.S2DESCRIPTION;
                            insertFASRT.Access_Code_S3__c = s.S3TIME;
                            insertFASRT.S3_Description__c = s.S3DESCRIPTION;
                            insertFASRT.Access_Code_S4__c = s.S4TIME;
                            insertFASRT.S4_Description__c = s.S4DESCRIPTION;
                            insertFASRT.Access_Code_S5__c = s.S5TIME;
                            insertFASRT.S5_Description__c = s.S5DESCRIPTION;
                            insertFASRT.Access_Code_S6__c = s.S6TIME;
                            insertFASRT.S6_Description__c = s.S6DESCRIPTION;
                            insertFASRT.Access_Code_S7__c = s.S7TIME;
                            insertFASRT.S7_Description__c = s.S7DESCRIPTION;
                            insertFASRT.Access_Code_S8__c = s.S8TIME;
                            insertFASRT.S8_Description__c = s.S8DESCRIPTION;
                            insertFASRT.Access_Code_S9__c = s.S9TIME;
                            insertFASRT.S9_Description__c = s.S9DESCRIPTION;
                            insertFASRT.SRT_Quantity__c = s.SRTQuantity;
                            insertFASRT.SRT_Message__c = s.SRTMessage;
                            if((s.SRTDetails.contains('00-901') || s.SRTDetails.contains('00-902') || s.SRTDetails.contains('00-904'))){
                                if(s.Assignment == 'NOT CLAIMABLE'){
                                    insertFASRT.Assignment__c = s.Assignment;
                                }
                                else{
                                    insertFASRT.Assignment__c = 'UNLISTED'; //Defaulting to UNLISTED to not display GSQ admin SRTs front end and not to include in any calculations
                                    s.Assignment = 'UNLISTED';
                                }
                                
                            }
                            else{
                                insertFASRT.Assignment__c = s.Assignment;
                            }
                            insertFASRT.Access_Code__c = s.SRTAccessCode;
                            insertFASRT.SRT_Access_Code__c = s.SRTAccessCode;//Added for the story#172627
                            insertFASRT.SRT_Time__c = s.SRTTime;
                            insertFASRT.Quote_ID__c = s.QuoteID;
                            insertFASRT.SRT_Warrantable__c = '100';
                            insertFASRT.SRT_Type__c = d.FieldActionType;  //Kalpana: 10/05/2018: Added to distinguish among the Field Action SRTs, with the type
                            if(s.Assignment.equalsIgnoreCase('PRIMARY')){
                                insertFASRT.SRT_Select__c = true;
                                insertFASRT.isPerformed__c=true;
                            }
                            //Added as part of story - GSSC-125
                            if(s.ECMFlag != null && s.ECMFlag !=''){
                                if(s.ECMFlag == 'Y'){
                                    insertFASRT.ECM_Flag__c = true;
                                    }
                                else{
                                    insertFASRT.ECM_Flag__c = false;
                                    }
                            }
                            lstFASRT.add(insertFASRT);
                        //}
                    }
                }
                if(lstFASRT != null && lstFASRT.size() > 0){
                    insert lstFASRT;
                }
            }
        }
        catch (exception e){
            system.debug('***********Inside catch of callFieldActionSRT method**************error at '+e.getLineNumber()+' with the error '+e.getMessage());
        }
    } 
    //Added additional parameter NonSelFieldActNumSet as part of the defect #189704
    public static CG_OP_OAGWrapper callGetCampaignsWSforClaimsonReselect(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, Id ClaimId,Set<String> FieldActNumSet, Set<String> NonSelFieldActNumSet){
        system.debug('entered into CG_BL_Campaigns callGetCampaignsWS esn>>>:'+esn);
        CG_OP_OAGWrapper resWrapper = null;
        List<CSS_Solution_Component__c> newSelectedSC = new List<CSS_Solution_Component__c>();
        CSS_Claims__c claimRec = new CSS_Claims__c();
        claimRec = [SELECT Id,FieldActionWebServiceResult__c FROM CSS_Claims__c WHERE Id =: ClaimId];
        try{
            system.debug('FieldActNumSet**'+FieldActNumSet);
            //Call service Layer to make Webservice Call
            system.debug('in CG_BL_Campaigns before calling callGetCampaignsWS esn>>>:'+esn);
            resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDate, region, territory, senderID, serviceName, messageID, target);
            system.debug('resWrapper>>>:'+resWrapper);
            HttpResponse httpRes = resWrapper.response;
            system.debug('httpRes--'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                if(claimRec!=null){
                    claimRec.FieldActionWebServiceResult__c='Error';
                    system.debug('Inside Camperror');
                }
                else{
                    claimRec.FieldActionWebServiceResult__c='Success';
                    system.debug('Inside campSuccess');
                }
            }
            
            //system.debug('ResBody>>>:'+resWrapper.response.getBody());
            //System.debug('#####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            CG_OP_CampaignsResJSON outputRes;
            if(resWrapper!=null && resWrapper.response != null)
                outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            system.debug('outputRes**'+outputRes);

            if(outputRes!=null && outputRes.DataArea != null){
                system.debug('outputRes.DataArea ' + outputRes.DataArea);
                List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
                List<CSS_Parts_Options__c> partsOptionList;
                Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: 'Parts'].Id;
                Map<String,List<CSS_Parts_Options__c>> wsDataMap = new Map<String,List<CSS_Parts_Options__c>>();
                list<CampaignsWrapper> CampaignsWrapperList = new list<CampaignsWrapper>();

                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    //Added below condition as per story 118800
                    system.debug('det.Status ' + det.Status);
                    //Here check Siebel Campaigns are meeting required criteria
                    if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                        continue;
                    if(det.Status == 'Approved' ){
                        CSS_Solution_Component__c campaignComp = new CSS_Solution_Component__c();
                        if(det.InShopSrtLimitFlag == 'Y')
                            campaignComp.In_Shop_SRT_Limit_Flag__c = true;
                        else
                            campaignComp.In_Shop_SRT_Limit_Flag__c = false;
                        campaignComp.Campaign_Description__c = det.CampaignDesc; 
                        if(det.CampaignEndDate != null && det.CampaignEndDate != '')
                            campaignComp.Campaign_End_Date__c = date.valueof(det.CampaignEndDate);
                        if(det.CampaignStartDate != null && det.CampaignStartDate != '')
                            campaignComp.Campaign_Start_Date__c = date.valueof(det.CampaignStartDate);
                        if(det.CampaignNumber != null)
                            campaignComp.Component_Id__c = string.valueof(det.CampaignNumber);
                        campaignComp.Failure_Mode__c = det.FailMode;
                        if(det.FailCode != null && det.FailCode != ''){
                            campaignComp.System_Code__c = (det.FailCode).substring(0,2);
                            campaignComp.Component_Code__c = (det.FailCode).substring(2);
                        }
                        //Uncommented as part of defect fix - 165273
                        //campaignComp.Selected_Component__c = true;
                        campaignComp.Status__c = det.Status;
                        if(det.MultipleTimes == 'Y')
                            campaignComp.Multiple_Times__c = true;
                        else
                            campaignComp.Multiple_Times__c = false;
                        campaignComp.Business_Unit__c = det.BusinessUnit;
                        campaignComp.Type__c = det.CampaignType;
                        campaignComp.Name = det.CampaignType+' '+det.CampaignNumber;
                        campaignComp.Status__c = det.Status;
                        if(det.CompleteIndicator == 'Y')
                            campaignComp.Complete_Indicator__c = true;
                        else
                            campaignComp.Complete_Indicator__c = false;
                        campaignComp.css_claims__c = ClaimId; 
                        system.debug('campaignComp ' + campaignComp);
                        solCompList.add(campaignComp);
                        /*if(FieldActNumSet.contains(campaignComp.Component_Id__c)){
                            //newSelectedSC.add(campaignComp);
                        }*/

                        partsOptionList = new List<CSS_Parts_Options__c>();
                        if(FieldActNumSet.contains(campaignComp.Component_Id__c)){
                            if(det.PartList != null){
                                for(CG_OP_CampaignsResJSON.PartList partlst : det.PartList){
                                    CSS_Parts_Options__c campaignPart = new CSS_Parts_Options__c();
                                    campaignPart.Quantity__c = partlst.PartQuantity;
                                    campaignPart.BMS_Quantity__c = partlst.PartQuantity;
                                    if(partlst.PartNumber != null)
                                        campaignPart.Service_partnumber__c = string.valueof(partlst.PartNumber);
                                    campaignPart.Part_Name__c = partlst.PartDescription;
                                    campaignPart.Part_Description__c = partlst.PartDescription;
                                    campaignPart.FailurepartId__c = campaignComp.Id;
                                    //campaignPart.Service_Job__c = JobId;
                                    campaignPart.css_claims__c = ClaimId;
                                    campaignPart.Replacement_Reason__c = 'Campaign-TRP-ATC';
                                    campaignPart.RecordTypeId = recTypeId;
                                    campaignPart.selected_part__c = false;
                                    campaignPart.Covered__c = 100;  //Defaulting to 100 since Field actions were inserted first time only when coverage is available.
                                    partsOptionList.add(campaignPart);
                                }
                            }
                            
                            wsDataMap.put(campaignComp.Component_Id__c, partsOptionList);
                        }
                    }
                }

                //Delete old saved solution comp & parts data for the job
                List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>([Select Id,Component_Id__c,In_Shop_SRT_Limit_Flag__c, FailCode_Formula__c, CSS_Account_Formula__c,Fail_Code__c,
                                                                                                       Campaign_Description__c,Campaign_End_Date__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,Failure_Mode__c,System_Code__c,Component_Code__c, CampaignLaborPercentage__c,
                                                                                                       Status__c,Multiple_Times__c,Business_Unit__c,Type__c,Name,Complete_Indicator__c,css_claims__c,Selected_Component__c from CSS_Solution_Component__c where css_claims__c=:ClaimId and Type__c in ('CAMPAIGN','TRP','ATC')]);              

                
                //Story 179356 Code to update existing Field Actions based on FieldActNum
                if(solCompList !=null && solCompList.size() > 0){
                    for(CSS_Solution_Component__c newSolComp:solCompList){
                        if(solCompListTemp !=null && solCompListTemp.size()>0){
                            for(CSS_Solution_Component__c oldSolComp:solCompListTemp){
                                if(newSolComp.Component_Id__c == oldSolComp.Component_Id__c){
                                    oldSolComp.In_Shop_SRT_Limit_Flag__c = newSolComp.In_Shop_SRT_Limit_Flag__c;
                                    oldSolComp.Campaign_Description__c = newSolComp.Campaign_Description__c; 
                                    oldSolComp.Campaign_End_Date__c = newSolComp.Campaign_End_Date__c;
                                    oldSolComp.Campaign_Start_Date__c = newSolComp.Campaign_Start_Date__c;
                                    oldSolComp.Component_Id__c = newSolComp.Component_Id__c;
                                    oldSolComp.Failure_Mode__c = newSolComp.Failure_Mode__c;
                                    oldSolComp.System_Code__c = newSolComp.System_Code__c;
                                    oldSolComp.Component_Code__c = newSolComp.Component_Code__c;
                                    oldSolComp.Status__c = newSolComp.Status__c;
                                    oldSolComp.Multiple_Times__c = newSolComp.Multiple_Times__c;
                                    oldSolComp.Business_Unit__c = newSolComp.Business_Unit__c;
                                    oldSolComp.Type__c = newSolComp.Type__c;
                                    oldSolComp.Name = newSolComp.Name;
                                    oldSolComp.Complete_Indicator__c = newSolComp.Complete_Indicator__c;
                                    oldSolComp.css_claims__c = newSolComp.css_claims__c; 
                                    if(FieldActNumSet.contains(newSolComp.Component_Id__c)){
                                        oldSolComp.Selected_Component__c = true;
                                    //if(FieldActNumSet.contains(campaignComp.Component_Id__c)){
                                        newSelectedSC.add(oldSolComp);
                                    }
                                    //Added below if condition as part of the defect #189704
                                    if(NonSelFieldActNumSet.contains(newSolComp.Component_Id__c)){
                                        oldSolComp.Selected_Component__c = false;
                                    }
                                }
                            }
                        }
                    }

                }
                /*************************/
                //fieldcompList = [SELECT Id, Component_Id__c,FailCode_Formula__c,CSS_Account_Formula__c, Type__c, CampaignLaborPercentage__c FROM CSS_Solution_Component__c WHERE (Type__c = 'ATC' OR Type__c = 'Campaign' OR Type__c = 'TRP') AND Service_Job__c=null and  CSS_Claims__c =:cId and Selected_Component__c = : true];
        
                system.debug('Testgsq'+newSelectedSC+'$$'+ClaimId);
                if(newSelectedSC != null && newSelectedSC.size()!=0)
                     CG_BL_Campaigns.callFieldActionSRTClaims(newSelectedSC, ClaimId);
                system.debug('Test222$');
    
                /*srtFieldList = [SELECT Id,Assignment__c FROM CSS_SRT__c WHERE CSS_Claims__c =: claimsRec.Id AND
                           (SRT_Category__c = 'AdditionalDiag' OR (Type__c = 'Diagnosis' OR Type__c = 'Diag Access'))]; 
                Map<String,List<CSS_SRT__c>> fieldActionMap = new Map<String,List<CSS_SRT__c>>();
                fieldActionMap.put(claimsRec.Id,srtFieldList);*/
                /*************************/
                if(solCompListTemp !=null && solCompListTemp.size()>0)
                    update solCompListTemp;
                system.debug('solCompListTemp**'+solCompListTemp);
                system.debug('Today wsDataMap**'+wsDataMap);

                List<CSS_Parts_Options__c> allPartsOptionList = new List<CSS_Parts_Options__c>();
                //for(Set<string> temppart: FieldActNumSet){
                for(CSS_Solution_Component__c campObj : solCompListTemp){
                    if(wsDataMap != null && wsDataMap.get(campObj.Component_Id__c) != null){
                        for(CSS_Parts_Options__c partObj : wsDataMap.get(campObj.Component_Id__c)){
                            partObj.FailurepartId__c = campObj.Id;
                            if(campObj.CSS_Account_Formula__c != null && campObj.CSS_Account_Formula__c != '' && campObj.CampaignPartsPercentage__c != null && campObj.CampaignPartsPercentage__c != '' && campObj.CampaignPartsPercentage__c != '0')//Added Condition as part of GSSC-268.
                            partObj.Account_Code__c = campObj.CSS_Account_Formula__c;//Saving parts with fail code and account code during WS itself as part of 191608
                            partObj.Fail_Code__c = campObj.Fail_Code__c;//Saving parts with fail code and account code during WS itself as part of 191608
                            allPartsOptionList.add(partObj);
                        }
                    }
                }
               // }
                system.debug('allPartsOptionList**'+allPartsOptionList);
                if(allPartsOptionList !=null && allPartsOptionList.size() > 0)
                    upsert allPartsOptionList;
                system.debug('Part Upsert Success**'+allPartsOptionList);
                for(CSS_Solution_Component__c sc : solCompList) {
                    CampaignsWrapperList.add(new CampaignsWrapper(ClaimId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
                }

                system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
                system.debug('START QUEUEABLE SOLUTION COMPONENT');
                //getAccountCodes(JobId,campaignComp.System_Code__c,campaignComp.Component_Code__c,campaignComp.Id,campaignComp.Component_Id__c);
                //ID jobIDs = System.enqueueJob(new CG_ServiceJobQueueable(JobId,campaignComp.System_Code__c,campaignComp.Component_Code__c,campaignComp.Id,campaignComp.Component_Id__c));
                system.debug('Claims**CampaignsWrapperList ' + CampaignsWrapperList);
                ID jobIDs = System.enqueueJob(new CG_ClaimsQueueable(CampaignsWrapperList));
                //System.debug('jobIDs ' + jobIDs);
                System.debug('END QUEUEABLE SOLUTION COMPONENT');
                system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );

            }
            
            if(claimRec!=null){
                update claimRec;
            }

        }catch(Exception ex){
            System.debug('in catch of callGetCampaignsWS of CG_BL_Campaigns >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{

        }
        return resWrapper;
    }
     @future(callout=true)
    public static void callGetCampaignsWebServiceforReselectonJob(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, Id ClaimId,Set<String> FieldActNumSet, Set<String> NonSelFieldActNumSet){
        System.debug('Inside FieldAction FutureCall');
        callGetCampaignsWSforJobsonReselect(esn, failureDate, region, territory, senderID, serviceName, messageID, target, ClaimId, FieldActNumSet, NonSelFieldActNumSet);
    }
     public static CG_OP_OAGWrapper callGetCampaignsWSforJobsonReselect(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target, Id ClaimId,Set<String> FieldActNumSet, Set<String> NonSelFieldActNumSet){
        system.debug('entered into CG_BL_Campaigns callGetCampaignsWS esn>>>:'+esn);
        CG_OP_OAGWrapper resWrapper = null;
        List<CSS_Solution_Component__c> newSelectedSC = new List<CSS_Solution_Component__c>();
        CSS_Claims__c claimRec = new CSS_Claims__c();
        //claimRec = [SELECT Id,FieldActionWebServiceResult__c FROM CSS_Claims__c WHERE Id =: ClaimId];
        try{
            system.debug('FieldActNumSet**'+FieldActNumSet);
            //Call service Layer to make Webservice Call
            system.debug('in CG_BL_Campaigns before calling callGetCampaignsWS esn>>>:'+esn);
            resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDate, region, territory, senderID, serviceName, messageID, target);
            system.debug('resWrapper>>>:'+resWrapper);
            HttpResponse httpRes = resWrapper.response;
            system.debug('httpRes--'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                if(claimRec!=null){
                    claimRec.FieldActionWebServiceResult__c='Error';
                    system.debug('Inside Camperror');
                }
                else{
                    claimRec.FieldActionWebServiceResult__c='Success';
                    system.debug('Inside campSuccess');
                }
            }
            
            //system.debug('ResBody>>>:'+resWrapper.response.getBody());
            //System.debug('#####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            CG_OP_CampaignsResJSON outputRes;
            if(resWrapper!=null && resWrapper.response != null)
                outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            system.debug('outputRes**'+outputRes);

            if(outputRes!=null && outputRes.DataArea != null){
                system.debug('outputRes.DataArea ' + outputRes.DataArea);
                List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
                List<CSS_Parts_Options__c> partsOptionList;
                Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: 'Parts'].Id;
                Map<String,List<CSS_Parts_Options__c>> wsDataMap = new Map<String,List<CSS_Parts_Options__c>>();
                list<CampaignsWrapper> CampaignsWrapperList = new list<CampaignsWrapper>();

                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    //Added below condition as per story 118800
                    system.debug('det.Status ' + det.Status);
                    //Here check Siebel Campaigns are meeting required criteria
                    if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                        continue;
                    if(det.Status == 'Approved' ){
                        CSS_Solution_Component__c campaignComp = new CSS_Solution_Component__c();
                        if(det.InShopSrtLimitFlag == 'Y')
                            campaignComp.In_Shop_SRT_Limit_Flag__c = true;
                        else
                            campaignComp.In_Shop_SRT_Limit_Flag__c = false;
                        campaignComp.Campaign_Description__c = det.CampaignDesc; 
                        if(det.CampaignEndDate != null && det.CampaignEndDate != '')
                            campaignComp.Campaign_End_Date__c = date.valueof(det.CampaignEndDate);
                        if(det.CampaignStartDate != null && det.CampaignStartDate != '')
                            campaignComp.Campaign_Start_Date__c = date.valueof(det.CampaignStartDate);
                        if(det.CampaignNumber != null)
                            campaignComp.Component_Id__c = string.valueof(det.CampaignNumber);
                        campaignComp.Failure_Mode__c = det.FailMode;
                        if(det.FailCode != null && det.FailCode != ''){
                            campaignComp.System_Code__c = (det.FailCode).substring(0,2);
                            campaignComp.Component_Code__c = (det.FailCode).substring(2);
                        }
                        //Uncommented as part of defect fix - 165273
                        //campaignComp.Selected_Component__c = true;
                        campaignComp.Status__c = det.Status;
                        if(det.MultipleTimes == 'Y')
                            campaignComp.Multiple_Times__c = true;
                        else
                            campaignComp.Multiple_Times__c = false;
                        campaignComp.Business_Unit__c = det.BusinessUnit;
                        campaignComp.Type__c = det.CampaignType;
                        campaignComp.Name = det.CampaignType+' '+det.CampaignNumber;
                        campaignComp.Status__c = det.Status;
                        if(det.CompleteIndicator == 'Y')
                            campaignComp.Complete_Indicator__c = true;
                        else
                            campaignComp.Complete_Indicator__c = false;
                        campaignComp.Service_Job__c = ClaimId; 
                        system.debug('campaignComp ' + campaignComp);
                        solCompList.add(campaignComp);
                        /*if(FieldActNumSet.contains(campaignComp.Component_Id__c)){
                            //newSelectedSC.add(campaignComp);
                        }*/

                        partsOptionList = new List<CSS_Parts_Options__c>();
                        if(FieldActNumSet != null && FieldActNumSet.contains(campaignComp.Component_Id__c)){
                            if(det.PartList != null){
                                for(CG_OP_CampaignsResJSON.PartList partlst : det.PartList){
                                    CSS_Parts_Options__c campaignPart = new CSS_Parts_Options__c();
                                    campaignPart.Quantity__c = partlst.PartQuantity;
                                    campaignPart.BMS_Quantity__c = partlst.PartQuantity;
                                    if(partlst.PartNumber != null)
                                        campaignPart.Service_partnumber__c = string.valueof(partlst.PartNumber);
                                    campaignPart.Part_Name__c = partlst.PartDescription;
                                    campaignPart.Part_Description__c = partlst.PartDescription;
                                    campaignPart.FailurepartId__c = campaignComp.Id;
                                    campaignPart.Service_Job__c	 = ClaimId;
                                    campaignPart.Replacement_Reason__c = 'Campaign-TRP-ATC';
                                    campaignPart.RecordTypeId = recTypeId;
                                    campaignPart.selected_part__c = false;
                                    campaignPart.Covered__c = 100;  //Defaulting to 100 since Field actions were inserted first time only when coverage is available.
                                    partsOptionList.add(campaignPart);
                                }
                            }
                            wsDataMap.put(campaignComp.Component_Id__c, partsOptionList);
                        }
                    }
                }

                List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>([Select Id,Component_Id__c,In_Shop_SRT_Limit_Flag__c, FailCode_Formula__c, CSS_Account_Formula__c,
                                                                                                       Campaign_Description__c,Campaign_End_Date__c,Campaign_Start_Date__c,Failure_Mode__c,System_Code__c,Component_Code__c, CampaignLaborPercentage__c,
                                                                                                       Status__c,Multiple_Times__c,Business_Unit__c,Type__c,Name,Complete_Indicator__c,css_claims__c,Selected_Component__c from CSS_Solution_Component__c where Service_Job__c=:ClaimId and Type__c in ('CAMPAIGN','TRP','ATC')]);              

                List<css_srt__c> srtList = [Select id,Component_Id__c,Component_Id__r.Component_Id__c,FailCode__c, AccountCode_Formula__c from css_Srt__c where Job_Order__c = :ClaimId AND 
                                    (Type__c IN ('Admin','Field Action','Field Action Access','CAMPAIGN','TRP','ATC','99Time') OR SRT_Category__c IN ('CAMPAIGN','TRP','ATC'))];
            system.debug('srtList**'+srtList);
             List<CSS_Parts_Options__c> partsList = [select id,Fail_Code__c,FailurepartId__c,Get_Fail_Code_Formula__c,Account_Code__c,recordtype.name,Parts_Type__c from CSS_Parts_Options__c
                                                    where Service_Job__c = :ClaimId AND ((recordtype.name = 'Parts' AND parts_type__c = 'Custom') OR (recordtype.name = 'Parts' AND FailurepartId__r.type__c IN ('CAMPAIGN','TRP','ATC')) OR recordtype.name IN('OtherClaimables','TTML'))];
            system.debug('partsList**'+partsList);
                /* List<CSS_Solution_Component__c> solCompListforSRTCall = new List<CSS_Solution_Component__c>();
                 for(css_srt__c srt: srtList){
                     if(FieldActNumSet.contains(srt.Component_Id__r.Component_Id__c)){}
                     else{solCompListforSRTCall.add(srt);}
                 }*/
                if(solCompList !=null && solCompList.size() > 0){
                    for(CSS_Solution_Component__c newSolComp:solCompList){
                        if(solCompListTemp !=null && solCompListTemp.size()>0){
                            for(CSS_Solution_Component__c oldSolComp:solCompListTemp){
                                if(newSolComp.Component_Id__c == oldSolComp.Component_Id__c){
                                    oldSolComp.In_Shop_SRT_Limit_Flag__c = newSolComp.In_Shop_SRT_Limit_Flag__c;
                                    oldSolComp.Campaign_Description__c = newSolComp.Campaign_Description__c; 
                                    oldSolComp.Campaign_End_Date__c = newSolComp.Campaign_End_Date__c;
                                    oldSolComp.Campaign_Start_Date__c = newSolComp.Campaign_Start_Date__c;
                                    oldSolComp.Component_Id__c = newSolComp.Component_Id__c;
                                    oldSolComp.Failure_Mode__c = newSolComp.Failure_Mode__c;
                                    oldSolComp.System_Code__c = newSolComp.System_Code__c;
                                    oldSolComp.Component_Code__c = newSolComp.Component_Code__c;
                                    oldSolComp.Status__c = newSolComp.Status__c;
                                    oldSolComp.Multiple_Times__c = newSolComp.Multiple_Times__c;
                                    oldSolComp.Business_Unit__c = newSolComp.Business_Unit__c;
                                    oldSolComp.Type__c = newSolComp.Type__c;
                                    oldSolComp.Name = newSolComp.Name;
                                    oldSolComp.Complete_Indicator__c = newSolComp.Complete_Indicator__c;
                                    oldSolComp.css_claims__c = newSolComp.css_claims__c; 
                                    if(FieldActNumSet != null && FieldActNumSet.contains(newSolComp.Component_Id__c)){
                                        oldSolComp.Selected_Component__c = true;
                                    //if(FieldActNumSet.contains(campaignComp.Component_Id__c)){
                                        newSelectedSC.add(oldSolComp); 
                                    }
                                    //Added below if condition as part of the defect #189704
                                    if(NonSelFieldActNumSet != null && NonSelFieldActNumSet.contains(newSolComp.Component_Id__c)){
                                        oldSolComp.Selected_Component__c = false;
                                    }
                                }
                            }
                        }
                    }

                }
                /*************************/
                //fieldcompList = [SELECT Id, Component_Id__c,FailCode_Formula__c,CSS_Account_Formula__c, Type__c, CampaignLaborPercentage__c FROM CSS_Solution_Component__c WHERE (Type__c = 'ATC' OR Type__c = 'Campaign' OR Type__c = 'TRP') AND Service_Job__c=null and  CSS_Claims__c =:cId and Selected_Component__c = : true];
        
                system.debug('Testgsq'+newSelectedSC+'$$'+ClaimId);
                if(newSelectedSC != null && newSelectedSC.size()!=0 )
                    CG_BL_Campaigns.callFieldActionSRT(newSelectedSC, ClaimId);
                system.debug('Test222$');
    
                /*srtFieldList = [SELECT Id,Assignment__c FROM CSS_SRT__c WHERE CSS_Claims__c =: claimsRec.Id AND
                           (SRT_Category__c = 'AdditionalDiag' OR (Type__c = 'Diagnosis' OR Type__c = 'Diag Access'))]; 
                Map<String,List<CSS_SRT__c>> fieldActionMap = new Map<String,List<CSS_SRT__c>>();
                fieldActionMap.put(claimsRec.Id,srtFieldList);*/
                /*************************/
                if(solCompListTemp !=null && solCompListTemp.size()>0)
                    update solCompListTemp;
                system.debug('solCompListTemp**'+solCompListTemp);
                system.debug('Today wsDataMap**'+wsDataMap);

                List<CSS_Parts_Options__c> allPartsOptionList = new List<CSS_Parts_Options__c>();
                for(CSS_Solution_Component__c campObj : solCompListTemp){
                    if(wsDataMap != null && wsDataMap.get(campObj.Component_Id__c) != null){
                        for(CSS_Parts_Options__c partObj : wsDataMap.get(campObj.Component_Id__c)){
                            partObj.FailurepartId__c = campObj.Id;
                            allPartsOptionList.add(partObj);
                        }
                    }
                }
                system.debug('allPartsOptionList**'+allPartsOptionList);
               /* if(partsList != null && partsList.size()==0){
                system.debug('TestKal**');}*/
                if(allPartsOptionList !=null && allPartsOptionList.size() > 0)
                    upsert allPartsOptionList;
                system.debug('Part Upsert Success**'+allPartsOptionList);
                 CG_CL_UpdateJob_FC_AC_ChildEntities contr = new CG_CL_UpdateJob_FC_AC_ChildEntities();
                contr.updateFieldActionPartsFailCodeAccCode(solCompListTemp);
                for(CSS_Solution_Component__c sc : solCompList) {
                    CampaignsWrapperList.add(new CampaignsWrapper(ClaimId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
                }

                system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
                system.debug('START QUEUEABLE SOLUTION COMPONENT');
                system.debug('Claims**CampaignsWrapperList ' + CampaignsWrapperList);
                ID jobIDs = System.enqueueJob(new CG_ServiceJobQueueable(CampaignsWrapperList));
                System.debug('END QUEUEABLE SOLUTION COMPONENT');
                system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );

            }
            
           /* if(claimRec!=null){
                update claimRec;
            }*/

        }catch(Exception ex){
            System.debug('in catch of callGetCampaignsWS of CG_BL_Campaigns >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{

        }
        return resWrapper;
    }
}