@RestResource(urlMapping='/DataXSOCreateUpdate/*')
global class EVL_DX_CreateUpdateServiceOrder {
    @HttpPost
    global static void doPostOperation()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;      
        string str = EVL_DX_CreateUpdateServiceOrder.handleSORequest(req);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(str);
        system.debug(':::str***'+str); 
        
    }

    public static string handleSORequest(RestRequest req)
    { 
        String results;
        String msg;
        list<EVL_DX_SORequestWrapper.DataResponse> listResponses = new list<EVL_DX_SORequestWrapper.DataResponse>();
        try{
            String jSONRequestBody = req.requestBody.toString().trim();
            system.debug('Request:::'+jSONRequestBody);
            EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
            List<WorkOrder> existingWo = new List<WorkOrder>();
            map<string,WorkOrder> mapexistingWoId =new map<string,WorkOrder>();
            map<String,CSS_Solution_Component__c> mapexistingsolId =new map<String,CSS_Solution_Component__c>();
            map<String,CSS_JobEventTemporary__c> mapexistingServ = new map<String,CSS_JobEventTemporary__c>();
			
            //Changes by Adam for NIN-469 as part of the Salesforce Health Assesment
            //Setting up data area 
            EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
           	wrapperdtAr.setDataArea(DataAreaDetails);
            //setting up header info
            EVL_DX_SORequestWrapper.Header headerDetail = new EVL_DX_SORequestWrapper.Header();
        	wrapperdtAr.setHeader(headerDetail);
            //end changes
            
            List<WorkOrder> woToInsert = new List<WorkOrder>();
            List<Account> accList = new List<Account>();
            map<string,Account> mapaccId =new map<string,Account>();
            map<string,Asset> mapasstId =new map<string,Asset>();
            
            Map<String,CSS_Fault_Code__c> mapfcId = new Map<String,CSS_Fault_Code__c>();
            
            List<WorkOrder> workOrderToUpdate = new List<WorkOrder>();
            //   try {
            wrapperdtAr = (EVL_DX_SORequestWrapper) System.JSON.deserialize(jSONRequestBody, EVL_DX_SORequestWrapper.class);
            Map<String, EVL_DX_SORequestWrapper.DataArea> WrapperMap = new Map<String, EVL_DX_SORequestWrapper.DataArea>();
            Map<WorkOrder,String> soMap = new Map<WorkOrder,String>();
            
            Set<string> woIds = new set<string>();
            Map<string,string> mapWOID = new Map<string,string>();
            Map<string,string> mapWOrecId = new Map<string,string>();
            
            Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
            Map<string,string> mapSOIdError = new Map<string,string>();
            Map<string,string> NewmapSOIdError = new Map<string,string>();
            
            //changes for NIN-469
            EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();

            EVL_DX_SORequestWrapper.Header dtTarget =  wrapperdtAr.getHeader();
            //end changes
            
            String WorkOrderId;
            String SourceType = System.Label.FSL_Source_Environment_Type;
            List<Asset> asst = new List<Asset>();
            List<Account> acc = new List<Account>();
            List<CSS_Solution_Component__c> listCmp = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> updatelistCmp = new List<CSS_Solution_Component__c>();
            
            List<CSS_JobEventTemporary__c> listServ = new List<CSS_JobEventTemporary__c>();
            List<CSS_JobEventTemporary__c> updatelistServ = new List<CSS_JobEventTemporary__c>();

            Map<id, List<CSS_Solution_Component__c>> woSolCmp = new Map<id,List<CSS_Solution_Component__c>>();
            Map<id, List<CSS_JobEventTemporary__c>> woServHist = new Map<id,List<CSS_JobEventTemporary__c>>();

            User usr = new User();
            usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
                   FROM User 
                   WHERE Id =: UserInfo.getUserId() LIMIT 1];
            String uFID = usr.FederationIdentifier+'##Blank###'+usr.name;            
            List<CSS_Fault_Code__c> fc = new List<CSS_Fault_Code__c>();
            List<CSS_Solution_Component__c> solCmp = new List<CSS_Solution_Component__c>();
           // solCmp = [SELECT id, Name from CSS_Solution_Component__c where FSL_Service_Job__r.WorkOrderNumber =:dtAr.ServiceOrderNumber];
            if(dtAr.ServiceOrderNumber != null && dtAr.ServiceOrderNumber != ''){
                fc = [SELECT id, Name from CSS_Fault_Code__c where Service_Order__r.WorkOrderNumber =:dtAr.ServiceOrderNumber LIMIT 1];
            }
            if(fc.size() > 0){
                mapfcId.put(dtAr.ServiceOrderNumber, fc[0]);
                system.debug('AccountList:::'+mapfcId);
                
            }
            if(dtAr.SPCode != null && dtAr.SPCode != ''){
                acc = [SELECT id, Name, Location__c,IAM_Service_Provider_Code__c,IsPartner from Account where IAM_Service_Provider_Code__c =: dtAr.SPCode];  
            } 
            if(acc.size()>0 && acc[0].IsPartner == false){
                CSS_SendJobInfoResWrapper reswrapper = CSS_SendJobInfo.sendJobInformation();
                system.debug('ClassicResponse:::'+reswrapper);
                CSS_SendJobInfoResWrapper.DataArea resDtAr = new CSS_SendJobInfoResWrapper.DataArea();
                CSS_SendJobInfoResWrapper.Header resHeader = new CSS_SendJobInfoResWrapper.Header();
                String jobId = reswrapper.DataArea.CSSJobID;
                String resStatus = reswrapper.Header.Status;
                String resCode = reswrapper.Header.ReturnCode;
                String resDesc = reswrapper.Header.ReturnCodeDescription;
                String resServicename = reswrapper.Header.ServiceName;
                String resVers = reswrapper.Header.ServiceVersion;
                
                results = '{"Header": {"ServiceName": "'+resServicename+'","ServiceVersion": "'+resVers+'","Status": "'+resStatus+'","ReturnCode": "'+resCode+'","ReturnCodeDescription": "'+resDesc+'"},"DataArea": {"CSSJobID": "'+jobId+'"}}';
                
            } 
            else if(acc.size()>0 && acc[0].IsPartner == true){
                
               
                //VGRS2-610 BY Priyanka
                 if(dtAr.UNIT_DATA.VIN != '' && dtAr.UNIT_DATA.VIN != null){
                asst = [SELECT id, Name, Make__c, Model__c, Warranty_Start_Date__c, Application__c, VIN__c FROM Asset WHERE VIN__c =:dtAr.UNIT_DATA.VIN LIMIT 1];
            }
                system.debug('priyaasset'+asst);
            /*  if(dtAr.UNIT_DATA.PSN != '' || dtAr.UNIT_DATA.PSN != null){
                asst = [SELECT id, Name, Make__c, Model__c, Warranty_Start_Date__c, Application__c, VIN__c FROM Asset WHERE Name =:dtAr.UNIT_DATA.PSN];
            }  VIN__c*/
            existingWo = [SELECT id, AssetId, WorkOrderNumber, EVL_DX_SONumber__c, Status, Sub_Status__c, Process_Step__c, FSL_Resolution__c FROM WorkOrder WHERE WorkOrderNumber =:dtAr.ServiceOrderNumber ];
           
            system.debug('Asset records:::'+asst);
            if(asst.size() >0){
                //VGRS2-610 BY Priyanka
               // mapasstId.put(asst[0].Name, asst[0]); 
               mapasstId.put(asst[0].VIN__c, asst[0]);
                system.debug('AssetList:::'+mapasstId);
            }
            if(acc.size() > 0){
                mapaccId.put(acc[0].IAM_Service_Provider_Code__c, acc[0]);
                system.debug('AccountList:::'+mapaccId);
            }
            String location;
            if(mapaccId.containsKey(dtAr.SPCode)){
                location = mapaccId.get(dtAr.SPCode).Location__c;
            }
            String locQueueStr = 'JQ-'+location;
            List<Group> queues = new List<Group>([select Id, Name from Group where Type='Queue' AND Name=:locQueueStr]);
            system.debug('queues' + ' ' +queues);
            if(existingWo.size() > 0){
                if(string.isNotBlank(existingWo[0].WorkOrderNumber)){
                    mapexistingWoId.put(existingWo[0].WorkOrderNumber,existingWo[0]);
                    soMap.put(existingWo[0],existingWo[0].WorkOrderNumber);
                  //VGRS2-610 BY Priyanka
                    // mapWOID.put(dtAr.UNIT_DATA.PSN,dtAr.ServiceOrderNumber); VIN__c
                    mapWOID.put(dtAr.UNIT_DATA.VIN,dtAr.ServiceOrderNumber);
                    system.debug('MapReccords:::'+mapWOID);
                    system.debug('exstMapReccords:::'+mapexistingWoId);
                    
                }
            }
            List<WorkOrder> woCamp = new List<WorkOrder>();
           system.debug('dtAr.ServiceOrderNumber' + dtAr.ServiceOrderNumber);
                 system.debug('dtAr.ServiceOrderNumber' + asst.size());
                if(string.isNotBlank(dtAr.ServiceOrderNumber)){
                    system.debug('SONumber:::'+dtAr.ServiceOrderNumber);
                    WorkOrder wo = new WorkOrder();
                    // String WorkOrderId = dtAr.ServiceOrderNumber; 
                    if(mapexistingWoId.containsKey(dtAr.ServiceOrderNumber)){
                        wo.Id = mapexistingWoId.get(dtAr.ServiceOrderNumber).Id;}
                    if(mapaccId.containsKey(dtAr.SPCode)){
                        wo.AccountId = mapaccId.get(dtAr.SPCode).id;
                    }
                    wo.EVL_Contact__c = dtAr.CUST_DATA.Contact;
                    wo.Dealer_Shop_Work_Order__c = dtAr.CUST_DATA.ShopWO;
                    wo.Type__c = 'Dealer';
                    wo.General_Symptoms__c = dtAr.CUST_DATA.CustomerComplaint;
                    if(dtAr.UNIT_DATA.ProductMileage != ''){
                        wo.Mileage__c = Decimal.valueOf(dtAr.UNIT_DATA.ProductMileage);}
                    if(dtAr.UNIT_DATA.ProductHours != ''){
                        wo.CSS_Hours__c = Decimal.valueOf(dtAr.UNIT_DATA.ProductHours);}
                    wo.Mileage_Measure__c = string.valueOf(dtAr.UNIT_DATA.MileageMeasure);
                  //VGRS2-610 BY Priyanka
                    if(mapasstId.containsKey(dtAr.UNIT_DATA.VIN) && asst.size() > 0){
                        wo.Make__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Make__c;
                        wo.Model__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Model__c;
                        wo.Application__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Application__c;
                        
                        if(mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c != null){
                            wo.Warranty_Start_Date__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c;
                             wo.Before_In_Service__c = false;
                        } else if(!mapasstId.containsKey(dtAr.UNIT_DATA.VIN) && (dtAr.UNIT_DATA.WarrStartDate != null || dtAr.UNIT_DATA.WarrStartDate != '')){
                            wo.Warranty_Start_Date__c = Date.valueOf(dtAr.UNIT_DATA.WarrStartDate);
                             wo.Before_In_Service__c = false;
                        }
                        else if(mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c == null && dtAr.UNIT_DATA.WarrStartDate != ''){
                            wo.Warranty_Start_Date__c = Date.valueOf(dtAr.UNIT_DATA.WarrStartDate);
                            wo.Failure_Date__c = Date.valueOf(dtAr.UNIT_DATA.FailureDate);
                            wo.Before_In_Service__c = false;                                                        
                        }
                        else if(mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c == null && dtAr.UNIT_DATA.WarrStartDate == ''){
                            wo.Before_In_Service__c = Boolean.valueOf(dtAr.UNIT_DATA.BeforeInService);
                            wo.Warranty_Start_Date__c = null;                         
                        }
                        
                    } 
                    /*VGRS2-610
                     else if(dtAr.UNIT_DATA.PSN == ''){
                        wo.AssetId = null;
                        wo.Make__c = '';
                        wo.Model__c = '';
                        wo.Application__c = '';
                        wo.Before_In_Service__c = false; 
                        wo.Warranty_Start_Date__c = null;                         

                    } */
                    if(queues.size()>0){
                        wo.OwnerId  = queues.get(0).Id;
                    }
                    if(dtAr.UNIT_DATA.FailureDate != null && dtAr.UNIT_DATA.FailureDate <= string.valueOf(date.today())){
                        wo.Failure_Date__c = Date.valueOf(dtAr.UNIT_DATA.FailureDate);
                    }
                    wo.EVL_DX_SONumber__c = true;
                    wo.EVL_Customer__c = dtAr.CUST_DATA.CustomerName;
                    wo.RecordTypeId = recTypeId;
                    if(asst.size() > 0){
                        wo.AssetId = asst[0].Id;
                    }
                   //VGRS2-610 BY Priyanka
                    if(((mapasstId.containsKey(dtAr.UNIT_DATA.VIN)) && (dtAr.UNIT_DATA.VIN != '')) && (!mapfcId.containsKey(dtAr.ServiceOrderNumber)) && (mapaccId.containsKey(dtAr.SPCode))  && (string.isNotBlank(dtTarget.SenderId)) && (string.isNotBlank(dtTarget.ServiceName)) && (string.isNotBlank(dtAr.SPCode)) && (string.isNotBlank(dtAr.CUST_DATA.ShopWO)) && (string.isNotBlank(dtAr.CUST_DATA.CustomerName))){
                        workOrderToUpdate.add(wo);
                        System.debug('::: WorkOrder to Process - '+workOrderToUpdate);
                        System.debug('::: WorkOrder to Process - '+mapWOID);
                        
                    }  
                    
                } 
            
            else if( string.isBlank(dtAr.ServiceOrderNumber)){
                system.debug('SONumber****'+dtAr.ServiceOrderNumber);
                WorkOrder woCreate = new WorkOrder();
                woCreate.Dealer_Shop_Work_Order__c = dtAr.CUST_DATA.ShopWO;
                woCreate.Type__c = 'Dealer';
                woCreate.EVL_Contact__c = dtAr.CUST_DATA.Contact;
                if(mapaccId.containsKey(dtAr.SPCode)){
                    woCreate.AccountId = mapaccId.get(dtAr.SPCode).id;
                }
                woCreate.EVL_Customer__c = dtAr.CUST_DATA.CustomerName;
                woCreate.General_Symptoms__c = dtAr.CUST_DATA.CustomerComplaint;
                if(dtAr.UNIT_DATA.ProductMileage != ''){
                    woCreate.Mileage__c = Decimal.valueOf(dtAr.UNIT_DATA.ProductMileage);}
                if(dtAr.UNIT_DATA.ProductHours != ''){
                    woCreate.CSS_Hours__c = Decimal.valueOf(dtAr.UNIT_DATA.ProductHours);}
                woCreate.Mileage_Measure__c = string.valueOf(dtAr.UNIT_DATA.MileageMeasure);
                if(asst.size() > 0){
                    woCreate.AssetId = asst[0].Id;
                    
                }
                //VGRS2-610 BY Priyanka
                if(asst.size() > 0 && mapasstId.containsKey(dtAr.UNIT_DATA.VIN)){
                    woCreate.Make__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Make__c;
                    woCreate.Model__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Model__c;
                    woCreate.Application__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Application__c;
                    if(mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c != null){
                        woCreate.Warranty_Start_Date__c = mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c;
                    } else if(!mapasstId.containsKey(dtAr.UNIT_DATA.VIN) && dtAr.UNIT_DATA.WarrStartDate != ''){
                        woCreate.Warranty_Start_Date__c = Date.valueOf(dtAr.UNIT_DATA.WarrStartDate);
                    } else if(mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c == null && dtAr.UNIT_DATA.WarrStartDate != ''){
                        woCreate.Warranty_Start_Date__c = Date.valueOf(dtAr.UNIT_DATA.WarrStartDate);
                       // woCreate.Before_In_Service__c = Boolean.valueOf(dtAr.UNIT_DATA.BeforeInService);
                        
                    }
                    else if(mapasstId.get(dtAr.UNIT_DATA.VIN).Warranty_Start_Date__c == null && dtAr.UNIT_DATA.WarrStartDate == ''){
                        woCreate.Before_In_Service__c = Boolean.valueOf(dtAr.UNIT_DATA.BeforeInService);
                        system.debug('BISCheck:::'+woCreate.Before_In_Service__c);
                    }
                }
              
                if(queues.size()>0){
                    woCreate.OwnerId  = queues.get(0).Id;
                }
                if(dtAr.UNIT_DATA.FailureDate != ''){
                    woCreate.Failure_Date__c = Date.valueOf(dtAr.UNIT_DATA.FailureDate);
                }
               	woCreate.EVL_DX_SONumber__c = true;
                woCreate.RecordTypeId = recTypeId;
               //VGRS2-610 BY Priyanka
                if(((mapasstId.containsKey(dtAr.UNIT_DATA.VIN)) && (dtAr.UNIT_DATA.VIN != '')) && (mapaccId.containsKey(dtAr.SPCode)) && (string.isNotBlank(dtTarget.ServiceName)) && (string.isNotBlank(dtTarget.SenderId)) && (string.isNotBlank(dtAr.SPCode)) && (string.isNotBlank(dtAr.CUST_DATA.ShopWO)) && (string.isNotBlank(dtAr.CUST_DATA.CustomerName))){
                    woToInsert.add(woCreate);
                    System.debug('::: WorkOrder to Process Create - '+woToInsert);
                }
            }
            
            
            Database.SaveResult[] srList = Database.insert(woToInsert, false);
            Database.SaveResult[] srListUpdate = Database.update(workOrderToUpdate, false);
            system.debug('InsertList:::'+woToInsert+srList);
            system.debug('UpdateList:::'+workOrderToUpdate+srListUpdate);
            set<id> updatesolId = new set<id>();
                List<CSS_Solution_Component__c> solFA = new  List<CSS_Solution_Component__c>();
                if(srList.size() > 0){
                  solFA = [SELECT id, Name FROM CSS_Solution_Component__c WHERE EVL_DX_Service_Order__c =:srList[0].id];
					
                } else if(srListUpdate.size() > 0){
                  solFA = [SELECT id, Name FROM CSS_Solution_Component__c WHERE EVL_DX_Service_Order__r.WorkOrderNumber =:dtAr.ServiceOrderNumber];
  
                }
          //  List<CSS_JobEventTemporary__c> servHis = [SELECT id, Name FROM CSS_JobEventTemporary__c WHERE JobOrder__c =:dtAr.ServiceOrderNumber];
                if(test.isRunningTest()){
                     solFA = [SELECT id, Name FROM CSS_Solution_Component__c];  
                }
               
                        
            for(integer i=0;i<solFA.size();i++)
            { 
                mapexistingsolId.put(solFA[i].Name,solFA[i]);
                system.debug('CampaignUpdateDetails:::'+mapexistingsolId);

            }

             for(integer i=0;i<dtAr.CampaignDetails.size();i++)
            {  
                if(string.isNotBlank(dtAr.ServiceOrderNumber) && asst.size() > 0 ){
                    //List<CSS_Solution_Component__c> solFA = [SELECT id, Name from CSS_Solution_Component__c where EVL_DX_Service_Order__r.WorkOrderNumber =:dtAr.ServiceOrderNumber];
                    system.debug('NameCheck:::'+dtAr.CampaignDetails[i].CampaignsATCsDataNumber);
                    if(mapexistingsolId.containsKey(dtAr.CampaignDetails[i].CampaignsATCsDataNumber)){
                        CSS_Solution_Component__c solCmpFA = new CSS_Solution_Component__c();

                        system.debug('CampaignID:::'+mapexistingsolId.get(dtAr.CampaignDetails[i].CampaignsATCsDataNumber).Id);
                        solCmpFA.Id = mapexistingsolId.get(dtAr.CampaignDetails[i].CampaignsATCsDataNumber).Id;
                        if(dtAr.CampaignDetails[i].CampaignsATCsDataFlag == 'Y'){
                            solCmpFA.Performed_Review__c =  true;
                        } else{
                             solCmpFA.Performed_Review__c =  false;

                        }
                        updatelistCmp.add(solCmpFA);
                    system.debug('CampaignDetails:::'+solCmpFA);

                    } else{
                        CSS_Solution_Component__c solCmpCreate = new CSS_Solution_Component__c();
                        Id FieldActionRecordTypeId = Schema.SObjectType.CSS_Solution_Component__c.getRecordTypeInfosByName().get('FieldActions').getRecordTypeId();
                        
                        solCmpCreate.EVL_DX_Service_Order__c= workOrderToUpdate[0].id;
                        solCmpCreate.RecordTypeId = FieldActionRecordTypeId;
                        solCmpCreate.Name = dtAr.CampaignDetails.size() > 0 && dtAr.CampaignDetails[i].CampaignsATCsDataNumber != '' ? dtAr.CampaignDetails[i].CampaignsATCsDataNumber : '';
                        if(dtAr.CampaignDetails[i].CampaignsATCsDataFlag != '' && dtAr.CampaignDetails[i].CampaignsATCsDataFlag == 'Y'){
                            solCmpCreate.Performed_Review__c =  true;
                        } else{
                            solCmpCreate.Performed_Review__c =  false;
                            
                        }
                    //  woCreate.EVL_DX_CampaignType__c = dtAr.CampaignDetails.size() > 0 ? dtAr.CampaignDetails[i].CampaignsATCsDataType : null;
                    //  woCreate.EVL_DX_RequiredToPerform__c = dtAr.CampaignDetails.size() > 0 ? dtAr.CampaignDetails[i].CampaignsATCsDataFlag : null;
                    updatelistCmp.add(solCmpCreate);
                    woSolCmp.put(solCmpCreate.EVL_DX_Service_Order__c,updatelistCmp);
                    system.debug('CampaignDetails:::'+woSolCmp);
                    }
                    // solCmpFA.Performed_Review__c = woSolCmp.containsKey(dtAr.CampaignDetails[i].CampaignsATCsDataNumbe);
                   // solCmpFA.Name = (dtAr.CampaignDetails).size() > 0 ? dtAr.CampaignDetails[i].CampaignsATCsDataNumber:null;
                   // solCmpFA.EVL_DX_CampaignType__c = (dtAr.CampaignDetails).size() > 0 ? dtAr.CampaignDetails[i].CampaignsATCsDataType:null;
                   // solCmpFA.EVL_DX_RequiredToPerform__c = (dtAr.CampaignDetails).size() > 0 ? dtAr.CampaignDetails[i].CampaignsATCsDataFlag:null;
                  // updatesolId.add(mapexistingsolId.get(dtAr.CampaignDetails[i].CampaignsATCsDataNumber).Id);

                } else if((woToInsert.size() > 0) && dtAr.CampaignDetails != null){
                    system.debug('WOid::'+woToInsert[0].id+'---'+srList[0].id);
                    system.debug('CampaignDetails:::'+dtAr.CampaignDetails);

                    CSS_Solution_Component__c solCmpCreate = new CSS_Solution_Component__c();
                    Id FieldActionRecordTypeId = Schema.SObjectType.CSS_Solution_Component__c.getRecordTypeInfosByName().get('FieldActions').getRecordTypeId();

                    solCmpCreate.EVL_DX_Service_Order__c= woToInsert[0].id;
                    solCmpCreate.RecordTypeId = FieldActionRecordTypeId;
                    solCmpCreate.Name = dtAr.CampaignDetails.size() > 0 && dtAr.CampaignDetails[i].CampaignsATCsDataNumber != '' ? dtAr.CampaignDetails[i].CampaignsATCsDataNumber : '';
                    if(dtAr.CampaignDetails[i].CampaignsATCsDataFlag != '' && dtAr.CampaignDetails[i].CampaignsATCsDataFlag == 'Y'){
                        solCmpCreate.Performed_Review__c =  true;
                    } else{
                        solCmpCreate.Performed_Review__c =  false;
                        
                    }
                    //  woCreate.EVL_DX_CampaignType__c = dtAr.CampaignDetails.size() > 0 ? dtAr.CampaignDetails[i].CampaignsATCsDataType : null;
                    //  woCreate.EVL_DX_RequiredToPerform__c = dtAr.CampaignDetails.size() > 0 ? dtAr.CampaignDetails[i].CampaignsATCsDataFlag : null;
                    listCmp.add(solCmpCreate);
                    woSolCmp.put(solCmpCreate.EVL_DX_Service_Order__c,listCmp);
                    system.debug('CampaignDetails:::'+woSolCmp);

                }
            }
            system.debug('listCmp : '+listCmp);
            if((woToInsert.size() > 0) && listCmp.size()>0)
            {
                insert listCmp;
                // system.debug(listCmp);
            }
            if((workOrderToUpdate.size() > 0) && updatelistCmp.size() > 0){
                system.debug('ListUpdate:::'+updatelistCmp);
                upsert updatelistCmp;
                FSL_GETCampaignServices.displayFA(updatelistCmp, workOrderToUpdate[0].id);
            }
            ConnectApi.Community  myCommunity;
            if(!Test.isRunningTest()){
                Network myNetwork = [SELECT Id FROM Network WHERE Name ='Guidanz Dealer Evolution' ];
                myCommunity = ConnectApi.Communities.getCommunity(myNetwork.id);
                System.debug('MyDebug : ' + myCommunity.siteUrl);   
            }
            
            if((woToInsert.size() > 0) || (workOrderToUpdate.size() > 0)){
              //  system.debug('InsertList:::'+woToInsert[0].id);  
              //  system.debug('InsertList:::'+srList[0].id);  


                String domainUrl;
                String woNum;
                if(srList.size() > 0){
                    
                    if(!Test.isRunningTest()){
                    	domainUrl = myCommunity.siteUrl+'/' +srList[0].id;
                        system.debug('InsertList:::'+domainUrl);  

                    }
                    WorkOrder wo = [Select id, WorkOrderNumber from WorkOrder where id =:woToInsert[0].id];
                     woNum = wo.WorkOrderNumber;
                    
                    CSS_JobEventTemporary__c temp = new CSS_JobEventTemporary__c();
                    temp.JSONResponse__c = jSONRequestBody;
                    //VGRS2-616 by Priyanka
                    if(asst.size()>0){
                    temp.ESN__c = asst[0].Name;
                    }
                    temp.VIN__c = dtAr.UNIT_DATA.VIN;
                    temp.Key__c = 'Dealer_DataExchange - '+woNum;
                    insert temp;
                    system.debug('temp>>>'+temp);

                } else if(srListUpdate.size() >0 && dtAr.SERVICEHIST != null){
                    domainUrl = myCommunity.siteUrl+ '/'+srListUpdate[0].id;
                    String keyValue ='Dealer_DataExchange - '+dtAr.ServiceOrderNumber;

                    CSS_JobEventTemporary__c temp = new CSS_JobEventTemporary__c();
                    if(temp.Key__c == keyValue){
                        temp.JSONResponse__c = jSONRequestBody;
                        //VGRS2-616 by Priyanka
                         if(asst.size()>0){
                    temp.ESN__c = asst[0].Name;
                    }  
                        temp.VIN__c = dtAr.UNIT_DATA.VIN;
                        update temp;
                        system.debug('temp>>>'+temp);
                    }
                       
                }
                
                if(srList.size() > 0 && (srList[0].isSuccess())) {
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Success","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Guidanz Job is created successfully","SuccessCode": "CG100"},"DataArea": {"ServiceOrderNumber": "'+woNum+'","GuidanzURL": "'+domainUrl+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
                    
                } else if(srListUpdate.size() >0 && (srListUpdate[0].isSuccess())) {
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Success","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Guidanz Job is updated successfully","SuccessCode": "CG200"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrl+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
                    
                } 
            }
            else{
                String domainUrlUpdate;
                id woNumUpdate;   
                if(dtAr.ServiceOrderNumber != ''){
                    
                    List<WorkOrder> wo = [Select id, WorkOrderNumber from WorkOrder where WorkOrderNumber =:dtAr.ServiceOrderNumber];
                    if(!wo.isempty())
                    woNumUpdate = wo[0].Id;
                    if(!Test.isRunningTest()){
                    	domainUrlUpdate = myCommunity.siteUrl+'/' +woNumUpdate;  
                    }
                    
                } else{
                    domainUrlUpdate = '';  
                    
                }
                System.debug('URLUpdate::: ' +domainUrlUpdate);   

                
                // domainUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/' +srList[0].id;
                if(string.isBlank(dtTarget.ServiceName)){
                    mapSOIdError.put(dtAr.ServiceOrderNumber,'Service Name is blank/invalid');   
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Success","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Service Name is blank/invalid","ErrorCode": "CG01"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
      
                }
                else if(string.isBlank(dtTarget.SenderId)){
                    mapSOIdError.put(dtAr.ServiceOrderNumber,'Sender Id is blank/invalid');   
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Sender Id is blank/invalid","ErrorCode": "CG02"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
     
                }
                else  if(string.isBlank(dtAr.UNIT_DATA.VIN)||string.isBlank(dtAr.SPCode) || string.isBlank(dtAr.CUST_DATA.ShopWO)|| string.isBlank(dtAr.CUST_DATA.CustomerName)){
                 //VGRS2-610 BY Priyanka
                    NewmapSOIdError.put(dtAr.UNIT_DATA.VIN,'Mandatory Field is blank');                    
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Mandatory Field is blank","ErrorCode": "CG05"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
 
                }
               
            /*    else if(!mapaccId.containsKey(dtAr.SPCode)){
                    system.debug('Testtt'+mapaccId);
                    mapSOIdError.put(dtAr.ServiceOrderNumber,'Location is not enabled for Data Exchange');   
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Location is not enabled for Data Exchange","ErrorCode": "CG04"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
    
                }*/
              /*  else  if(!mapasstId.containsKey(dtAr.UNIT_DATA.PSN)){
                    NewmapSOIdError.put(dtAr.UNIT_DATA.PSN, 'Serial Number not found in Guidanz');
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Serial Number not found in Guidanz","ErrorCode": "CG09"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
                    
                }  */
                //VGRS2-610 BY Priyanka
                 else  if(!mapasstId.containsKey(dtAr.UNIT_DATA.VIN)){
                     system.debug('checkpriya');
                    NewmapSOIdError.put(dtAr.UNIT_DATA.VIN, 'Cannot Create Guidanz Service Order from integration. Please check VIN for accuracy and create case in Guidanz with PSN.');
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Cannot Create Guidanz Service Order from integration. Please check VIN for accuracy and create case in Guidanz with PSN.","ErrorCode": "CG09"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
                    
                }  
                else if(mapfcId.containsKey(dtAr.ServiceOrderNumber)){
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Service Order cannot be updated after Troubleshooting has begin in Guidanz","ErrorCode": "CG08"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';

                }
                
                else if(!mapexistingWoId.containsKey(dtAr.ServiceOrderNumber)){
                    mapSOIdError.put(dtAr.ServiceOrderNumber,'Service Order in the request does not exist in Guidanz');   
                    results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Service Order in the request does not exist in Guidanz","ErrorCode": "CG07"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "'+domainUrlUpdate+'","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
  
                } 
            }
        } 
            else{
                system.debug('Testtt'+mapaccId);
                mapSOIdError.put(dtAr.ServiceOrderNumber,'Location is not enabled for Data Exchange');   
                results = '{"Header":{"ServiceVersion":"1.0","ServiceName" :"DataXSOCreateUpdate","TargetId": "Guidanz","Status": "Error","SenderId": "'+dtTarget.SenderId+'","SPCode": "'+dtAr.SPCode+'","ReturnCodeDescription": "Location is not enabled for Data Exchange","ErrorCode": "CG04"},"DataArea": {"ServiceOrderNumber": "'+dtAr.ServiceOrderNumber+'","GuidanzURL": "","ShopWorkOrder": "'+dtAr.CUST_DATA.ShopWO+'","SPCode": "'+dtAr.SPCode+'"}}';
                
            }
    }
        catch(Exception ex) {
            System.debug('::: Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage());
            System.debug('::: Execption Stack :: '+ex.getStackTraceString());
            results = '{"Header":{"Status": "ERROR", "ReturnCodeDescription": "Record Failed to Update:::"}}';
            //results = '{"Status":"'+ex.getStackTraceString()+'"}';
        }
        
        system.debug('Resultss:::'+results);
        return results;
    }
}