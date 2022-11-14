/***********************************************************************************************
Name:
==============================================================================================
==============================================================================================
Purpose:                                                            
-------  
This class is to send SRTData request to BMS
==============================================================================================
==============================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                                   
1.0         PiyushR                    08/11/2020                         
************************************************************************************************/ 
public class FSL_CL_BMSSRTData {
    public static String requestJSON;
    
    @AuraEnabled
    public static String getBMSSRTData(String serviceJob) {
        List<WorkOrder> serviceOrders = [SELECT Id, WorkOrderNumber, Shop_Work_Order__c, Make__c, Model__c, 
                                         ServiceTerritory.Location_Code__c, Asset.Engine_Family_Code__c
                                         FROM WorkOrder 
                                         WHERE Id=:serviceJob];
        String SRTData = FSL_CL_BMSSRTData.getSRTData(serviceJob);
        requestJSON = '{'+
            '   \"Header\":{'+
            '      \"Sender\":{'+
            '         \"ServiceName\":\"SRTData\",'+
            '         \"SenderID\":\"Guidanz\"'+
            '      },'+
            '      \"Target\":{'+
            '         \"TargetID\":\"BMS\"'+
            '      },'+
            '      \"Location\":{'+
            '         \"LocationID\":\"'+ serviceOrders[0].ServiceTerritory.Location_Code__c +'\"'+
            '      }'+
            '   },'+
            '   \"DataArea\":{'+
            '      \"GuidanzJobID\":\"'+ serviceOrders[0].WorkOrderNumber +'\",'+
            '      \"ShopWONumber\":\"'+ serviceOrders[0].Shop_Work_Order__c +'\",'+
            '      \"Make\":\"'+ serviceOrders[0].Make__c +'\",'+
            '      \"Model\":\"'+ serviceOrders[0].Model__c +'\",'+
            '      \"EngineFamilyCode\":\"'+ serviceOrders[0].Asset.Engine_Family_Code__c +'\",'+
            SRTData
            +
            '   }'+
            '}';  
        System.debug('::: JSON Final = '+requestJSON);
        return requestJSON;
    }
    
    public static string getSRTData(String serviceJob) {
        List<FSL_SRT__c> SRTList = [SELECT Id, name, Access_Code__c, Service_Order__c, SRT_Time__c, Actual_SRT_Time__c, SRT_Quantity__c FROM FSL_SRT__c where Service_Order__c =: serviceJob];
        String jsonData;
        if(!SRTList.isEmpty()) {
            try {
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();     
                gen.writeFieldName('SRTs');
                gen.writeStartArray();
                for(FSL_SRT__c srt :SRTList){
                    gen.writeStartObject();
                    gen.writeStringField('AccessCode', (srt.Access_Code__c != null ? srt.Access_Code__c : ''));
                    if(srt.Name == 'Travel') {
                        gen.writeStringField('SRTgroupnum', srt.Name);
                        gen.writeStringField('Procedureno', '');
                        gen.writeStringField('Stepnumber', '');
                    } else if(srt.Name == '99-999') {
                        gen.writeStringField('SRTgroupnum', srt.Name.substringBefore('-'));
                        gen.writeStringField('Procedureno', srt.Name.substringAfter('-'));
                        gen.writeStringField('Stepnumber', '00');
                    } else {
                        gen.writeStringField('SRTgroupnum', srt.Name.substringBefore('-'));
                        gen.writeStringField('Procedureno', srt.Name.substringBetween('-'));
                        gen.writeStringField('Stepnumber', srt.Name.substringAfterLast('-'));
                    }
                    
                    gen.writeNumberField('SRTTime', (srt.SRT_Time__c != null ? srt.SRT_Time__c : Decimal.valueOf('')));
                    gen.writeStringField('ActualSRTTime', (srt.Actual_SRT_Time__c != null ? srt.Actual_SRT_Time__c : ''));
                    gen.writeNumberField('SRTquantity', (srt.SRT_Quantity__c != null ? srt.SRT_Quantity__c : Decimal.valueOf('')));
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject(); 
                jsonData = gen.getAsString();
                System.debug('::: SRT JSON Data - ' + jsonData);
                
                return jsonData;
            } catch(Exception ex) {
                System.debug('::: Exception Caused are = '+ex.getMessage());
                System.debug('::: Exception Caused are = '+ex.getStackTraceString());
                //Insert Error Log
                //handleErrorLog(request, response, serviceName, status, serviceVersion, toolId, senderId);
                return null;
            }
            
        } else {
            return null;
        }
    }
    
    public static void handleErrorLog(RestRequest request, RestResponse response, String serviceName, String status,String serviceVersion, String toolId, String senderId){
        /*FSL_Integration_Error_Log__c objIntegrationErrorLog = new FSL_Integration_Error_Log__c();
        objIntegrationErrorLog.Request__c =  request.requestBody.toString().trim();
        objIntegrationErrorLog.Response__c = response.responseBody.toString();
        objIntegrationErrorLog.Service_Name__c = serviceName;
        objIntegrationErrorLog.Service_Version__c = serviceVersion;
        if(status=='Success'){
            objIntegrationErrorLog.Status__c = 'Success';
        }else{
            objIntegrationErrorLog.Status__c = 'Error';
        }
        objIntegrationErrorLog.ToolID__c = toolId;
        objIntegrationErrorLog.SenderID__c = senderId;
        try{
            insert objIntegrationErrorLog;
        }catch(Exception ex){
            ex.getStackTraceString();
        }
        */
    } 
    
    
}