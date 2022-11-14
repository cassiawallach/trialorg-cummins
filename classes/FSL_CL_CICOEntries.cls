/******************************************************************************************************************
Name: FSL_CL_CICOEntries 
Description: Timesheet Trigger Handler class.

Version                 Date                    Author                      Summary Of Change
-----------------------------------------------------------------------------------------------------
1.0                   8/12/2020                Ravikanth                  Class created for CICO Webservice

********************************************************************************************************************/
public class FSL_CL_CICOEntries {

  public static void sendJsonRequest() {

          JSONGenerator gen=JSON.createGenerator(true);
        gen.writeStartObject(); //It is used for making starting object(‘{‘)
        gen.writeFieldName('Header');//Here it is used for making name ,value pair
        gen.writeStartObject();
        gen.writeFieldName('Sender');
        gen.writeStartObject();
        gen.writeStringField('ServiceName','CICOData');
        gen.writeStringField('SenderID','Guidanz');
        gen.writeEndObject();//It is used for making end of object(‘}’)
        gen.writeFieldName('Target');
        gen.writeStartObject();
        gen.writeStringField('TargetID','BMS');
        gen.writeEndObject();
        gen.writeFieldName('Location');
        gen.writeStartObject();
        gen.writeStringField('LocationID','56270-56255');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeFieldName('DataArea');
        gen.writeStartObject();
        gen.writeFieldName('Timesheets');
         gen.writeStartArray();
               
                gen.writeStartObject();
                gen.writeStringField('WorkOrderNumber','');
                gen.writeStringField('ShopWorkOrder','');
                gen.writeStringField('RepairLocation','');
                gen.writeStringField('TimesheetNumber','');
                gen.writeStringField('Reason','');
                gen.writeStringField('Status','');
                gen.writeEndObject();
                
        gen.writeEndArray();
        gen.writeEndObject();
        gen.writeEndObject();
         String jsonString = gen.getAsString();
        System.debug('jsonString:'+jsonString);
     
   }



}