@isTest
public class CG_ClaimsInbound_SubmitToSiebel_Req_Test
{
    static testMethod void testParse() {
    String json = '{'+
    ''+
    '  \"Header\": {'+
    ''+
    '    \"Sender\": {'+
    ''+
    '      \"MessageID\": \"UniqueID\",'+
    ''+
    '      \"ServiceName\": \"ClaimSubmission\",'+
    ''+
    '      \"SenderID\": \"CSS\"'+
    ''+
    '    },'+
    ''+
    '    \"Target\": \"CSSWarranty\"'+
    ''+
    '  },'+
    ''+
    '  \"DataArea\": {'+
    ''+
    '    \"ServiceProviderCode\": \"38677\",'+
    ''+
    '    \"DistributorCode\": \"73011\",'+
    ''+
    '    \"EngineSerialNumber\": \"79758995\",'+
    ''+
    '    \"RONumber\": \"852541\",'+
    ''+
    '    \"WarrantyStartDate\": \"02/27/2015\",'+
    ''+
    '    \"EngineApplicationCode\": \"130\",'+
    ''+
    '    \"Manufacturer\": \"KENWORTH\",'+
    ''+
    '    \"ModelSeries\": \"T800\",'+
    ''+
    '    \"FirstName\": \"\",'+
    ''+
    '    \"LastName\": \"\",'+
    ''+
    '    \"BISFlag\": \"N\",'+
    ''+
    '    \"MultiESNFlg\": \"N\",'+
    ''+
    '    \"CampaignNumber\": \"\",'+
    ''+
    '    \"InfoOnlyFlag\": \"N\",'+
    ''+
    '    \"NewPartsWarrantyFlg\": \"N\",'+
    ''+
    '    \"ReConPartsWarrantyFlg\": \"N\",'+
    ''+
    '    \"RoadRelayWarrantyFlg\": \"N\",'+
    ''+
    '    \"FailureDate\": \"03/23/2018\",'+
    ''+
    '    \"FailurePoint\": \"515540\",'+
    ''+
    '    \"FailureMeasure\": \"Kilometers\",'+
    ''+
    '    \"MissionDisablingFlag\": \"B\",'+
    ''+
    '    \"CatastrophicFlag\": \"N\",'+
    ''+
    '    \"RepairDescription\": \"\",'+
    ''+
    '    \"ReplacementPart\": \"\",'+
    ''+
    '   \"SPCertifiedFlag\": \"N\",'+
    ''+
    '    \"WarrantyTrainedFlag\": \"Y\",'+
    ''+
    '    \"CustomerPossession\": \"\",'+
    ''+
    '    \"DISDNumber\": \"\",'+
    ''+
    '    \"CustomerName\": \"Fletes RGC S.A. de C.V.\",'+
    ''+
    '    \"ECMCalibAfter\": \"\",'+
    ''+
    '    \"ReviewAfter\": \"\",'+
    ''+
    '    \"ECMCalibBefore\": \"\",'+
    ''+
    '    \"RevisionBefore\": \"\",'+
    ''+
    '    \"Justification\": \"\",'+
    ''+
    '    \"EngineVIN\": \"\",'+
    ''+
    '    \"ESNCount\": \"\",'+
    ''+
    '    \"TSRNumber\": \"\",'+
    ''+
    '    \"UnitNumber\": \"\",'+
    ''+
    '    \"PaccarFlag\": \"N\",'+
    ''+
    '    \"PenaltyFlag\": \"\",'+
    ''+
    '    \"SRTPenaltyPercentage\": \"\",'+
    ''+
    '    \"manualAdjudicationFlag\": \"\",'+
    ''+
    '    \"DealerClaimNumber\": \"C0000270418-03\",'+
    ''+
    '    \"ClaimSource\": \"Guidanz\",'+
    ''+
    '    \"ClaimFiledDate\": \"03/27/2018\",'+
    ''+
    '    \"SPInShopLaborRate\": \"31.63\",'+
    ''+
    '    \"SPLaborRate\": \"34.79\",'+
    ''+
    '    \"SPTravelRate\": \"0.49\",'+
    ''+
    '    \"Contact\": \"GY321\",'+
    ''+
    '    \"ListOfComplaintCodes\": {'+
    ''+
    '      \"ComplaintCodes\": ['+
    ''+
    '        {'+
    ''+
    '          \"ComplaintCode\": \"116\"'+
    ''+
    '        }'+
    ''+
    '      ]'+
    ''+
    '    },'+
    ''+
    '    \"ListOfPromotionIds\": {'+
    ''+
    '      \"PromotionIds\": ['+
    ''+
    '        {'+
    ''+
    '          \"PromotionID\": \"1032937\"'+
    ''+
    '        }'+
    ''+
    '      ]'+
    ''+
    '    },'+
    ''+
    '    \"ListOfNotes\": {'+
    ''+
    '      \"Notes\": ['+
    ''+
    '        {'+
    ''+
    '          \"Note\": \"They followed the symptoms the tree T-091 Fuel in Coolant step 4 Replace the cylinder head. Refer to Procedure 002-004 in Section 2.pressure tests were performed on the head of cylinde.Finding the root cause frontal bank leak for the return passage cylinder head porous.it replace gasket set upper engine gasket by not reusable,it replace cylinder head the according the to procedure 002-004,When the components were removed, valve camshafts and a valve rocker arm were found, the damage is found in the intake shaft of the camshaft and the intake rocker 1, the components are replaced according to the procedure 002-024  and 002-004 ,it was necessary remove Radiator clean and road test.claim of major component.\\r\\nthe cooling system is cleaned by contamination and the filter and coolant are replaced.\",'+
    ''+
    '          \"NoteType\": \"Narrative\"'+
    ''+
    '        }'+
    ''+
    '      ]'+
    ''+
    '    },'+
    ''+
    '    \"listOfFailureList\": {'+
    ''+
    '      \"FailureList\": ['+
    ''+
    '        {'+
    ''+
    '          \"SystemCode\": \"CH\",'+
    ''+
    '          \"ComponentCode\": \"CA\",'+
    ''+
    '          \"FailMode\": \"PO\",'+
    ''+
    '          \"AccountCode\": \"67\",'+
    ''+
    '          \"PayCode\": \"R\",'+
    ''+
    '          \"CertificateNumber\": \"\",'+
    ''+
    '          \"CampaignNumber\": \"\",'+
    ''+
    '          \"FaultCode\": \"\",'+
    ''+
    '          \"WarrantyId\": \"1-608-309\",'+
    ''+
    '          \"ApproverCode\": \"\",'+
    ''+
    '          \"CoverageType\": \"NEW-New Engine Warranty\",'+
    ''+
    '          \"CoveredLaborHours\": \"9999999.00\",'+
    ''+
    '          \"CoveredMealsLodgingAmt\": \"0.00\",'+
    ''+
    '          \"CoveredOCAmount\": \"9999999.00\",'+
    ''+
    '          \"CoveredPartsQuantity\": \"9999999.00\",'+
    ''+
    '          \"CoveredTowingMiles\": \"0.00\",'+
    ''+
    '          \"CoveredTravelLabor\": \"0.00\",'+
    ''+
    '          \"CoveredTravelMiles\": \"0.00\",'+
    ''+
    '          \"DeductibleAmount\": \"0.00\",'+
    ''+
    '          \"AuthorizationNum\": \"\",'+
    ''+
    '          \"CampaignLabourPrcnt\": \"0.00\",'+
    ''+
    '          \"CampaignOCPrcnt\": \"0.00\",'+
    ''+
    '          \"CampaignPartsPrcnt\": \"0\",'+
    ''+
    '          \"CampaignTowingPrcnt\": \"0.00\",'+
    ''+
    '          \"CampaignTravelPrcnt\": \"0.00\",'+
    ''+
    '          \"listOfOtherClaimables\": {'+
    ''+
    '            \"OtherClaimables\": ['+
    ''+
    '              {'+
    ''+
    '                \"Item\": \"Antifreeze/Coolant\",'+
    ''+
    '                \"OtherClaimableDetails\": \"Antifreeze/Coolant\",'+
    ''+
    '                \"ClaimedReason\": \"\",'+
    ''+
    '                \"ClaimedAmount\": \"65.06\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"Item\": \"Coolant Filter\",'+
    ''+
    '                \"OtherClaimableDetails\": \"Coolant Filter\",'+
    ''+
    '                \"ClaimedReason\": \"\",'+
    ''+
    '                \"ClaimedAmount\": \"10.69\"'+
    ''+
    '              }'+
    ''+
    '            ]'+
    ''+
    '          },'+
    ''+
    '          \"listOfParts\": {'+
    ''+
    '            \"Parts\": ['+
    ''+
    '              {'+
    ''+
    '                \"PartNumber\": \"435214500\",'+
    ''+
    '                \"QtyClaimed\": \"1\",'+
    ''+
    '                \"PartUnitPrice\": \"729.75\",'+
    ''+
    '                \"PartPercentage\": \"100\",'+
    ''+
    '                \"PricebookName\": \"015111_02_MEMGOMS\",'+
    ''+
    '                \"ReplacementReason\": \"Damaged Upon Removal\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"PartNumber\": \"429862600\",'+
    ''+
    '                \"QtyClaimed\": \"1\",'+
    ''+
    '                \"PartUnitPrice\": \"1239.03\",'+
    ''+
    '                \"PartPercentage\": \"100\",'+
    ''+
    '                \"PricebookName\": \"015111_02_MEMGOMS\",'+
    ''+
    '                \"ReplacementReason\": \"Root Cause\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"PartNumber\": \"438604700\",'+
    ''+
    '                \"QtyClaimed\": \"1\",'+
    ''+
    '                \"PartUnitPrice\": \"43.23\",'+
    ''+
    '                \"PartPercentage\": \"100\",'+
    ''+
    '                \"PricebookName\": \"015111_02_MEMGOMS\",'+
    ''+
    '                \"ReplacementReason\": \"Root Cause\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"PartNumber\": \"541378200RX\",'+
    ''+
    '                \"QtyClaimed\": \"1\",'+
    ''+
    '                \"PartUnitPrice\": \"2897.55\",'+
    ''+
    '                \"PartPercentage\": \"100\",'+
    ''+
    '                \"PricebookName\": \"015111_02_MEMGOMS\",'+
    ''+
    '                \"ReplacementReason\": \"Root Cause\"'+
    ''+
    '              }'+
    ''+
    '            ]'+
    ''+
    '          },'+
    ''+
    '          \"listOfSRTs\": {'+
    ''+
    '            \"SRTs\": ['+
    ''+
    '              {'+
    ''+
    '                \"SRTCode\": \"CS-066-00\",'+
    ''+
    '                \"SRTAccessCode\": \"B\",'+
    ''+
    '                \"Justification\": \"Mexico Claim\",'+
    ''+
    '                \"SRTHours\": \"23.2\",'+
    ''+
    '                \"SRTQty\": \"1\",'+
    ''+
    '                \"SRTPrcnt\": \"100\",'+
    ''+
    '                \"OutOfChasis\": \"N\",'+
    ''+
    '                \"OverlapHrs\": \"0\",'+
    ''+
    '                \"Offiste\": \"N\",'+
    ''+
    '                \"SRTType\": \"Custom\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"SRTCode\": \"17-141-00\",'+
    ''+
    '                \"SRTAccessCode\": \"B\",'+
    ''+
    '                \"Justification\": \"Mexico Claim\",'+
    ''+
    '                \"SRTHours\": \"2.5\",'+
    ''+
    '                \"SRTQty\": \"1\",'+
    ''+
    '                \"SRTPrcnt\": \"100\",'+
    ''+
    '                \"OutOfChasis\": \"N\",'+
    ''+
    '                \"OverlapHrs\": \"0\",'+
    ''+
    '                \"Offiste\": \"N\",'+
    ''+
    '                \"SRTType\": \"Custom\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"SRTCode\": \"00-401-00\",'+
    ''+
    '                \"SRTAccessCode\": \"B\",'+
    ''+
    '                \"Justification\": \"Mexico Claim\",'+
    ''+
    '                \"SRTHours\": \"0.5\",'+
    ''+
    '                \"SRTQty\": \"1\",'+
    ''+
    '                \"SRTPrcnt\": \"100\",'+
    ''+
    '                \"OutOfChasis\": \"N\",'+
    ''+
    '                \"OverlapHrs\": \"0.5\",'+
    ''+
    '                \"Offiste\": \"N\",'+
    ''+
    '                \"SRTType\": \"Custom\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"SRTCode\": \"00-901-00\",'+
    ''+
    '                \"SRTAccessCode\": \"R\",'+
    ''+
    '                \"Justification\": \"Mexico Claim\",'+
    ''+
    '                \"SRTHours\": \"0.4\",'+
    ''+
    '                \"SRTQty\": \"1\",'+
    ''+
    '                \"SRTPrcnt\": \"100\",'+
    ''+
    '                \"OutOfChasis\": \"Y\",'+
    ''+
    '                \"OverlapHrs\": \"0\",'+
    ''+
    '                \"Offiste\": \"N\",'+
    ''+
    '                \"SRTType\": \"Custom\"'+
    ''+
    '              },'+
    ''+
    '              {'+
    ''+
    '                \"SRTCode\": \"00-714-00\",'+
    ''+
    '                \"SRTAccessCode\": \"B\",'+
    ''+
    '                \"Justification\": \"Mexico Claim\",'+
    ''+
    '                \"SRTHours\": \"0.5\",'+
    ''+
    '                \"SRTQty\": \"1\",'+
    ''+
    '                \"SRTPrcnt\": \"100\",'+
    ''+
    '                \"OutOfChasis\": \"N\",'+
    ''+
    '                \"OverlapHrs\": \"0\",'+
    ''+
    '                \"Offiste\": \"N\",'+
    ''+
    '                \"SRTType\": \"Custom\"'+
    ''+
    '              }'+
    ''+
    '            ]'+
    ''+
    '          }'+
    ''+
    '        }'+
    ''+
    '      ]'+
    ''+
    '    },'+
    ''+
    '                \"ListOfAdditionalESN\": {'+
    ''+
    '      \"AdditionalESN\": ['+
    ''+
    '        {'+
    ''+
    '          \"EngineSerialNumber\": \"79758995\",'+
    ''+
    '                                  \"WarrantyStartDate\": \"02/27/2015\",'+
    ''+
    '                                  \"BISFlag\": \"N\",'+
    ''+
    '                                  \"FailureDate\": \"03/23/2018\",'+
    ''+
    '                                  \"FailurePoint\": \"515540\",'+
    ''+
    '                                  \"FailureMeasure\": \"Kilometers\",'+
    ''+
    '                                  \"EngineVIN\": \"\",'+
    ''+
    '                                  \"ECMCalibAfter\": \"\",'+
    ''+
    '                                  \"ECMCalibBefore\": \"\",'+
    ''+
    '                                  \"RevisionBefore\": \"\",'+
    ''+
    '                                  \"ReviewAfter\": \"\"'+
    ''+
    '        }'+
    ''+
    '      ]'+
    ''+
    '    }         '+
    ''+
    '  }'+
    ''+
    '}';
    CG_ClaimsInbound_SubmitToSiebel_Req obj = CG_ClaimsInbound_SubmitToSiebel_Req.parse(json);
    System.assert(obj != null);
  }
}