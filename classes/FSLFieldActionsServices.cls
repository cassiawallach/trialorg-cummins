/*************************************************************************
Name:FSLFieldActionsServices 
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose: 
--------
This class written for to get FieldActionsSRT' webservice for Field Actions 
when the supervisor checks ‘Required to perform/review’ and saves.
======================================================
======================================================
History
-------
VERSION  AUTHOR                     DATE
1.0     Ravikanth Macherla         05/16/2019
2.0 Added Mule Token Mechanism for Dynamic authentication -- VY - 8/31/2020
**************************************************************************/
public class FSLFieldActionsServices {

    @Future(callout=true)
   public static void fieldactionsrt(String strCSSSolutionComponent) {
        system.debug('check calling');
        set<id> setCSSSolCompId = new set<id>();
        CSS_Solution_Component__c listSolComp;
        list<CSS_Solution_Component__c> lstNewCssSolution  = new list<CSS_Solution_Component__c>();
        if(String.isNotBlank(strCSSSolutionComponent)) {
            lstNewCssSolution = (List<CSS_Solution_Component__c>)JSON.deserialize(strCSSSolutionComponent, List<CSS_Solution_Component__c>.class);
            for(CSS_Solution_Component__c objCssSol: lstNewCssSolution) {
                setCSSSolCompId.add(objCssSol.id);
            }
            system.debug('check set'+setCSSSolCompId);
            fieldactionsrtwebservices(setCSSSolCompId);
        }
    }
    
