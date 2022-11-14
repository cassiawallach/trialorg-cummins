/**********************************************************************
Name:  CSS_GetRSWControlNumber
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to receive (multiple) control numbers 
from RSW application. 
This class receives the list of CSS Job Numbers and a corresponding list of control 
numbers, and stores the control numbers with the associated CSS Job Number in CSS.
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 - Shruti            4/19/2016     INITIAL DEVELOPMENT   
2.0 - Shruti            5/11/2016     Added Parsing Logic      
3.0 - Shruti            5/13/2016     Updated JSONs and parsing logic   
4.0 - Shruti            5/24/2016     Updated JSONs and parsing logic, created json responses
5.0 - Gyana             5/24/2016     Logic Review and code optimization 
6.0 - Shruti            6/3/2016      Filter 'DUMMY' data,
                                      Serializing/deserializing logic to store control number

Input: 
CSSJobNumber and list of control numbers from RSW 
Output: 
The list of control numbers are stored in the ControlNumber field 
of the corresponsing service job object provided the CSS Job ID 
exists and status of the job is not closed.
A control number field cannot store a list of more than 25 control numbers.

Methods:
1. updateJobOrderData()
Description: This function stores the list of control numbers to the corresponding service job object record 
for the list fo jobs received from RSW. 
Input: This class is called when RSW calls the URL 
Test: https://cs51.salesforce.com/services/apexrest/RSW/V02/CSS/ControlNumber/
Dev: https://cs50.salesforce.com/services/apexrest/RSW/V02/CSS/ControlNumber/

Output: The list of control numbers corresponding to the received CSS Job ID are stored in CSS
Returntype: Void

2. logIntegrationError(String msg): 
Description:
This function logs the integration error message in the Integration Error object CSS_Integration_Error__c.
Input: The integration error message.
Output: The corresponding integration error is logged.
Returntype: Void

***********************************************************************/

