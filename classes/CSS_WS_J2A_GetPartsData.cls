Public Class CSS_WS_J2A_GetPartsData{

    Public Header Header;
    Public DataArea DataArea;

    Public Class Header{
        Public String Status;
        Public String ReturnCodeDescription;
    }
    
    Public Class DataArea{
        Public String PartNumberLong;
        Public String PartInService;
        Public String PartDescription;
        Public String KitPartFlag;
        Public String SupersededPartNumber;
        Public String PartProductCode;
    }

    Public Static CSS_WS_J2A_GetPartsData parse(String json){
        return (CSS_WS_J2A_GetPartsData) System.JSON.deserialize(json, CSS_WS_J2A_GetPartsData.class);
    }
}