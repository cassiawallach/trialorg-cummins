/************************************************************
Name:  OSM_BOLT_WS_CurrenciesInbound
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is service class which will be expose as webservice when
the request to OSM will be made by BOLT system. This will take
the currency request, parse, deserialize to give response 
apex after inserting the currencies record in the system.                                   
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit Saxena            09/04/2018     INITIAL DEVELOPMENT          


*************************************************************/

@RestResource(UrlMapping = '/BoltCurrenciesInbound/*')
global with sharing class OSM_BOLT_WS_CurrenciesInbound 
{    
    
/*----------------------------------------------------------------------------------
1. CurrenciesInboundService
Description: It will take JSON request containing currencies information and will 
insert the record in OSM database. 
Input: None - Request will be provided since this is HTTPPost method
Output: Success and Error Message.
Returntype:OSM_BOLT_WS_CurrenciesInboundRes
------------------------------------------------------------------------------------*/
    
    @HttpPost
    global static OSM_BOLT_WS_CurrenciesInboundRes CurrenciesInboundService(){
    
    OSM_BOLT_WS_CurrenciesInboundRes resJSON = null;
    OSM_BOLT_WS_CurrenciesInboundReq reqJSON = null;
    OSM_Integration_Log__c log = null; //Initializing integration log object
    
            RestRequest req = RestContext.request; //Variable to store request from restContext
            RestResponse res = RestContext.response; //Variable to store response from restContext
            
            String jSONRequestBody = req.requestBody.toString().trim(); //Get the request body
            system.debug('jSONRequestBody'+jSONRequestBody);
            
            reqJSON = (OSM_BOLT_WS_CurrenciesInboundReq)JSON.deserialize(jSONRequestBody,OSM_BOLT_WS_CurrenciesInboundReq.class); //Deserialize the request body
            system.debug('reqJSON'+reqJSON);
            
            log = new OSM_Integration_Log__c();
            OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
            
            if(jSONRequestBody.length() >= 32768){
                log.Request__c = jSONRequestBody.substring(0,32768);    
            }else if (jSONRequestBody.length() < 32768){
                log.Request__c = jSONRequestBody;
                }
            
            log.Service_Name__c = label.Bolt_Currency_Inbound_Service;
            log.Source__c = label.Bolt_Source;
            log.Target__c = label.DA_Source;
            log.Logged_In_User__c = userinfo.getUserId();
            
            resJSON = new OSM_BOLT_WS_CurrenciesInboundRes();            
                            
                List<OSM_BOLT_WS_CurrenciesInboundReq.CURR_RATE_STG_ROW> clist = reqJSON.DataArea.CURR_RATE_STG_ROW; //List of currency data from Bolt
                List<OSM_BOLT_WS_CurrenciesInboundReq.CURR_RATE_STG_ROW> clistCorrect = new List<OSM_BOLT_WS_CurrenciesInboundReq.CURR_RATE_STG_ROW>(); //List of correct currency records
                
                List<Currency_Conversion__c> ccrnlist = new List<Currency_Conversion__c>(); //List of currencies record
                Integer currentVersion;
                
                //Get Current version of currency records
                List<AggregateResult> ccd = [Select max(Bolt_Version__c) from Currency_Conversion__c]; 
                        for(AggregateResult agr :ccd){
                            system.debug('agr@@@'+agr);
                            Object val = (agr.get('expr0'));
                            system.debug('val@@@'+val);
                            Decimal Ovalue = (Decimal)val; //prototype object into decimal datatype
                            if(Ovalue == null){
                                currentVersion = 1; 
                            }
                            if(Ovalue >= 1){
                                currentVersion = integer.valueOf(Ovalue)+1;                             
                            }
                            system.debug('@@2Inside'+currentVersion);                       
                    }
                
                //Check if all input parameters are passed and create currency record as received from input JSON
                system.debug('clist$$$$'+clist);
                try{
                    if(clist.size() != 0){
                    for(OSM_BOLT_WS_CurrenciesInboundReq.CURR_RATE_STG_ROW ccrec :clist){
                                                
                        if((!string.isBlank(ccrec.FROM_CURRENCY) || (ccrec.FROM_CURRENCY) != null)  && (!string.isBlank(ccrec.TO_CURRENCY) || (ccrec.TO_CURRENCY) != null) && (!string.isBlank(ccrec.FROM_CONVERSION_DATE) || (ccrec.FROM_CONVERSION_DATE) != null) && (!string.isBlank(ccrec.TO_CONVERSION_DATE) || (ccrec.TO_CONVERSION_DATE) != null) && (!string.isBlank(ccrec.CONVERSION_TYPE) || (ccrec.CONVERSION_TYPE) != null) && (!string.isBlank(ccrec.CONVERSION_RATE) || (ccrec.CONVERSION_RATE) != null)){
                            clistCorrect.add(ccrec);    
                        }
                    }
                    system.debug('clistCorrect'+clistCorrect);
                    for(OSM_BOLT_WS_CurrenciesInboundReq.CURR_RATE_STG_ROW ccrnrec :clistCorrect){                         
                            Currency_Conversion__c ccrn = new Currency_Conversion__c();
                            ccrn.Bolt_From_Currency__c = ccrnrec.FROM_CURRENCY;
                            ccrn.Bolt_To_Currency__c = ccrnrec.TO_CURRENCY;
                            
                            //Call date conversion method
                            ccrn.Bolt_From_Conversion_date__c = setStringToDateFormat(ccrnrec.FROM_CONVERSION_DATE);
                            ccrn.Bolt_To_Conversion_date__c = setStringToDateFormat(ccrnrec.TO_CONVERSION_DATE);
                            
                            ccrn.Bolt_Conversion_Type__c = ccrnrec.CONVERSION_TYPE;                         
                            ccrn.Bolt_Conversion_Rate__c = Decimal.valueOf(ccrnrec.CONVERSION_RATE);
                            ccrn.Bolt_Version__c = currentVersion;
                     
                            ccrnlist.add(ccrn); //Add to the list
                            }   
                        }
                }catch(Exception e){
                    system.debug('Currency List is empty.Error at line number:'+e.getLineNumber() + 'Error Message:'+e.getMessage());   
                }        
                
                system.debug('ccrnlist'+ccrnlist);
                system.debug('CSize'+ccrnlist.size());
                
                if(ccrnlist.size() >=1){
                    Database.SaveResult[] srList = Database.insert(ccrnlist,false);   //Insert the record
                    
                    //If update is successfull, update status and ReturnCodeDescription of OSM_BOLT_WS_CurrenciesInboundRes response class 
                    for(Database.SaveResult dsr :srList){
                        if(dsr.isSuccess()){

                            //System.debug('Successfully inserted record. Record ID: ' + dsr.getId());
                            String jBody = JSON.serialize(dsr);
                            system.debug('jBody'+jBody);
                                resJSON = (OSM_BOLT_WS_CurrenciesInboundRes)JSON.deserialize(jBody,OSM_BOLT_WS_CurrenciesInboundRes.class);
                                resJSON.Status = 'Success';
                                resJSON.ReturnCodeDescription = 'Currencies Information received successfully';
                                //Populate log for success
                                log.Response__c  = label.Bolt_Currency_Success_Msg;
                                log.Status__c = label.DA_Log_Status_Success;
                                log.Error_Description__c = label.DA_Not_Applicable;
                                system.debug('resJSON'+resJSON); 
                                }
                                else{
                                    //If update fails, get error details into OSM_BOLT_WS_CurrenciesInboundRes response class
                                    for(DataBase.Error err :dsr.getErrors()){
                                        //System.debug('The following error has occurred.');                   
                                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());            
                                        //System.debug('Fields that are affected by this error: ' + err.getFields()); 
                                        String jBody = JSON.serialize(err);
                                        system.debug('jBody'+jBody);
                                        resJSON = (OSM_BOLT_WS_CurrenciesInboundRes)JSON.deserialize(jBody,OSM_BOLT_WS_CurrenciesInboundRes.class);
                                        resJSON.Status = 'Error';
                                        resJSON.ReturnCodeDescription = err.getStatusCode() + ': ' + err.getMessage();
                                        //Populate log for failure
                                        log.Response__c  = err.getMessage();
                                        log.Status__c = label.DA_Log_Status_Failure;
                                        log.Error_Description__c = string.valueOf(err.getStatusCode());
                                        system.debug('resJSON'+resJSON);                                       
                                    }
                                }   
                            }
                        }else if(ccrnlist.size() ==0){
                            resJSON = new OSM_BOLT_WS_CurrenciesInboundRes();
                            resJSON.Status = 'Error';
                            resJSON.ReturnCodeDescription = 'Either Date format is wrong or required parameters are missing. Review Input request.';
                            //Populate log for exception
                            log.Response__c  = label.Bolt_Currency_Failure_Msg;
                            log.Status__c = label.DA_Log_Status_Failure;
                            log.Error_Description__c = label.Bolt_Currency_Failure_Msg;
                            system.debug('resJSON'+resJSON);      
                        }
                    OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record    
                    return resJSON;
        }
        
        //Get Date from INput JSON and convert into logged in user format
            global static Date setStringToDateFormat(String myDate) {
                Date FinalDt = null;
                String[] myDateOnly = myDate.split(' ');
                String[] strDate = myDateOnly[0].split('-');
          
                if((strDate[0] != null) && (strDate[1] != null) && (strDate[2] != null)){
                    Integer myIntDate = integer.valueOf(strDate[0]);
                    Integer myIntYear = integer.valueOf(strDate[2]);                                
                    Integer Intmonth;
                    String monthVal = strDate[1];
                        if(monthVal != null){
                        if(monthVal == 'JAN'){Intmonth = 1;}    
                        if(monthVal == 'FEB'){Intmonth = 2;}
                        if(monthVal == 'MAR'){Intmonth = 3;}
                        if(monthVal == 'APR'){Intmonth = 4;}
                        if(monthVal == 'MAY'){Intmonth = 5;}
                        if(monthVal == 'JUN'){Intmonth = 6;}
                        if(monthVal == 'JUL'){Intmonth = 7;}
                        if(monthVal == 'AUG'){Intmonth = 8;}
                        if(monthVal == 'SEP'){Intmonth = 9;}
                        if(monthVal == 'OCT'){Intmonth = 10;}
                        if(monthVal == 'NOV'){Intmonth = 11;}
                        if(monthVal == 'DEC'){Intmonth = 12;}   
                        }                  
                    Date d1 = Date.newInstance(myIntYear,Intmonth,myIntDate);
                    FinalDt = date.valueof(d1); 
                    system.debug('$$$$d'+FinalDt);
                }
                return FinalDt; 
            }   
}