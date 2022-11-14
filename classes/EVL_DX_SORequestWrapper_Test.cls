@isTest
public class EVL_DX_SORequestWrapper_Test {
    @isTest
    static void testParse() {
       String json = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
        EVL_DX_SORequestWrapper obj = EVL_DX_SORequestWrapper.parse(json);
        
        //Added as part of NIN-469 changes to increase code coverage after changing the Wrapper Class
        EVL_DX_SORequestWrapper.Header headerDetail = new EVL_DX_SORequestWrapper.Header();
        obj.setHeader(headerDetail);
        EVL_DX_SORequestWrapper.Header dtArHead =  obj.getHeader();
        
        EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
        obj.setDataArea(DataAreaDetails);
        
        EVL_DX_SORequestWrapper.DataArea dtAr =  obj.getDataArea();
        //End changes
               
        
        System.assert(obj != null);
    }
}