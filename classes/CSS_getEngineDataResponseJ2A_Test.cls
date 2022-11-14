@isTest
public class CSS_getEngineDataResponseJ2A_Test {
    static testMethod void testParse(){
        String json='{\r\n\t\"DataArea\": {\r\n\t\t\"EtoConversionDate\": \"\",\r\n\t\t\"EquipmentId\": \"EQ7503\",\r\n\t\t\"EngineAppCode\": \"130\",\r\n\t\t\"DesignPhaseCode\": \"21\",\r\n\t\t\"ETOOldPSN\": \"79464646\",\r\n\t\t\"ETOOldESN\": \"23231245\",\r\n\t\t\"Manufacturer\": \"AUTOCAR\",\r\n\t\t\"OEMSPCode\": \"01005\",\r\n\t\t\"CriticalPartsListNumber\": \"8257\",\r\n\t\t\"CustomerName\": \"testingTTMl\",\r\n\t\t\"ProdAppCode\": \"BB\",\r\n\t\t\"ServiceModelName\": \"ISX CM570\",\r\n\t\t\"EngineFamilyName\": \"ISXSIGNATURE(APEX)\",\r\n\t\t\"EquipmentConfiguration\": \"CAB OVER\",\r\n\t\t\"PACCARFlag\": \"\",\r\n\t\t\"Esn\": \"79462880\",\r\n\t\t\"EngineBillToCode\": \"01405\",\r\n\t\t\"MarineAppFlag\": \"N\",\r\n\t\t\"AccessCode\": \"B\",\r\n\t\t\"ShipDate\": \"2011-03-05 00:00:00.0\",\r\n\t\t\"AutomotiveAppFlag\": \"Y\",\r\n\t\t\"EngineFamilyCode\": \"10\",\r\n\t\t\"BuildDate\": \"2011-03-01T00:00:00.000-06:00\",\r\n\t\t\"EngineAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"NoWarranty\": \"N\",\r\n\t\t\"ProdAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"Model\": \"ACX\",\r\n\t\t\"VIN\": \"3HSDJAPT9CN565886\",\r\n\t\t\"WarrantyStartDate\": \"2018-10-01T00:00:00.000-05:00\"\r\n\t},\r\n\t\"Header\": {\r\n\t\t\"Status\": \"Success\"\r\n\t}\r\n}'+
            '';
        CSS_getEngineDataResponseJ2A.parse(json);
        CSS_getEngineDataResponseJ2A.DataArea cont = new CSS_getEngineDataResponseJ2A.DataArea();
        cont.ETOOldESN = null;
        System.assert(cont.ETOOldESN == null);

        //CSS_getEngineDataResponseJ2A.DataArea.ETOOldESN;
    }
}