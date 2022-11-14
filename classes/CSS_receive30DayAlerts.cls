/**********************************************************************
Name:  CSS_receive30DayAlerts
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to retrieve the 30 day Alerts from Connected Diagnostics.                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 - Shruti            2/1/2016     INITIAL DEVELOPMENT          
2.0 - Varun Sinha       2/10/2016    UDAC WIRE FRAME CHANGES 
3.0 - Anirudh           2/12/2016    Coding Standards
4.0 - Shruti            2/12/2016    Modularized integration error logging 
Input: 
ESN, CSSJobNumber, Mileage and Unit of Measure will be sent to Connected Diagnostics
Output: 
The 30 day alerts will be received as a JSON response and stored in Salesforce in the 
CSS_ConnectedDiagnostics__c custom object

Methods:
1. requestAlerts(ID id,String ESN, String CSSJobNumber,Decimal Mileage,String Measure): 
This function retrives the 30 day alerts from Connected diagnostics for the CSS workorder 
with Identifier = Id.

2. removeAlerts(ID id):  
This function removes the 30day alerts for the given CSS Work order Id.
***********************************************************************/

public class CSS_receive30DayAlerts 
{
    /*--------------------------------------------------------------------------------------------------------------
1. requestAlerts(ID id,String ESN, String CSSJobNumber,Decimal Mileage,String Measure): 
Description:
This function retrives the 30 day alerts from Connected diagnostics for the CSS workorder 
with Identifier = Id
Input: 
CSS Workorder ID, ESN, CSSJobNumber, Mileage and Unit of Measure (Measure). 
This funtion will be invoked from the trigger.
Output: 
The 30 day alerts will be received as a JSON response and stored in Salesforce in the 
CSS_ConnectedDiagnostics__c custom object after parsing
Returntype: 
Void
--------------------------------------------------------------------------------------------------------------*/
    @future(callout=true)
    public static void requestAlerts(Id id,String ESN, String CSSJobNumber,Decimal Mileage,String Measure)
    {
        String MileageString;
        if(ESN != NULL)
        {
            if(Mileage != NULL){
                MileageString = Mileage.toPlainString();
            }
            else{
                MileageString = '-1';
            }
            String uom;
            if(Measure != NULL)
            {
                if(Measure.equals('Kilometers'))
                {
                    Measure = 'KM';
                }
                else if(Measure.equals('Hours'))
                {
                    Measure = 'HR';
                }
                else
                {
                    Measure = 'MI';
                }
            }
            else
            {
                Measure ='';
            }
            
            //Create remote connection object to get connection parameters
            //CSS_Remote_Connection__c ConnectionObject = [SELECT Application_URL__c,Password1__c from CSS_Remote_Connection__c where Application_Name__c='ConnectedDiagnostics-30DayAlert'];
            //String URL = ConnectionObject.Application_URL__c;
            //String sPassphrase = ConnectionObject.Password1__c;   
            String URL;
            String sPassphrase;
            if(!Test.isRunningTest()){
             URL = CSS_getConnnectionDetails.getConnection('CDAlerts').End_Point__c;
             sPassphrase = CSS_getConnnectionDetails.getConnection('CDAlerts').Passcode__c;
            }else{
				URL = 'yahoo.com';
             sPassphrase = '1234';
            }
            
            //create querystring to be sent in request URL
            String queryString = '?passphrase='+sPassphrase+'&esn='+ESN+'&dsid='+CSSJobNumber+'&milehrs='+MileageString+'&uom='+Measure;
            
            System.debug('queryString satish' + queryString); 
            
            //Creating an HTTP request object
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(URL+queryString);
            
            //making a call to the Connected diagnostics web service
            Http http = new Http();
            HTTPResponse res = http.send(req);
                    
            //storing the JSON response
            String jSONRequestBody = res.getBody();
            System.debug(res.getBody());
            
            //Error messages for Exception Handling
            String autherror = '{"Error Code : 1":"Authentication Failed"}';   
            String dberror = '{"Error Code : 2":"Database Exception"}';
            String dbconnerror = '{"Error Code : 3":"Database Connectivity Error"}';
            
            //Handling Authentication Error
            if(jSONRequestBody.equals(autherror))
            {
                logIntegrationError(autherror,jSONRequestBody);
            }
            //Handling Database Exception
            else if(jSONRequestBody.equals(dberror))
            {
                logIntegrationError(dberror,jSONRequestBody);
            }
            //Handling Database Connectivity Exception
            else if(jSONRequestBody.equals(dbconnerror))
            {
                logIntegrationError(dbconnerror,jSONRequestBody);
            }
            else
            {
                //if no errors, parse the JSON response and store in oConnDiag object of custom type CSS_JSON2Apex_CD
                CSS_JSON2Apex_CD oConnDiag = (CSS_JSON2Apex_CD)JSON.deserializeStrict(jSONRequestBody,CSS_JSON2Apex_CD.class); 
                
                //check if engine is a telematics engine or not
                if((oConnDiag.engine_Serial_Number).equals('99999999') || (oConnDiag.total_Distinct_Faults).equals('-1'))
                {
                    logIntegrationError('Engine not connected to Telematics',jSONRequestBody);
                    removealerts(id);
                    telematicsFalse(id);
                }
                //if parsing successful and engine is connected to Telematics, retrieive 
                //the distinct faults and store the 30 day alerts in salesforce
                else
                {  
                    //delete existing records before inserting
                    removealerts(id);
                    Telematics(id);
                    
                    List<CSS_ConnectedDiagnostics__c> lConnDiag = new List<CSS_ConnectedDiagnostics__c>();
                    for(integer i=0; i< oConnDiag.distinct_Fault_Code_Info.size(); i++)
                    {
                        CSS_ConnectedDiagnostics__c rConn = new CSS_ConnectedDiagnostics__c();
                        rConn.CSSJobId__c = id;
                        rConn.Name = oConnDiag.engine_Serial_Number+'-'+oConnDiag.distinct_Fault_Code_Info[i].fault_code+CSSJobNumber;
                        rConn.Response_Version__c = oConnDiag.response_Version;
                        rConn.ESN__c = oConnDiag.engine_Serial_Number;
                        rConn.Total_Distinct_Faults__c = oConnDiag.total_Distinct_Faults; 
                        rConn.Fault_Code__c = oConnDiag.distinct_Fault_Code_Info[i].fault_code;
                        rConn.Fault_Code_Description__c = oConnDiag.distinct_Fault_Code_Info[i].fault_Code_Description;
                        rConn.Latest_Occurrence_Date_Time__c = oConnDiag.distinct_Fault_Code_Info[i].latest_Occurrence_Date_Time;
                        rConn.Total_Occurrence_Count__c = oConnDiag.distinct_Fault_Code_Info[i].total_Occurrence_Count;
                        lConnDiag.add(rConn);
                    }                
                    System.debug(lConnDiag.size());
                    
                    //Insert records to database only if there are valid alerts from Telematics
                    if(lConnDiag.size() > 0)
                    {
                        insert lConnDiag;
                    }
                }
            }
        }
        else
        {
            //Exception handling for invalid ESN
            logIntegrationError('Invalid ESN','');
            //System.debug('Invalid ESN'); 
        }                  
    }   
    
