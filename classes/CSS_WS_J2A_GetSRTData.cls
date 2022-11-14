Public Class CSS_WS_J2A_GetSRTData{

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
        Public String SRTCode;
        Public String SRTDescription;
        Public String HrsUnit;
        Public String StepId;
    }
    
    Public Static CSS_WS_J2A_GetSRTData parse(String json){
        return (CSS_WS_J2A_GetSRTData) System.JSON.deserialize(json, CSS_WS_J2A_GetSRTData.class);
    }
}