Public Class CSS_WS_J2A_GetCampaignData{

    Public Header Header;
    Public DataArea DataArea;
    
    Public Class Header{
        Public String Status;
        Public String ReturnCodeDescription;
    }
    
    Public Class DataArea{
        Public List<Details> Details;
    }

    Public Class Details{
        Public String CampaignDesc;
        Public String CampaignEndDate;
        Public String CampaignStartDate;
        Public List<PartList> PartList;
        Public List<SrtList> SrtList;
        Public String CampaignNumber;
        Public String FailMode;
        Public String FailCode;
        Public String InShopSrtLimitFlag;
    }
    
    Public Class PartList{
        Public String PartQuantity;
        Public String PartNumber;
        Public String PartDescription;
    }

    Public Class SrtList{
        Public String SrtCode;
        Public String SrtDescription;
    }
    
    Public Static CSS_WS_J2A_GetCampaignData parse(String json){
        return (CSS_WS_J2A_GetCampaignData) System.JSON.deserialize(json, CSS_WS_J2A_GetCampaignData.class);
    }
}