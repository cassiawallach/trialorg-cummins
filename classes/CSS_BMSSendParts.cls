/**********************************************************************
Name:CSS_BMSSendParts
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get Parts from BMS #133137                                                       
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Karthik G     04/16/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/

@RestResource(urlMapping='/BMS/V01/CSS/BMSPartsSendToGuidanz/*')

global with sharing class CSS_BMSSendParts {
    @HttpPut
    global static void insertBMSPartsData(){
        String JSONResponseBody;
        String wsESN;
        String ServiceJobLocation = '';
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<CSS_Parts_Options__c> lstPartsinsert = new List<CSS_Parts_Options__c>();
        list<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
        list<CSS_Parts_Options__c> GSQpartsList = new List<CSS_Parts_Options__c>();
        Boolean FlagToInsert = false;
        Boolean FlagToWOQoute = false;
        res.addHeader('Content-Type', 'application/json');
        String jsonRequestBody ;
        jSONRequestBody = req.requestBody.toString().trim(); 
        system.debug('** Req'+req.requestBody);
        system.debug('**'+jSONRequestBody);
        try
        {

            CSS_BMSJobParts_Req_Json sendPartsReq = (CSS_BMSJobParts_Req_Json)JSON.deserialize(jsonRequestBody, CSS_BMSJobParts_Req_Json.class);
            system.debug('**  '+sendPartsReq);
            //   System.debug('===> Request' + sendJobPlanReq);
            // System.debug('===>Job Name: ' + sendJobPlanReq.DataArea.CSSjobID);


            //Fetch the Job Order from Salesforce based on the parameter passed on the URL
            CSS_Job_Order__c serJob = [SELECT Id, Name, CSS_Job_Location_Code__c,ODM_Status__c, Status__c, Unit_Number__c,Sub_Status__c From CSS_Job_Order__c WHERE Name =: sendPartsReq.DataArea.CSSjobID];
            System.debug('===> Service Job' + serJob);
            ServiceJobLocation = serJob.CSS_Job_Location_Code__c;
            if(serJob != null){
                System.debug('====> ServiceJobLocation' +ServiceJobLocation);
                Id partRecTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
                Id OtherClaimlableRecId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
                Id TowingRecId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();

                Set<id> RecordTypeIds = new Set<id>();
                RecordTypeIds.add(partRecTypeId);
                RecordTypeIds.add(OtherClaimlableRecId);
                RecordTypeIds.add(TowingRecId);

                Set<String> PartOCType = new Set<String>();
                PartOCType.add('TOW');
                PartOCType.add('OC');
                PartOCType.add('PART');

                Id GSQParts =   Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();

                //The partsList query criteria has been modified by Rajesh Narra on 6-27-2018 to query all the BMS Parts to delete before inserting new reocords
                partsList = [select Id, Name, Quantity__c, Quantity_Used__c,Price_Book__c,Part_Description__c,Part_Name__c,Sell_Price__c, Service_partnumber__c, Account_Code__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c from CSS_Parts_Options__c where Service_Job__c =: serJob.id AND RecordTypeId IN: RecordTypeIds and PartOC__c IN:PartOCType];     

                GSQpartsList = [select Id, Name,Service_partnumber__c,FailurepartId__r.FailCode_Formula__c,Get_Fail_Code_Formula__c, FailurepartId__r.CSS_Account_Formula__c, Fail_Code__c,Account_Code__c,ODM_Status__c,ReturnToFactory__c from CSS_Parts_Options__c where Service_Job__c =: serJob.id AND RecordTypeId=:GSQParts];



                if(sendPartsReq.DataArea.OrderType != 'WO'){
                    FlagToWOQoute = true;
                    // If condition is added by Rajesh Narra to delete all the parts if the BMS deletes all the parts based on the part number criteria DELETE_ALL
                    if(sendPartsReq.DataArea.PartDetails.size()>0 && (sendPartsReq.DataArea.PartDetails[0].PartNumber != null &&  sendPartsReq.DataArea.PartDetails[0].PartNumber != 'DELETE_ALL')){
                        system.debug('** entered into if cond'+sendPartsReq.DataArea.PartDetails);
                        for(CSS_BMSJobParts_Req_Json.PartDetails dArea : sendPartsReq.DataArea.PartDetails){
                            CSS_Parts_Options__c PartsRec = new CSS_Parts_Options__c();
                            if(GSQpartsList != null && GSQpartsList.size() > 0){
                                for(CSS_Parts_Options__c existpart: GSQpartsList){
                                    if(dArea.PartNumber == existpart.Service_partnumber__c){
                                        PartsRec.ReturnToFactory__c = existpart.ReturnToFactory__c;
                                        PartsRec.Fail_Code__c = existpart.Get_Fail_Code_Formula__c;
                                        PartsRec.Account_Code__c = existpart.Account_Code__c;
                                        PartsRec.ODM_Status__c = existpart.ODM_Status__c;
                                        system.debug('Inside IF '+PartsRec.Fail_Code__c);
                                        system.debug('Inside IF Part Number '+existpart.Service_partnumber__c);
                                        break;
                                    }
                                    else{
                                        PartsRec.Fail_Code__c=existpart.FailurepartId__r.FailCode_Formula__c;
                                        PartsRec.Account_Code__c = existpart.FailurepartId__r.CSS_Account_Formula__c;
                                        PartsRec.ReturnToFactory__c = dArea.PartsReturn;
                                    }
                                }
                            }else{
                                PartsRec.ReturnToFactory__c = dArea.PartsReturn;
                            }
                            PartsRec.Service_Job__c = serJob.Id;
                            PartsRec.Service_partnumber__c = dArea.PartNumber;
                            PartsRec.Part_Name__c = dArea.PartDescription;//We are saving the Part Name as Part Description for the BMS OUTbound Parts as part of SIT testing, this comment is made by Rajesh Narra
                            PartsRec.Part_Description__c = dArea.PartDescription;
                            PartsRec.Quantity_Ordered__c = dArea.QuantityOrdered;
                            if(dArea.QuantityOrdered != null && dArea.QuantityOrdered != '')
                                PartsRec.Quantity__c = decimal.valueOf(dArea.QuantityOrdered);
                            //PartsRec.Quantity_Used__c = dArea.QuantityUsed;
                            PartsRec.Quantity_Used__c = dArea.QuantityOrdered;
                            PartsRec.Parts_Return__c = dArea.PartsReturn;
                            PartsRec.Sell_Price__c = double.valueOf(dArea.SellPrice);
                            PartsRec.Unit_Price__c = dArea.SellPrice;//Newly Added.
                            system.debug('SellPrice'+PartsRec.Sell_Price__c);
                            PartsRec.Warranty_Allocation__c = Integer.valueOf(dArea.WarrantyAllocation);
                            PartsRec.Comments__c = dArea.Comments;
                            PartsRec.Notes__c = dArea.Comments;
                            PartsRec.Line_Type__c = dArea.LineType;
                            PartsRec.Serial_Number__c = dArea.SerialNumber;
                            PartsRec.Serial_Number_Vendor__c = dArea.SerialNumberVendor;
                            PartsRec.selected_part__c = true;
                            PartsRec.Model__c = dArea.Model;
                            PartsRec.Option__c = dArea.Option;
                            PartsRec.Option_ESN__c = dArea.ESN;
                            PartsRec.SSN__c = dArea.SSN;
                            PartsRec.VIN__c = dArea.VIN;
                            PartsRec.PartOC__c = dArea.PartOC;
                            PartsRec.Tracking_Number__c = dArea.TrackingNumber;
                            PartsRec.RID__c = dArea.RID;
                            PartsRec.Address1__c = dArea.Address1;
                            PartsRec.Address2__c = dArea.Address2;
                            PartsRec.City__c = dArea.City;
                            PartsRec.State__c = dArea.State;
                            //PartsRec.Price_Book__c=dArea.priceBook; This is commented by Rajesh Narra on 6-28-2018
                            PartsRec.Zip__c = dArea.Zip;
                            PartsRec.Create_Date__c = dArea.CreateDate;
                            PartsRec.Create_User__c = dArea.CreateUser;
                            PartsRec.Change_Date__c = dArea.ChangeDate;
                            PartsRec.Change_User__c = dArea.ChangeUser;
                            PartsRec.Replacement_Reason__c='Refer to Narrative'; // story 152510, updating replacement reason.

                            if(PartsRec.Quantity__c != null  && PartsRec.Sell_Price__c != null )
                                PartsRec.ExpenseTotal__c = (PartsRec.Quantity__c * PartsRec.Sell_Price__c); // Added by Rajesh Narra on 6-28-2018

                            if(PartsRec.Warranty_Allocation__c > 0 && PartsRec.ExpenseTotal__c > 0) //Newly Added.
                                PartsRec.ExpenseTotal__c =  (PartsRec.ExpenseTotal__c * PartsRec.Warranty_Allocation__c) / 100;//Newly Added.

                            if(dArea.PartOC == 'TOW'){
                                PartsRec.RecordTypeId = TowingRecId;
                            }else if(dArea.PartOC == 'OC'){
                                PartsRec.RecordTypeId = OtherClaimlableRecId;
                            }else if(dArea.PartOC == 'PART'){
                                PartsRec.RecordTypeId = partRecTypeId;
                                serJob.Sub_Status__c='Parts Received from ERP';
                            }
                            //PartsRec.RecordTypeId = partRecTypeId;
                            system.debug('** RecordType Id'+PartsRec.RecordTypeId);
                            lstPartsinsert.add(PartsRec);
                            system.debug('** Parts List'+lstPartsinsert);
                        }
                    }else{
                        FlagToInsert = true;
                    }
                }else{
                    JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"ERROR:'+' - Failed to update in Guidanz. Parts are sent from Work Order.","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';            
                }
                /*Rajesh Narra has added this || (lstPartsinsert==null || lstPartsinsert.isEmpty()) this criteria to delete the BMS parts, when the BMS parts gets deleted
                 in the BMS end. if(lstPartsinsert.size() > 0) this criteria is added only to insert when the BMS sends parts in the response(if BMS doesn't send any parts then Guidnaz is not inserting any data) 
                */
                if(lstPartsinsert.size() > 0 || lstPartsinsert.size()==0){
                    try{
                        if(partsList.size()>0 && FlagToWOQoute == true)
                            delete partsList;

                        if(lstPartsinsert.size() > 0 && FlagToInsert == false){
                            insert lstPartsinsert;
                            if(serJob.Sub_Status__c=='Parts Received from ERP')
                                update serJob;
                        }
                        system.debug('*** IsTPartsInsert'+lstPartsinsert);
                        String temppartnum = '';
                        for(CSS_Parts_Options__c errorParts : lstPartsinsert){
                            if(temppartnum == '')
                                temppartnum = temppartnum + errorParts.Service_partnumber__c;
                            else
                                temppartnum = temppartnum + ',' + errorParts.Service_partnumber__c;
                        }
                        JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"SUCCESS:'+temppartnum+' - updated successfully in Guidanz.","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';
                    }
                    catch(exception err){
                        String temppartnum = '';
                        for(CSS_Parts_Options__c errorParts : lstPartsinsert){
                            if(temppartnum == '')
                                temppartnum = temppartnum + errorParts.Service_partnumber__c;
                            else
                                temppartnum = temppartnum + ',' + errorParts.Service_partnumber__c;
                        }
                        JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"ERROR:'+temppartnum+' - Failed to update in Guidanz.","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';
                    }
                }
                System.debug('===>JSONResponseBody 36' + JSONResponseBody);
            }
        }
        catch(Exception e){
            System.debug('** exception'+e.getMessage());
            if(e.getTypeName() == 'System.JSONException'){
                JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"Invalid JSON Schema","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';
                insIntegrationError(JSONResponseBody, 'Invalid JSON. Notify INSITE.',jsonRequestBody);
            }
            else
            {
                JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"Internal Error Occurred","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';                
                insIntegrationError(JSONResponseBody, 'CSS Error:' + e.getMessage(),jsonRequestBody);
            }
            System.debug('In Catch block with the message '+e.getmessage()+' and in the line '+e.getLineNumber());
        }
        System.debug('===>JSONResponseBody 63' +JSONResponseBody);
        res.responseBody = Blob.valueOf(JSONResponseBody);
    }


    global static void insIntegrationError(string errDesc, string sysError, string reqMsg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + errDesc;
        errObj.Source__c = 'BMS Parts to Guidanz';
        errObj.Processed_Data__c = reqMsg;
        insert errObj;
    }
}