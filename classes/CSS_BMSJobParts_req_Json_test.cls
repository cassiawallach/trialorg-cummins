/**********************************************************************
Name:CSS_BMSSendJobPlan_Req_Json
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get Parts from BMS(Parts) request Wrapper class #133137                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Karthik G     04/16/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
@IsTest
public class CSS_BMSJobParts_req_Json_test {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"getBMSParts\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\",'+
		'			\"SourceEnvironment\": \"CGCDWTST\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"CSS-00001234\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"CustomerCode\": 123,'+
		'		\"OrderType\": \"WO/WOQT\",'+
		'		\"BMSReferenceNumber\": 98687687,'+
		'		\"PartDetails\": [{'+
		'				\"PartNumber\": \"876435\",'+
		'				\"PartDescription\": \"\",'+
		'				\"QuantityOrdered\": \"\",'+
		'				\"QuantityUsed\": \"3\",'+
		'				\"PartsReturn\": \"Y\",'+
		'				\"SellPrice\": 345,'+
		'				\"WarrantyAllocation\": 98,'+
		'				\"Comments\": \"\",'+
		'				\"LineType\": \"\",'+
		'				\"SerialNumber\": \"64646\",'+
		'				\"SerialNumberVendor\": \"XYZ\",'+
		'				\"Model\": \"VOLVO\",'+
		'				\"Option\": \"6\",'+
		'				\"ESN\": \"79464646\",'+
		'				\"SSN\": \"765\",'+
		'				\"VIN\": \"54365jhgf98798jhgj\",'+
		'				\"PartOC\": \"PART\",'+
		'				\"TrackingNumber\": \"FN87687688\",'+
		'				\"RID\": \"\",'+
		'				\"Address1\": \"\",'+
		'				\"Address2\": \"\",'+
		'				\"City\": \"\",'+
		'				\"State\": \"\",'+
		'				\"Zip\": \"\",'+
		'				\"CreateUser\": \"WWID\",'+
		'				\"CreateDate\": \"Date\",'+
		'				\"ChangeUser\": \"WWID\",'+
		'				\"ChangeDate\": \"Date\"'+
		'			},'+
		'			{'+
		'				\"PartNumber\": \"876495\",'+
		'				\"PartDescription\": \"\",'+
		'				\"QuantityOrdered\": \"\",'+
		'				\"QuantityUsed\": \"3\",'+
		'				\"PartsReturn\": \"Y\",'+
		'				\"SellPrice\": 345,'+
		'				\"WarrantyAllocation\": 98,'+
		'				\"Comments\": \"\",'+
		'				\"LineType\": \"\",'+
		'				\"SerialNumber\": \"64646\",'+
		'				\"SerialNumberVendor\": \"XYZ\",'+
		'				\"Model\": \"VOLVO\",'+
		'				\"Option\": \"6\",'+
		'				\"ESN\": \"79464646\",'+
		'				\"SSN\": \"765\",'+
		'				\"VIN\": \"54365jhgf98798jhgj\",'+
		'				\"PartOC\": \"PART\",'+
		'				\"TrackingNumber\": \"FN87687688\",'+
		'				\"RID\": \"\",'+
		'				\"Address1\": \"\",'+
		'				\"Address2\": \"\",'+
		'				\"City\": \"\",'+
		'				\"State\": \"\",'+
		'				\"Zip\": \"\",'+
		'				\"CreateUser\": \"WWID\",'+
		'				\"CreateDate\": \"Date\",'+
		'				\"ChangeUser\": \"WWID\",'+
		'				\"ChangeDate\": \"Date\"'+
		'			}'+
		'		]'+
		'	}'+
		'}';
		CSS_BMSJobParts_Req_Json obj = CSS_BMSJobParts_Req_Json.parse(json);
		System.assert(obj != null);
	}
}