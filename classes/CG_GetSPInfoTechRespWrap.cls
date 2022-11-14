public class CG_GetSPInfoTechRespWrap {
    public string FirstName;
    public string LastName;
    public string PromotionID;
    public string SP_CODE;
    public string SP_ROW_ID;
    public string TECH_ROW_ID;
    public static CG_GetSPInfoTechRespWrap parser(string json){
        return (CG_GetSPInfoTechRespWrap) SYSTEM.JSON.deserialize(json,CG_GetSPInfoTechRespWrap.class);
    }
}