@RestResource(urlMapping='/RSW/V02/CSS/ControlNumber/')
global with sharing class CSS_GetRSWControlNumber
{    
    @HttpPut
    global static void updateJobOrderData()
    {
        string JSONResponseBody;
        string JSONRequestBody;
       
        String errorresponse=null;
       
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        JSONRequestBody = req.requestBody.toString();
        
        //System.debug (jSONRequestBody);
         
        if (JSONRequestBody == 'Null')
        {
            JSONResponseBody = '{'+
                               '\"Header\":' +
                               '    {'+
                               '    \"MessageIdentifier\": \"'+ DateTime.now().format('yyyy-MM-dd','GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS','GMT') + '\",' +
                               '    \"Status\": \"ERROR\"' +
                               '    }'+
                               '}';
            logIntegrationError('No Data',JSONRequestBody); 
        }
        else
        {
            try
            {
                System.Debug('Before JSON Serialize');
                CSS_RSWJSON2Apex rswObj = (CSS_RSWJSON2Apex)JSON.deserializeStrict(jSONRequestBody,CSS_RSWJSON2Apex.class);
                System.Debug('After JSON Serialize');
                System.debug(rswObj);
                
                List<String> lstJobIds = new List<String>();
                List<String> lstNAJobs = new List<String>();
                List<String> lstCLJobs = new List<String>();
                List<String> lstControlNums = new List<String>();
                String sJobNumb;
                String sControlNum ;
                Boolean blnFound;
                //check if received request contains list of job orders                
                if(!rswObj.DataArea.CSSJobIdRecords.CSSJobIDRecord.isempty())
                {
                    //for every job sent to CSS from RSW, select the record in CSS with same CSS Job ID
                    for (integer i=0;i< rswObj.DataArea.CSSJobIdRecords.CSSJobIDRecord.size(); ++i)
                    {
                        sJobNumb = rswObj.DataArea.CSSJobIdRecords.CSSJobIDRecord[i].CSSJobId;
                        if(sJobNumb != 'DUMMY')
                        {
                            lstJobIds.add(sJobNumb);
                        }
                    }
                    if (!lstJobIds.isEmpty()) 
                    {
                        list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, ESN__c,Status__c,Control_Number__c From CSS_Job_Order__c WHERE Name IN :lstJobIds];
                        if (lstJobOrder.size() != lstJobIds.size())
                        {
                            for (integer i=0; i<lstJobIds.size(); ++i)
                            {
                                blnfound = false;
                                for (CSS_Job_Order__c recJobOrder: lstJobOrder )
                                {
                                    if (lstJobIds[i] == recJobOrder.Name)
                                    {
                                        blnFound = true;
                                        break;
                                    }
                                }
                                if (!blnFound) { lstNAJobs.add(lstJobIds[i]);}
                            }
                        } //Got all Jobs that are not present in CSS
                        
                        if (!lstJobOrder.isEmpty()) 
                        {
                            List<CSS_Job_Order__c> updlstJobOrder = new List<CSS_Job_Order__c>();
                            for (CSS_Job_Order__c recJobOrder: lstJobOrder )
                            {
                                //For Closed Jobs
                                if (recJobOrder.Status__c.touppercase() == 'CLOSED')
                                {
                                    lstCLJobs.add(recJobOrder.Name);
                                }
                                else
                                {
                                    for (integer i=0; i<rswObj.DataArea.CSSJobIdRecords.CSSJobIdRecord.size(); ++i)
                                    {
                                        if (rswObj.DataArea.CSSJobIdRecords.CSSJobIDRecord[i].CSSJobId != 'DUMMY' && rswObj.DataArea.CSSJobIdRecords.CSSJobIDRecord[i].CSSJobId == recJobOrder.Name)
                                        {
                                            for (integer k=0; k<rswObj.DataArea.CSSJobIdRecords.CSSJobIdRecord[i].ControlNumbers.ControlNumber.size(); ++k)
                                            {
                                                if(rswObj.DataArea.CSSJobIdRecords.CSSJobIdRecord[i].ControlNumbers.ControlNumber[k]!= 'DUMMY' && rswObj.DataArea.CSSJobIdRecords.CSSJobIdRecord[i].ControlNumbers.ControlNumber[k]!= NULL)
                                                {
                                                    lstControlNums.add(rswObj.DataArea.CSSJobIdRecords.CSSJobIdRecord[i].ControlNumbers.ControlNumber[k]);
                                                }
                                            }
                                        }
                                     }
                                     if(recJobOrder.Control_Number__c != NULL)
                                     {
                                        List<String> lstCSSCN = (List<String>)JSON.deserialize(recJobOrder.Control_Number__c,List<String>.class);
                                    
                                        if(!lstControlNums.isEmpty())
                                        {
                                            for(integer i=0; i<lstControlNums.size(); ++i)
                                            {
                                                lstCSSCN.add(lstControlNums[i]);
                                            }
                                        }
                                        String strCSSCN = JSON.serialize(lstCSSCN);
                                        recJobOrder.Control_Number__c = strCSSCN;
                                     }
                                     else
                                     {
                                        if(!lstControlNums.isEmpty())
                                        {
                                             String strCSSCN = JSON.serialize(lstControlNums);
                                             recJobOrder.Control_Number__c = strCSSCN;
                                        }
                                     }
                                     updlstJobOrder.add(recJobOrder);
                                     lstControlNums.clear();
                               }
                            }
                            if(!updlstJobOrder.isempty())
                            {
                                update updlstJobOrder;
                            }
                        }
                    }
                } 
                //create JSON responses 
                if(lstCLJobs.size() == 0 && lstNAJobs.size() == 0) //if all successful updates
                {
                     JSONResponseBody = '{'+
                       '\"Header\":' +
                       '    {'+
                       '    \"MessageIdentifier\": \"'+ DateTime.now().format('yyyy-MM-dd','GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS','GMT') + '\",' +
                       '    \"Status\": \"SUCCESS\"' +
                       '    }'+
                       '}'; 
                }
                else
                {
                    JSONResponseBody = 
                       '{'+
                       '\"Header\":' +
                       '    {'+
                       '    \"MessageIdentifier\": \"'+ DateTime.now().format('yyyy-MM-dd','GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS','GMT') + '\",' +
                       '    \"Status\": \"ERROR\"' +
                       '    },'+
                       '\"DataArea\":'+
                       '    {'+
                       '     \"CSSJobIdRecords\":'+
                       '       {'+
                       '         \"CSSJobIdRecord\":' +
                       '          [';             
                       for (integer i=0; i<lstCLJobs.size(); ++i) //create error JSON responses for closed jobs
                       {
                             if(i < lstCLJobs.size()-1)
                             {
                                 JSONResponseBody += 
                                   '{'+
                                   '    \"CSSJobId\": \"'+lstCLJobs[i]+ '\",' +
                                   '    \"Code\": \"ERROR\",' +
                                   '    \"Description\": \"CLOSED CSS JOB\" '+
                                   '},'; 
                             }
                             else
                             {
                                 if(lstNAJobs.size()!=0 && i==lstCLJobs.size())
                                 {
                                 JSONResponseBody += 
                                   '{'+
                                   '    \"CSSJobId\": \"'+lstCLJobs[i]+ '\",' +
                                   '    \"Code\": \"ERROR\",' +
                                   '    \"Description\": \"CLOSED CSS JOB\" '+
                                   '}';
                                 }         
                             }
                       }
                       for (integer i=0; i<lstNAJobs.size(); ++i) //create error JSON responses for non-existing jobs
                       {
                             if(i < lstNAJobs.size()-1)
                             {
                             JSONResponseBody += 
                               '{'+
                               '    \"CSSJobId\": \"'+lstNAJobs[i]+ '\",' +
                               '    \"Code\": \"ERROR\",' +
                               '    \"Description\": \"CSS JOB DOES NOT EXIST\" '+
                               '},';
                             }
                             else
                             {
                             JSONResponseBody += 
                               '{'+
                               '    \"CSSJobId\": \"'+lstNAJobs[i]+ '\",' +
                               '    \"Code\": \"ERROR\",' +
                               '    \"Description\": \"CSS JOB DOES NOT EXIST\" '+
                               '}';
                             }
                       }        
                       JSONResponseBody += 
                       '        ]'+
                       '       }'+
                       '    }'+
                       '}';        
                }
                 logIntegrationError(JSONResponseBody,JSONRequestBody);         
            }
            catch(Exception e)
            {
                system.debug('Exception===>>>>>'+e);
                system.debug('Exception Line Number===>>>>>'+e.getLineNumber());
                
                if(e.getTypeName() == 'System.JSONException')
                {
                  JSONResponseBody = '{'+
                               '\"Header\":' +
                               '    {'+
                               '    \"MessageIdentifier\": \"'+ DateTime.now().format('yyyy-MM-dd','GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS','GMT') + '\",' +
                               '    \"Status\": \"INVALID JSON ERROR\"' +
                               '    }'+
                               '}';
                  logIntegrationError('Invalid JSON',JSONRequestBody); 
                }
                else if(e.getTypeName() == 'System.TypeException')
                {
                    JSONResponseBody = '{'+
                               '\"Header\":' +
                               '    {'+
                               '    \"MessageIdentifier\": \"'+ DateTime.now().format('yyyy-MM-dd','GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS','GMT') + '\",' +
                               '    \"Status\": \"INVALID SCHEMA ERROR\"' +
                               '    }'+
                               '}';
                    logIntegrationError('Invalid Schema',JSONRequestBody); 
                }
                else
                {
                    JSONResponseBody = '{'+
                               '\"Header\":' +
                               '    {'+
                               '    \"MessageIdentifier\": \"'+ DateTime.now().format('yyyy-MM-dd','GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS','GMT') + '\",' +
                               '    \"Status\": \"CSS INTERNAL ERROR\"' +
                               '    }'+
                               '}';
                    logIntegrationError('CSS Internal Error',JSONRequestBody); 
                }
            }
            res.responseBody = Blob.valueOf(JSONResponseBody);
       }
    }
    /*--------------------------------------------------------------------------------------------------------------
    2. logIntegrationError(String msg): 
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
        ErrorObj.Source__c='RSW';
        insert ErrorObj; 
        System.debug(msg); 
    }
}