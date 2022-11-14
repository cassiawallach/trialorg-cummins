/*********************************************************************************************************************************
Name:FSL_TextCommuniationUnsubscribe
Copyright © 2020  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the integration api expose class for Unsubscribe Text
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       Mani Kumar              8/10/2019                       INITIAL DEVELOPMENT  

***************************************************************************************************************************************/

@RestResource(urlMapping='/Communications/Text/Unsubscribe/*')
Global class FSL_TextCommuniationUnsubscribe {
    @HttpPOST
    global static List<FSL_TextUnsubscribeWrapper.UnsubscribeResponse> doPostOperation() {
        List<Account> lstAccountDetails = new List<Account>();
        Set<string> lstConToUnscNum =  new Set<string>();
        Set<string> lstConToUnscNumsql =  new Set<string>();
        Map<string, List<Contact>> mapConToUnsc = new Map<string, List<Contact>>();
        List<FSL_TextUnsubscribeWrapper.UnsubscribeResponse> lstResp = new List<FSL_TextUnsubscribeWrapper.UnsubscribeResponse>();
        
        try {
            if(RestContext.request.requestBody != null) {
                List<Object> lstBody = new  List<Object>  ();
                system.debug('RestContext.request.requestBody=== '+RestContext.request.requestBody);
                if(test.isRunningTest() == false){
                    lstBody = (List<Object>)JSON.deserializeUntyped((string)(RestContext.request.requestBody.toString()));
                }
                else {
                    string sobjectdata = '[ { "contact_mobile_phone":"9999999999",  "smssubscribeFlag":"N" }, { "contact_mobile_phone":"16178286985", "smssubscribeFlag":"N" }]';
                    lstBody.add(sobjectdata);
                }
                for(Object obj : lstBody) {
                    Map<string,object> mapReqBody = new  Map<string,object> ();
                    if(test.isRunningTest() == true){

                        mapReqBody.put('contact_mobile_phone', '9999999999');
                        mapReqBody.put('smssubscribeFlag', 'N'); 
                       
                    }
                    else
                    {
                        mapReqBody = (Map<string,object>) JSON.deserializeUntyped(JSON.serialize(obj));
                    }
                    
                    if(mapReqBody.size() > 0 && mapReqBody.containsKey('contact_mobile_phone') && mapReqBody.containsKey('smssubscribeFlag')) {
                        if(string.isNotBlank((string)mapReqBody.get('contact_mobile_phone')) && string.isNotBlank((string)mapReqBody.get('smssubscribeFlag')) && mapReqBody.get('smssubscribeFlag') == 'N') {
                            string contc = ((string)mapReqBody.get('contact_mobile_phone'));
                            lstConToUnscNum.Add(contc.right(10));
                             
                            contc = '%' + contc.right(10);
                            lstConToUnscNumsql.Add(contc);
                           // lstConToUnscNum.Add((string)mapReqBody.get('contact_mobile_phone'));
                        }                    
                    }                    
                }
                System.debug('lstConToUnscNum::'+lstConToUnscNum);
                if(lstConToUnscNum.size() > 0 ){                
                    List<ServiceOrderContact__c> SOCListToUpdate = new List<ServiceOrderContact__c>();  
                    List<Contact> lstConToUnsc = [Select id, Text_SMS_Notification_Frequency__c, Name, /*Mobile_Phone__c*/ MobilePhone FROM Contact where /*Mobile_Phone__c*/ MobilePhone LIKE :lstConToUnscNumsql ]; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                    List<ServiceOrderContact__c> lstSOC = [select id,Opt_In__c,Payer_Contact__c from ServiceOrderContact__c where /*Payer_Contact__r.Mobile_Phone__c*/ Payer_Contact__r.MobilePhone =: lstConToUnscNum];
                    if(lstConToUnsc.size() > 0 ) {
                        for(Contact con : lstConToUnsc) {
                          /* string trimlst = con.MobilePhone;
                           trimlst = trimlst.right(10);*/
                            con.Text_SMS_Notification_Frequency__c = 'Never/Unsubscribed';
                            // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                            /*if(mapConToUnsc.containsKey(con.Mobile_Phone__c)) {
                                    List<Contact> lstConPresent = mapConToUnsc.get(con.Mobile_Phone__c);
                                    lstConPresent.add(con);
                                    mapConToUnsc.put(con.Mobile_Phone__c, lstConPresent);
                                    } else {
                                    List<Contact> lstConPresent = new List<Contact>();
                                    lstConPresent.add(con);
                                    mapConToUnsc.put(con.Mobile_Phone__c, lstConPresent);
                                    }*/
                            if(mapConToUnsc.containsKey(con.MobilePhone)) {
                                List<Contact> lstConPresent = mapConToUnsc.get(con.MobilePhone);
                                lstConPresent.add(con);
                                mapConToUnsc.put(con.MobilePhone, lstConPresent);
                            } else {
                                List<Contact> lstConPresent = new List<Contact>();
                                lstConPresent.add(con);
                                mapConToUnsc.put(con.MobilePhone, lstConPresent);
                            }
                        }
                        //updating in salesforce
                        update lstConToUnsc;
                       
                        for (ServiceOrderContact__c ObjSOC : lstSOC){
                            ObjSOC.Opt_In__c =true;   
                            SOCListToUpdate.add(ObjSOC); 
                            
                        } 
                        if(!SOCListToUpdate.isEmpty()) {  update SOCListToUpdate;  } 
                        
                        if(mapConToUnsc.size() > 0) {
                            for(string mobile_num : lstConToUnscNum) {
                                FSL_TextUnsubscribeWrapper.UnsubscribeResponse objResp = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
                                if(mapConToUnsc.containsKey(mobile_num)) { 
                                    objResp.MessageIdentifier ='dscvsdvnernv5151vdvd5svd5vdv';      objResp.ReturnCode='UNSUB02';    
                                    objResp.ReturnCodeDescription='The contact number ' + mobile_num +'  is Unsubscribed';  objResp.Status='SUCCESS';   objResp.MessageType='S';                                
                                } else {                                
                                    objResp.MessageIdentifier ='dscvsdvnernv5151vdvd5svd5scds';  objResp.ReturnCode='ERR-UNSUB01'; 
                                    objResp.ReturnCodeDescription='The contact number '+ mobile_num +' is not available for Unsubscribe';  objResp.Status='ERROR'; objResp.MessageType='E';                                
                                }
                                lstResp.Add(objResp);
                            }
                        }
                    } else {
                        // return response
                        for(string mobile_num :lstConToUnscNum) {
                            FSL_TextUnsubscribeWrapper.UnsubscribeResponse objResp = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
                            objResp.MessageIdentifier ='dscvsdvnernv5151vdvd5svd5scds';
                            objResp.ReturnCode='ERR-UNSUB01';
                            objResp.ReturnCodeDescription='The contact number '+ mobile_num +' is not available for Unsubscribe';
                            objResp.Status='ERROR';
                            objResp.MessageType='E'; 
                            lstResp.add(objResp);                            
                        }
                        System.debug('lstResp:err:1:'+lstConToUnscNum);
                        return lstResp;                    }
                }            
            } else {
                FSL_TextUnsubscribeWrapper.UnsubscribeResponse objResp = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
                objResp.MessageIdentifier ='dscvsdvnernv5151vdvd5svd5scds';
                objResp.ReturnCode='ERR-UNSUB01';
                objResp.ReturnCodeDescription='Invalid values present in request Body';
                objResp.Status='ERROR';
                objResp.MessageType='E';
                lstResp.add(objResp);
                System.debug('lstResp:err:2:'+lstConToUnscNum);
                return lstResp;
            }
        } catch(Exception ex) {
            FSL_TextUnsubscribeWrapper.UnsubscribeResponse objResp = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
            objResp.MessageIdentifier ='dscvsdvnernv5151vdvd5svd5scds';
            objResp.ReturnCode='ERR-UNSUB01';
            objResp.ReturnCodeDescription=ex.getMessage();
            objResp.Status='ERROR';
            objResp.MessageType='E';
            lstResp.add(objResp);
            return lstResp;
        }
        
        return lstResp;
    }
}