    // @Future(callout=true)
    public static  void  fieldactionsrtwebservices(set<Id> CSScompId) {

        system.debug('compid--->' + CSScompId);
        FSLfieldactionRequest lstwarrequest = new FSLfieldactionRequest();
        CSS_Solution_Component__c listSolComp;
        if(!CSScompId.isempty()){
            try{
            listSolComp = [SELECT Id, Type__c, Component_Id__c, System_Code__c, Component_Code__c, AccountCode__c, 
                           FSL_Service_Order__c, FSL_Service_Order__r.ServiceTerritory.Location_Code__c, FSL_Service_Order__r.Application__c, 
                           FSL_Service_Order__r.Asset.Name, FSL_Service_Order__r.Failure_Date__c, FSL_Service_Order__r.Mileage__c, 
                           FSL_Service_Order__r.Mileage_Measure__c, FSL_Service_Order__r.Warranty_Start_Date__c, FSL_Service_Order__r.Asset.Service_Model__c, 
                           FSL_Service_Order__r.Asset.Equipment_Id__c, FSL_Service_Order__r.Asset.Engine_Family_Code__c 
                           FROM CSS_Solution_Component__c WHERE Id =: CSScompId]; 
            }
            catch(exception e){
                listSolComp = null;
            }
            /*listSolComp = [SELECT Id, Type__c, Component_Id__c, System_Code__c, Component_Code__c, AccountCode__c, 
FSL_Service_Job__c, FSL_Service_Job__r.ServiceTerritory.Location_Code__c, FSL_Service_Job__r.Application__c, 
FSL_Service_Job__r.Asset.Name, FSL_Service_Job__r.Failure_Date__c, FSL_Service_Job__r.Mileage__c, 
FSL_Service_Job__r.Mileage_Measure__c, FSL_Service_Job__r.Warranty_Start_Date__c, FSL_Service_Job__r.Asset.Service_Model__c, 
FSL_Service_Job__r.Asset.Equipment_Id__c, FSL_Service_Job__r.Asset.Engine_Family_Code__c 
FROM CSS_Solution_Component__c WHERE Id =: CSScompId]; */
            
            /*system.debug('compid sssss--->' + CSScompId);
listSolComp = [select id,Type__c,FSL_Service_Job__c from CSS_Solution_Component__c WHERE Id =: CSScompId]; 
system.debug('check sc job'+listSolComp.FSL_Service_Job__c);
system.debug('check sc job'+listSolComp.FSL_Service_Job__r.Asset);*/
        }
        
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd')+'T00:00:00';
        String  dtStamp = currDate;
        String  effDtSTamp = currDate;
        
        /* FSLfieldactionRequest.cls_Sender fslfield = new FSLfieldactionRequest.cls_Sender();
fslfield.ServiceName = 'GetFieldActionSRTs';
fslfield.SenderID = 'Guidanz';
fslfield.MessageID = ''; */
        
        FSLfieldactionRequest.cls_DataArea fsldata = new FSLfieldactionRequest.cls_DataArea();
        if(listSolComp != null) {
        fsldata.ServiceModelName = listSolComp.FSL_Service_Order__r.Asset.Service_Model__c;
        fsldata.EquipmentID = listSolComp.FSL_Service_Order__r.Asset.Equipment_Id__c;
        fsldata.EngineFamilyCode = listSolComp.FSL_Service_Order__r.Asset.Engine_Family_Code__c;
    }
        fsldata.Language = 'en';
        
        fsldata.EffectiveDTTime = effDtSTamp;
        fsldata.DTTimestamp = dtStamp;
        system.debug('Timestamp'+fsldata.DTTimestamp);
        system.debug('EffectiveDTTime'+fsldata.EffectiveDTTime);
        
        FSLfieldactionRequest.cls_FieldAction fslfd = new FSLfieldactionRequest.cls_FieldAction();
        List<FSLfieldactionRequest.cls_FieldAction> fslfdLst = new List<FSLfieldactionRequest.cls_FieldAction>();
        if(listSolComp != null) {
        fslfd.FieldActionType = listSolComp.Type__c;
        fslfd.FieldActionNumber = listSolComp.Component_Id__c;
        }
        fslfdLst.add(fslfd);
        fsldata.FieldAction = fslfdLst;
        FSLfieldactionRequest.cls_Header fslhead = new FSLfieldactionRequest.cls_Header();
        
        FSLfieldactionRequest.cls_Target fslTarget = new FSLfieldactionRequest.cls_Target();
        FSLfieldactionRequest.cls_Sender fslSender = new FSLfieldactionRequest.cls_Sender();
        fslhead.Sender = fslSender;
        fslSender.ServiceName = 'GetFieldActionSRTs';
        fslSender.SenderID = 'Guidanz';
        fslSender.MessageID = '';
        fslTarget.TargetID = 'SRT';
        fslhead.Target = fslTarget;
        
        FSLfieldactionRequest clswrp = new FSLfieldactionRequest();
        clswrp.DataArea = fsldata;
        clswrp.Header = fslhead;
        
        String jsonreq = JSON.serialize(clswrp);
        system.debug('JSON Request---->' + jsonreq);
        if(listSolComp != null)
        insertfslSRT(jsonreq, listSolComp.FSL_Service_Order__r.Id,listSolComp.Id );
    }
    
