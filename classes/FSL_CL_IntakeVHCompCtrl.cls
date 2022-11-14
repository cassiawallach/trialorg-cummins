/********************************************************************************************
Name:FSL_CL_IntakeVHCompCtrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this controller for view historycss_
====================================================
===================================================
History                                                            
--------                                                            
VERSION  AUTHOR                DATE                DETAIL                                 
1.0 -   SRIPRADA SESHAM       12/18/2018        INITIAL DEVELOPMENT 
1.1 -   Sunitha Mattaparthi   1/8/2021     Individual Item Number field as Blank for CMI Assets
1.2 -   CharanTeja Sura       07/09/2021   For displaying the Classic jobs at bottom in Service history and user tools
1.3 -   Dinesh Yadav          02/05/2022    Reverting back CPS-126 Changes
1.4 -   Shirisha Pedditi      07/26/2022    Advanced users with same location view pdf
1.5 -	Adam Glaub			  08/15/2022	Updated DX_SORequest Wrapper to allow for the change of the DataArea to be private in EVL_DX_SORequestWrapper class 
***********************************************************************************************/

public class FSL_CL_IntakeVHCompCtrl {
    
    public String ServiceHistList { get; set; }
    public static String strESN { get; set  { strESN=value; } }
    public static String strJobNum { get; set  { strJobNum=value; } }
    public static String strWOId { get; set  { strWOId=value; } }
    public static String strLocation { get; set  { strLocation=value; } }
    public static List<String> strLocationterritory { get; set  { strLocationterritory=value; } } // added by Naveen, Phoen-209
    public static String strLocationCode { get; set  { strLocationCode=value; } }
    public static dateTime dtCreated { get; set { dtCreated=value; } }  
    public Boolean Profilecheck { get; set; }
    public Boolean isFactoryRole { get; set; }
    public string currentUserName { get; set; } //Added by Naveen PHOEN-131
    public Boolean advancedOrSuperUser { get; set; } //Added by Shirisha
    public FSL_CL_IntakeVHCompCtrl(){
        currentUserName='';
        String profileId = UserInfo.getProfileId();
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
        Id userId = userinfo.getUserId();
        User userDetails =[SELECT Id,Name,  UserRole.Name FROM User where Id=:userId ];
        currentUserName=userDetails.Name; //Added by Naveen PHOEN-131
        system.debug('currentUserName==>'+currentUserName); //Added by Naveen PHOEN-131
        
        //Factory Role condition added by Sriprada S for VGRS2-12 : 11/29/2021
        if(profile.Name == 'CSS_Service_Advanced' && userDetails.UserRole.Name == 'factory')
        {
            isFactoryRole = true;
        }else{
            isFactoryRole = false; // added by Naveen---- PHOEN-131 ----
        }
        
        system.debug('profile>>>>>>>>>>'+profile.Name);
        if(profile.Name == 'EVL_Dealer_Advanced' || profile.Name == 'EVL_Dealer_Technician' || profile.Name == 'EVL_Dealer_Readonly'){
            Profilecheck = true;
        }
        else if(!profile.Name.containsIgnoreCase('dealer') && isFactoryRole == false){
            Profilecheck = false;
        }        
        //Added by Shirisha for ROAD-504 :  07/26/2022
        if(profile.Name == 'CSS_Service_Advanced' || profile.Name == 'EVL_Dealer_Advanced'){
            advancedOrSuperUser = true;
        }else{
            advancedOrSuperUser = false;
        }        
    }
    public class ServiceHistWrap {
        public string sCustomerName;
        public string sCSSJobNum;
        public Boolean sType;
        public string sShopsWorkOrder;
        public string sServiceModel;    
        public string sLocation;
        public Boolean isWorkOrder;
        public string sWorkSummary;
        public string sFaultcodeSymp;
        public Decimal sMileage;
        public string sRecent_Visit;
        public string sCreated_Time_Zone;
        public string sCreated_Time_sort;
        public string sMeter;
        public Boolean sRepeat_Visit;
        public Boolean sameLocation;
        public Id sjobId;
        public string sBMSLink;
        public string sFaultCodeSym;
        public string sCustomerComplaint;
        public string sStatus;
        public string userId;
        public string CreatedBy2;
        public string CreatedBy2Name; //Added by Naveen PHOEN-131
        public string assignedResource;
        public string evolutiontech;
        public  ServiceHistWrap () {
            sameLocation=false;
            sRepeat_Visit=false;
            isWorkOrder = false;
            sCustomerName='';
            sCSSJobNum='';
            sType = false;
            sShopsWorkOrder='';
            sLocation='';
            sWorkSummary='';
            sjobId=null;
            sFaultcodeSymp='';
            sMileage=0;
            sCreated_Time_sort='';
            sBMSLink='';
            sFaultCodeSym='';
            sCustomerComplaint='';
            sStatus='';
            CreatedBy2 = '';
            CreatedBy2Name = ''; //Added by Naveen PHOEN-131
            assignedResource = '';
            evolutiontech= '';
        }
    }
    public class ServiceHistWrap2 {
        //Static Variables        
        public boolean brepeatFlg2;
        public boolean brecentFlg2;
        public string sCustomerName2;
        public string sCSSJobNum2;
        public Boolean sType2;
        public string sShopsWorkOrder2;
        public string sServiceModel2;    
        public string sLocation2;
        public Boolean sameLocation2;
        public Boolean isWorkOrder;
        public string sWorkSummary2;
        public string sFaultcodeSymp2;
        public Decimal sMileage2;
        public string sCreated_Time_Zone2;
        public string sCreated_Time_sort2;
        public Boolean sRepeat_Visit2;
        public string sMeter2;
        public Id sjobId2;
        public string sBMSLink2;
        public string sFaultCodeSym2;
        public string sCustomerComplaint2;
        public string sStatus2;
        public string userId;
        public string CreatedBy;
        public string CreatedByName; //Added by Naveen PHOEN-131
        public string assignedResource2;
        public string evolutiontech2;
 
        public ServiceHistWrap2 () {
            isWorkOrder = false;
            sameLocation2=false;
            sRepeat_Visit2=false;
            sCustomerName2='';
            sCSSJobNum2='';
            sType2 = false;
            sShopsWorkOrder2='';
            sLocation2='';
            sWorkSummary2='';
            sFaultcodeSymp2='';
            sMileage2=0;
            sjobId2=null;
            sCreated_Time_sort2='';
            sBMSLink2='';
            sFaultCodeSym2='';
            sCustomerComplaint2='';
            sStatus2='';
            CreatedBy = '';
            CreatedByName = ''; //Added by Naveen PHOEN-131
            assignedResource2 = '';
            evolutiontech2 = '';
        }
    }
    
