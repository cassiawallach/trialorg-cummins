/**********************************************************************
Name:CG_ClaimsInbound_SubmitToBMS_Req
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Submit Claim details to BMS-request Wrapper class                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Rajkumar BT      06/05/2018        INITIAL DEVELOPMENT  
1.1 -     Vignesh S       10/03/2018      Changed ListOfAdditionalESN to ListOfAdditionalESNs
=======================================================================
***********************************************************************/
public class CG_ClaimsInbound_SubmitToBMS_Req {

    public class Sender {
        public String MessageID;
        public String ServiceName;
        public String SenderID;
    }

    public class TravelDetails {
        public String TravelLaborHour;
        public String TravelRate;
        public String TravelLaborAmount;
        public String TravelDistance;
        public String TravelDistanceRate;
        public String TravelMealAmount;
        public String TravelLodgingAmount;
    }

    public class DataArea {
        public String DistributorCode;
        public String BranchCode;
        public String ClaimType;
        public String ClaimDate;
        public String Owned;
        public String SiebelClaimNumber;
        public String DealerClaimNumber;
        public String GuidanzClaimNumber;
        public String CSSJobID;
        public String BMSReferenceNumber;
        public String DealerCode;
        public String CustomerCode;
        public String ESN;
        public String ApplicationCode;
        public String AccountCode;
        public String PayCode;
        public String AuthorizationNumber;
        public String ApprovalCode;
        public String PolicyRequestNumber;
        public String FailureLocation;
        public String CreateUser;
        public String FailureDate;
        public String WarrantyStartDate;
        public String Severity;
        public String SMN;
        public String EngineFamily;
        public String Make;
        public String Model;
        public String EquipmentConfiguration;
        public String DistanceType;
        public String Hours;
        public String DealerApproval;
        public String DistributorAuthorization;
        public String MaterialDisposition;
        public String TotalPartsAmount;
        public String TotalLaborAmount;
        public String TotalTravelAmount;
        public String TotalOtherAmount;
        public String PMU;
        public String BFC;
        public String Tax;
        public String TotalClaimAmount;
        public String Reference1;
        public String Reference2;
        public String Reference3;
        public List<Notes> Notes;
        public List<FailCode> FailCode;
        public List<Parts> Parts;
        public List<OtherClaimables> OtherClaimables;
        public List<SRTs> SRTs;
        public List<TravelDetails> TravelDetails;
        public List<AdditionalESNs> AdditionalESNs;
    }

    public Header Header;
    public DataArea DataArea;

    public class Header {
        public Sender Sender;
        public String Target;
    }

    public class AdditionalESNs {
        public String ESN;
        public String ESNModel;
        public String ApplicationCode;
        public String DistanceType;
        public String Hours;
        public String FailureDate;
        public String WarrantyStartDate;
    }

    public class Parts {
        public String PartNumberService;
        public String ProductCodeOEM;
        public String Description;
        public String PartQuantity;
        public String UnitPrice;
        public String ExtendedPrice;
        public String PercentClaimed;
    }

    public class FailCode {
        public String ProductGroup;
        public String GroupCode;
        public String SystemCode;
        public String ComponentCode;
        public String FailureMode;
        public String FailLocation;
        public String FailureOrder;
    }

    public class OtherClaimables {
        public String OCCreditType;
        public String MiscName;
        public String MiscDescription;
        public String MiscQuantity;
        public String MiscAmount;
    }

    public class SRTs {
        public String SRTgroupnum;
        public String Procedureno;
        public String Stepnumber;
        public String Accesscode;
        public String PercentClaimed;
        public String SRTquantity;
        public String SRTTime;
        public String SRTLaborRate;
        public String ExtendedAmount;
        public String ServiceModelName;
        public String AdjustmentReason;
    }

    public class Notes {
        public String NoteType;
        public String Notes;
    }
        
    public static CG_ClaimsInbound_SubmitToBMS_Req parse(String json) {
        return (CG_ClaimsInbound_SubmitToBMS_Req) System.JSON.deserialize(json, CG_ClaimsInbound_SubmitToBMS_Req.class);
    }
}