    public static void insertfslSRT(string jsonreq, Id CSScompId, Id listSolComp) {
        List<FSLFieldActionswrapper> fslCDSResps = new list<FSLFieldActionswrapper>();
        FSL_IP_NamedCredentialWrapper reqWrapper = null;  //code changes by Charan , PHOEN-264
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/fieldactions';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
		
        reqWrapper.jsonReqBody = jsonreq;
        reqWrapper.timeOut = 120000;
        system.debug('SRT req d1>>>>>>>>>>>'+reqWrapper.jsonReqBody);

		CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
        system.debug('SRT res d1>>>>>>>>>>>'+outputWrapper);
        HttpResponse resp = outputWrapper.response;
        system.debug('RESPONSEEEE '+resp);
        String responseBody='';
        if(Test.isRunningTest())
            responseBody = '{   "Header":{     "Status":"SUCCESS",     "ReturnCode":"ORA-00000",     "ReturnCodeDescription":"Normal, Successful completion.",     "MessageIdentifier":"debc5930-3a95-4420-bb8c-2695f4398614",     "MessageType":"S"   },   "DataArea":{     "FieldAction":[       {         "FieldActionNumber":"2189",         "FieldActionType":"CAMPAIGN",         "FieldActionSRTTime":[           {             "S7TIME":0,             "SRTDetails":"00-901-00",             "SRTAccessCode":"B",             "S6DESCRIPTION":"","S9DESCRIPTION":"","BTIME":0.4,"S2TIME":0,"CTIME":0,"S2DESCRIPTION":"","S8TIME":0,"Assignment":"ALTERNATIVE","S5DESCRIPTION":"","S6TIME":0,"S3TIME":0,"S8DESCRIPTION":"","SRTTime":0.4,"S1DESCRIPTION":"","StepDescription":"Note: Also applies to repairs performed on lots or aprons immediately adjacent to a shop operated by the repairing location.  Note: Use 00-902 if travel is required to vehicle  Includes:   -Clock on and clock off the job  -Move equipment to and from work area  -Record engine and equipment identification  numbers  -Record the following:  . Mileage or hours of operation  . CPL number  . Fuel pump code  -Move tool box to and from work area  -Clean up work area and write up repair order  at end of each shift and when job has been  completed","S4DESCRIPTION":"","SRTQuantity":1, "QuoteID":331510, "S4TIME":0, "SRTTitle":"Administrative Time - Open and Close Repair Order (Shop Repairs)", "SRTMessage":"", "StepID":19502, "DTIME":0, "S3DESCRIPTION":"", "RTIME":0.4, "ATIME":0, "S7DESCRIPTION":"", "S1TIME":0, "S5TIME":0, "S9TIME":0           },           { "S7TIME":0, "SRTDetails":"00-902-00", "SRTAccessCode":"B", "S6DESCRIPTION":"", "S9DESCRIPTION":"", "BTIME":0.7, "S2TIME":0, "CTIME":0, "S2DESCRIPTION":"", "S8TIME":0, "Assignment":"ALTERNATIVE", "S5DESCRIPTION":"", "S6TIME":0, "S3TIME":0, "S8DESCRIPTION":"", "SRTTime":0.7, "S1DESCRIPTION":"", "StepDescription":"Note: This SRT applies when travel is covered and the repair is performed away from the shop operated by the repairing location to include work in a customer or dealer shop by a distributor or branch technician.  Includes:   -Clock on and clock off the job  -Move equipment to and from work area   -Record the following:   . Engine serial number  . Equipment identification number  . Hours of operation  . CPL number  . Fuel pump code  -Load and unload any special tools, equipment  and parts necessary for the repair  -Clean up work area and write up repair order at  end of each shift and when job has been  completed", "S4DESCRIPTION":"", "SRTQuantity":1, "QuoteID":331510, "S4TIME":0, "SRTTitle":"Administrative Time - Open and Close Repair Order (Road Repairs)", "SRTMessage":"", "StepID":131376, "DTIME":0, "S3DESCRIPTION":"", "RTIME":0.7, "ATIME":0, "S7DESCRIPTION":"", "S1TIME":0, "S5TIME":0, "S9TIME":0           }         ]       }     ]   } }';
        else{
            system.debug('response checkk'+resp.getBody());
            responseBody = resp.getBody();
        }
        responseBody = ' [ ' + responseBody + ' ] '; 
        fslCDSResps = (List<FSLFieldActionswrapper>)JSON.deserialize(responseBody, List<FSLFieldActionswrapper>.Class);
        system.debug('response for syptoms\n::' + responseBody);
        list<FSL_SRT__c> lstsrt = new list<FSL_SRT__c>();
        Id FieldActionSRTRecordTypeId = Schema.SObjectType.FSL_SRT__c.getRecordTypeInfosByName().get('FA SRT').getRecordTypeId();  
        system.debug('FieldActionSRTRecordTypeId---'+FieldActionSRTRecordTypeId);      
        for(FSLFieldActionswrapper owrapper : fslCDSResps) {
            Boolean booleanR = FALSE;
            if(owrapper.DataArea.FieldAction != null) {
                for(FSLFieldActionswrapper.cls_FieldAction  objd : owrapper.DataArea.FieldAction) {
                    for(FSLFieldActionswrapper.cls_FieldActionSRTTime objwa :objd.FieldActionSRTTime) {
                        // if(objwa.Assignment !='Diagnostic' || objwa.Assignment !='Unlisted' || objwa.Assignment !='NOT CLAIMABLE' || objwa.Assignment !='NOT APPLICABLE'  || objwa.Assignment !='ALTERNATIVE') {
                        if (objwa.Assignment == 'Primary' || objwa.Assignment == 'ALTERNATIVE' || objwa.Assignment == 'PROGRESSIVE') {
                            FSL_SRT__c objSRT = new FSL_SRT__c ();
                            objSRT.Name = objwa.SRTDetails;
                            objSRT.SRT_Time__c = objwa.SRTTime;
                            objSRT.Service_Order__c = CSScompId;
                            objSRT.Type__c = 'Field Action';
                            if(objwa.Assignment == 'Primary') {
                                objSRT.SRT_Select__c = TRUE;
                            }
                            objSRT.Assignment__c = objwa.Assignment;
                            objSRT.SRT_Access_Code__c = objwa.SRTAccessCode;
                            if(objSRT.SRT_Access_Code__c == 'R') {
                                booleanR = TRUE;
                            }
                            objSRT.SRT_Quantity__c = objwa.SRTQuantity;
                            objSRT.SRT_Title__c = objwa.SRTTitle;
                            objSRT.Step_Id__c = objwa.StepID;
                            // objSRT.Step_Description__c = String.join(objwa.StepDescription, '\r\n');
                            objSRT.Step_Description__c = objwa.StepDescription;
                            objSRT.Access_Code_A__c = objwa.ATIME;   //Addes Access code times for SRTs in Job plan
                            objSRT.Access_Code_B__c = objwa.BTIME;
                            objSRT.Access_Code_C__c = objwa.CTIME;
                            objSRT.Access_Code_D__c = objwa.DTIME;
                            objSRT.Access_Code_R__c = objwa.RTIME;
                            objSRT.Access_Code_S1__c = objwa.S1TIME;
                            objSRT.Access_Code_S2__c = objwa.S2TIME;
                            objSRT.Access_Code_S3__c = objwa.S3TIME;
                            objSRT.Access_Code_S4__c = objwa.S4TIME;
                            objSRT.Access_Code_S5__c = objwa.S5TIME;
                            objSRT.Access_Code_S6__c = objwa.S6TIME;
                            objSRT.Access_Code_S7__c = objwa.S7TIME;
                            objSRT.Access_Code_S8__c = objwa.S8TIME;
                            objSRT.Access_Code_S9__c = objwa.S9TIME;  //end
                            objSRT.RecordTypeId = FieldActionSRTRecordTypeId;
                            objSRT.Component_Id__c = listSolComp;
                            lstsrt.add(objSRT);
                        }
                    }
                }
            }
        }
        if(!Test.isRunningTest()){
            system.debug('responsess'+resp.getStatus()); 
            system.enqueuejob(new FSL_ApplicationLoggerQueueable(jsonreq,resp.getBody(),Null,Null,'GetFieldActionSRTs',resp.getStatus(),'code','toolid','Guidanz',NULL,'SRT'));
        }
        
        if(lstsrt.size() > 0) {
            Database.insert(lstsrt, false);
            system.debug('srt-->'+lstsrt);
        }
    }
    
