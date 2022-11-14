@Istest
public class CSS_GetClaimDetailsResponse_Test {
    static testMethod void testParse() {
       /* String json = 
'{'+

'  \"Header\": {'+



'      \"ReturnCodeDescription\": \"UniqueID\",'+

'      \"Status\": \"ClaimSubmission\",'+

'      \"ReturnCode\": \"CSS\",'+



'    \"MessageIdentifier\": \"CSSWarranty\"'+

'  },'+

'  \"DataArea\": {'+

'    \"ServiceProviderCode\": \"38677\",'+

'    \"DistributorCode\": \"73011\",'+

'    \"DistributorName\": \"79758995\",'+

'    \"PSN\": \"852541\",'+

'    \"WorkOrderNumber\": \"02/27/2015\",'+

'    \"WarrantyStartDate\": \"130\",'+

'    \"EngineApplicationCode\": \"KENWORTH\",'+

'    \"ModelSeries\": \"T800\",'+

'    \"Contact\": \"9899898998\",'+

'    \"BISFlag\": \"Y\",'+

'    \"FailureDate\": \"N\",'+

'    \"FailurePoint\": \"N\",'+

'    \"DISDNumber\": \"3465677\",'+

'    \"CustomerName\": \"N\",'+

'    \"EngineVIN\": \"N\",'+

'    \"TSRNumber\": \"N\",'+

'    \"UnitNumber\": \"N\",'+

'    \"DealerClaimNumber\": \"03/23/2018\",'+

'    \"ClaimSource\": \"515540\",'+

'    \"ClaimFiledDate\": \"Kilometers\",'+

'    \"ECMCalibAfter\": \"B\",'+

'    \"ECMCalibBefore\": \"N\",'+

'    \"ECMRevBfr\": \"test\",'+

'    \"ECMRevAfter\": \"test\"'+

'          \"FailureList\": {'+
'      \"FailureList\": ['+

'        {'+

'          \"SystemCode\": \"CH\",'+

'          \"ComponentCode\": \"CA\",'+

'          \"FailMode\": \"PO\",'+

'          \"Failurename\": \"67\",'+

'          \"CampaignNumber\": \"R\",'+

'          \"FaultCode\": \"2636\",'+

'          \"AccountCode\": \"Emission warranty 70\",'+

'          \"PayCode\": \"C\"'+


'          \"PartsList\": {'+

'            \"PartsList\": ['+

'              {'+

'                \"PartNumber\": \"Antifreeze/Coolant\",'+

'                \"PartDescription\": \"Antifreeze/Coolant\",'+

'                \"ClaimedQty\": \"2\",'+

'                \"AdjustedQty\": \"65.06\",'+

'                \"TrackingNumber\": \"65.06\",'+

'                \"RID\": \"65.06\",'+

'                \"AdjustmentReason\": \"65.06\"'+

'              }'+



'            ]'+

'          }'+


'          \"OtherClaimablesList\": {'+
'            \"OtherClaimablesList\": ['+

'              {'+

'                \"Item\": \"Antifreeze/Coolant\",'+

'                \"ItemDescription\": \"Antifreeze/Coolant\",'+

'                \"ClaimedAmount\": \"234\",'+

'                \"AdjustedAmount\": \"65.06\",'+
'                \"AdjustmentReason\": \"65.06\"'+

'              }'+


'            ]'+

'          }'+

'          \"SRTList\": {'+

'            \"SRTList\": ['+

'              {'+

'                \"SRTCode\": \"Antifreeze/Coolant\",'+

'                \"SRTDescription\": \"Antifreeze/Coolant\",'+

'                \"SRTHours\": \"10\",'+

'                \"ClaimedQty\": \"65.06\",'+

'                \"ClaimedPercent\": \"65.06\",'+

'                \"ClaimedHours\": \"65.06\",'+

'                \"AdjustedQty\": \"65.06\",'+

'                \"AdjustedPercent\": \"Antifreeze/Coolant\",'+

'                \"AdjustedHours\": \"Antifreeze/Coolant\",'+

'                \"AdjustmentReason\": \"test\",'+

'                \"PenaltyAppliedFlag\": \"65.06\",'+

'              }'+



'            ]'+

'          }'+ 

'          \"TravelList\": {'+

'            \"TravelList\": ['+

'              {'+

'                \"TravelType\": \"Antifreeze/Coolant\",'+

'                \"ClaimedDistance\": \"Antifreeze/Coolant\",'+

'                \"ClaimedHours\": \"2\",'+

'                \"ClaimedAmount\": \"65.06\",'+

'                \"AdjustedDistance\": \"65.06\",'+

'                \"AdjustedHours\": \"65.06\",'+

'                \"AdjustedAmount\": \"65.06\",'+

'                \"LodgingAmount\": \"Antifreeze/Coolant\",'+

'                \"MealsAmount\": \"Antifreeze/Coolant\",'+


'                \"TowingAmount\": \"23\",'+



'                \"TotalTravel\": \"65.06\",'+

'                \"BaseFare\": \"10\",'+

'                \"AdjustmentReason\": \"test\",'+


'                \"PenaltyAppliedFlag\": \"N\",'+

'                \"AdjustedPercent\": \"100\",'+


'              }'+



'            ]'+

'          }'+

'          \"AdditionalESNs\": {'+

'            \"AdditionalESNs\": ['+

'              {'+

'                \"PSN\": \"Antifreeze/Coolant\",'+

'                \"WarrantyStartDate\": \"Antifreeze/Coolant\",'+

'                \"BISFlag\": \"Y\",'+

'                \"FailurePoint\": \"65.06\",'+

'                \"FailureMeasure\": \"65.06\",'+

'                \"VIN\": \"65.06\",'+

'                \"ECMCalibAfter\": \"65.06\",'+

'                \"ECMCalibBefore\": \"Antifreeze/Coolant\",'+

'                \"MealsAmount\": \"Antifreeze/Coolant\",'+


'                \"TowingAmount\": \"23\",'+



'                \"TotalTravel\": \"65.06\",'+

'                \"BaseFare\": \"10\",'+

'                \"AdjustmentReason\": \"test\",'+


'                \"PenaltyAppliedFlag\": \"N\",'+

'                \"AdjustedPercent\": \"100\",'+
'              }'+

'            ]'+

'          }'+


'          }'+

'          }'+



'}';*/
        string json = '{"Header": {"ReturnCodeDescription": "<Message from Siebel>","Status": "Success","ReturnCode": "<MessageCode from Siebel>","MessageIdentifier": "<Identifier from MW>" },"DataArea": [{"Notes": [{"Note": "TestComplaint","NoteType": "Complaint","CreatedDate": "2012-06-06"},{"Note": "TestComplaint1","NoteType":"Complaint","CreatedDate":"2012-06-07"},{"Note": "TestCause","NoteType": "Cause","CreatedDate": "2013-06-10"},{"Note": "TestCorrection1","NoteType": "Correction","CreatedDate": "2014-06-09"},{"Note": "TestComplaint","NoteType": "Reject Reason","CreatedDate": "2015-06-06"},{"Note": "TestComplaint1","NoteType": "Narratives","CreatedDate": "2016-06-07"},{"Note": "NarrativesTest","NoteType": "Narratives","CreatedDate": "2017-06-10"},{"Note": "RejectTest reason","NoteType": "Cause","CreatedDate": "2018-06-09"}]}]}';
            
            CSS_GetClaimDetailsResponse obj = CSS_GetClaimDetailsResponse.parse(json);     
        System.assert(obj != null);
    }
    
}