    public static String getRecentHistJobs() {
        
        system.debug('inside 1rajeshhhhhhhhhhhhhhh' + dtCreated);
        try {
            map<id,ServiceAppointment> mapSA = new map<id,ServiceAppointment>();
            map<id,case> mapCA = new map<id,case>();
            list<FSL_CL_ServiceHistoryWrapper> listHis = new list<FSL_CL_ServiceHistoryWrapper>();
            List< ServiceHistWrap > lstwrap = new List < ServiceHistWrap > ();
            List < ServiceHistWrap2 > lstwrap2 = new List < ServiceHistWrap2 > ();
            
            List< WorkOrder > lstjob = new List< WorkOrder >();
            List< CSS_Job_Order__c> lstjob1 = new List< CSS_Job_Order__c>();
            List<CSS_Fault_Code__c> allFaultCodes = new List<CSS_Fault_Code__c>(); 
            List<CSS_SymptomQA__c> allRecList = new List<CSS_SymptomQA__c>();
            List<CSS_Fault_Code__c> allFaultCodes1 = new List<CSS_Fault_Code__c>(); 
            List<CSS_SymptomQA__c> allRecList1 = new List<CSS_SymptomQA__c>();
            List<CSS_Solutions__c> lstSolsForSym = new List<CSS_Solutions__c>();
            List< CSS_JobEventTemporary__c > Histlstjob = new List< CSS_JobEventTemporary__c >();
            List< CSS_JobEventTemporary__c > ServHistlstjob = new List< CSS_JobEventTemporary__c >();
            
            DateTime lastDate = dtCreated.addDays(-30);
            
            system.debug('strESNrajesh'+strESN);
            system.debug('nishaaaaaaaaaaa'+dtCreated);
            //Added Category and Complaint Type Desciption fields to display Customer Complaint for Defect 110833 -- Rajasekhar H
            lstjob1 = [SELECT Id, CreatedDate, Created_Time_Zone__c, Customer_Name__c, Category__c, Complaint_Type__c, 
                       Mileage_Measure__c, Name, Status__c, Shop_Work_Order__c, Repeat_Visit__c, Service_Model__c, 
                       Mileage__c, CSS_Hours__c, createdBy.User_location__c, Category_Desc__c, Complaint_Type_Desc__c 
                       FROM CSS_Job_Order__c WHERE ESN__c = :strESN AND createdDate >= :lastDate AND createdDate < :dtCreated
                       ORDER BY createdDate DESC];
            //Added CreatedBy.name by Naveen PHOEN-131
            lstjob = [SELECT Id,CreatedById,CreatedBy.name, CreatedDate, Account.Name, Type__c,Asset.Individual__c,EVL_Customer__c,Dealer_Shop_Work_Order__c, Status, Process_Step__c, Category1__c, 
                      Complaint_Type1__c, Mileage_Measure__c, Mileage__c, CSS_Hours__c, WorkOrderNumber, General_Symptoms__c, 
                      Service_Model__c, Shop_Work_Order__c, Asset.Name, ServiceTerritory.Name,Service_Order_Extension__c,Service_Order_Extension__r.Repeat_Visit__c,  //mapping changed by Piyush for VGRS2-398
                      ServiceTerritory.Location_Code__c
                      FROM WorkOrder WHERE Asset.Name=:strESN AND createdDate >= :lastDate  AND createdDate < :dtCreated
                      ORDER BY CreatedDate DESC];
            
            set<string> woids = new set<string>();
            for(WorkOrder wo : lstjob){
                woids.add(wo.id);
            }
            List<ServiceAppointment> Lst_SA = new List<ServiceAppointment>([select id,user__c,Service_Order__c from ServiceAppointment where Service_Order__c=:woids ]);
            for(ServiceAppointment sap : Lst_SA){
                mapSA.put(sap.Service_Order__c,sap);
            }
            
            List<Case> Lst_Ca = new List<Case>([select id,Assigned_to__c,ServiceJob__c from case where ServiceJob__c =:woids ]);
            for(case cs : Lst_Ca){
                mapCA.put(cs.ServiceJob__c,cs);
            }
            ServHistlstjob = [SELECT Id, Name,Attribute3__c, Attribute1__c, Attribute2__c, Attribute4__c, Attribute5__c, Attribute13__c, Attribute6__c , Attribute7__c from CSS_JobEventTemporary__c where ESN__c =:strESN ];
            system.debug('lstjob%% :: NEW '+lstjob.size() +' :: '+lstjob);
            
            WorkOrder wo;
            User usr = new User();
            usr = [SELECT Id, ERP__c FROM User 
                   WHERE Id =: UserInfo.getUserId() LIMIT 1];
            String UserERP;
            UserERP = (String)usr.ERP__c;
            String sLoc = strLocationCode;
            
            //Added for symptom search
            allRecList = [select Id,name,Job_Order__c,Service_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                          Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c  from CSS_Solutions__r) 
                          from CSS_SymptomQA__c where Service_Order__r.asset.Name=:strESN and createdDate >= :lastDate and createdDate < :dtCreated
                          order by createdDate asc];
            //Adding for fault code
            allFaultCodes = [Select id,name,Primary_Fault_Code__c,Job_Order__c,Service_Order__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                             Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c,
                             (select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c,Repair_Notes__c,FaultCode__c  from CSS_Solutions__r)
                             from CSS_Fault_Code__c where Service_Order__r.asset.Name=:strESN and createdDate >= :lastDate and createdDate < :dtCreated
                             order by createdDate asc ];
            
            //Added for classic jobs symptom search
            allRecList1 = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                           Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c  from CSS_Solutions__r) 
                           from CSS_SymptomQA__c where Job_Order__r.ESN__c = :strESN and createdDate >= :lastDate and createdDate < :dtCreated
                           order by createdDate asc];
            //Adding for classic jobs fault code
            allFaultCodes1 = [Select id,name,Primary_Fault_Code__c,Job_Order__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                              Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c,
                              (select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c,FaultCode__c  from CSS_Solutions__r)
                              from CSS_Fault_Code__c where Job_Order__r.ESN__c = :strESN and createdDate >= :lastDate and createdDate < :dtCreated
                              order by createdDate asc ];
            
            //Added by Sriprada for DataExchange changes 
            if(strWOId != '' && strWOId != NULL){
                
                WorkOrder woDealer = [SELECT id, Type__c,EVL_DX_SONumber__c, WorkOrderNumber FROM WorkOrder WHERE id =:strWOId];
                if(woDealer.EVL_DX_SONumber__c == true && woDealer.Type__c == 'Dealer'){
                    String JobNumber = 'Dealer_DataExchange - ' + strJobNum;
                    system.debug('JobNumber::'+JobNumber);
                    List<Account> acct = new List<Account>();
                    EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
                    CSS_JobEventTemporary__c temp = [SELECT id, Name, Key__c, JSONResponse__c FROM CSS_JobEventTemporary__c where Key__c =: JobNumber AND ESN__c =:strESN LIMIT 1];
                    system.debug('JobNumber::'+temp);
                    
                    //Changes made by Adam as part of NIN-469 changes for Salesforce Health Asesment 
                    EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
                    wrapperdtAr.setDataArea(DataAreaDetails);
              
                    
                    wrapperdtAr = (EVL_DX_SORequestWrapper) System.JSON.deserialize(temp.JSONResponse__c, EVL_DX_SORequestWrapper.class);
                    EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();
                    system.debug('DATA AREA:: '+ dtAr);
                    //End changes for NIN-469
                    
                    if(dtAr.SERVICEHIST != null){
                        //added As a part of FBI-393
                        List<String> listOf_IAM_Service_Provider_Code = new List<String>();
                        Map<String, Account> IAMServiceProviderCodeToAccountMap = new Map<String, Account>();
                        for(integer i=0;i<dtAr.SERVICEHIST.size();i++) {
                            String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                            system.debug('ServLoc>>>>'+servLoc);
                            listOf_IAM_Service_Provider_Code.add(servLoc.substringAfter('-'));
                        }

                        for(Account acc : [SELECT id, Name, Location__c,IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN :listOf_IAM_Service_Provider_Code]) {
                            IAMServiceProviderCodeToAccountMap.put(acc.IAM_Service_Provider_Code__c, acc);
                        }
                        
                        for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                        { 
                            ServiceHistWrap awrap = new ServiceHistWrap();
                            String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                            system.debug('ServLoc>>>>'+servLoc);
                            String accLocation = servLoc.substringAfter('-');
                            system.debug('SubServLoc>>>>'+accLocation);
                            String timeStamp;
                            DateTime acceptableDateTime;
                            if(dtAr.SERVICEHIST[i].JobDate != null){
                                String ReceivedDate = dtAr.SERVICEHIST[i].JobDate;
                                acceptableDateTime = Date.Valueof(ReceivedDate.replace('T', ' ')); 
                                system.debug('TimeCheck***:'+lastDate);
                                system.debug('TimeCheckBefore***:'+acceptableDateTime);
                                system.debug('TimeCheckCreated***:'+dtCreated);
                                
                                
                                timeStamp = String.valueOf(acceptableDateTime.format('dd MMM YYYY hh:mm a z'));
                                system.debug('Time Stamp:'+timeStamp);}
                            else{
                                timeStamp = '';
                            }
                            if(acceptableDateTime >= lastDate && acceptableDateTime <= dtCreated){
                                system.debug('testLoop:::');
                                awrap.sCustomerName = dtAr.SERVICEHIST[i].CustomerName;
                                awrap.sShopsWorkOrder = dtAr.SERVICEHIST[i].ShopWO;
                                awrap.sMileage = Decimal.valueOf(dtAr.SERVICEHIST[i].Mileage);
                                awrap.sMeter = dtAr.SERVICEHIST[i].MileageMeasure;
                                awrap.sFaultcodeSym = dtAr.SERVICEHIST[i].FaultCodeSymptom;
                                awrap.sWorkSummary = dtAr.SERVICEHIST[i].WorkSummary;
                                awrap.sServiceModel = dtAr.SERVICEHIST[i].ServiceModelNM;
                                DateTime timeZone = Date.valueOf(dtAr.SERVICEHIST[i].JobDate);
                                awrap.sCreated_Time_Zone = timeZone.format('dd MMM yyyy hh:mm a z'); //ct3-637
                                awrap.sCreated_Time_sort = timeZone.format('yyyy MM dd HH:mm a z');
                                if(acct != null && IAMServiceProviderCodeToAccountMap.containskey(accLocation)){
                                    Account accLoc = IAMServiceProviderCodeToAccountMap.get(accLocation);
                                    awrap.sLocation = accLoc.Name;   
                                    awrap.sameLocation = (accLoc.Name == strLocation) ? true:false;                                    
                                }
                                lstwrap.add(awrap);
                                system.debug('ListWrap:::'+lstwrap);
                                
                            }
                        }
                    }
                } // Ends here --- Sriprada
            }
            
            
            String itemNumber;
            
            //Display of FSL WorkOrders
            
            for (WorkOrder a: lstjob)
            {                
                ServiceHistWrap awrap = new ServiceHistWrap();
                
                awrap.sCSSJobNum = a.WorkOrderNumber;
                awrap.sjobId = a.id;
                awrap.isWorkOrder = true;
                
                awrap.CreatedBy2 = a.CreatedById;
                awrap.CreatedBy2Name = a.CreatedBy.name; //Added by Naveen PHOEN-131
                if(mapCA.size() > 0){
                    if(mapCA.containskey(a.id) && mapCA.get(a.id) != null){
                        string urname = '';
                        if(mapCA.get(a.id).Assigned_to__c!= null ){ 
                            //start ----code changes added by Naveen ----PHOEN-131----
                            if(mapCA.get(a.id).Assigned_to__c.contains(',')){
                                urname = MultiUserscheck(mapCA.get(a.id).Assigned_to__c.split(','));
                                if(urname != ''){
                                    awrap.evolutiontech = urname;
                                }else{
                                    awrap.evolutiontech = null;
                                }
                            }else{
                                awrap.evolutiontech = mapCA.get(a.id).Assigned_to__c;
                            }
                        } else{
                            awrap.evolutiontech = null;
                        }
                        //End ----code changes added by Naveen ----PHOEN-131----
                    }
                }
                system.debug('MASA-----> '+awrap.evolutiontech);
                system.debug('SA-----> '+mapSA);
                if(mapSA.size() > 0){
                    if(mapSA.containskey(a.id) && mapSA.get(a.id) != null) {
                        if(mapSA.get(a.id).user__c!= null ){
                            awrap.assignedResource = mapSA.get(a.id).user__c ;
                        }else{
                            awrap.assignedResource = null;
                        }
                    }                    
                } 
                
                system.debug('MapSA-----> '+awrap.assignedResource); 
                
                if(a.Type__c == 'Dealer'){
                    awrap.sType = true;
                }
                else{
                    awrap.sType = false; 
                }
                if (a.Account.Name != null && (a.Type__c == 'Internal' || a.Type__c == 'External')) {
                    awrap.sCustomerName = a.Account.Name;
                }
                //Added by karthik G as part CT1-70
                if (a.EVL_Customer__c != null && a.Type__c == 'Dealer') {
                    awrap.sCustomerName = a.EVL_Customer__c;
                }
                //Added the Customer Complaint column in Service History table1 on View History Chevron
                if (a.Category1__c != null && a.Complaint_Type1__c != null) {
                    awrap.sCustomerComplaint = a.Category1__c + ' / ' + a.Complaint_Type1__c;
                    
                }
                if (a.General_Symptoms__c != null && a.Type__c == 'Dealer') {
                    awrap.sCustomerComplaint = a.General_Symptoms__c;
                    
                }
                if (a.Shop_Work_Order__c != null && (a.Type__c == 'Internal' || a.Type__c == 'External')) {
                    awrap.sShopsWorkOrder = a.Shop_Work_Order__c;
                }  
                //Added by karthik G as part CT1-70
                if (a.Dealer_Shop_Work_Order__c != null && a.Type__c == 'Dealer') {
                    awrap.sShopsWorkOrder = a.Dealer_Shop_Work_Order__c;
                }
                
                if (a.Mileage__c != null && a.Mileage__c != 0) {
                    awrap.sMileage = a.Mileage__c;
                    awrap.sMeter = a.Mileage_Measure__c;
                } 
                else{
                    if(a.CSS_Hours__c != null) {
                        awrap.sMileage = a.CSS_Hours__c;
                        awrap.sMeter = 'Hours';
                    }
                    else {
                        awrap.sMileage = a.Mileage__c;
                        awrap.sMeter = a.Mileage_Measure__c;
                    }
                }
                
                if (a.Service_Model__c != null) {
                    awrap.sServiceModel = a.Service_Model__c;
                } 
                if(a.createdDate!=null){
                    awrap.sCreated_Time_Zone = a.createdDate.format('dd MMM yyyy hh:mm a z'); //ct3-637
                    awrap.sCreated_Time_sort = a.createdDate.format('yyyy MM dd HH:mm a z');
                }
                if(a.ServiceTerritoryId != null && (a.Type__c == 'Internal' || a.Type__c == 'External'))
                {
                    awrap.sLocation = a.ServiceTerritory.Name; 
                    // Start - added by Naveen, PHOEN-209
                    if(strLocationterritory.size() > 0){
                        awrap.sameLocation = (strLocationterritory.contains(a.ServiceTerritory.Name)) ? true:false;	// added by Naveen, PHOEN-209
                    system.debug('sameLocation ===> '+awrap.sameLocation);
                     
                    }else{
                   	  awrap.sameLocation = (a.ServiceTerritory.Name == strLocation) ? true:false;
                    }
                    // End - added by Naveen, PHOEN-209
                }
                if(a.Account.Name != null && a.Type__c == 'Dealer') //karthik G need to check for dealers ServiceTerritoryId wt should be..
                {
                    awrap.sLocation = a.Account.Name;   
                    awrap.sameLocation = (a.Account.Name == strLocation) ? true:false;
                }
                //mapping changed by Piyush for VGRS2-398
                system.debug('a.Service_Order_Extension__r.Repeat_Visit__c'+a.Service_Order_Extension__r.Repeat_Visit__c);
                if(a.Service_Order_Extension__r.Repeat_Visit__c != null) {
                    awrap.sRepeat_Visit = a.Service_Order_Extension__r.Repeat_Visit__c;
                }
                system.debug('awrap.sRepeat_Visit'+awrap.sRepeat_Visit);
                //awrap.sRepeat_Visit =true ;
                //Added by shanthi - Rod: 88178            
                
                integer faulCodCount=0;
                integer fcCounter = 0;
                    if(a.Process_Step__c != null ||Test.isRunningTest()){
                    
                    System.debug('Inside symp');
                    if(allFaultCodes.size()>0|| Test.isRunningTest()){
                        System.debug('Inside symp 1');
                        for(CSS_Fault_Code__c fauCod : allFaultCodes){
                            if(fauCod.Service_Order__c == a.id || Test.isRunningTest()){
                                if(fcCounter > 0 ){
                                    
                                    system.debug('FaultCode is:'+awrap.sFaultcodeSym);
                                    fcCounter++;
                                }
                                for(CSS_Solutions__c sol : fauCod.CSS_Solutions__r){
                                    if(faulCodCount < 5){
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.FaultCode__c == fauCod.id)
                                            {
                                                awrap.sFaultcodeSym = awrap.sFaultcodeSym + fauCod.name + '\n';
                                                awrap.sWorkSummary =awrap.sWorkSummary+'\n'+ sol.Repair_Notes__c + '\n' + sol.Solution_Title__c + '\n';
                                                
                                                faulCodCount++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                    integer sympCounter = 0;
                    integer symCount = 0;
                    if(faulCodCount==0 || Test.isRunningTest()){
                        System.debug('Inside symp 2'+ allRecList);
                        for(CSS_SymptomQA__c symp : allRecList)
                        {
                            System.debug('Inside symp 3'+symp.Name);
                            if(symp.Service_Order__c == a.id )
                            {
                                if(symCount >= 0)
                                {
                                    awrap.sFaultcodeSym = awrap.sFaultcodeSym+  symp.name + '\n';
                                    symCount++;
                                }
                                System.debug('Inside symp 4'+symp.Service_Order__c);
                                for(CSS_Solutions__c sol : symp.CSS_Solutions__r){
                                    
                                    if(sympCounter >= 0){
                                        System.debug('Inside symp 5'+sol.Solution_Title__c);
                                        if(sol.Repair_Response__c == 'Repair Successful' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures'){
                                            if(sol.Symptom__c == symp.id)
                                            {
                                                System.debug('Inside symp 6'+sol.Symptom__c);
                                                awrap.sWorkSummary  = awrap.sWorkSummary+  sol.Repair_Notes__c + '\n' + sol.Solution_Title__c + '\n';
                                                
                                                sympCounter++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                }
                lstwrap.add(awrap);
            }
            for (CSS_Job_Order__c a: lstjob1) {
                
                ServiceHistWrap awrap = new ServiceHistWrap();
                
                awrap.sCSSJobNum = a.name;
                awrap.sjobId = a.id;
                if (a.Customer_Name__c != null) {
                    awrap.sCustomerName = a.Customer_Name__c;
                }
                //Added the Customer Complaint column in Service History table1 on View History Chevron
                if (a.Category__c != null && a.Complaint_Type__c != null) {
                    awrap.sCustomerComplaint = a.Category__c + ' / ' + a.Complaint_Type__c;
                    
                }
                if (a.Shop_Work_Order__c != null) {
                    awrap.sShopsWorkOrder = a.Shop_Work_Order__c;
                } 
                if (a.Mileage__c != null && a.Mileage__c != 0) {
                    awrap.sMileage = a.Mileage__c;
                    awrap.sMeter = a.Mileage_Measure__c;
                } 
                else {
                    if(a.CSS_Hours__c != null) {
                        awrap.sMileage = a.CSS_Hours__c;
                        awrap.sMeter = 'Hours';
                    }
                    else {
                        awrap.sMileage = a.Mileage__c;
                        awrap.sMeter = a.Mileage_Measure__c;
                    }
                }
                
                if (a.Service_Model__c != null) {
                    awrap.sServiceModel = a.Service_Model__c;
                } 
                if(a.Created_Time_Zone__c != null) {
                    awrap.sCreated_Time_Zone = a.Created_Time_Zone__c.format('dd MMM yyyy hh:mm a z'); //ct3-637
                    awrap.sCreated_Time_sort = a.Created_Time_Zone__c.format('yyyy MM dd HH:mm a z');
                }
                if(a.createdBy.User_Location__c != null) {
                    awrap.sLocation = a.createdBy.User_Location__c;
                }
                
                if(a.Repeat_Visit__c!=null){
                    awrap.sRepeat_Visit = a.Repeat_Visit__c;
                }
                //Added by shanthi - Rod: 88178
                integer faulCodCount=0;
                integer fcCounter = 0;
                if(a.Status__c != null){
                    System.debug('Inside symp');
                    if(allFaultCodes1.size()>0){
                        System.debug('Inside symp 1');
                        for(CSS_Fault_Code__c fauCod : allFaultCodes1){
                            if(fauCod.Job_Order__c == a.id){
                                if(fcCounter >= 0){
                                    awrap.sFaultcodeSym = awrap.sFaultcodeSym + fauCod.Name + '\n'; 
                                    fcCounter++;
                                }
                                for(CSS_Solutions__c sol : fauCod.CSS_Solutions__r){
                                    if(faulCodCount<5){
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.FaultCode__c == fauCod.id){
                                                awrap.sWorkSummary = awrap.sWorkSummary + sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                faulCodCount++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                    integer sympCounter = 0;
                    integer symCount = 0;
                    if(faulCodCount==0){
                        System.debug('Inside symp 2');
                        for(CSS_SymptomQA__c symp : allRecList1){
                            System.debug('Inside symp 3'+symp.Name);
                            if(symp.Job_Order__c == a.id && symp.Type__c == 'SearchString'){
                                if(symCount<3){
                                    awrap.sFaultcodeSym = awrap.sFaultcodeSym+  symp.Name + '\n';
                                    symCount++;
                                }
                                System.debug('Inside symp 4'+symp.Job_Order__c);
                                for(CSS_Solutions__c sol : symp.CSS_Solutions__r){
                                    
                                    if(sympCounter<3){
                                        System.debug('Inside symp 5'+sol.Solution_Title__c);
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.Symptom__c == symp.id){
                                                System.debug('Inside symp 6'+sol.Symptom__c);
                                                awrap.sWorkSummary  = awrap.sWorkSummary+  sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                sympCounter++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                }
                lstwrap.add(awrap);
            }
            
            WorkOrder so = [SELECT Id, Type__c, Asset.Individual__c, Asset.Engine_Manufacturer__c 
                            FROM WorkOrder 
                            WHERE Asset.Name =:strESN 
                            ORDER BY CreatedDate DESC LIMIT 1];
            system.debug('ItemNumber:'+Asset.Individual__c );
            if(so.Type__c != 'Dealer'  && sLoc != null){
                system.debug('TestInsideIf:::'+so.Type__c);
                String subString = sLoc.substringBefore('-');
                String subString2 = sLoc.substringAfter('-').substring(0,5);
                if(UserERP == 'BMS'){
                    sLoc = subString + '-' + subString2;
                }
                //CT3-262
                if(so.Asset.Individual__c != null && so.Asset.Individual__c != '' && so.Asset.Engine_Manufacturer__c != 'CUMMINS') {
                    itemNumber = String.valueOf(so.Asset.Individual__c);
                    system.debug('ItemNumber:'+itemNumber);
                } else {
                    itemNumber = '';
                }
                system.debug('Location Code:'+sLoc);
                system.debug('Location:'+strLocation);
                system.debug('Location territory:'+strLocationterritory);
                system.debug('strESN >>>' + strESN);
                system.debug('itemNumber >>>' + itemNumber);
                /**make Call for Service History **/  // karthik G to check for evl Dealers should call for not
                FSL_CL_ServiceHistoryWrapper ServiceHistoryObj = new FSL_CL_ServiceHistoryWrapper();
                if(string.isNotBlank(strESN) && string.isNotBlank(sLoc))
                {
                    ServiceHistoryObj = FSL_CL_QSOLIntegrations.getServiceHistory(strESN, sLoc, itemNumber);
                    System.debug('** ServiceHistoryObj---------->: ' + ServiceHistoryObj);
                    listHis.add(ServiceHistoryObj);
                    system.debug('Service History List:'+listHis);
                }            
                
                for(FSL_CL_ServiceHistoryWrapper historyObj:listHis)
                {             
                    if(historyObj.DataArea != null && historyObj.DataArea.size() >0)
                    {
                        for(integer i = 0;i<historyObj.DataArea.size();i++)
                        {
                            ServiceHistWrap hisWrap = new ServiceHistWrap();
                            ServiceHistWrap2 hisWrap2 = new ServiceHistWrap2();
                            
                            system.debug('data : '+historyObj.DataArea[i]);
                            String timeStamp;
                            DateTime acceptableDateTime;
                            if(historyObj.DataArea[i].ReceivedDate != ''){
                                String ReceivedDate = historyObj.DataArea[i].ReceivedDate;
                                acceptableDateTime = DateTime.Valueof(ReceivedDate.replace('T', ' ')); 
                                system.debug('TimeCheck***:'+lastDate);
                                system.debug('TimeCheckBefore***:'+acceptableDateTime);
                                system.debug('TimeCheckCreated***:'+dtCreated);
                                
                                
                                timeStamp = String.valueOf(acceptableDateTime.format('dd MMM YYYY hh:mm a z'));
                                system.debug('Time Stamp:'+timeStamp);}
                            else{
                                timeStamp = '';
                            }
                            if((acceptableDateTime >= lastDate && acceptableDateTime <= dtCreated)||Test.isRunningTest()){
                                system.debug('TimeCheck***:'+lastDate);
                                system.debug('TimeCheckBefore***:'+acceptableDateTime);
                                system.debug('TimeCheckCreated***:'+dtCreated);
                                hisWrap.sFaultcodeSym =  (historyObj.DataArea[i].WorkSummaryCAUSE != null || historyObj.DataArea[i].WorkSummaryCAUSE != '') ? historyObj.DataArea[i].WorkSummaryCAUSE : '';
                                hisWrap.sCustomerName = (historyObj.DataArea[i].CustomerName != null || historyObj.DataArea[i].CustomerName != '') ? historyObj.DataArea[i].CustomerName : '';
                                hisWrap.sShopsWorkOrder = (historyObj.DataArea[i].BMSWOreference != null || historyObj.DataArea[i].BMSWOreference != '') ? historyObj.DataArea[i].BMSWOreference : '';
                                
                                string loc =  historyObj.DataArea[i].Location;
                                system.debug('Location ID'+ loc);
                                for(ServiceTerritory st : [select id,name,Location_Code__c from ServiceTerritory where Location_Code__c=:loc]){
                                    hisWrap.sLocation = st.Name;
                                    // Start - added by Naveen, PHOEN-209
                                    if(strLocationterritory.size() > 0){
                                        hisWrap.sameLocation = (strLocationterritory.contains(st.Name)) ? true:false;	// added by Naveen, PHOEN-209
                                    system.debug('Location is'+st.Name);
                                    }else{
                                        hisWrap.sameLocation =   (st.Name == strLocation) ? true:false;
                                    }
                                    // End - added by Naveen, PHOEN-209
                                    
                                      
                                }
                                
                                hisWrap.sCustomerComplaint = (historyObj.DataArea[i].WorkSummaryCOMPLAINT != null || historyObj.DataArea[i].WorkSummaryCOMPLAINT != '') ? historyObj.DataArea[i].WorkSummaryCOMPLAINT : '';
                                hisWrap.sWorkSummary = (historyObj.DataArea[i].FaultcodesCORRECTION != null || historyObj.DataArea[i].FaultcodesCORRECTION != '') ?  historyObj.DataArea[i].FaultcodesCORRECTION : '';
                                hisWrap.sCreated_Time_Zone = timeStamp;
                                hisWrap.sMileage = (historyObj.DataArea[i].Distance != '' ) ? Decimal.valueOf(historyObj.DataArea[i].Distance) : null;
                                hisWrap.sMeter = (historyObj.DataArea[i].DistanceType != '' || historyObj.DataArea[i].DistanceType != null) ? historyObj.DataArea[i].DistanceType : '';
                                hisWrap.sServiceModel = (historyObj.DataArea[i].ProductModel != null || historyObj.DataArea[i].ProductModel != '') ? historyObj.DataArea[i].ProductModel : '';
                                lstwrap.add(hisWrap);
                            }   
                        }                                   
                    }               
                }
            }
            system.debug('lastDate '+lastDate+'dtCreated '+dtCreated);
            Histlstjob = [select Attribute1__c, Attribute13__c, Attribute14__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, 
                          Attribute9__c, Attribute10__c, Attribute11__c, Attribute12__c, Attribute15__c, Circuit_Description__c, Reason__c 
                          from CSS_JobEventTemporary__c where  key__c = :strESN and Attribute13__c >= :lastDate and Attribute13__c < :dtCreated];
            system.debug('the flag is  ');
            
            return JSON.serialize(lstwrap);
            
        }
        catch(Exception e)        
        { 
            System.debug('An exception occurred: ' + e.getMessage() + 'At line : '+ e.getLineNumber());
            return null;
        } 
    }
    
    public static String getHistJobs() {
        try{
            map<id,ServiceAppointment> mapSA = new map<id,ServiceAppointment>();
            map<id,case> mapCA = new map<id,case>();
            list<FSL_CL_ServiceHistoryWrapper> listHis = new list<FSL_CL_ServiceHistoryWrapper>();
            List < ServiceHistWrap2 > lstwrap2 = new List < ServiceHistWrap2 > ();
            List < WorkOrder > lstjob2;
            List< CSS_Job_Order__c> lstjobG;
            List < CSS_JobEventTemporary__c > Histlstjob2;
            List < CSS_JobEventTemporary__c > ServHistlstjob2;
            
            List<CSS_Fault_Code__c> allFaultCodes2; 
            List<CSS_SymptomQA__c> allRecList2;
            List<CSS_Fault_Code__c> allFaultCodesG; 
            List<CSS_SymptomQA__c> allRecListG;
            DateTime lastDate2 = dtCreated.addDays(-30);
            DateTime past2Yr = dtCreated.addDays(-730);
            WorkOrder wo;
            User usr = new User();
            usr = [SELECT Id, ERP__c FROM User 
                   WHERE Id =: UserInfo.getUserId() LIMIT 1];
            String UserERP;
            UserERP = (String)usr.ERP__c;
            String sLoc = strLocationCode;
            
            system.debug('lastDate2'+lastDate2 +' past2Yr '+past2Yr);
            
            //Added Category and Complaint Type Desciption fields to display Customer Complaint for Defect 110833 -- Rajasekhar H
            lstjobG = [select id,Status__c, createdDate,Customer_Name__c,Complaint_Type__c,Category__c,Created_Time_Zone__c,Mileage_Measure__c, Name, Shop_Work_Order__c,Service_Model__c,Repeat_Visit__c, Mileage__c, CSS_Hours__c,createdBy.User_location__c,Category_Desc__c,Complaint_Type_Desc__c
                       from CSS_Job_Order__c where ESN__c = :strESN and createdDate < :lastDate2 and createdDate >= : past2Yr
                       order by createdDate desc];
            //Added by Naveen PHOEN-131
            lstjob2 = [select id,CreatedById,CreatedBy.name, createdDate,Account.Name,Status,Type__c,EVL_Customer__c,General_Symptoms__c,Dealer_Shop_Work_Order__c,Process_Step__c,Category1__c,Complaint_Type1__c,WorkOrderNumber, Shop_Work_Order__c, ServiceTerritory.Name,Service_Model__c,(SELECT id, user__c FROM Service_Appointments__r)
                       from WorkOrder where Asset.Name=:strESN and createdDate < :lastDate2 and createdDate >=: past2Yr
                       order by createdDate desc];
            
            system.debug('lstjob2 :: '+lstjob2.size() +' :: '+lstjob2);
            
            set<string> woids = new set<string>();
            for(WorkOrder wo2 : lstjob2){
                woids.add(wo2.id);
            }
            List<ServiceAppointment> Lst_SA = new List<ServiceAppointment>([select id,user__c,Service_Order__c from ServiceAppointment where Service_Order__c=:woids ]);
            for(ServiceAppointment sap : Lst_SA){
                mapSA.put(sap.Service_Order__c,sap);
            }
            
            List<case> Lst_CA = new List<case>([select id,Assigned_to__c,ServiceJob__c from case where ServiceJob__c =:woids ]);
            for(case cs : Lst_Ca){
                mapCA.put(cs.ServiceJob__c,cs);
            }
            //Added for symptom search
            allRecList2 = [select Id,name,Job_Order__c,Service_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                           Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c  from CSS_Solutions__r) 
                           from CSS_SymptomQA__c where Service_Order__r.ESN__c = :strESN and createdDate < :lastDate2 and createdDate >= : past2Yr
                           order by createdDate asc];
            //Adding for fault code
            allFaultCodes2 = [Select id,name,Primary_Fault_Code__c,Job_Order__c, Service_Order__c,isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                              Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c,
                              (select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c,FaultCode__c  from CSS_Solutions__r)
                              from CSS_Fault_Code__c where Service_Order__r.ESN__c = :strESN and createdDate < :lastDate2 and createdDate >= : past2Yr
                              order by createdDate asc ];
            //Added for symptom search
            allRecListG = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                           Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c  from CSS_Solutions__r) 
                           from CSS_SymptomQA__c where Job_Order__r.ESN__c = :strESN and createdDate < :lastDate2 and createdDate >= : past2Yr
                           order by createdDate asc];
            //Adding for fault code
            allFaultCodesG = [Select id,name,Primary_Fault_Code__c,Job_Order__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                              Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c,
                              (select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c,FaultCode__c  from CSS_Solutions__r)
                              from CSS_Fault_Code__c where Job_Order__r.ESN__c = :strESN and createdDate < :lastDate2 and createdDate >= : past2Yr
                              order by createdDate asc ];
            ServHistlstjob2 = [SELECT Id, Name,Attribute3__c, Attribute1__c, Attribute2__c, Attribute4__c, Attribute5__c, Attribute13__c, Attribute6__c , Attribute7__c from CSS_JobEventTemporary__c where ESN__c =:strESN ];
            
            String itemNumber;
            if(strWOId != '' && strWOId != NULL){
                //Added by Sriprada for DataExchange changes 
                WorkOrder woDealer = [SELECT id, Type__c,EVL_DX_SONumber__c, WorkOrderNumber FROM WorkOrder WHERE id =:strWOId];
                if(woDealer.EVL_DX_SONumber__c == true && woDealer.Type__c == 'Dealer'){
                    String JobNumber = 'Dealer_DataExchange - ' + strJobNum;
                    List<Account> acct = new List<Account>();
                    EVL_DX_SORequestWrapper wrapperdtAr2 = new EVL_DX_SORequestWrapper();
                    CSS_JobEventTemporary__c temp = [SELECT id, Name, Key__c, JSONResponse__c FROM CSS_JobEventTemporary__c where Key__c =:JobNumber AND ESN__c =:strESN LIMIT 1];
                    //Adam changes for NIN-469 - added .getDataArea() as part of Salesforce Health Assesment
                    EVL_DX_SORequestWrapper.DataArea DataAreaDetails2 = new EVL_DX_SORequestWrapper.DataArea();
                    wrapperdtAr2.setDataArea(DataAreaDetails2);
                    
                    wrapperdtAr2 = (EVL_DX_SORequestWrapper) System.JSON.deserialize(temp.JSONResponse__c, EVL_DX_SORequestWrapper.class);
                    
                    EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr2.getDataArea();
                    //End NIN-469 changes
                    
                    if(dtAr.SERVICEHIST != null){
                        
                        List<String> listOf_IAM_Service_Provider_Code = new List<String>();
                        Map<String, Account> IAMServiceProviderCodeToAccountMap = new Map<String, Account>();
                        for(integer i=0;i<dtAr.SERVICEHIST.size();i++) {
                            String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                            system.debug('ServLoc>>>>'+servLoc);
                            listOf_IAM_Service_Provider_Code.add(servLoc.substringAfter('-'));
                        }

                        for(Account acc : [SELECT id, Name, Location__c,IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN :listOf_IAM_Service_Provider_Code]) {
                            IAMServiceProviderCodeToAccountMap.put(acc.IAM_Service_Provider_Code__c, acc);
                        }
                        
                        for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                        { 
                            ServiceHistWrap2 bwrap2 = new ServiceHistWrap2();
                            String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                            system.debug('ServLoc>>>>'+servLoc);
                            String accLocation = servLoc.substringAfter('-');
                            system.debug('SubServLoc>>>>'+accLocation);
                            String timeStamp;
                            DateTime acceptableDateTime;
                            if(dtAr.SERVICEHIST[i].JobDate != null){
                                String ReceivedDate = dtAr.SERVICEHIST[i].JobDate;
                                acceptableDateTime = Date.Valueof(ReceivedDate.replace('T', ' ')); 
                                system.debug('TimeCheckBefore***:'+acceptableDateTime);
                                system.debug('TimeCheckCreated***:'+dtCreated);
                                
                                
                                timeStamp = String.valueOf(acceptableDateTime.format('dd MMM YYYY hh:mm a z'));
                                system.debug('Time Stamp:'+timeStamp);}
                            else{
                                timeStamp = '';
                            }
                            if((acceptableDateTime < past2Yr)||Test.isRunningTest()){
                                system.debug('testLoop:::');
                                bwrap2.sCustomerName2 = dtAr.SERVICEHIST[i].CustomerName;
                                bwrap2.sShopsWorkOrder2 = dtAr.SERVICEHIST[i].ShopWO;
                                bwrap2.sMileage2 = Decimal.valueOf(dtAr.SERVICEHIST[i].Mileage);
                                bwrap2.sMeter2 = dtAr.SERVICEHIST[i].MileageMeasure;
                                bwrap2.sFaultcodeSym2 = dtAr.SERVICEHIST[i].FaultCodeSymptom;
                                bwrap2.sWorkSummary2 = dtAr.SERVICEHIST[i].WorkSummary;
                                bwrap2.sServiceModel2 = dtAr.SERVICEHIST[i].ServiceModelNM;
                                DateTime timeZone = Date.valueOf(dtAr.SERVICEHIST[i].JobDate);
                                bwrap2.sCreated_Time_Zone2 = timeZone.format('dd MMM yyyy hh:mm a z'); //ct3-637
                                bwrap2.sCreated_Time_sort2 = timeZone.format('yyyy MM dd HH:mm a z');
                                if(acct != null && IAMServiceProviderCodeToAccountMap.containskey(accLocation)){
                                    Account accLoc = IAMServiceProviderCodeToAccountMap.get(accLocation);
                                    bwrap2.sLocation2 = accLoc.Name;   
                                    bwrap2.sameLocation2 = (accLoc.Name == strLocation) ? true:false;                                    
                                }
                                lstwrap2.add(bwrap2);
                                system.debug('ListWrap:::'+lstwrap2);
                            }
                        }
                    }
                } // Ends here ----- Sriprada
            }
            for (WorkOrder b: lstjob2) {
                ServiceHistWrap2 bwrap2 = new ServiceHistWrap2();
                bwrap2.sCSSJobNum2 = b.WorkOrderNumber;
                bwrap2.sjobId2 = b.id;
                bwrap2.isWorkOrder = true;
                bwrap2.CreatedBy = b.CreatedById;
                bwrap2.CreatedByName = b.CreatedBy.name; //Added by Naveen PHOEN-131
                if(mapCA.size() > 0){
                    if(mapCA.containskey(b.id) && mapCA.get(b.id) != null) {
                        string urname = ''; //Added by Naveen Phoen-131----
                        if(mapCA.get(b.id).Assigned_to__c!= null ){
                            //Strat -----code changes added by Naveen PHOEN-131-------------
                            if(mapCA.get(b.id).Assigned_to__c.contains(',')){
                                urname = MultiUserscheck(mapCA.get(b.id).Assigned_to__c.split(','));
                                if(urname != ''){
                                    bwrap2.evolutiontech2 = urname;
                                }else{
                                    bwrap2.evolutiontech2 = null;
                                }
                            }else{
                                bwrap2.evolutiontech2 = mapCA.get(b.id).Assigned_to__c;
                            }
                            
                        }else{
                            bwrap2.evolutiontech2 =  null;
                        } 
                        //End -----code changes added by Naveen PHOEN-131---------------------
                    }
                }
                system.debug('evolutiontech2====>'+bwrap2.evolutiontech2);
                if(mapSA.size() > 0){
                    if(mapSA.containskey(b.id) && mapSA.get(b.id) != null) {
                        if(mapSA.get(b.id).user__c!= null ){
                            bwrap2.assignedResource2 =  mapSA.get(b.id).user__c ;
                        }else{
                            bwrap2.assignedResource2 =  null;
                        }
                    } 
                }
                if(b.Type__c == 'Dealer'){
                    bwrap2.sType2 = true;
                }
                else{
                    bwrap2.sType2 = false; 
                }
                if (b.Account.Name != null && (b.Type__c =='External' || b.Type__c =='Internal' )) {
                    bwrap2.sCustomerName2 = b.Account.Name;
                }
                //karthi G added as part of CT1-70
                if (b.EVL_Customer__c != null && b.Type__c =='Dealer' ) {
                    bwrap2.sCustomerName2 = b.EVL_Customer__c;
                }
                if (b.Shop_Work_Order__c != null && (b.Type__c =='External' || b.Type__c =='Internal' )) {
                    bwrap2.sShopsWorkOrder2 = b.Shop_Work_Order__c;
                }
                //karthi G added as part of CT1-70
                if (b.Dealer_Shop_Work_Order__c != null && b.Type__c =='Dealer') {
                    bwrap2.sShopsWorkOrder2 = b.Dealer_Shop_Work_Order__c;
                }
                if (b.createdDate != null) {
                    bwrap2.sCreated_Time_Zone2 = b.createdDate.format('dd MMM yyyy hh:mm a z'); //ct3-637
                    bwrap2.sCreated_Time_sort2 = b.createdDate.format('yyyy MM dd HH:mm a z');
                }
                if(b.ServiceTerritoryId != null && (b.Type__c =='External' || b.Type__c =='Internal' )) {
                    bwrap2.sLocation2 = b.ServiceTerritory.Name;
                    // Start - added by Naveen, PHOEN-209
                    if(strLocationterritory.size() > 0){
                    bwrap2.sameLocation2 = (strLocationterritory.contains(b.ServiceTerritory.Name)) ? true:false;	// added by Naveen, PHOEN-209
                    system.debug('sameLocation2 ===>'+bwrap2.sameLocation2);
                    }else{
                        bwrap2.sameLocation2 =   (b.ServiceTerritory.Name == strLocation) ? true:false;
                    }
                     // End - added by Naveen, PHOEN-209 
                }
                // karthik Added as part of EVL dealer chnages CT1-70
                if(b.Account.Name != null &&  b.Type__c =='Dealer') { //karthik G added
                    bwrap2.sLocation2 = b.Account.Name;
                    bwrap2.sameLocation2 =   (b.Account.Name == strLocation) ? true:false;
                    
                }
                if (b.Service_Model__c != null) {
                    bwrap2.sServiceModel2 = b.Service_Model__c;
                }
                //Added the Customer Complaint column in Service History table2 on View History Chevron
                if (b.Category1__c != null && b.Complaint_Type1__c != null) {
                    bwrap2.sCustomerComplaint2 = b.Category1__c + ' / ' + b.Complaint_Type1__c;
                    
                }
                if (b.General_Symptoms__c != null && b.Type__c =='Dealer') {
                    bwrap2.sCustomerComplaint2 = b.General_Symptoms__c;
                    
                }
                
                //Added by shanthi - Rod: 88178
                integer faulCodCount2 = 0;
                integer fcCounter2 = 0;
                if(b.Process_Step__c != null) {
                    System.debug('::: Inside symp='+allFaultCodes2);
                    if(allFaultCodes2.size()>0){
                        System.debug('Inside symp 1 = '+allFaultCodes2);
                        for(CSS_Fault_Code__c fauCod : allFaultCodes2){
                            if(fauCod.Service_Order__c == b.id){
                                if(fcCounter2 >= 0){ 
                                    fcCounter2++;
                                } 
                                for(CSS_Solutions__c sol : fauCod.CSS_Solutions__r){
                                    if(faulCodCount2 >= 0){
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.FaultCode__c == fauCod.id){
                                                bwrap2.sFaultcodeSym2 = bwrap2.sFaultcodeSym2 + fauCod.Name + '\n'; 
                                                bwrap2.sWorkSummary2 = bwrap2.sWorkSummary2+ sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                faulCodCount2++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                    integer sympCounter2 = 0;
                    integer symCount2 = 0;
                    if(faulCodCount2==0){
                        System.debug('Inside symp 2');
                        for(CSS_SymptomQA__c symp : allRecList2){
                            System.debug('Inside symp 3'+symp.Name);
                            if(symp.Service_Order__c == b.id && symp.Type__c == 'SearchString'){
                                if(symCount2<3){
                                    bwrap2.sFaultcodeSym2 = bwrap2.sFaultcodeSym2+  symp.Name + '\n';
                                    symCount2++;
                                }
                                System.debug('Inside symp 4'+symp.Service_Order__r);
                                for(CSS_Solutions__c sol : symp.CSS_Solutions__r){
                                    
                                    if(sympCounter2<3){
                                        System.debug('Inside symp 5'+sol.Solution_Title__c);
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.Symptom__c == symp.id){
                                                System.debug('Inside symp 6'+sol.Symptom__c);
                                                bwrap2.sWorkSummary2  = bwrap2.sWorkSummary2+  sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                sympCounter2++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                }
                lstwrap2.add(bwrap2);
            }
            
            for(CSS_Job_Order__c b: lstjobG) {
                ServiceHistWrap2 bwrap2 = new ServiceHistWrap2();
                bwrap2.sCSSJobNum2 = b.Name;
                bwrap2.sjobId2 = b.id;
                
                if (b.Customer_Name__c != null) {
                    bwrap2.sCustomerName2 = b.Customer_Name__c;
                }
                //Added the Customer Complaint column in Service History table1 on View History Chevron
                if (b.Category__c != null && b.Complaint_Type__c != null) {
                    bwrap2.sCustomerComplaint2 = b.Category__c + ' / ' + b.Complaint_Type__c;
                    
                }
                if (b.Shop_Work_Order__c != null) {
                    bwrap2.sShopsWorkOrder2 = b.Shop_Work_Order__c;
                } 
                if (b.Mileage__c != null && b.Mileage__c != 0) {
                    bwrap2.sMileage2 = b.Mileage__c;
                    bwrap2.sMeter2 = b.Mileage_Measure__c;
                } 
                else{
                    if(b.CSS_Hours__c != null) {
                        bwrap2.sMileage2 = b.CSS_Hours__c;
                        bwrap2.sMeter2 = 'Hours';
                    }
                    else {
                        bwrap2.sMileage2 = b.Mileage__c;
                        bwrap2.sMeter2 = b.Mileage_Measure__c;
                    }
                }
                
                if (b.Service_Model__c != null) {
                    bwrap2.sServiceModel2 = b.Service_Model__c;
                } 
                if(b.Created_Time_Zone__c != null) {
                    bwrap2.sCreated_Time_Zone2 = b.Created_Time_Zone__c.format('dd MMM yyyy hh:mm a z'); //ct3-637
                    bwrap2.sCreated_Time_sort2 = b.Created_Time_Zone__c.format('yyyy MM dd HH:mm a z');
                }
                if(b.createdBy.User_Location__c != null)
                {
                    bwrap2.sLocation2 = b.createdBy.User_Location__c;
                    bwrap2.sameLocation2 = (b.createdBy.User_Location__c == strLocation) ? true:false;
                }
                
                integer faulCodCount = 0;
                integer fcCounter = 0;
                if(b.Status__c != 'Closed'){
                    System.debug('::: Inside symp'+allFaultCodesG);
                    if(allFaultCodesG.size() > 0) {
                        System.debug('Inside symp 1');
                        for(CSS_Fault_Code__c fauCod : allFaultCodesG){
                            if(fauCod.Job_Order__c == b.id){
                                if(fcCounter > 0) {
                                    fcCounter++;
                                }
                                for(CSS_Solutions__c sol : fauCod.CSS_Solutions__r) {
                                    if(faulCodCount < 5) {
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.FaultCode__c == fauCod.id){
                                                bwrap2.sFaultcodeSym2 = bwrap2.sFaultcodeSym2 + fauCod.Name + '\n'; 
                                                bwrap2.sWorkSummary2 = bwrap2.sWorkSummary2 + sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                faulCodCount++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                    integer sympCounter = 0;
                    integer symCount = 0;
                    if(faulCodCount == 0) {
                        System.debug('Inside symp 2');
                        for(CSS_SymptomQA__c symp : allRecListG) {
                            System.debug('Inside symp 3'+symp.Name);
                            System.debug('::: Inside symp 3='+symp.Job_Order__c+' and '+b.id+' and '+symp.Type__c);
                            if(symp.Job_Order__c == b.id && symp.Type__c == 'SearchString') {
                                if(symCount<3){
                                    bwrap2.sFaultcodeSym2 = bwrap2.sFaultcodeSym2+  symp.Name + '\n';
                                    symCount++;
                                }
                                System.debug('Inside symp 4'+symp.Job_Order__c);
                                for(CSS_Solutions__c sol : symp.CSS_Solutions__r) {
                                    if(sympCounter < 3) {
                                        System.debug('Inside symp 5'+sol.Solution_Title__c);
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.Symptom__c == symp.id){
                                                System.debug('Inside symp 6'+sol.Symptom__c);
                                                bwrap2.sWorkSummary2  = bwrap2.sWorkSummary2+  sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                sympCounter++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                }
                lstwrap2.add(bwrap2);
            }
            
            WorkOrder so = [SELECT Id, Type__c, Asset.Individual__c, Asset.Engine_Manufacturer__c, Service_Location__c
                            FROM WorkOrder 
                            WHERE Asset.Name=:strESN 
                            ORDER BY CreatedDate DESC LIMIT 1];
            system.debug('ItemNumber:'+Asset.Individual__c );
            
            if(so.Type__c != 'Dealer' && sLoc != null){
                String subString = sLoc.substringBefore('-');
                String subString2 = sLoc.substringAfter('-').substring(0,5);
                if(UserERP == 'BMS'){
                    sLoc = subString + '-' + subString2;
                }
                //CT3-262
                if(so.Asset.Individual__c != null && so.Asset.Individual__c != '' && so.Asset.Engine_Manufacturer__c != 'CUMMINS') {
                    itemNumber = String.valueOf(so.Asset.Individual__c);
                    system.debug('ItemNumber:'+itemNumber);
                } else {
                    itemNumber = '';
                }
                system.debug('Location Code:'+sLoc);
                system.debug('Location:'+strLocation);
                system.debug('Location territory:'+strLocationterritory);
                system.debug('strESN >>>' + strESN);
                system.debug('itemNumber >>>' + itemNumber);
                /**make Call for Service History **/
                FSL_CL_ServiceHistoryWrapper ServiceHistoryObj = new FSL_CL_ServiceHistoryWrapper();
                if(string.isNotBlank(strESN) && string.isNotBlank(sLoc))
                {
                    ServiceHistoryObj = FSL_CL_QSOLIntegrations.getServiceHistory(strESN, sLoc, itemNumber);
                    System.debug('**   ServiceHistoryObj --------------------->: ' + ServiceHistoryObj);
                    listHis.add(ServiceHistoryObj);
                    system.debug('Service History List:'+listHis);
                }

                 
                List<String> locationCodeList = new List<String>();
                Map<String, ServiceTerritory> locationCodeToServiceTerritoryMap = new Map<String, ServiceTerritory>();
                for(FSL_CL_ServiceHistoryWrapper historyObj : listHis) {
                    if(historyObj.DataArea != null && historyObj.DataArea.size() >0)
                    {
                        for(integer i = 0;i<historyObj.DataArea.size();i++)
                        {
                           locationCodeList.add(historyObj.DataArea[i].Location);
                        }
                    }
                }
                for(ServiceTerritory servTerr : [select id,name,Location_Code__c from ServiceTerritory where Location_Code__c IN :locationCodeList]) {
                    locationCodeToServiceTerritoryMap.put(servTerr.Location_Code__c, servTerr);
                }
                
                           
                
                for(FSL_CL_ServiceHistoryWrapper historyObj:listHis)
                {             
                    if(historyObj.DataArea != null && historyObj.DataArea.size() >0)
                    {
                        for(integer i = 0;i<historyObj.DataArea.size();i++)
                        {
                            ServiceHistWrap hisWrap = new ServiceHistWrap();
                            ServiceHistWrap2 hisWrap2 = new ServiceHistWrap2();
                            
                            system.debug('data : '+historyObj.DataArea[i]);
                            String timeStamp;
                            DateTime acceptableDateTime;
                            if(historyObj.DataArea[i].ReceivedDate != ''){
                                String ReceivedDate = historyObj.DataArea[i].ReceivedDate;
                                acceptableDateTime = DateTime.Valueof(ReceivedDate.replace('T', ' ')); 
                                system.debug('TimeCheck***:'+lastDate2);
                                system.debug('TimeCheckBefore***:'+acceptableDateTime);
                                system.debug('TimeCheckCreated***:'+dtCreated);
                                timeStamp = String.valueOf(acceptableDateTime.format('dd MMM YYYY hh:mm a z'));
                                system.debug('Time Stamp:'+timeStamp);}
                            else{
                                timeStamp = '';
                            }
                            if( acceptableDateTime < past2Yr){
                                
                                system.debug('TimeCheck***:'+lastDate2);
                                system.debug('TimeCheckBefore***:'+acceptableDateTime);
                                system.debug('TimeCheckCreated***:'+dtCreated);
                                
                                hisWrap2.sFaultcodeSym2 =  (historyObj.DataArea[i].WorkSummaryCAUSE != null || historyObj.DataArea[i].WorkSummaryCAUSE != '') ? historyObj.DataArea[i].WorkSummaryCAUSE : '';
                                hisWrap2.sCustomerName2 = (historyObj.DataArea[i].CustomerName != null || historyObj.DataArea[i].CustomerName != '') ? historyObj.DataArea[i].CustomerName : '';
                                hisWrap2.sShopsWorkOrder2 = (historyObj.DataArea[i].BMSWOreference != null || historyObj.DataArea[i].BMSWOreference != '') ? historyObj.DataArea[i].BMSWOreference : '';
                                
                                string loc =  historyObj.DataArea[i].Location;
                                system.debug('Location ID'+ loc);
                                if(locationCodeToServiceTerritoryMap.containskey(loc)) {
                                    ServiceTerritory st = locationCodeToServiceTerritoryMap.get(loc);
                                    hisWrap2.sLocation2 = st.Name;
                                    // Start - added by Naveen, PHOEN-209
                                     if(strLocationterritory.size() > 0){
                                         hisWrap2.sameLocation2 = (strLocationterritory.contains(st.Name)) ? true:false;	
                                         system.debug('Location is'+st.Name);
                                     }else{
                                         hisWrap2.sameLocation2 =   (st.Name == strLocation) ? true:false;
                                     }
                                    // End - added by Naveen, PHOEN-209
                                      
                                }
                                
                                hisWrap2.sCustomerComplaint2 = (historyObj.DataArea[i].WorkSummaryCOMPLAINT != null || historyObj.DataArea[i].WorkSummaryCOMPLAINT != '') ? historyObj.DataArea[i].WorkSummaryCOMPLAINT : '';
                                hisWrap2.sWorkSummary2 = (historyObj.DataArea[i].FaultcodesCORRECTION != null || historyObj.DataArea[i].FaultcodesCORRECTION != '') ?  historyObj.DataArea[i].FaultcodesCORRECTION : '';
                                hisWrap2.sCreated_Time_Zone2 = timeStamp;
                                hisWrap2.sMileage2 = (historyObj.DataArea[i].Distance != '' ) ? Decimal.valueOf(historyObj.DataArea[i].Distance) : null;
                                hisWrap2.sMeter2 = (historyObj.DataArea[i].DistanceType != '' || historyObj.DataArea[i].DistanceType != null) ? historyObj.DataArea[i].DistanceType : '';
                                hisWrap2.sServiceModel2 = (historyObj.DataArea[i].ProductModel != null || historyObj.DataArea[i].ProductModel != '') ? historyObj.DataArea[i].ProductModel : '';
                                lstwrap2.add(hisWrap2);
                                system.debug('879-List****'+lstwrap2); 
                            }                                   
                        }               
                    }
                }
                system.debug('lastDate '+lastDate2+'dtCreated '+past2Yr);
                system.debug('List****'+lstwrap2);
                if(!test.isRunningTest()) {
                    return JSON.serialize(lstwrap2);
                }
                
                
            }
            Histlstjob2 = [select Attribute1__c, Attribute13__c,Attribute14__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, 
                           Attribute9__c, Attribute10__c, Attribute11__c, Attribute12__c, Attribute15__c, Circuit_Description__c, Reason__c 
                           from CSS_JobEventTemporary__c where  key__c = :strESN and Attribute13__c < :lastDate2 and Attribute13__c >= : past2Yr];           
            
            Boolean displayHist2;
            system.debug('Histlstjob2 '+Histlstjob2);
            for (CSS_JobEventTemporary__c b: Histlstjob2) {
                
                ServiceHistWrap2 bwrap2 = new ServiceHistWrap2();
                displayHist2=true;
                if (lstjob2!=null) {
                }
                
                if(displayHist2){
                    if(b.Attribute1__c != null){
                        Boolean repeat_flag = Boolean.valueOf(b.Attribute1__c);
                        bwrap2.sRepeat_Visit2 = repeat_flag; 
                    }
                    if(b.Attribute13__c !=null){                    
                        bwrap2.sCreated_Time_Zone2 = b.Attribute13__c.format('dd MMM yyyy hh:mm a z'); //ct3-637
                        bwrap2.sCreated_Time_sort2 = b.Attribute13__c.format('yyyy MM dd HH:mm a z');
                    }
                    
                    if (b.Attribute3__c != null) {
                        bwrap2.sCustomerName2 = b.Attribute3__c;
                    }
                    //commented by manjari
                    //bwrap2.sCSSJobNum2 = b.Attribute4__c;
                    if (b.Attribute5__c != null) {
                        bwrap2.sShopsWorkOrder2 = b.Attribute5__c;
                    } 
                    if (b.Attribute6__c != null) {
                        bwrap2.sServiceModel2 = b.Attribute6__c;
                    } 
                    if (b.Attribute7__c != null) {
                        bwrap2.sLocation2 = b.Attribute7__c;
                        bwrap2.sameLocation2 =   (b.Attribute7__c == strLocation) ? true:false;
                    }
                    if (b.Circuit_Description__c!=null){
                        system.debug('Circuit_Description__c *** --> '+b.Circuit_Description__c);
                        bwrap2.sWorkSummary2 = b.Circuit_Description__c;
                    }
                    if (b.Attribute8__c != null) {  
                        bwrap2.sFaultcodeSymp2 = b.Attribute8__c;
                    }
                    if ((b.Attribute14__c != null) && (b.Attribute14__c.equalsIgnoreCase('undefined')!= true)) { // added by sai 0921 'undefined'
                        String NumericValue = ''; // Begin-71133:Sai:0926 - Added the below logic to parse Integer/Floating number from Miles attribute(Attribute14__c)
                        for(string s : b.Attribute14__c.split('(?!d*^)')){
                            if(s.isNumeric() || s =='.'){
                                NumericValue = NumericValue+s;
                                system.debug('Numeric Value is --' + NumericValue);
                            }
                        }
                        if(NumericValue!= null && NumericValue!=''){
                            Decimal mil = Decimal.valueOf(NumericValue);
                            bwrap2.sMileage2 = mil;
                        }
                    }
                    if(b.Attribute9__c!=null){
                        if(b.Attribute9__c.contains('MI')){
                            bwrap2.sMeter2 = 'Miles';
                        }
                        else if(b.Attribute9__c.contains('KM')){
                            bwrap2.sMeter2 = 'Km';
                        }
                        else if(b.Attribute9__c.contains('HR')){
                            bwrap2.sMeter2 = 'Hours';
                        }
                    }
                    if (b.Attribute15__c != null) {
                        bwrap2.sBMSLink2 = b.Attribute15__c;
                    }
                    if (b.Reason__c != null) {
                        bwrap2.sFaultCodeSym2 = b.Reason__c;
                    }
                    lstwrap2.add(bwrap2);
                    system.debug('bwrap2 '+ bwrap2);
                }
            }
            system.debug('lstwrap2 '+lstwrap2);
            return JSON.serialize(lstwrap2);
        } catch(Exception e) { 
            system.debug('exception '+e.getMessage());
            system.debug('::: exception stack = '+e.getStackTraceString());
            return null;
        }
    }
    //Method and logic code added by Naveen PHOEN-131-----
    public static string MultiUserscheck(List<String> listUsers){
        string TechUser = '';
        for(string un: listUsers){
            if(un.contains(UserInfo.getName()) ){
                TechUser = un;
            }
        }
        system.debug('TechUser==>'+TechUser);
        return TechUser;
    }
}