    /*--------------------------------------------------------------------------------------------------------------
    2. removeAlerts(Id): 
    Description:
    This function removes the 30day alerts for the given CSS Work order, once the workorder status is closed.
    Input: 
    CSS Workorder's ID. 
    This funtion will be invoked from the Visualforce Page <page_name>, when workorder status changes to 'closed'.
    Output: 
    The corresponding CSS_ConnectedDiagnostics__c custom object for the CSS workorder Id must be empty
    Returntype: 
    Void
    --------------------------------------------------------------------------------------------------------------*/
    public static void removeAlerts(Id id)
    {
        List<CSS_ConnectedDiagnostics__c> getalerts = [Select CSSJobId__c,Name,ESN__c from CSS_ConnectedDiagnostics__c where CSSJobId__c=: id LIMIT 30];
        if(getalerts.size() > 0)
        {
            delete getalerts;
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------
    3. logIntegrationError(String msg): 
    Description:
    This function logs the integration error message in the Integration Error object CSS_Integration_Error__c.
    Input: 
    The integration error message.
    Output: 
    The corresponding integration error is logged.
    Returntype: 
    Void
    --------------------------------------------------------------------------------------------------------------*/
    public static void logIntegrationError(String msg,String Processed_data)
    {
        CSS_Integration_Error__c ErrorObj = new CSS_Integration_Error__c();
        ErrorObj.Error_Description__c=msg;
        ErrorObj.Error_Type__c='APP';
        ErrorObj.Processed_Data__c=Processed_data;
        ErrorObj.Source__c='ConnectedDiagnostics';
        insert ErrorObj; 
        System.debug(msg); 
    }
  
    public static void Telematics(Id id)
    {
        list<CSS_Job_Order__c> jobOrderList = [Select Id,Telematics_Indicator__c from CSS_Job_Order__c where Id = :id];
        if(jobOrderList != null && !jobOrderList.isEmpty()){
            jobOrderList[0].Telematics_Indicator__c = true;
            update jobOrderList[0];
        }   
    }
    
    public static void telematicsFalse(Id id){
        list<CSS_Job_Order__c> jobOrderList = [Select Id,Telematics_Indicator__c from CSS_Job_Order__c where Id = :id];
        if(jobOrderList != null && !jobOrderList.isEmpty()){
            jobOrderList[0].Telematics_Indicator__c = false;
            update jobOrderList[0];
        } 
    }
}