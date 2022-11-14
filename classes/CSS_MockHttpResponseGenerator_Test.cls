/**********************************************************************
Name:  css_MockHttpResponseGeneratort_Test
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to mock an HTTP response to test if we received the 30 day Alerts from Connected Diagnostics.                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 - Shruti            2/11/2016     INITIAL DEVELOPMENT          

Methods:
1. respond(HttpRequest req) - 
we implement the respond interface method to mock the response
Input - HttpRequest 
Return - Http Response
***********************************************************************/
@isTest
global class CSS_MockHttpResponseGenerator_Test implements HttpCalloutMock 
{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        if((req.getEndpoint()).contains('79586617'))
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"response_Version":"1.000.EDS","engine_Serial_Number":"79586617","total_Distinct_Faults":3,"distinct_Fault_Code_info":[{"fault_Code":"123","fault_Code_Description":"Intake Manifold 1 Pressure Sensor Circuit - Voltage Below Normal or Shorted to Low Source","latest_Occurrence_Date_Time":"2016-01-13 13:57:12","total_Occurrence_Count":1},{"fault_Code":"124","fault_Code_Description":"Intake Manifold 1 Pressure - Data Valid But Above Normal Operating Range - Moderately Severe Level","latest_Occurrence_Date_Time":"2016-01-26 13:57:12","total_Occurrence_Count":1},{"fault_Code":"4484","fault_Code_Description":"Engine Air Shutoff - Mechanical System Not Responding or Out of Adjustment","latest_Occurrence_Date_Time":"2016-01-27 13:57:12","total_Occurrence_Count":1}]}');
        }
        else if((req.getEndpoint()).contains('11111111'))
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"response_Version":"1.000.EDS","engine_Serial_Number":"1111111","total_Distinct_Faults":"-1","distinct_Fault_Code_info":[]}');
        }
            else if((req.getEndpoint()).contains('CSS-00002678'))
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"response_Version":"1.000.BMS","{ "Header": { "Status": "success", "ReturnCodeDescription": "message_ifany", "Location": { "LocationID": "02400-02394" } }, "DataArea": { "CSSjobID": "CSS-00001234", "Companycode": "AB23456", "DivisionCode": "", "LocationCode": "12345-23456", "CustomerNumber": "", "TransactionType": "1XFFERR2344REWS", "OrderReference": "KENWORTH", "ItemGrossSell": 0, "ItemWarranty": 0, "ItemBillable": 0, "LaborGrossSell": 0, "LaborWarranty": 0, "LaborBillable": 0, "MiscGrossSell": 0, "MiscWarranty": 0, "MiscBillable": 0, "Taxes": 0, "QuoteTotal": 0, "Diagnosticcharges": 0, "GrandTotal": 0 } }"}');
        }
        return res;
    }
}