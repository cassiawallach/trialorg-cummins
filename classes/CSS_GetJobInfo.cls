/*
*****************************************************************************
HISTORY
*****************************************************************************
******************************************************************************
Version        Author        Date        Details
1.0  Vignesh  Shanmugakani              Intial Developement
1.1  Rajesh Narra           10-24-2017  Made modifications to the existing class and added SymptomQA
2.1  Gopal Raj              04-06-2018  Updated with story#
2.2  Rajesh Narra           05-17-2019  Updated css_dealercode__c with IAM_Service_Provider_Code__c
****************************************************************************
*/
@RestResource(UrlMapping = '/GetJobInfo/*')
global with sharing class CSS_GetJobInfo {
    
    @HttpPost
    global static CSS_GetJobInfoResWrapper GetJobInfomration() {
        CSS_GetJobInfoResWrapper resJSON = null;
        CSS_GetJobInfoResWrapper.DataArea resDataArea = new CSS_GetJobInfoResWrapper.DataArea();
        CSS_GetJobInfoResWrapper.Header resHeader = new CSS_GetJobInfoResWrapper.Header();
        CSS_GetJobInfoResWrapper.CUST_DATA resCUST_DATA = new CSS_GetJobInfoResWrapper.CUST_DATA();
        CSS_GetJobInfoResWrapper.UNIT_DATA resUNIT_DATA = new CSS_GetJobInfoResWrapper.UNIT_DATA();
        CSS_GetJobInfoResWrapper.FAULTDETAILS resFAULTDETAILS = null;
        CSS_GetJobInfoResWrapper.SymptomData resSymptomData = null;
        CSS_GetJobInfoResWrapper.SolutionData resSolutionData = null;
        CSS_GetJobInfoResWrapper.RepairData resRepairData = null;
        
        List<CSS_DataExchange_Child__c> lstDEChild = new List<CSS_DataExchange_Child__c>();
        WrapperInput wrapperObj = new WrapperInput();
        ComponentWrapper compwrapperObj = new ComponentWrapper();
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String jSONRequestBody = req.requestBody.toString().trim();
            CSS_GetJobInfoReqWrapper reqJSON;
            resHeader.ServiceName = wrapperObj.ServiceName;
            resHeader.ServiceVersion = wrapperObj.ServiceVersion;
            resHeader.Status = 'ERROR';
            resJSON = new CSS_GetJobInfoResWrapper();
            //This (try ,catch) block of code is used to catch any kind of JSON format validations in the request
            
            try{
                reqJSON = (CSS_GetJobInfoReqWrapper)JSON.deserializeStrict(jSONRequestBody,CSS_GetJobInfoReqWrapper.class);
            }catch(Exception ex){
                resHeader.ReturnCode = 'CSS10';
                resHeader.ReturnCodeDescription = 'Invalid JSON Format';
                resJSON.Header = resHeader;
                return resJSON;
            }
            //This block of code verify whether the service name is not null or not equal to GetJobInfo
            
            if(reqJSON.Header.ServiceName==null || reqJSON.Header.ServiceName!='GetJobInfo'){
                resHeader.ReturnCode = 'CSS02';
                resHeader.ReturnCodeDescription = 'Service Name is invalid/missing';
                resJSON.Header = resHeader;
                return resJSON;
            }
            wrapperObj.ServiceName = reqJSON.Header.ServiceName;
            wrapperObj.ServiceVersion = reqJSON.Header.ServiceVersion;
            //This block of code verify whether the tool id is not null or empty
            
            if(reqJSON.Header.ToolID==null || reqJSON.Header.ToolID==''){
                resHeader.ReturnCode = 'CSS03';
                resHeader.ReturnCodeDescription = 'ToolID is invalid';
                resJSON.Header = resHeader;
                return resJSON;
            }
            
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            wrapperObj.SPCode = reqJSON.Header.SPCode;
            wrapperObj.SenderID = reqJSON.Header.SenderID;
            wrapperObj.TargetID = reqJSON.Header.TargetID;
            
            wrapperObj.CSSJobID = reqJSON.DataArea.CSSJobID;
            wrapperObj.ShopWO = reqJSON.DataArea.ShopWO;
            CSS_Job_Order__c jobdetails;
            id usrid = userinfo.getuserid(); //Logic Added by Gopal
            boolean Dealercodestatus;
            if (usrid == null) // || usrid =='')
            {
                resHeader.ReturnCode = 'CSS07';
                resHeader.ReturnCodeDescription = 'Problem with DataExchange Setup: Invalid API User';
                resJSON.Header = resHeader;
                return resJSON;
            }
            else {
                ID accd1 = [select id, accountid from user where id=:usrid Limit 1].accountid;
                if (accd1 == null) // || accd1 =='')
                {
                    resHeader.ReturnCode = 'CSS08';
                    resHeader.ReturnCodeDescription = 'Problem with DataExchange Setup: API User Location unavailable';
                    resJSON.Header = resHeader;
                    return resJSON;
                }
                else 
                {
                    list<account> act = [select id ,css_de_parent__c, Data_Exchange_Enabled__c,
                                         Customer_Data_Send_to_CSS__c, Vehicle_Unit_Data_Send_to_CSS__c,
                                         ESN_Service_History_Send_to_CSS__c, Location__c,IAM_Service_Provider_Code__c
                                         from account where css_de_parent__c=:accd1];
                    Dealercodestatus = false;
                    for(account acc1:act)
                    {
                        if(acc1.IAM_Service_Provider_Code__c==wrapperObj.SPCode)
                            Dealercodestatus=true;
                    }
                }
            }
            
            //This (try ,catch) block of code is used verify whether the CSSJobID and ShopWorkOrder is valid or not
            if(Dealercodestatus==true)//Logic Added by Gopal
            {
                try{
                    //Make code changes
                    jobdetails = [Select id, name, ESN__c, Date_in_Shop__c,Service_Model_N__c, Make__c, Model__c, 
                                  Creator_Location__c, Mileage__c, Mileage_Measure__c, Warranty_Start_Date__c, 
                                  CSS_Hours__c, Failure_Date__c, Before_In_Service__c, Application__c, VIN__c, 
                                  Customer_Name__c, Unit_Number__c, Customer_Code__c, Contact_Name__c, CSS_State__c, 
                                  Country__c, Address__c, City__c, Shop_Work_Order__c from CSS_Job_Order__c
                                  where name = : wrapperObj.CSSJobID and Shop_Work_Order__c = : wrapperObj.ShopWO];
                                  
                }catch(Exception ex){
                    resHeader.ReturnCode = 'CSS04';
                    resHeader.ReturnCodeDescription = 'CSS Job Id is inactive/invalid';
                    resJSON.Header = resHeader;
                    return resJSON;
                }
            }
            else//Logic Added by Gopal
            {
                resHeader.ReturnCode = 'CSS05';
                resHeader.ReturnCodeDescription = 'Problem with DataExchange Setup: SP Code not part of API user';
                resJSON.Header = resHeader;
                return resJSON;
            }
            Account acc = [select id, Customer_Data_Receive_from_CSS__c, Vehicle_Unit_Data_Receive_from_CSS__c,
                           Fault_Code_Data_Receive_from_CSS__c,Repair_Data_Receive_from_CSS__c,
                           Solution_Data_Receive_from_CSS__c,Data_Exchange_Enabled__c 
                           from Account where Location__c =:jobdetails.Creator_Location__c];
            CSS_DataExchange_Parent__c dataParent;
            
            //This (try ,catch) block of code is used verify whether there is unprocessed data is available or not in the data exchange parent object
            
            try{
                dataParent  = [Select id, Failure_Point__c,Customer_Name__c, CustomerID__c, Hours__c,ESN__c, 
                               Unit_Number__c, Failure_Date__c, MAKE__c, VIN__c, Mileage_Hours__c, 
                               Warranty_Start_Date__c, Mileage_Measure__c, MODEL__c, Application__c, Address__c, 
                               SERVICEMODELNAME__c, Contact_Name__c, City__c, State__c, Country__c,Before_In_Service__c 
                               from CSS_DataExchange_Parent__c 
                               where CSS_Job_Number__c = : wrapperObj.CSSJobID 
                               and DataExchange_Status__c =: 'UnProcessed' limit 1 ];
            }catch(Exception ex){
                resHeader.ReturnCode = 'CSS09';
                resHeader.ReturnCodeDescription = 'No Recent Data Available';
                resJSON.Header = resHeader;
                return resJSON;
            }
            
            lstDEChild= [Select id,CSS_DataExchange_Parent__c,Selected_Component__c,Repair_Comments__c, 
                         DataExchangeChild_Status__c,DataExchangeChildType__c,Count__c,ESN__c,FaultCode__c,
                         Fault_Code__c,FaultCodeR2__c,Fault_Code_Type__c,Make__c,Model__c,Primary_Fault_Code__c,
                         RelatedFault_Code__c,Related_Fault_Code__c,Service_Model_Name__c,VIN__c,Comments__c,
                         Sol_Descriptions__c,Solutions_Descriptions__c,Solution_Number__c,Repair_Solution__c,
                         Repair_Symptom__c,Solution_Symptom__c,Caption__c,Solution_Fault_Code__c,
                         Solution_Related_Fault_Code__c,Repair_Fault_Code__c,Repair_Related_Fault_Code__c,
                         Repair_Action__c,Solution_Title__c from CSS_DataExchange_Child__c 
                         Where DataExchangeChild_Status__c=:'UnProcessed' and  CSS_DataExchange_Parent__c=:dataParent.Id ];
            
            System.debug('shanthi acc ' + acc);
            System.debug('shanthi jobdetails ' + jobdetails);
            System.debug('shanthi dataParent ' + dataParent);
            System.debug('Shanthi dataChild '+lstDEChild);
            if (jobdetails != null) {
                resDataArea.CSSJobId = jobdetails.name;
                resDataArea.PSN = jobdetails.ESN__c;
                resDataArea.SERVICEMODELNAME = String.ValueOf(jobdetails.Service_Model_N__c);
                resDataArea.MAKE = jobdetails.Make__c;
                resDataArea.MODEL = jobdetails.Model__c;
                resDataArea.CUSTOMERNAME = jobdetails.Customer_Name__c;
                resDataArea.SHOPWO = jobdetails.Shop_Work_Order__c;
                resDataArea.DATEAVAILSERVICE = String.ValueOf(jobdetails.Date_in_Shop__c);
                resHeader.ServiceName = wrapperObj.ServiceName;
                resHeader.ServiceVersion = wrapperObj.ServiceVersion;
                resHeader.Status = 'Success';
                resHeader.ReturnCode = 'CSS00';
                resHeader.ReturnCodeDescription = '';
                
                if (acc.Customer_Data_Receive_from_CSS__c == true && acc.Data_Exchange_Enabled__c == true) {
                    resCUST_DATA.CustomerName = dataParent.Customer_Name__c;
                    resCUST_DATA.CustomerID = dataParent.CustomerID__c;
                    resCUST_DATA.ContactName = dataParent.Contact_Name__c;
                    resCUST_DATA.AddressLine1 = dataParent.Address__c;
                    resCUST_DATA.AddressLine2 = dataParent.Address__c;
                    resCUST_DATA.City = dataParent.City__c;
                    resCUST_DATA.StateProvince = dataParent.State__c;
                    resCUST_DATA.Country = dataParent.Country__c;
                    resDataArea.CUST_DATA=resCUST_DATA;
                    dataParent.DataExchange_Status__c = 'Processed';
                    update dataParent;
                }
                if (acc.Vehicle_Unit_Data_Receive_from_CSS__c == true && acc.Data_Exchange_Enabled__c == true) {
                    resUNIT_DATA.ESN = dataParent.ESN__c;
                    resUNIT_DATA.UnitNumber = dataParent.Unit_Number__c;
                    resUNIT_DATA.Application = dataParent.Application__c;
                    resUNIT_DATA.ServiceModel = String.ValueOf(dataParent.SERVICEMODELNAME__c);
                    resUNIT_DATA.Make = dataParent.MAKE__c;
                    resUNIT_DATA.Model = dataParent.MODEL__c;
                    resUNIT_DATA.VIN = dataParent.VIN__c;
                    resUNIT_DATA.WarrStartDate = String.ValueOf(dataParent.Warranty_Start_Date__c);
                    resUNIT_DATA.FailureDate = String.ValueOf(dataParent.Failure_Date__c);
                    resUNIT_DATA.MileageOrKms = String.valueOf(dataParent.Mileage_Hours__c);
                    resUNIT_DATA.MileageMeasure = String.ValueOf(dataParent.Mileage_Measure__c);
                    resUNIT_DATA.Hours = String.ValueOf(dataParent.Hours__c);  
                    resUNIT_DATA.FailurePoint=String.ValueOf(dataParent.Failure_Point__c) ;
                    resUNIT_DATA.BeforeInService=String.valueOf(dataParent.Before_In_Service__c);
                    resDataArea.UNIT_DATA=resUNIT_DATA;
                    dataParent.DataExchange_Status__c = 'Processed';
                    update dataParent;
                }
                if(lstDEChild.size()>0 && acc.Data_Exchange_Enabled__c == true && (acc.Solution_Data_Receive_from_CSS__c == true || acc.Repair_Data_Receive_from_CSS__c == true || acc.Fault_Code_Data_Receive_from_CSS__c == true)){
                    
                    for(integer i=0;i<lstDEChild.size();i++){
                        if(lstDEChild[i].DataExchangeChildType__c!=null){
                            if(lstDEChild[i].DataExchangeChildType__c=='FaultCode' && acc.Fault_Code_Data_Receive_from_CSS__c == true){
                                System.debug('shanthi fault if 1 ');
                                resFAULTDETAILS = new CSS_GetJobInfoResWrapper.FAULTDETAILS();
                                resFAULTDETAILS.Count=String.ValueOf(lstDEChild[i].Count__c);
                                resFAULTDETAILS.FaultCodeText=lstDEChild[i].FaultCode__c;
                                resFAULTDETAILS.FaultCode=lstDEChild[i].FaultCodeR2__c;
                                resFAULTDETAILS.FaultCodeType=lstDEChild[i].Fault_Code_Type__c;
                                resFAULTDETAILS.PrimaryFC=String.ValueOf(lstDEChild[i].Primary_Fault_Code__c);
                                resFAULTDETAILS.RelatedFC=lstDEChild[i].Related_Fault_Code__c;
                                resFAULTDETAILS.RelatedFC_Text=lstDEChild[i].Related_Fault_Code__c;
                                resDataArea.FAULTDETAILS.add(resFAULTDETAILS);
                                lstDEChild[i].DataExchangeChild_Status__c='Processed';
                            }
                            if(lstDEChild[i].DataExchangeChildType__c=='SymptomQA' && acc.Fault_Code_Data_Receive_from_CSS__c == true){
                                resSymptomData = new CSS_GetJobInfoResWrapper.SymptomData();
                                resSymptomData.SymptomName =lstDEChild[i].Caption__c;
                                resDataArea.SymptomData.add(resSymptomData);
                                lstDEChild[i].DataExchangeChild_Status__c='Processed';
                            }
                            
                            if(lstDEChild[i].DataExchangeChildType__c=='SolutionData' && acc.Solution_Data_Receive_from_CSS__c == true){
                                System.debug('shanthi sol if  ');
                                resSolutionData = new CSS_GetJobInfoResWrapper.SolutionData();
                                resSolutionData.SolDescriptions=lstDEChild[i].Sol_Descriptions__c;
                                resSolutionData.SolutionTitle = lstDEChild[i].Solution_Title__c;
                                resSolutionData.Comments=lstDEChild[i].Comments__c;
                                resSolutionData.SolutionNumber=lstDEChild[i].Solution_Number__c;
                                if(lstDEChild[i].Solution_Symptom__c!='' && lstDEChild[i].Solution_Symptom__c!=null)
                                    resSolutionData.SymptomName=lstDEChild[i].Solution_Symptom__c;
                                if(lstDEChild[i].Solution_Fault_Code__c!=null){
                                    resSolutionData.FaultCode = lstDEChild[i].Solution_Fault_Code__c;
                                    resSolutionData.RelatedFC = lstDEChild[i].Solution_Related_Fault_Code__c;
                                }
                                resDataArea.SolutionData.add(resSolutionData);
                                lstDEChild[i].DataExchangeChild_Status__c='Processed';
                            }
                            if(lstDEChild[i].DataExchangeChildType__c=='RepairData' && acc.Repair_Data_Receive_from_CSS__c == true){
                                System.debug('shanthi repair if  ');
                                if(lstDEChild[i].Selected_Component__c!=null && lstDEChild[i].Selected_Component__c!=''){
                                    resRepairData = new CSS_GetJobInfoResWrapper.RepairData();
                                    String[] s = (lstDEChild[i].Selected_Component__c).split('},');
                                    for(String s1: s){
                                        String s2= s1+'}';
                                        ComponentWrapper ressJSON = (ComponentWrapper) JSON.deserialize((s2), ComponentWrapper.class);
                                        CSS_GetJobInfoResWrapper.Components resComponents= new CSS_GetJobInfoResWrapper.Components();
                                        resComponents.ComponentID=ressJSON.ComponentID;
                                        resComponents.ComponentName=ressJSON.ComponentName;
                                        resComponents.Action=ressJSON.Action;
                                        resRepairData.Components.add(resComponents);
                                    }
                                }
                                resRepairData.SolutionTitle=lstDEChild[i].Solution_Title__c;
                                System.debug('**'+lstDEChild[i].Repair_Comments__c);
                                System.debug('**'+lstDEChild[i].Repair_Action__c);
                                resRepairData.RepairComments=lstDEChild[i].Repair_Comments__c;
                                resRepairData.RepairAction=lstDEChild[i].Repair_Action__c;
                                resRepairData.SolutionNumber = lstDEChild[i].Repair_Solution__c;
                                if(lstDEChild[i].Repair_Symptom__c!='' && lstDEChild[i].Repair_Symptom__c!=null)
                                    resRepairData.SymptomName = lstDEChild[i].Repair_Symptom__c;
                                if(lstDEChild[i].Repair_Fault_Code__c!='' && lstDEChild[i].Repair_Fault_Code__c!=null){
                                    resRepairData.FaultCode = lstDEChild[i].Repair_Fault_Code__c;
                                    resRepairData.RelatedFC = lstDEChild[i].Repair_Related_Fault_Code__c;
                                }
                                resDataArea.RepairData.add(resRepairData);
                                lstDEChild[i].DataExchangeChild_Status__c='Processed';
                            }
                            
                        }
                        update lstDEChild;
                    }
                }
            }
            resJSON.DataArea = resDataArea;
            resJSON.Header = resHeader;
            return resJSON;
        }
        catch (Exception ex) {
            resHeader.ServiceName = wrapperObj.ServiceName;
            resHeader.ServiceVersion = wrapperObj.ServiceVersion;
            //resHeader.ReturnCodeDescription = 'No Recent Data Available';
            resHeader.ReturnCodeDescription = 'Data Exchange is not Enabled for SP';
            resHeader.Status = 'ERROR';
            resHeader.ReturnCode = 'CSS01';
            resJSON = new CSS_GetJobInfoResWrapper();
            resJSON.Header = resHeader;
            return resJSON;
        } finally {
            wrapperObj = null;
        }
     //   return resJSON;
    }
    
    public class WrapperInput {
        public String CSSJobID;
        public String ShopWO;
        public String ServiceName;
        public String ServiceVersion;
        public String ToolID;
        public String SPCode;
        public String SenderID;
        public String TargetID;
    }
    
    public Class ComponentWrapper {
        public String ComponentID;
        public String ComponentName;
        public String Action;
    }
    
}