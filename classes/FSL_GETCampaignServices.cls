/**********************************************************************
Name: FSL_GETCampaignServices
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This process is used to call Getcampaigndata web service on change of PSN inorderto get Field action number,type and desc.
This class we are calling call the Get warranty docs on change of asset after insertion of Fieldactions on Css Soltuion Components.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE             Detail                      
1.0     Ravikanth Macherla         5/21/2019         Initial Development 
2.0     Ravikanth Macherla         10/23/2019        Pilot+
3.0		  Diksha Rajpurohit		       07/15/2022        Migrate to Named Credentials for Get Campaigns
***********************************************************************/
public class FSL_GETCampaignServices { 
    @TestVisible static Boolean doCallout = true; // Bypasing the callout method in Test class
    public static Boolean isServiceFailed = false;
    //  public static boolean callQueueable = true;

    @future (callout = true)
    public static  void storeApplicationOrCategoryComplaintList(ID woID) {
                             executeFieldActionService(woID);
              }

    /*
     * This is a non future callout method for FieldActions webservice
     * As part of CT3-2
     * Author: Surender Madipeddi
     */
    public static void executeFieldActionService(ID woID) {
        try{
            system.debug('in executeFieldActionService-->'+woID );
             WorkOrder objWO =[SELECT Id, Asset.Name, Failure_Date__c, Formatted_Date__c, ServiceTerritory.Region__c,   
                              ServiceTerritory.Territory__c, FieldActionService_Failure_Flag__c     
                               FROM WorkOrder WHERE id=:woID ];//Comment By Sravanthi Gundreddy: removed Available_FAs_Count__c, Required_To_Complete__c fields from query beacuse of fieldactions issue we are deleting this two fields from object
            
            string strESN = objWO.Asset.Name;
            Date failureDate = objWO.Failure_Date__c ;
            string strRegion = objWO.ServiceTerritory.Region__c ;
            string strTerritory = objWO.ServiceTerritory.Territory__c;
            String strFdate = DateTime.newInstance(failureDate.year(),failureDate.month(),failureDate.day()).format('DD-MMM-YY'); //add date null check here
            // Preparing Request body and passing the parameters dynamically 
            FSLgetCampaignRequestwrap.Sender fslcamp = new FSLgetCampaignRequestwrap.Sender();
            fslcamp.ServiceName = 'GetCampaign';
            fslcamp.SenderID = 'CSS';
            fslcamp.MessageID = '';
            
            FSLgetCampaignRequestwrap.DataArea clsData = new FSLgetCampaignRequestwrap.DataArea();
            clsData.Territory = strTerritory ;
            clsData.Region = strRegion ;
            clsData.FailureDate = objWO.Formatted_Date__c; //strFdate; //add date null check here
            clsData.Esn = strESN ;
            
            FSLgetCampaignRequestwrap.Header fslhead = new FSLgetCampaignRequestwrap.Header();
            fslhead.Target = 'CSSWarranty';
            fslhead.Sender = fslcamp;
            
            FSLgetCampaignRequestwrap clswrp = new FSLgetCampaignRequestwrap();
            clswrp.DataArea = clsData;
            clswrp.Header = fslhead ;
            system.debug('***i just added debug for clswrp***'+clswrp);
            String jsonreq = JSON.serialize(clswrp);
            system.debug('***i just added debug for jsonreq***'+jsonreq);
            List<CSS_Solution_Component__c> solCompList = inserrtcsscomp(jsonreq,woID);
            system.debug('RequestBody--->'+jsonreq );
            
            //Updating WorkOrder with FA counts
            //objWO.Available_FAs_Count__c = solCompList !=null ? solCompList.size() : 0; LINE No:38    
            //objWO.Required_To_Complete__c = 0;Line no:38  
            if(isServiceFailed == true) {
                objWO.FieldActionService_Failure_Flag__c = isServiceFailed;
                update objWO; //if infinite loop, add Static flag to check
                RecursiveTriggerHandler.isUpdFSLFailureFlag =false;
                system.debug('After update objWO--->'+objWO);
            }
            /*else if(objWO.FieldActionService_Failure_Flag__c == true){ //ROAD-24, Added this line because of getting error System.CalloutException. 
                objWO.FieldActionService_Failure_Flag__c = false;
                update objWO; //if infinite loop, add Static flag to check
                system.debug('After update objWO--->'+objWO);                
            }*/
        }catch(Exception e)  {
            system.debug('EXCEPTION of FSL_GETCampaignServices executeFieldActionService method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    public static List<CSS_Solution_Component__c>  inserrtcsscomp(string jsonreq, Id Woid) {
        List<CSS_Solution_Component__c> lstSC;
        try{
        system.debug('calling FSL_GETCampaignServices in inserrtcsscomp-->'+Woid );
        lstSC = new List<CSS_Solution_Component__c>();
        isServiceFailed = false;

        DateTime startTime = System.Now();
        HttpRequest req;
        HttpResponse res;
        String tokenStr2;
        Http h = new Http();
        List<FSL_GETCampaignServiceswrapper> fslCDSResps = new list<FSL_GETCampaignServiceswrapper>();
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-DD')+'T00:00:00';
        String  dtStamp =currDate;
        String  effDtSTamp=currDate;
       String responseBody = '';//Initialised this to set different
        system.debug('ResponseBody--->'+jsonreq );
        // String reqBody = '{"Header":{"Target":"CSSWarranty","Sender":{"ServiceName":"GetCampaign","SenderID":"CSS","MessageID":"MID12345675"}},"DataArea":{"Territory":"","Region":"","FailureDate":"28-Feb-19","Esn":"79644334"}}';
        /*karthik added below code for Mule Api migration*/
            WorkOrder objWO =[SELECT Id, Asset.Name, Failure_Date__c,Type__c, Formatted_Date__c, ServiceTerritory.Region__c,    
                              ServiceTerritory.Territory__c, FieldActionService_Failure_Flag__c     
                              FROM WorkOrder WHERE id=:Woid ];//Commented By Sravanthi Gundreddy: removed Available_FAs_Count__c, Required_To_Complete__c fields from query beacuse of fieldactions issue we are deleting this two fields from object
            system.debug('objWO>>>'+objWO.Asset);
            
            string strESN;
            strESN = objWO.Asset.Name;
            if(Test.isRunningTest()) {
                strESN ='79462880';
            }
            Date failureDate = objWO.Failure_Date__c ;
            
            string strRegion = objWO.ServiceTerritory.Region__c ;
            string strTerritory = objWO.ServiceTerritory.Territory__c;
            String strFdate = DateTime.newInstance(failureDate.year(),failureDate.month(),failureDate.day()).format('dd-MMM-yy'); //add date null check here DD-MMM-YY
            system.debug('strESN>>>kk>>'+strESN);
            system.debug('strRegion>>>kk>>'+strRegion);
            system.debug('strTerritory>>>kk>>'+strTerritory);
            system.debug('failureDate>kk>>'+failureDate);
            system.debug('strFdate>>>kk>>'+strFdate);
            
        FSL_GETCampaignServiceswrapper outputRes = new FSL_GETCampaignServiceswrapper();
        
        string path = '/engines/' + strESN + '/campaigns?sender=CSS&target=CSSWarranty&failureDate=' + strFdate + '&territory=' + strTerritory + '&region=' + strRegion;
        // added by Diksha Rajpurohit vgrs2-522 named credential callout to enhance system credentials
        if (!Test.isRunningTest() && doCallout) {
            CG_OP_OAGWrapper responseWrapper = getResponseForFSLCampaignService(path);
            responseBody = responseWrapper.response.getBody();
            system.debug('response FSL_getCampaignServices ==> ' + responseBody);
            outputRes = FSL_GETCampaignServiceswrapper.parse(responseWrapper.response.getBody());
            system.debug('outputRes--->' + outputRes);
        } else {
          // if test class is running
          // set the respose string with a constant
          responseBody='{"DataArea":{"Details":[{"Status":"Approved","CampaignStartDate":"2018-02-02","FailCode":"WSNF","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"00-902-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Road Repairs)"},{"SrtCode":"13-004-00","SrtDescription":"Starting Motor - Remove and Install, One (Common Rail Fuel System)"},{"SrtCode":"13-104-00","SrtDescription":"Starting Motor - Remove and Install, Each"},{"SrtCode":"99-902-00","SrtDescription":"Non SRT details- Campaign/TRP/ATC-0.1Hr"}],"MultipleTimes":"N","CampaignDesc":"ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP","FailMode":"WN","InShopSrtLimitFlag":"N","CompleteIndicator":"N","CampaignNumber":1982,"BusinessUnit":"CMI","CampaignEndDate":"2020-02-28","PartList":[{"PartNumber":"499670900","PartDescription":"MOTOR,STARTING","PartQuantity":1}],"CampaignType":All""}]},"Header":{"Status":"Success"}}';
          string  stropt ='{ "DataArea": { "Details": [{ "Status": "Approved", "CampaignStartDate": "2018-02-02", "FailCode": "WSNF", "SrtList": [{ "SrtCode": "99-902-00", "SrtDescription": "Non SRT details- Campaign/TRP/ATC-0.1Hr" }], "MultipleTimes": "N", "CampaignDesc": "ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP", "FailMode": "WN", "InShopSrtLimitFlag": "N", "CompleteIndicator": "N", "CampaignNumber": 1982, "BusinessUnit": "CMI", "CampaignEndDate": "2020-02-28", "PartList": [{ "PartNumber": "499670900", "PartDescription": "MOTOR,STARTING", "PartQuantity": 1 }], "CampaignType": "TRP" }] }, "Header": { "Status": "Success" }}';
          outputRes = (FSL_GETCampaignServiceswrapper)JSON.deserializeStrict( stropt , FSL_GETCampaignServiceswrapper.class);
        }
        
        //making changes to cover the main class. 
        if(!String.isEmpty(responseBody)) {
            //  fslCDSResps = (List<FSL_GETCampaignServiceswrapper>)JSON.deserialize(responseBody, List<FSL_GETCampaignServiceswrapper>.Class);     
        }
           
        // List<CSS_CampTsbTrp__c> lsttsb = new List<CSS_CampTsbTrp__c>();
        Set<CSS_Solution_Component__c> solutionset = new Set<CSS_Solution_Component__c>();
        Map<String,list<FSL_Parts__c>> wsDataMap = new Map<String,list<FSL_Parts__c>>();
        Id FieldActionRecordTypeId = Schema.SObjectType.CSS_Solution_Component__c.getRecordTypeInfosByName().get('FieldActions').getRecordTypeId();
        system.debug('Before if loop');
        if(outputRes.DataArea!=null && outputRes.DataArea.Details!=null){
            system.debug('Enter inside if loop');
           for(FSL_GETCampaignServiceswrapper.cls_Details fslwra : outputRes.DataArea.Details) {
            // Pilot+ - Changing as per the design, not using CampTsbTrp object for storing Field Action links
            /* CSS_CampTsbTrp__c objtsb = new CSS_CampTsbTrp__c ();
        objtsb.Name = fslwra.CampaignType;
        objtsb.Doc_Title__c = fslwra.CampaignDesc;
        objtsb.Doc_Num__c = String.valueOf(fslwra.CampaignNumber);
        objtsb.FSL_ServiceJob__c = woID;
        lsttsb.add(objtsb); */
               
            CSS_Solution_Component__c objSC = new CSS_Solution_Component__c();
            System.debug('Fieldaction RK'+outputRes.DataArea.Details);
            if(fslwra.Status == 'Approved' && (fslwra.CompleteIndicator =='N' || fslwra.MultipleTimes =='Y' || (fslwra.CompleteIndicator =='Y' && fslwra.MultipleTimes =='Y'))){ 
                System.debug('Fieldaction PK');
                objSC.Name = fslwra.CampaignType + ' ' + String.valueOf(fslwra.CampaignNumber);
                objSC.Campaign_Description__c = fslwra.CampaignDesc;
                objSC.Campaign_End_Date__c = date.valueof(fslwra.CampaignEndDate);
                objSC.Campaign_Start_Date__c = date.valueof(fslwra.CampaignStartDate);
                objSC.Business_Unit__c = fslwra.BusinessUnit;
                objSC.Status__c = fslwra.Status;
                if(fslwra.MultipleTimes =='N') {
                    objSC.Multiple_Times__c= false;
                }
                else if(fslwra.MultipleTimes =='Y') {
                    objSC.Multiple_Times__c= true;
                }
                if(fslwra.InShopSrtLimitFlag=='N') {
                    objSC.In_Shop_SRT_Limit_Flag__c = false;
                }
                else if(fslwra.InShopSrtLimitFlag=='Y') {
                    objSC.In_Shop_SRT_Limit_Flag__c = true;
                }
                if(fslwra.CompleteIndicator =='N') {
                    objSC.Complete_Indicator__c = false;
                }
                else if(fslwra.CompleteIndicator =='Y') {
                    objSC.Complete_Indicator__c = true;
                }
                objSC.Component_Id__c = string.valueof(fslwra.CampaignNumber);
                objSC.Type__c = fslwra.CampaignType;
                objSC.FailCode__c = fslwra.FailCode;
                objSC.Failure_Mode__c = fslwra.FailMode;
                objSC.FSL_Service_Job__c = woID;
                objSC.FSL_Service_Order__c = woID;      
                objSC.RecordTypeId = FieldActionRecordTypeId;
                // Added by Sailaja Guntupalli CT3-68 to feed language created by field actions
                objSC.QSOL_Language__c = UserInfo.getLanguage();
                lstSC.add(objSC);
            }
            System.debug('Fieldaction--->'+lstSC);
            // Inserting Parts from GET Campgains services into FSL Parts object
            list<FSL_Parts__c> lsttparts = new list<FSL_Parts__c>();
            Id FieldActionPartsRecordTypeId = Schema.SObjectType.FSL_Parts__c.getRecordTypeInfosByName().get('FA Parts').getRecordTypeId();
            system.debug('recordtypecheck--->'+FieldActionPartsRecordTypeId);
            if(fslwra != Null && fslwra.PartList != Null && fslwra.PartList.size() > 0){
                for(FSL_GETCampaignServiceswrapper.cls_PartList pst: fslwra.PartList) {
                    FSL_Parts__c objparts = new FSL_Parts__c();
                    objparts.Name = pst.PartNumber;
                    objparts.CSS_Solution_Component__c = objSC.Id;
                    objparts.Part_Name__c = pst.PartDescription;
                    // objparts.Part_Quantity__c =string.valueof(pst.PartQuantity);
                    objparts.Part_Quantity__c = pst.PartQuantity;
                    objparts.Service_Order__c = woID;
                    objparts.RecordTypeId = FieldActionPartsRecordTypeId;
                    objparts.Type__c = fslwra.CampaignType;
                    lsttparts.add(objparts);
                }
            }
            system.debug('lsttparts--->'+lsttparts);
            wsDataMap.put(objSC.Component_Id__c, lsttparts);
            
            integer count = 0;
            for(FSL_Parts__c obj : lsttparts)
            {
                if(count<90)
                {
                    FSL_CL_getEPRFlag.getEPRFlagTriggerUpdate(lsttparts);
                    system.debug('Parts List:'+lsttparts[0].id);
                    count++;
                }
            }   
        }     
        }
        
        // List<CSS_Solution_Component__c> lstdeleteCSS = [SELECT Id FROM CSS_Solution_Component__c 
        //WHERE FSL_Service_Job__c =: woID ];
        List<CSS_Solution_Component__c> lstdeleteCSS = [SELECT Id FROM CSS_Solution_Component__c 
                                                        WHERE FSL_Service_Order__c =: woID ];
        
        /*if(lstdeleteCSS.size() > 0) {
Database.delete(lstdeleteCSS, false); // deleting existing css solution comp
} */
        
        if(lstSC.size() > 0) {
            lstSC.addall(solutionset);
            //Database.insert(lstSC, false);
            insert lstSC;
            
            system.debug('complist----->'+lstSC[0].Id);
        }
        
        Set<FSL_Parts__c> allPartsOptionset = new Set<FSL_Parts__c >();
        List<FSL_Parts__c> allPartsOptionList = new List<FSL_Parts__c >();
        for(CSS_Solution_Component__c campObj : lstSC) {
            system.debug('duplicate----'+wsDataMap.get(campObj.Component_Id__c));
            for(FSL_Parts__c partObj : wsDataMap.get(campObj.Component_Id__c)){
                partObj.CSS_Solution_Component__c = campObj.Id;
                allPartsOptionset.add(partObj);
                //  allPartsOptionList.add(partObj);
            }
        }
        
        if(allPartsOptionset.size() > 0) {
            system.debug('allPartsOptionset---->'+allPartsOptionset);
            allPartsOptionList.addall(allPartsOptionset);
            database.insert(allPartsOptionList,false);
        }
            if(objWO.Type__c == 'Dealer'){
                displayFA(lstSC,woId); // Added by Sriprada
            }
        // Ravikanth added below method to call Get warranty docs (QSOL Links for Campaigns, ATC, TRPS)
        // Code start for Get warranty docs from here
        // Passing Newly inserted list of CSS_Solution_Component__c and Workorder Id to Queueable Apex
        if(!Test.isRunningTest() && objWO.Type__c != 'Dealer') {
            System.enqueueJob( new FSL_UpdateQSOLlinks( lstSC, Woid));
        }
           
        }catch(Exception e)  {
            isServiceFailed = true;
            system.debug('EXCEPTION of FSL_GETCampaignServices inserrtcsscomp method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return lstSC;
    //Added by Sriprada as part of CT1-309 to check the Required Flag from Data Management system
    }
    public static List<CSS_Solution_Component__c> displayFA( List<CSS_Solution_Component__c> listFA, String woId){
        List<CSS_Solution_Component__c> listCmpDX = new List<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> dxsolCmp = [SELECT ID, Name, Performed_Review__c from CSS_Solution_Component__c WHERE EVL_DX_Service_Order__c =:woId];
        Map<string, List<CSS_Solution_Component__c>> woSolCmp = new Map<string,List<CSS_Solution_Component__c>>();
        Map<string, CSS_Solution_Component__c> mapexistingsolId = new Map<string,CSS_Solution_Component__c>();
        EVL_CL_RSW.FIRE_RSW_CALL = FALSE;

        system.debug('DXFieldActions:::'+dxsolCmp);
        WorkOrder wo = [SELECT id, Type__c from WorkOrder where id =:woId];
        List<CSS_Solution_Component__c> dxsolUpdate = new List<CSS_Solution_Component__c>();
        if(dxsolCmp != null && dxsolCmp.size() >0){
            for(integer i=0; i<dxsolCmp.size();i++){
                woSolCmp.put(dxsolCmp[i].Name, dxsolCmp);
                
            }
            system.debug('DXFieldActions:::'+woSolCmp);
        }
        List<CSS_Solution_Component__c> solFA = [SELECT id, Name, Performed_Review__c from CSS_Solution_Component__c where FSL_Service_Order__c =: woId];
        for(integer i=0;i<solFA.size();i++)
        { 
            mapexistingsolId.put(solFA[i].Name,solFA[i]);
            system.debug('CampaignUpdateDetails:::'+mapexistingsolId);
            
        }
      //  if(System.isFuture() || System.isBatch()){
            for(integer i=0;i<dxsolCmp.size();i++)
            { 
                if(mapexistingsolId.containsKey(dxsolCmp[i].Name) && wo.Type__c == 'Dealer'){
                    system.debug('inside for');
                        CSS_Solution_Component__c solCmpFA = new CSS_Solution_Component__c();
                        solCmpFA.id = mapexistingsolId.get(dxsolCmp[i].Name).Id;
                        system.debug('FAId:::'+solCmpFA.id);
                        if(dxsolCmp[i].Performed_Review__c == true){
                            solCmpFA.Performed_Review__c =  true;
                        } else{
                            solCmpFA.Performed_Review__c =  false;
                            
                        }
                        listCmpDX.add(solCmpFA);
                        system.debug('CheckBox::'+solCmpFA.Performed_Review__c);
                    }
               
            }
   // }
       
        
        if(listCmpDX.size() > 0){
            update listCmpDX;
            system.debug('CheckBox::'+listCmpDX);

        }
        return listCmpDX;
    }
    /*** Method to retrieve fieldactions from webservice, to display in UserTools CT3-7***/
    public static List<CSS_Solution_Component__c>  getFieldActions(string strESN,string strRegion,string strTerritory,string strFdate) {
      String responseBody = '';//Initialised this to set different
      // added by Diksha Rajpurohit vgrs2-522 named credential callout to enhance system credentials
      string path = '/engines/' + strESN + '/campaigns?sender=CSS&target=CSSWarranty&failureDate=' + strFdate + '&territory=' + strTerritory + '&region=' + strRegion;
      FSL_GETCampaignServiceswrapper outputRes = new FSL_GETCampaignServiceswrapper();
      
      if (!Test.isRunningTest() && doCallout) {
          CG_OP_OAGWrapper responseWrapper = getResponseForFSLCampaignService(path);
          responseBody = responseWrapper.response.getBody();
          system.debug('response FSL_getCampaignServices ==> ' + responseBody);
          outputRes = FSL_GETCampaignServiceswrapper.parse(responseWrapper.response.getBody());
        
          system.debug('outputRes--->'+outputRes);
      } else {
          // if test class is running
          // set the respose string with a constant
          responseBody='{"DataArea":{"Details":[{"Status":"Approved","CampaignStartDate":"2018-02-02","FailCode":"WSNF","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"00-902-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Road Repairs)"},{"SrtCode":"13-004-00","SrtDescription":"Starting Motor - Remove and Install, One (Common Rail Fuel System)"},{"SrtCode":"13-104-00","SrtDescription":"Starting Motor - Remove and Install, Each"},{"SrtCode":"99-902-00","SrtDescription":"Non SRT details- Campaign/TRP/ATC-0.1Hr"}],"MultipleTimes":"N","CampaignDesc":"ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP","FailMode":"WN","InShopSrtLimitFlag":"N","CompleteIndicator":"N","CampaignNumber":1982,"BusinessUnit":"CMI","CampaignEndDate":"2020-02-28","PartList":[{"PartNumber":"499670900","PartDescription":"MOTOR,STARTING","PartQuantity":1}],"CampaignType":All""}]},"Header":{"Status":"Success"}}';
          string  stropt ='{ "DataArea": { "Details": [{ "Status": "Approved", "CampaignStartDate": "2018-02-02", "FailCode": "WSNF", "SrtList": [{ "SrtCode": "99-902-00", "SrtDescription": "Non SRT details- Campaign/TRP/ATC-0.1Hr" }], "MultipleTimes": "N", "CampaignDesc": "ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP", "FailMode": "WN", "InShopSrtLimitFlag": "N", "CompleteIndicator": "N", "CampaignNumber": 1982, "BusinessUnit": "CMI", "CampaignEndDate": "2020-02-28", "PartList": [{ "PartNumber": "499670900", "PartDescription": "MOTOR,STARTING", "PartQuantity": 1 }], "CampaignType": "TRP" }] }, "Header": { "Status": "Success" }}';
          outputRes = (FSL_GETCampaignServiceswrapper)JSON.deserializeStrict( stropt , FSL_GETCampaignServiceswrapper.class);        
      }
        //making changes to cover the main class. 
        /*if(!String.isEmpty(responseBody)) {
            //  fslCDSResps = (List<FSL_GETCampaignServiceswrapper>)JSON.deserialize(responseBody, List<FSL_GETCampaignServiceswrapper>.Class);     
        }*/        
        // List<CSS_CampTsbTrp__c> lsttsb = new List<CSS_CampTsbTrp__c>();
        List<CSS_Solution_Component__c> lstSC = new List<CSS_Solution_Component__c>();
        Set<CSS_Solution_Component__c> solutionset = new Set<CSS_Solution_Component__c>();
        Map<String,list<FSL_Parts__c>> wsDataMap = new Map<String,list<FSL_Parts__c>>();
        Id FieldActionRecordTypeId = Schema.SObjectType.CSS_Solution_Component__c.getRecordTypeInfosByName().get('FieldActions').getRecordTypeId();
        system.debug('Before if loop');  
        if(outputRes.DataArea!=null && outputRes.DataArea.Details!=null){
            system.debug('Enter inside if loop');
           for(FSL_GETCampaignServiceswrapper.cls_Details fslwra : outputRes.DataArea.Details) {
            // Pilot+ - Changing as per the design, not using CampTsbTrp object for storing Field Action links
            /* CSS_CampTsbTrp__c objtsb = new CSS_CampTsbTrp__c ();
                objtsb.Name = fslwra.CampaignType;
                objtsb.Doc_Title__c = fslwra.CampaignDesc;
                objtsb.Doc_Num__c = String.valueOf(fslwra.CampaignNumber);
                objtsb.FSL_ServiceJob__c = woID;
                lsttsb.add(objtsb); */
            CSS_Solution_Component__c objSC = new CSS_Solution_Component__c();
            System.debug('Fieldaction RK'+outputRes.DataArea.Details);
            if(fslwra.Status == 'Approved' && (fslwra.CompleteIndicator =='N' || fslwra.MultipleTimes =='Y' || (fslwra.CompleteIndicator =='Y' && fslwra.MultipleTimes =='Y'))){ 
                System.debug('Fieldaction PK');
                objSC.Name = fslwra.CampaignType + ' ' + String.valueOf(fslwra.CampaignNumber);
                objSC.Campaign_Description__c = fslwra.CampaignDesc;
                objSC.Campaign_End_Date__c = date.valueof(fslwra.CampaignEndDate);
                objSC.Campaign_Start_Date__c = date.valueof(fslwra.CampaignStartDate);
                objSC.Business_Unit__c = fslwra.BusinessUnit;
                objSC.Status__c = fslwra.Status;
                if(fslwra.MultipleTimes =='N') {
                    objSC.Multiple_Times__c= false;
                }
                else if(fslwra.MultipleTimes =='Y') {
                    objSC.Multiple_Times__c= true;
                }
                if(fslwra.InShopSrtLimitFlag=='N') {
                    objSC.In_Shop_SRT_Limit_Flag__c = false;
                }
                else if(fslwra.InShopSrtLimitFlag=='Y') {
                    objSC.In_Shop_SRT_Limit_Flag__c = true;
                }
                if(fslwra.CompleteIndicator =='N') {
                    objSC.Complete_Indicator__c = false;
                }
                else if(fslwra.CompleteIndicator =='Y') {
                    objSC.Complete_Indicator__c = true;
                }
                objSC.Component_Id__c = string.valueof(fslwra.CampaignNumber);
                objSC.Type__c = fslwra.CampaignType;
                objSC.FailCode__c = fslwra.FailCode;
                objSC.Failure_Mode__c = fslwra.FailMode;
                //objSC.FSL_Service_Job__c = woID;//Commented, as we dont need to insert the Feild Actions
                //objSC.FSL_Service_Order__c = woID;      //Commented, as we dont need to insert the Feild Actions
                objSC.RecordTypeId = FieldActionRecordTypeId;
                lstSC.add(objSC);
            }
            System.debug('Fieldaction--->'+lstSC);
           
        /*if(!Test.isRunningTest()) {
            System.enqueueJob( new FSL_UpdateQSOLlinks( lstSC, strEsn)); //passing WoId as null for now.
        }*/
        //commenting below code, for timebeing as the service is down
        if(lstSC !=null && lstSC.size()>0) 
            lstSC = getQsolLinks(strEsn,lstSC);
        }
        }
        if(lstSC != null && lstSC.size()>0) 
        return lstSC;
        else
            return null;
    
}

   public static List<CSS_Solution_Component__c> getQsolLinks(string esn, List<CSS_Solution_Component__c> lstSC){
    string endPoint;
    List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
   //CT3-68 Added by Sailaja Guntupalli to pass the user lang if mapping exists for QSOL Translations
    CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
    system.debug('csAccountLang :: '+csAccountLang);
    system.debug('userInfoLang :: '+UserInfo.getLanguage());
    string strCSS_QsolLanguage ='en';
    if(csAccountLang != null){
            if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
                    strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
            }
    system.debug('***getQsolLinks.esn*** '+esn);
    try{
        if(!Test.isRunningTest()) {
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_Getwarrantydocs');                
            endPoint = conDetails.End_Point__c +'serialNumber='+esn+'&'+'documentType='+ conDetails.DocumentType__c +'&'+'language='+ strCSS_QsolLanguage +'&'+'businessUnit='+conDetails.BusinessUnit__c;
        } else {
            endPoint=  'https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?';
        }
        String authorizationHeader = 'Bearer '+ FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setTimeout(100000);
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', authorizationHeader); 
        // req.setEndpoint('https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?serialNumber=79643468&documentType=TRP&language=en&businessUnit=EBU');
        system.debug('getQsolLinks.req::: '+req);
        
        HttpResponse res = h.send(req);
        String responseBody = res.getBody();
        system.debug('**getQsolLinks.res*** '+res);

        if(responseBody!=null && responseBody!=''){
            fslQSOLResps = (List<FSL_QSOLResponsewrapper>)JSON.deserialize(responseBody, List<FSL_QSOLResponsewrapper>.Class);
        }
   
        system.debug('getQsolLinks.fslQSOLResps---> '+fslQSOLResps);
        if(fslQSOLResps.size() > 0){
        for(CSS_Solution_Component__c objCss : lstSC){
                for(FSL_QSOLResponsewrapper owrapper : fslQSOLResps ){
                    if(objCss.Component_Id__c == owrapper.documentNum){
                        objCss.FSL_Link__c  = owrapper.documentLink;
                    }
                }
            }
        }
        
    } catch(Exception ex){ 
        system.debug('ex'+ex+'Line number'+ex.getLineNumber());
    }
    return lstSC;
}

  // added by Diksha Rajpurohit vgrs2-522 named credential callout to enhance system credentials
  public static CG_OP_OAGWrapper getResponseForFSLCampaignService(string path){
    FSL_IP_NamedCredentialWrapper requestWrapper = new FSL_IP_NamedCredentialWrapper();
    requestWrapper.methodType = 'GET';
    requestWrapper.NamedCredential = 'FSL_NC_Engine';
    requestWrapper.Path = path.replace(' ','%20');  //VGRS-2-522 Fix bug to handle spaces in path
    CG_OP_OAGWrapper responseWrapper = FSL_WS_Mule.calloutNamedCredentials(requestWrapper);
    if (responseWrapper.exceptionFlag) {
        System.debug('Inside FSL_getCampaignServices, request failed with endpoint :: ' + responseWrapper.endPoint);
        System.debug('Inside FSL_getCampaignServices, request failed with exception :: ' + responseWrapper.exceptionMessage);
        throw new CalloutException(responseWrapper.exceptionMessage);
    }
    return responseWrapper;
  }

    //Commented below, as it is a future requirement
    /*public static List<CSS_Solution_Component__c>  getFieldActions_Mule(string esn,string region,string territory,string fdate) {
        String responseBody = '';//Initialised this to set different
        
        // String reqBody = '{"Header":{"Target":"CSSWarranty","Sender":{"ServiceName":"GetCampaign","SenderID":"CSS","MessageID":"MID12345675"}},"DataArea":{"Territory":"","Region":"","FailureDate":"28-Feb-19","Esn":"79644334"}}';
        
        string endPointURL;
        
        //FSL_GETCampaignServiceswrapper outputRes = new FSL_GETCampaignServiceswrapper(); //Commented and added below, as per the new mule response
        CG_OP_CampaignsResJSON outputRes = new CG_OP_CampaignsResJSON();
        if(!Test.isRunningTest()) {
            if(doCallout) {
                CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
                CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            //
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('GetCampaign');
            system.debug('conDetails<><>'+conDetails);
            
                endPointURL = conDetails.End_Point__c;
                //endPointURL = endPointURL+'/cmi-engine/engines/'+esn+'/campaigns?'+'sender=SFMX&target=CSSWarranty&'+'failureDate='+failureDate;
                endPointURL = endPointURL+'/cmi-engine/engines/'+esn+'/campaigns?'+'sender=CSS&target=CSSWarranty&'+'failureDate='+fdate+'&territory='+territory+'&region='+region;
                endPointURL = endPointURL.replace(' ','%20');
                system.debug('*****endPointURL***'+endPointURL);
            
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.serviceName = conDetails.Name;
            reqWrapper.endPoint = endPointURL;
            System.debug('reqWrapper.methodType>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.methodType);
            System.debug('reqWrapper.serviceName>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.serviceName);
            System.debug('reqWrapper.endPointr>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.endPoint);
                       
                //commented below line as per Mule
               // resWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
                resWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                System.debug('resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper);
            
                if(resWrapper.response!=null)
                responseBody = resWrapper.response.getBody();
                //responseBody = ' [ ' + responseBody + ' ] '; 
                system.debug('response for syptoms\n::'+responseBody);
                outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict( responseBody, CG_OP_CampaignsResJSON.class);
                system.debug('outputRes--->'+outputRes);
            }
        } else {
            // if test class is running
            // set the respose string with a constant
            responseBody='{"DataArea":{"Details":[{"Status":"Approved","CampaignStartDate":"2018-02-02","FailCode":"WSNF","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"00-902-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Road Repairs)"},{"SrtCode":"13-004-00","SrtDescription":"Starting Motor - Remove and Install, One (Common Rail Fuel System)"},{"SrtCode":"13-104-00","SrtDescription":"Starting Motor - Remove and Install, Each"},{"SrtCode":"99-902-00","SrtDescription":"Non SRT details- Campaign/TRP/ATC-0.1Hr"}],"MultipleTimes":"N","CampaignDesc":"ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP","FailMode":"WN","InShopSrtLimitFlag":"N","CompleteIndicator":"N","CampaignNumber":1982,"BusinessUnit":"CMI","CampaignEndDate":"2020-02-28","PartList":[{"PartNumber":"499670900","PartDescription":"MOTOR,STARTING","PartQuantity":1}],"CampaignType":All""}]},"Header":{"Status":"Success"}}';
            string  stropt ='{ "DataArea": { "Details": [{ "Status": "Approved", "CampaignStartDate": "2018-02-02", "FailCode": "WSNF", "SrtList": [{ "SrtCode": "99-902-00", "SrtDescription": "Non SRT details- Campaign/TRP/ATC-0.1Hr" }], "MultipleTimes": "N", "CampaignDesc": "ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP", "FailMode": "WN", "InShopSrtLimitFlag": "N", "CompleteIndicator": "N", "CampaignNumber": 1982, "BusinessUnit": "CMI", "CampaignEndDate": "2020-02-28", "PartList": [{ "PartNumber": "499670900", "PartDescription": "MOTOR,STARTING", "PartQuantity": 1 }], "CampaignType": "TRP" }] }, "Header": { "Status": "Success" }}';
            outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict( stropt , CG_OP_CampaignsResJSON.class);
        }
        
             
        // List<CSS_CampTsbTrp__c> lsttsb = new List<CSS_CampTsbTrp__c>();
        List<CSS_Solution_Component__c> lstSC = new List<CSS_Solution_Component__c>();
        Set<CSS_Solution_Component__c> solutionset = new Set<CSS_Solution_Component__c>();
        Map<String,list<FSL_Parts__c>> wsDataMap = new Map<String,list<FSL_Parts__c>>();
        Id FieldActionRecordTypeId = Schema.SObjectType.CSS_Solution_Component__c.getRecordTypeInfosByName().get('FieldActions').getRecordTypeId();
        system.debug('Before if loop');
        if(outputRes.DataArea!=null && outputRes.DataArea.Details!=null){
            system.debug('Enter inside if loop');
           for(CG_OP_CampaignsResJSON.Details fslwra : outputRes.DataArea.Details) {
            // Pilot+ - Changing as per the design, not using CampTsbTrp object for storing Field Action links
            // CSS_CampTsbTrp__c objtsb = new CSS_CampTsbTrp__c ();
               // objtsb.Name = fslwra.CampaignType;
               // objtsb.Doc_Title__c = fslwra.CampaignDesc;
               // objtsb.Doc_Num__c = String.valueOf(fslwra.CampaignNumber);
               // objtsb.FSL_ServiceJob__c = woID;
               // lsttsb.add(objtsb); 
            CSS_Solution_Component__c objSC = new CSS_Solution_Component__c();
            System.debug('Fieldaction RK'+outputRes.DataArea.Details);
            if(fslwra.Status == 'Approved' && (fslwra.CompleteIndicator =='N' || fslwra.MultipleTimes =='Y' || (fslwra.CompleteIndicator =='Y' && fslwra.MultipleTimes =='Y'))){ 
                System.debug('Fieldaction PK');
                objSC.Name = fslwra.CampaignType + ' ' + String.valueOf(fslwra.CampaignNumber);
                objSC.Campaign_Description__c = fslwra.CampaignDesc;
                objSC.Campaign_End_Date__c = date.valueof(fslwra.CampaignEndDate);
                objSC.Campaign_Start_Date__c = date.valueof(fslwra.CampaignStartDate);
                objSC.Business_Unit__c = fslwra.BusinessUnit;
                objSC.Status__c = fslwra.Status;
                if(fslwra.MultipleTimes =='N') {
                    objSC.Multiple_Times__c= false;
                }
                else if(fslwra.MultipleTimes =='Y') {
                    objSC.Multiple_Times__c= true;
                }
                if(fslwra.InShopSrtLimitFlag=='N') {
                    objSC.In_Shop_SRT_Limit_Flag__c = false;
                }
                else if(fslwra.InShopSrtLimitFlag=='Y') {
                    objSC.In_Shop_SRT_Limit_Flag__c = true;
                }
                if(fslwra.CompleteIndicator =='N') {
                    objSC.Complete_Indicator__c = false;
                }
                else if(fslwra.CompleteIndicator =='Y') {
                    objSC.Complete_Indicator__c = true;
                }
                objSC.Component_Id__c = string.valueof(fslwra.CampaignNumber);
                objSC.Type__c = fslwra.CampaignType;
                objSC.FailCode__c = fslwra.FailCode;
                objSC.Failure_Mode__c = fslwra.FailMode;
                //objSC.FSL_Service_Job__c = woID;//Commented, as we dont need to insert the Feild Actions
                //objSC.FSL_Service_Order__c = woID;      //Commented, as we dont need to insert the Feild Actions
                objSC.RecordTypeId = FieldActionRecordTypeId;
                lstSC.add(objSC);
            }
            System.debug('Fieldaction--->'+lstSC);
           
        if(!Test.isRunningTest()) {
            System.enqueueJob( new FSL_UpdateQSOLlinks( lstSC, esn)); //passing WoId as null for now.
        }
        }
        }
        if(lstSC !=null && lstSC.size()>0) 
        return lstSC;
        else
            return null;
    
}*/
}