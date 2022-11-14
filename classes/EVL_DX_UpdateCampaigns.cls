public class EVL_DX_UpdateCampaigns implements Queueable,Database.AllowsCallouts {
    list<CSS_Solution_Component__c> lstCssComp = new list<CSS_Solution_Component__c>();  
    String strWorkOrderId = '';  
	List<id> solCmp = new List<id>();
    public EVL_DX_UpdateCampaigns(List<id> CssComp) {  
        
        this.solCmp = CssComp;  
      //  this.strWorkOrderId = strWID ;
        
    }  
    public void execute(QueueableContext qc) { 
        system.debug('TestSRT:::');
       set<id> setCSSSolCompId = new set<id>();
        CSS_Solution_Component__c listSolComp;
        list<CSS_Solution_Component__c> lstNewCssSolution  = new list<CSS_Solution_Component__c>();
        if(solcmp != null) {
            system.debug('List:::'+solCmp[0]);
          /*  lstNewCssSolution = (List<CSS_Solution_Component__c>)JSON.deserialize(solCmp[0], List<CSS_Solution_Component__c>.class);
            for(CSS_Solution_Component__c objCssSol: lstNewCssSolution ){
                setCSSSolCompId.add(solCmp[0]);
            }
            system.debug('check set'+setCSSSolCompId);*/
            //setCSSSolCompId.add(solCmp);
            fieldactionsrtwebservices(solCmp);
        }
    }
    
     public static  void  fieldactionsrtwebservices(List<id> CSScompId) {
        system.debug('compid--->' + CSScompId);
        FSLfieldactionRequest lstwarrequest = new FSLfieldactionRequest();
        List<CSS_Solution_Component__c> listSolComp = new List<CSS_Solution_Component__c>();
        if(!CSScompId.isempty()){
            try{
            listSolComp = [SELECT Id, Type__c, Component_Id__c, System_Code__c, Component_Code__c, AccountCode__c, 
                           FSL_Service_Order__c, FSL_Service_Order__r.ServiceTerritory.Location_Code__c, FSL_Service_Order__r.Application__c, 
                           FSL_Service_Order__r.Asset.Name, FSL_Service_Order__r.Failure_Date__c, FSL_Service_Order__r.Mileage__c, 
                           FSL_Service_Order__r.Mileage_Measure__c, FSL_Service_Order__r.Warranty_Start_Date__c, FSL_Service_Order__r.Asset.Service_Model__c, 
                           FSL_Service_Order__r.Asset.Equipment_Id__c, FSL_Service_Order__r.Asset.Engine_Family_Code__c 
                           FROM CSS_Solution_Component__c WHERE Id IN: CSScompId]; 
                system.debug('InsideTryTestList:::'+listSolComp);

            }
            catch(exception e){
                system.debug('TestList:::'+listSolComp);
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
         
        if(listSolComp != null){
        fsldata.ServiceModelName = listSolComp[0].FSL_Service_Order__r.Asset.Service_Model__c;
        fsldata.EquipmentID = listSolComp[0].FSL_Service_Order__r.Asset.Equipment_Id__c;
        fsldata.EngineFamilyCode = listSolComp[0].FSL_Service_Order__r.Asset.Engine_Family_Code__c;
    }
        fsldata.Language = 'en';
        
        fsldata.EffectiveDTTime = effDtSTamp;
        fsldata.DTTimestamp = dtStamp;
        system.debug('Timestamp'+fsldata.DTTimestamp);
        system.debug('EffectiveDTTime'+fsldata.EffectiveDTTime);
        
        List<FSLfieldactionRequest.cls_FieldAction> fslfdLst = new List<FSLfieldactionRequest.cls_FieldAction>();
         Map<String, Id> solCmpMap = new Map<String, Id>();
        if(listSolComp != null){
            for(CSS_Solution_Component__c updateSol: listSolComp){
                FSLfieldactionRequest.cls_FieldAction fslfd = new FSLfieldactionRequest.cls_FieldAction();
                solCmpMap.put(updateSol.Component_Id__c, updateSol.Id);
                fslfd.FieldActionType = updateSol.Type__c;
                fslfd.FieldActionNumber = updateSol.Component_Id__c;
                fslfdLst.add(fslfd);
               
            }
        }
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
         system.debug('ListTocheck:::'+listSolComp);
        if(listSolComp != null)
        insertfslSRT(jsonreq, listSolComp[0].FSL_Service_Order__r.Id, solCmpMap );
    }
    
    
    public static void insertfslSRT(string jsonreq, Id CSScompId, Map<String, Id> CmpMap) {
        
        List<FSLFieldActionswrapper> fslCDSResps = new list<FSLFieldActionswrapper>();
        Id FieldActionRecordTypeId = Schema.SObjectType.CSS_Solution_Component__c.getRecordTypeInfosByName().get('FieldActions').getRecordTypeId();

        List<CSS_Solution_Component__c> lstsolUpdateCmp = [SELECT id, Name,RecordTypeId,FSL_Service_Order__c,FSL_Service_Job__c,Failure_Mode__c,
                                                           FailCode__c, Type__c, Component_Id__c,Complete_Indicator__c,In_Shop_SRT_Limit_Flag__c,Multiple_Times__c,
                                                           Status__c, Business_Unit__c, Campaign_Start_Date__c, Campaign_End_Date__c,Campaign_Description__c
                                                           FROM CSS_Solution_Component__c WHERE FSL_Service_Order__c =: CSScompId AND RecordTypeId =:FieldActionRecordTypeId ];
        HttpResponse res;
        HttpRequest req;
        String tokenStr2;
        string endPoint;
        Integer timeout;
        String method;
        //commented below lines to use the mule version of calling mechanism -by vinod 8/31
        /*Http h = new Http();
        String reqBody = jsonreq;
        system.debug('Request body'+reqBody);
        req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(100000);
        req.setBody(reqBody);
        req.setEndpoint(endPoint);
        String authorizationHeader = 'Bearer ' + FSL_WS_OAG.getAccessToken();
        req.setHeader('Authorization', authorizationHeader);
        system.debug('reqreqreq:::' + req);
        res = h.send(req);*/
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('CG_FieldActionSRT');
        if(!Test.isRunningTest()) {
            endPoint = conDetails.End_Point__c;
            timeout = Integer.valueOf(conDetails.Timeout__c);
            method = conDetails.Method_Type__c;
        } 
        else {
            endPoint = 'https://services-stg.cummins.com/csswarranty/srtfieldactions';
        }
        //changed method signature to make use of newer mule & return type. - mule4 changes 8/31 by vinod
        CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CG_FieldActionSRT',endPoint, method, jsonreq, timeout);                
        CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
        res = outputWrapper.response;//Ends mule changes
        req = outputWrapper.request; // Added:Charan CT3-404
        String responseBody='';
        if(Test.isRunningTest())
            responseBody = '{   "Header":{     "Status":"SUCCESS",     "ReturnCode":"ORA-00000",     "ReturnCodeDescription":"Normal, Successful completion.",     "MessageIdentifier":"debc5930-3a95-4420-bb8c-2695f4398614",     "MessageType":"S"   },   "DataArea":{     "FieldAction":[       {         "FieldActionNumber":"2189",         "FieldActionType":"CAMPAIGN",         "FieldActionSRTTime":[           {             "S7TIME":0,             "SRTDetails":"00-901-00",             "SRTAccessCode":"B",             "S6DESCRIPTION":"","S9DESCRIPTION":"","BTIME":0.4,"S2TIME":0,"CTIME":0,"S2DESCRIPTION":"","S8TIME":0,"Assignment":"ALTERNATIVE","S5DESCRIPTION":"","S6TIME":0,"S3TIME":0,"S8DESCRIPTION":"","SRTTime":0.4,"S1DESCRIPTION":"","StepDescription":"Note: Also applies to repairs performed on lots or aprons immediately adjacent to a shop operated by the repairing location.  Note: Use 00-902 if travel is required to vehicle  Includes:   -Clock on and clock off the job  -Move equipment to and from work area  -Record engine and equipment identification  numbers  -Record the following:  . Mileage or hours of operation  . CPL number  . Fuel pump code  -Move tool box to and from work area  -Clean up work area and write up repair order  at end of each shift and when job has been  completed","S4DESCRIPTION":"","SRTQuantity":1, "QuoteID":331510, "S4TIME":0, "SRTTitle":"Administrative Time - Open and Close Repair Order (Shop Repairs)", "SRTMessage":"", "StepID":19502, "DTIME":0, "S3DESCRIPTION":"", "RTIME":0.4, "ATIME":0, "S7DESCRIPTION":"", "S1TIME":0, "S5TIME":0, "S9TIME":0           },           { "S7TIME":0, "SRTDetails":"00-902-00", "SRTAccessCode":"B", "S6DESCRIPTION":"", "S9DESCRIPTION":"", "BTIME":0.7, "S2TIME":0, "CTIME":0, "S2DESCRIPTION":"", "S8TIME":0, "Assignment":"ALTERNATIVE", "S5DESCRIPTION":"", "S6TIME":0, "S3TIME":0, "S8DESCRIPTION":"", "SRTTime":0.7, "S1DESCRIPTION":"", "StepDescription":"Note: This SRT applies when travel is covered and the repair is performed away from the shop operated by the repairing location to include work in a customer or dealer shop by a distributor or branch technician.  Includes:   -Clock on and clock off the job  -Move equipment to and from work area   -Record the following:   . Engine serial number  . Equipment identification number  . Hours of operation  . CPL number  . Fuel pump code  -Load and unload any special tools, equipment  and parts necessary for the repair  -Clean up work area and write up repair order at  end of each shift and when job has been  completed", "S4DESCRIPTION":"", "SRTQuantity":1, "QuoteID":331510, "S4TIME":0, "SRTTitle":"Administrative Time - Open and Close Repair Order (Road Repairs)", "SRTMessage":"", "StepID":131376, "DTIME":0, "S3DESCRIPTION":"", "RTIME":0.7, "ATIME":0, "S7DESCRIPTION":"", "S1TIME":0, "S5TIME":0, "S9TIME":0           }         ]       }     ]   } }';
        else{
            system.debug('response checkk'+res.getBody());
            responseBody = res.getBody();
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
                            objSRT.Component_Id__c = CmpMap.get(objd.FieldActionNumber);
                            lstsrt.add(objSRT);
                        }
                    }
                }
            }
        }
        if(!Test.isRunningTest()){
           // String woID = listSolComp[0].FSL_Service_Order__c;
           // system.debug('responsess'+res.getStatus()); 
            System.enqueueJob( new FSL_UpdateQSOLlinks( lstsolUpdateCmp, CSScompId));

           // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'GetFieldActionSRTs',res.getStatus(),'code','toolid','Guidanz',NULL,'SRT'));
        }
        
        if(lstsrt.size() > 0) {
            Database.insert(lstsrt, false);
            system.debug('srt-->'+lstsrt);
        }
    }
    
}