/**********************************************************************
Name:CG_ClaimsInbound_SubmitToSiebel_Req
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Submit Claim details to Siebel-request Wrapper class #144545                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Vignesh S      05/30/2018        INITIAL DEVELOPMENT
1.1 -    Vignesh S      10/03/2018        Changed ListOfAdditionalESN to ListOfAdditionalESNs
=======================================================================
***********************************************************************/
public class CG_ClaimsInbound_SubmitToSiebel_Req
{
    public Header Header;
    public DataArea  DataArea;
    
    public class Header{
        public Sender Sender;
        public String Target;
    }
    
    public class Sender{
        public String MessageID;
        public String ServiceName;
        public String SenderID;
    }
    
    public class DataArea{
        public String ServiceProviderCode;
        public String DistributorCode;
        public String EngineSerialNumber;
        public String RONumber;
        public String WarrantyStartDate;
        public String EngineApplicationCode;
        public String Manufacturer;
        public String ModelSeries;
        public String FirstName;
        public String LastName;
        public String BISFlag;
        public String MultiESNFlg;
        public String CampaignNumber;
        public String InfoOnlyFlag;
        public String NewPartsWarrantyFlg;
        public String ReConPartsWarrantyFlg;
        public String RoadRelayWarrantyFlg;
        public String FailureDate;
        public String FailurePoint;
        public String FailureMeasure;
        //public String SSAAvailableLimit; //ProductHours; //Added, as per story GSSC-514
        public String MissionDisablingFlag;
        public String CatastrophicFlag;
        public String RepairDescription;
        public String ReplacementPart;
        public String SPCertifiedFlag;
        public String WarrantyTrainedFlag;
        public String CustomerPossession;
        public String DISDNumber;
        public String CustomerName;
        public String ECMCalibAfter;
        public String ReviewAfter;
        public String ECMCalibBefore;
        public String RevisionBefore;
        public String Justification;
        public String EngineVIN;
        public String ESNCount;
        public String TSRNumber;
        public String UnitNumber;
        public String PaccarFlag;
        public String PenaltyFlag;
        public String SRTPenaltyPercentage;
        public String manualAdjudicationFlag;
        public String SSAAvailableLimit; //ProductHours; //Added, as per story GSSC-514
        public String DealerClaimNumber;
        public String ClaimSource;
        public String ClaimFiledDate;
        public String SPInShopLaborRate;
        public String SPLaborRate;
        public String SPTravelRate;
        public String Contact;
        public String CSSJobID;
        public String LicencePlateState;
        public String SubmittedBy;
        public String TechActualHrs;
        public String PolicyRequestID;
        public String RMAFlag;
        public ListOfComplaintCodes ListOfComplaintCodes;
        public ListOfPromotionIds ListOfPromotionIds;
        public ListOfNotes ListOfNotes;
        public ListOfFailureList listOfFailureList;
        public ListOfAdditionalESNs ListOfAdditionalESNs; 
    }
    
    public class ListOfComplaintCodes{
        public List<ComplaintCode> ComplaintCodes;
    }
    
    public class ComplaintCode{
        public String ComplaintCode;
    }
    
    public class ListOfPromotionIds{
        public List<PromotionId> PromotionIds;
    }
    
    public class PromotionId{
        public String PromotionID;
    }  
    
    public class ListOfNotes{
        public List<Note> Notes;
    }
    
    public class Note{
        public String Note;
        public String NoteType;
    }
    
    public class ListOfFailureList{
        public List<FailureList> FailureList;
    }
    
    public class FailureList{
        public String SystemCode;
        public String ComponentCode;
        public String FailMode;
        public String AccountCode;
        public String PayCode;
        public String CertificateNumber;
        public String CampaignNumber;
        public String FaultCode;
        public String WarrantyId;
        public String ApproverCode;
        public String CoverageType;
        public String CoveredLaborHours;
        public String CoveredMealsLodgingAmt;
        public String CoveredOCAmount;
        public String CoveredPartsQuantity;
        public String CoveredTowingMiles;
        public String CoveredTravelLabor;
        public String CoveredTravelMiles;
        public String DeductibleAmount;
        public String AuthorizationNum;
        public String CampaignLabourPrcnt;
        public String CampaignOCPrcnt;
        public String CampaignPartsPrcnt;
        public String CampaignTowingPrcnt;
        public String CampaignTravelPrcnt;
        public String SupportPlanID;
        public String Bank;
        public String PrimaryFailureFlag;
        public ListOfFailureCylinder listOfFailureCylinder;
        public ListOfOtherClaimables listOfOtherClaimables;
        public ListOfTravelDetails listOfTravelDetails;
        public ListOfParts listOfParts;
        public ListOfSRTs listOfSRTs;
    }
    
    public class ListOfOtherClaimables{
        public List<OtherClaimable> OtherClaimables;
    }
    
    public class OtherClaimable{
        public String Item;
        public String OtherClaimableDetails;
        public String ClaimedReason;
        public String ClaimedAmount;
    }
    
    public class ListOfTravelDetails{
        public List<TravelDetail> TravelDetails;
    }
    
    public class TravelDetail{
        public String TravelType;
        public String TravelMode;
        public String OtherModeDetails;
        public String TechnicianPromotionId;
        public String TechnicalWage;
        public String BaseFare;
        public String Hours;
        public String Distance;
        public String UOM;
        public String MealsAmount;
        public String LodgingAmount;
        public String TowingAmount;
    }
    
    public class ListOfParts{
        public List<Part> Parts;
    }
    
    public class Part{
        public String PartNumber;
        public String QtyClaimed;
        public String PartUnitPrice;
        public String PartPercentage;
        public String PricebookName;
        public String ReplacementReason;
        public String SupersededPart;
        public String RIDNumber;
        public String TrackingNumber;
        public String PartsReturnFlag;
    }
    
    public class ListOfSRTs{
        public List<SRT> SRTs;
    }
    
    public class SRT{
        public String SRTCode;
        public String SRTAccessCode;
        public String Justification;
        public String SRTHours;
        public String SRTQty;
        public String SRTPrcnt;
        public String OutOfChasis;
        public String OverlapHrs;
        public String Offiste;
        public String SRTType;
        Public String ExcludeOvrlpFlg;
    } 
    
    public class ListOfAdditionalESNs{
        public List<AdditionalESNs> AdditionalESNs;
    }
    
    public class AdditionalESNs{
        public String EngineSerialNumber;
        public String WarrantyStartDate;
        public String BISFlag;
        public String FailureDate;
        public String FailurePoint;
        public String FailureMeasure;
        //public String SSAAvailableLimit; //ProductHours; Added as per story GSSC-514, commenting it for now, as its not mentioned in the story
        public String EngineVIN;
        public String ECMCalibAfter;
        public String ECMCalibBefore;
        public String RevisionBefore;
        public String ReviewAfter;
    }  
    
    public class FailureCylinder {
        public String Cylinder;
    }
 
    public class ListOfFailureCylinder {
        public List<FailureCylinder> FailureCylinder;
    }
    
    public static CG_ClaimsInbound_SubmitToSiebel_Req parse(String json){
        return (CG_ClaimsInbound_SubmitToSiebel_Req) System.JSON.deserialize(json, CG_ClaimsInbound_SubmitToSiebel_Req.class);
    }
}