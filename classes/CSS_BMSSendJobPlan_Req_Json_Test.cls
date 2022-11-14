/**********************************************************************
Name:CSS_BMSSendJobPlan_Req_Json_Test
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get SRT from BMS(Job Plan) #133132                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Rajesh P         04/09/2018           INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
@isTest()
public class CSS_BMSSendJobPlan_Req_Json_Test {
    public static testMethod void testParse(){
        string json = '{'+
'  \"Header\": {'+
 '   \"Sender\": {'+
  '    \"ServiceName\": \"SendJobPlan\",'+
   '   \"SenderID\": \"BMS\"'+
   ' },'+
   ' \"Target\": {'+
    '  \"TargetID\": \"CSS\"'+
    '},'+
    '\"Location\": {'+
    '  \"LocationID\": \"02400-02394\"'+
    '}'+
 ' },'+
  '\"DataArea\": {'+
   ' \"CSSjobID\": \"CSS-00001234\",'+
'\"DistributorCode\": \"56270\",'+
   ' \"BranchCode\": \"56275\",'+
   ' \"CustomerCode\": \"56275\",'+
    '\"OrderSourceType\": \"WO\",'+
   ' \"BMSReferenceNumber\": \"987\",'+
   ' \"SRTDetails\": ['+
   '   {'+
    '    \"Group\": \"00\",'+
     '   \"Procedure\": \"980\",'+
     '   \"Step\": \"02\",'+
      '  \"Quantity\": 4,'+
      '  \"SRTHour\": 2.4,'+
      '  \"ActualHour\": 6,'+
       ' \"BilledHour\": 5.2,'+
       ' \"Bill\": \"\",'+
       ' \"Troubleshoot\": \"\",'+
       ' \"Flexible\": \"\",'+
       ' \"PrivateWork\": \"\",'+
       ' \"ServiceModelName\": \"\",'+
       ' \"Title\": \"\",'+
       ' \"SortOrder\": 1,'+
       ' \"Access\": \"\",'+
       ' \"WarrantyAllocation\": 60,'+
        '\"AdjustmentReason\": \"\",'+
       ' \"AccountCode\": \"\",'+
       ' \"ClaimType\": \"\",'+
       ' \"CreateDate\": \"\",'+
       ' \"CreateUser\": \"\",'+
       ' \"ChangeDate\": \"\",'+
       ' \"ChangeUser\": \"\"'+
      '},'+
      '{'+
       ' \"Group\": \"00\",'+
       ' \"Procedure\": \"980\",'+
        '\"Step\": \"02\",'+
        '\"Quantity\": 4,'+
        '\"SRTHour\": 2.4,'+
        '\"ActualHour\": 6,'+
        '\"BilledHour\": 5.2,'+
        '\"Bill\": \"\",'+
        '\"Troubleshoot\": \"\",'+
        '\"Flexible\": \"\",'+
        '\"PrivateWork\": \"\",'+
        '\"ServiceModelName\": \"\",'+
        '\"Title\": \"\",'+
        '\"SortOrder\": 1,'+
        '\"Access\": \"\",'+
        '\"WarrantyAllocation\": 60,'+
        '\"AdjustmentReason\": \"\",'+
        '\"AccountCode\": \"\",'+
        '\"ClaimType\": \"\",'+
        '\"CreateDate\": \"\",'+
        '\"CreateUser\": \"\",'+
        '\"ChangeDate\": \"\",'+
        '\"ChangeUser\": \"\"'+
      '}'+
    ']'+
  '}'+
'}';

		CSS_BMSSendJobPlan_Req_Json obj = CSS_BMSSendJobPlan_Req_Json.parse(json);
		System.assert(obj != null);
        system.assert(obj.DataArea.CSSjobID!=null);
        system.debug('obj'+obj);
        
    }
}