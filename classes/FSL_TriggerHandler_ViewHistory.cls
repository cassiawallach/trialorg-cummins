/**********************************************************************
Name: FSL_TriggerHandler_ViewHistory
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This process is used to populate the Repeat visit flag 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE               Description                                      
1.0     Sriprada shesham           5/03/2019     
2.0     karthik Gorantla           09/2/2020          Mule Api migration
2.1     Naveen					   18/08/2022         Phoen-262,make updates to integrations from Guidanz to leverage name credentials for enhanced system performance
***********************************************************************/
public class FSL_TriggerHandler_ViewHistory
{   
    // raghav
    public static void handleRepeatFlag(Set<Id> setWoIds){
        if(system.isBatch() || system.isFuture()){
            handleRepeatFlagHere(setWoIds);
        }else{
            handleRepeatFlagFuture(setWoIds);
        }
    }
    
    
    @future(callout=true)
    public static void handleRepeatFlagFuture(Set<Id> setWoIds){
        system.debug('priyanka here');
        handleRepeatFlagHere(setWoIds);
    }
    
    //karthik G made it future for mule soft callout
    private static void handleRepeatFlagHere(Set<Id> setWoIds)
    {
        system.debug('karthik inside handle');
       
        try {
            List<WorkOrder> woUpdate = new List<WorkOrder>();
            List<Service_Order_Extension__c> woExtUpsert = new List<Service_Order_Extension__c>();
            // Start -- Changes Added by Naveen , Phoen-262 ---------------------------
            FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();  
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Services';
            reqWrapper.Path = '/repeatvisitflag';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            system.debug('endpoint==>'+reqWrapper.endPoint);
            // End -- Changes Added by Naveen , Phoen-262 ---------------------------
            
      /*  Set<Id> setAssetIds = new Set<Id>();

        for(workorder wo : workOrderList)
        {
            setAssetIds.add(wo.AssetId);

            system.debug('wo.Asset.Name>>'+wo);
            //wo.Repeat_Visit__c =  updateRepeatFlag(conDetails,'',wo.Asset.Name,wo.Mileage__c,wo.Mileage_Measure__c,wo.WorkOrderNumber,'',null,wo.RPVControlNumber__c); 
            
  
        }*/
            //Added by Priyanka for Ct1-670 , in where condition changed it to WO Id instead of assetid
        List<WorkOrder> wo = [SELECT id,AssetId,Asset.Name, Mileage__c,Type__c, Mileage_Measure__c, WorkOrderNumber, RPVControlNumber__c,  
                              (select id,Repeat_Visit__c from Service_Order_Extension__r )
                              FROM WorkOrder WHERE id =: setWoIds LIMIT 1];
            system.debug('priyanka asset' + wo);
           
            String flag;
            if(wo[0].Type__c != 'Dealer'){
                flag = 'DIST';
            } else if(wo[0].Type__c == 'Dealer'){
                flag = 'DLR';
            }
            if(Test.isRunningTest()) {
                if(wo != null && !wo.isEmpty() && wo[0] !=null && wo[0].Asset !=null && wo[0].Asset.Name != null ) //CT2-388 : null and empty check added
                    wo[0].Asset.Name ='79462880';
            }
            if(!wo.isEmpty()) {                 
                if(wo[0].Asset.Name != null)
                {
                    system.debug('wo.Asset.Name isideif '+wo[0].Asset.Name);
                    system.debug('wo.Asset.Name isideif '+reqWrapper);
                    system.debug('wo.Asset.Name Mileage__c '+wo[0].Mileage__c);
                    system.debug('wo.Asset.Name isideif '+wo[0].Mileage_Measure__c);
                    system.debug('wo.Asset.Name isideif '+wo[0].WorkOrderNumber);
                    system.debug('wo.Asset.Name isideif '+wo[0].RPVControlNumber__c);
                  //  wo[0].Repeat_Visit__c =  updateRepeatFlag(conDetails,'',wo[0].Asset.Name,wo[0].Mileage__c,wo[0].Mileage_Measure__c,wo[0].WorkOrderNumber,flag,null,wo[0].RPVControlNumber__c);   
                   // woUpdate.add(wo[0]);
                    //By Priyanka for VGRS2-456 (part of VGRS2-398)
                    if(!wo[0].Service_Order_Extension__r.isEmpty() && wo[0].Service_Order_Extension__r[0] != null)
                    {
                        
                        wo[0].Service_Order_Extension__r[0].Repeat_Visit__c = updateRepeatFlag(reqWrapper,'',wo[0].Asset.Name,wo[0].Mileage__c,wo[0].Mileage_Measure__c,wo[0].WorkOrderNumber,flag,null,wo[0].RPVControlNumber__c); // replaced conDetails to reqWrapper by Naveen , Phoen-262 ---------------------------
                    	woExtUpsert.add(wo[0].Service_Order_Extension__r[0]);
                    }
                    else
                    {
                      system.debug('insert priyanka');
                        Service_Order_Extension__c soExtention = new  Service_Order_Extension__c();
                        soExtention.Repeat_Visit__c = updateRepeatFlag(reqWrapper,'',wo[0].Asset.Name,wo[0].Mileage__c,wo[0].Mileage_Measure__c,wo[0].WorkOrderNumber,flag,null,wo[0].RPVControlNumber__c); // replaced conDetails to reqWrapper by Naveen , Phoen-262 ---------------------------
                   		soExtention.Service_Order_Id__c = wo[0].id;
                        woExtUpsert.add(soExtention);
                    }
                }
            }
             system.debug(' priyanka****' + woExtUpsert);
            //By Priyanka for VGRS2-456 (part of VGRS2-398)
            if(woExtUpsert.size() > 0){
                 system.debug(' priyanka++++++' + woExtUpsert);  
                upsert woExtUpsert;
            }
        } catch(exception e){
            system.debug('Entered into catch of  Method in FSL_TriggerHandler_ViewHistory>>>'+e.getMessage() +e.getLineNumber());
        }
    }
    //Method to Make Call Out 
   // replaced conDetails to reqWrapper by Naveen , Phoen-262 ---------------------------
    public static Boolean updateRepeatFlag(FSL_IP_NamedCredentialWrapper reqWrapper,string personType, string esn, Decimal vmiles, string vmileage,string cssJobNum, string vdsid, datetime vDSIDCrDt, string vcontrolNum)
    {      
        system.debug('insideupdatemethod');
        string accessToken;
        boolean flagVal = false;
        HttpRequest req = new HttpRequest();
        
        string miles = string.valueOf(vmiles);
        
        string controlNum;
        
        if (vcontrolNum==null)
        {
            controlNum = '';
        }else 
        {
            controlNum = vcontrolNum;
        }
        
        string dsid;
        
        if (vdsid==null){
            dsid = '';
        }else {dsid = vdsid;}
        
        string mileage;
        
        if(vmileage=='Miles'){
            mileage = 'MI';
        } else if(vmileage=='Kilometers'){
            mileage = 'KM';
        } else {
            mileage = 'HR';
        }
        string DISIDCrDt=string.valueOf(vDSIDCrDt);             
        if (DISIDCrDt==null)
        {
            DISIDCrDt = '';
        }            
        string endPoint;
        system.debug('out>>dmiles'+miles);
        if (miles!=null || miles!='')
       {
            string timestamp=string.valueof(system.now());  //"MM-DD-YYYY HH:MM:SS"
            
            if(!Test.isRunningTest())
            {
                 endPoint = reqWrapper.endPoint;  //added by Naveen , Phoen-262
                  
            }else{
                endPoint = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-services/repeatvisitflag';
                accessToken='Test';
            }
            string rpvRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName": "ServiceRequest","SenderID": "SF"},"Target":{"TargetID":"RPV"}},';
           // rpvRequest = rpvRequest + '"DataArea":{"ESN":"'+'73368236'+'","Mileage": "'+'55346'+'","MileageMSR":"'+'MI'+'","FailDate": "","JobNumber":"'+cssJobNum+'","DealerDistributorFlag": "'+'DISTR'+'",'; 
            rpvRequest = rpvRequest + '"DataArea":{"ESN":"'+esn+'","Mileage": "'+miles+'","MileageMSR":"'+mileage+'","FailDate": "","JobNumber":"'+cssJobNum+'","DealerDistributorFlag": "'+personType+'",'; 
            rpvRequest = rpvRequest + '"ControlNumber": "'+controlNum+'","DSID": "'+dsid+'","DSIDOpenedDate":"'+DISIDCrDt+'","TimeStamp":"'+timestamp+'" }}';
            System.debug('The repairRequest is!@!@#'+rpvRequest);
         
            
           //Start-- added by Naveen , Phoen-262 ---------------------------
           reqWrapper.jsonReqBody = rpvRequest;
           reqWrapper.timeOut = 120000;
           system.debug('RPV req d1>>>>>>>>>>>'+reqWrapper.jsonReqBody);
           
           CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
           system.debug('RPV res d1>>>>>>>>>>>'+outputWrapper);
           HttpResponse res = outputWrapper.response;//Ends mule changes
           system.debug('RESPONSEEEE '+res);
           system.debug('RESPONSEEEE Body==> '+res.getBody());
           
            //End-- added by Naveen , Phoen-262 ---------------------------
           
           FSL_J2ARPV wo5 = (FSL_J2ARPV)JSON.deserializeStrict(res.getBody(),FSL_J2ARPV.class);           
            if(wo5.DataArea!=null)
            {  
                System.debug('The json format is'+wo5);
                System.debug('BODY: '+res.getBody());
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode()); 
                System.debug('RepeatVisitFlag:'+wo5.DataArea.RepeatVisitFlag);   
                if(wo5.DataArea.RepeatVisitFlag == 'RF' || wo5.DataArea.RepeatVisitFlag == 'RN') //RF condition added by Sriprada for RPV flag changes
                {
                    flagVal = true;
                } else if(wo5.DataArea.RepeatVisitFlag == 'N' || wo5.DataArea.RepeatVisitFlag == 'FS') //FS and N condition added by Sriprada for RPV flag changes
                {
                    flagVal = false;
                }
            }				          
        }
        return flagVal;
    }
    
    @AuraEnabled
    public static string getRPVFlag(Id woId) {
        //WorkOrder wo = [SELECT  Id, Repeat_Visit__c, RecentVisit__c, Repeat_or_Recent_Visit__c 
          //              FROM WorkOrder WHERE id=:woId];
                       //By Priyanka for VGRS2-456 (part of VGRS2-398)
            Service_Order_Extension__c soExt = [SELECT  Id, Repeat_Visit__c, Recent_Visit__c, Repeat_or_Recent_Visit__c 
                      FROM Service_Order_Extension__c WHERE Service_Order_Id__c=:woId limit 1];            
        return soExt.Repeat_or_Recent_Visit__c;
    }
}