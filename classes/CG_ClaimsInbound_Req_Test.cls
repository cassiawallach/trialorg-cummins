@istest
public class CG_ClaimsInbound_Req_Test {
    static testmethod void testParse(){
        
       string json='{ "Header": { "Sender": { "MessageID": "ClaimSubmission", "ServiceName": "ClaimSubmission", "SenderID": "CSS" } }, "DataArea": { "LAST_PROCESSED_DATE": "12-11-18", "DistributorCode": "4563", "BranchCode": "764567", "ClaimType": "inter", "ClaimDate": "11-2-98", "Owned": "CSSWarranty", "SiebelClaimNumber": "34567", "DealerClaimNumber": "87654", "GuidanzClaimNumber": "4567", "CSSJobID": "CSSWarranty", "BMSReferenceNumber": "234567", "DealerCode": "98654", "CustomerCode": "56789", "ESN": "CSSWarranty", "ApplicationCode": "234567", "AccountCode": "67890", "PayCode": "234567", "AuthorizationNumber": "7890", "ApprovalCode": "3456", "PolicyRequestNumber": "8765", "FailureLocation": "CSSWarranty", "CreateUser": "CSSWarranty", "FailureDate": "18-19-19", "WarrantyStartDate": "11-92-37", "Severity": "test", "SMN": "test", "EngineFamily": "test", "Make": "test", "Model": "test", "EquipmentConfiguration": "testr", "DistanceType": "ywuw", "Hours": "22:22", "DealerApproval": "test", "DistributorAuthorization": "test", "MaterialDisposition": "test", "TotalPartsAmount": "3456778", "TotalLaborAmount": "45678", "TotalTravelAmount": "5678", "TotalOtherAmount": "5677890", "PMU": "CSSWarranty", "BFC": "CSSWarranty", "Tax": "CSSWarranty", "TotalClaimAmount": "456789", "Reference1": "CSSWarranty", "Reference2": "CSSWarranty2", "Reference3": "CSSWarranty3", "Notes": [ { "NoteType": "test", "Notes": "tester" } ], "FailCode": [ { "ProductGroup": "test", "GroupCode": "testet", "SystemCode": "5677899", "ComponentCode": "23456", "FailureMode": "test", "FailLocation": "edmountain", "FailureOrder": "request" } ], "Parts": [ { "PartNumberService": "tesr", "ProductCodeOEM": "test", "Description": "tsrsts", "PartQuantity": "dfghj", "UnitPrice": "345678", "ExtendedPrice": "765432", "PercentClaimed": "234567" } ], "OtherClaimables": [ { "OCCreditType": "tesst", "MiscName": "new", "MiscDescription": "test", "MiscQuantity": "112345", "MiscAmount": "65473829" } ], "SRTs": [ { "SRTgroupnum": "5678", "Procedureno": "234", "Stepnumber": "6789", "Accesscode": "456789", "PercentClaimed": "987654", "SRTquantity": "4567899", "SRTTime": "11:74", "SRTLaborRate": "6643328", "ExtendedAmount": "67878", "ServiceModelName": "test", "AdjustmentReason": "tester" } ], "TravelDetails": [ { "TravelLaborHour": "11:87", "TravelRate": "8989424", "TravelLaborAmount": "783637", "TravelDistance": "6632737", "TravelDistanceRate": "test", "TravelMealAmount": "5678", "TravelLodgingAmount": "3456789" } ], "AdditionalESN": [ { "ESN": "ClaimSubmission", "ESNModel": "ClaimSubmission", "ApplicationCode": "ClaimSubmission", "DistanceType": "ClaimSubmission", "Hours": "ClaimSubmission", "FailureDate": "ClaimSubmission", "WarrantyStartDate": "ClaimSubmission" } ] } }';
        
        
        CG_ClaimsInbound_Req obj = CG_ClaimsInbound_Req.parse(json);
        System.assert(obj != null);
    }
}