    public static void updatePerformed(list<CSS_Solution_Component__c> CSSComp) {
        
        set<id> setCSSSolCompId = new set<id>();
        CSS_Solution_Component__c listSolComp;
        list<CSS_Solution_Component__c> lstNewCssSolution  = new list<CSS_Solution_Component__c>();
        list<FSL_Parts__c> lstParts = new list<FSL_Parts__c>();
        
        for(CSS_Solution_Component__c objCssSol: CSSComp) {
            setCSSSolCompId.add(objCssSol.id);
        }
        system.debug('css sol list'+setCSSSolCompId);
        for(FSL_Parts__c objFslPart : [Select id,Performed_Review__c,CSS_Solution_Component__r.Performed_Review__c,CSS_Solution_Component__r.FSL_Service_Order__r.Status,CSS_Solution_Component__r.FSL_Service_Job__c from FSL_Parts__c where CSS_Solution_Component__c in :setCSSSolCompId]){
            if(objFslPart.CSS_Solution_Component__r.FSL_Service_Order__r.Status !='Closed' && objFslPart.CSS_Solution_Component__r.FSL_Service_Order__r.Status !='Canceled'){
                objFslPart.Performed_Review__c  = objFslPart.CSS_Solution_Component__r.Performed_Review__c;
                lstParts.add(objFslPart);
            }
        }
        system.debug('check parts'+lstParts);
        if(lstParts != null  && lstParts.size() > 0) {
            update lstParts;
        }
    }
    
    //As part of CTE3-2
    public static void updateFACounts(list<CSS_Solution_Component__c> CSSComp) {
        try {
            System.debug('in updateFACounts method');
            Integer count=0;
            Id woId;
            for(CSS_Solution_Component__c objCssSol: CSSComp) {
                if(objCssSol.Type__c=='TRP' || objCssSol.Type__c=='ATC' || objCssSol.Type__c=='CAMPAIGN'){
                    woId = objCssSol.FSL_Service_Order__c;
                }
            }
            if(woId != null) {
                List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>([SELECT Id,Performed_Review__c,Performed__c,Type__c,FSL_Service_Order__c FROM CSS_Solution_Component__c 
                                                                                                   WHERE (Type__c='TRP' or Type__c='ATC' or Type__c='CAMPAIGN') and FSL_Service_Order__c =:woId]);
                for(CSS_Solution_Component__c solCompObj: solCompList) {
                    if(solCompObj.Performed_Review__c && !solCompObj.Performed__c) {
                        count++;
                    }
                }
                //Update WorkOrder with updated FA count
                WorkOrder objWO =[SELECT Id, FieldActionService_Failure_Flag__c
                                  FROM WorkOrder WHERE id=:woId ];
                //objWO.Required_To_Complete__c = count;
                objWO.FieldActionService_Failure_Flag__c = false;
                update objWO; //if infinite loop, add Static flag to check
                //system.debug('After update objWO Required_To_Complete__c--->'+objWO.Required_To_Complete__c);
            }
        } catch(Exception e) {
            system.debug('EXCEPTION of FSLFieldActionServices updateFACountsupdateFACounts method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    
    //Harsha started 07/08/20 added for 4cs correction notes
    public static void actionsfor4cs(List<Id> solutionIdList)  {
        List<CSS_Solution_Component__c> solutionList = new List<CSS_Solution_Component__c>();
        List<WorkOrder> workorderList = new List<WorkOrder>();
        solutionList = [SELECT Id, FSL_Service_Order__c, FSL_Service_Order__r.Field_Actions__c, Name, Campaign_Description__c 
                        FROM CSS_Solution_Component__c WHERE Id IN : solutionIdList];
        Map<Id,WorkOrder> idWOMap = new Map<Id,WorkOrder>();//05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
	for(CSS_Solution_Component__c cs : solutionList) {
	if(!idWOMap.containsKey(cs.FSL_Service_Order__c)){ //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
            workorder wo = new workorder();
            wo.Id = cs.FSL_Service_Order__c;
            String str = (cs.Name + '    ' + cs.Campaign_Description__c).replaceAll('<.*?>','');
            if(cs.FSL_Service_Order__r.Field_Actions__c == null) {
                wo.Field_Actions__c = str;
            }
            else {
                wo.Field_Actions__c = cs.FSL_Service_Order__r.Field_Actions__c + '\n' + str; 
            }
	idWOMap.put(cs.FSL_Service_Order__c,wo);//05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
            //workorderList.add(wo); //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
        }
	else{   //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
	workorder wo = idWOMap.get(cs.FSL_Service_Order__c); 
	String str = (cs.Name + '    ' + cs.Campaign_Description__c).replaceAll('<.*?>','');
        if(wo.Field_Actions__c == null) {
                wo.Field_Actions__c = str;
            }
            else {
                wo.Field_Actions__c = wo.Field_Actions__c + '\n' + str; 
		  }
	idWOMap.put(cs.FSL_Service_Order__c,wo);
	}
	}
/*if(workorderList != null && workorderList.size() > 0) {
            update workorderList;
        }*/       
	if(idWOMap!= null && !idWOMap.isEmpty()){
    update idWOMap.values();
	}
}   //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
public static void actionsfor4csforRemoval(List<Id> solutionIdRemList) {
        List<CSS_Solution_Component__c> solutionList = new List<CSS_Solution_Component__c>();
        List<WorkOrder> workorderList = new List<WorkOrder>();
        
        solutionList = [SELECT Id, FSL_Service_Order__c, FSL_Service_Order__r.Field_Actions__c, Name, Campaign_Description__c 
                        FROM CSS_Solution_Component__c WHERE Id IN : solutionIdRemList];
        Map<Id,WorkOrder> idWOMap = new Map<Id,WorkOrder>(); //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
        for(CSS_Solution_Component__c cs : solutionList) {
            if(!idWOMap.containsKey(cs.FSL_Service_Order__c)){ //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
                workorder wo = new workorder();
                wo.Id = cs.FSL_Service_Order__c;
                String strForRemove = (cs.Name + '    ' + cs.Campaign_Description__c).replaceAll('<.*?>','');
                system.debug('strForRemove**'+strForRemove);
                String strForOriginal = cs.FSL_Service_Order__r.Field_Actions__c;
                if(strForOriginal != null && strForOriginal.contains(strForRemove)) {   
                    if(strForOriginal.contains('\n')) { 
                        strForOriginal = strForOriginal.replace(strForRemove + '\n', '');   
                    }   
                    else {  
                        strForOriginal = strForOriginal.replace(strForRemove, '');  
                    }   
                    strForOriginal = strForOriginal.trim(); 
                    wo.Field_Actions__c = strForOriginal;   
                    //workorderList.add(wo);    //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
                    idWOMap.put(cs.FSL_Service_Order__c,wo);  //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
                }                
            }
            else{ //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
                workorder wo = idWOMap.get(cs.FSL_Service_Order__c);
                
                String strForRemove = (cs.Name + '    ' + cs.Campaign_Description__c).replaceAll('<.*?>','');
                system.debug('strForRemove**'+strForRemove);
                String strForOriginal = idWOMap.get(cs.FSL_Service_Order__c).Field_Actions__c;
                if(strForOriginal != null && strForOriginal.contains(strForRemove)) {   
                    if(strForOriginal.contains('\n')) { 
                        strForOriginal = strForOriginal.replace(strForRemove + '\n', '');   
                    }   
                    else {  
                        strForOriginal = strForOriginal.replace(strForRemove, '');  
                    }   
                    strForOriginal = strForOriginal.trim(); 
                    wo.Field_Actions__c = strForOriginal;   
                    //workorderList.add(wo);   
                    idWOMap.put(cs.FSL_Service_Order__c,wo);
                }                
            }

        }
        /*if(workorderList != null && workorderList.size() > 0) {
           update workorderList;
        }*/   //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
        if(idWOMap != null && !idWOMap.isEmpty() && idWOMap.values().size() > 0){
            update idWOMap.values();
        }
    }  //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
    // Harsha ended 07/08/20
}