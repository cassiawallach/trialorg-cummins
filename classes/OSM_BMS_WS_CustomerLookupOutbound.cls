/************************************************************
Name:  OSM_BMS_WS_CustomerLookupOutbound
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the business layer of BMS Customer Lookup Outbound Service

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            23/10/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_BMS_WS_CustomerLookupOutbound{

/*----------------------------------------------------------------------------------
1. callBMSService
Description: This is the service method which will be called by the business layer and return 
One BMS API response 
params
 OSM_BMS_WS_GeneralizedInputWrapper - object of OSM_BMS_WS_GeneralizedInputWrapper
Return: OSM_BMS_WS_GeneralizedOutputWrapper

------------------------------------------------------------------------------------*/
public static OSM_BMS_WS_GeneralizedOutputWrapper callBMSService(OSM_BMS_WS_GeneralizedInputWrapper inputWrapperObj){
  boolean isException = false;
  OSM_BMS_WS_GeneralizedOutputWrapper outputWrapperObj=new OSM_BMS_WS_GeneralizedOutputWrapper();
  
  String jsonStr = '';
  OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
  OSM_Integration_Log__c log = new OSM_Integration_Log__c();
  Integer retryAPICallForErr=0;
  Integer retryAPICallForExp=0;
  
  try{
      //preparing OSM_BMS_WS_CustomerOuboundReq object
       OSM_BMS_WS_CustomerOuboundReq customerOuboundReq=OSM_BMS_WS_CustomerOutbound_Helper.populateRequestObjectData(inputWrapperObj);
       jsonStr = JSON.serialize(customerOuboundReq);
       System.debug('JSON String>>>>>'+jsonStr);
       
       //Preaparing request object for final callout layer
       OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
       //requestWrap.serviceName = 'BMSCustomerLookupService';
       requestWrap.serviceName = Label.BMS_CustomerGetAPI;
       log.Account__c = inputWrapperObj.DataArea.AcctId;//'0011F00000bcCHS';//Added by Dhiraj
       log.Service_Name__c = System.Label.OSM_BMS_Service_Name;
       //log.Cart__c = objVertexGeneralWrapper.recordId;
       requestWrap.jsonReqBody = jsonStr;//Commenting to check rtery logic
       requestWrap.AuthEnv  = 'BMSCustomerLookupAuth';
       requestWrap.AccesTokenRequired = true;
       log.Target__c = System.Label.OSM_BMS_Target_ID;
       log.Request__c = jsonStr;
       log.Source__c = 'OSM';
       log.Logged_In_User__c = userinfo.getuserid();
       log.Retrial_Count__c=retryAPICallForErr;
       
       // Added for MAR-606
       // Passing parameter for GET request
       OSM_BMS_WS_CustomerOuboundReq.DataArea daObj = customerOuboundReq.DataArea;
       OSM_BMS_WS_CustomerOuboundReq.Header headerObj = customerOuboundReq.Header;
       OSM_BMS_WS_CustomerOuboundReq.Target targetObj = headerObj.Target;
       OSM_BMS_WS_CustomerOuboundReq.Sender senderObj = headerObj.Sender;
       OSM_BMS_WS_CustomerOuboundReq.Location locObj = headerObj.Location;
       
       requestWrap.CustomerName = daObj.CustomerName;
       requestWrap.CustomerCode = daObj.CustomerCode;
       requestWrap.DealerCode = daObj.DealerCode;
       requestWrap.TargetID = targetObj.TargetID;
       requestWrap.SenderID = senderObj.SenderID;
       requestWrap.LocationID = locObj.LocationID;

       //Making call to callout Layer
       //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);
       resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
       log.API_URL__c =resAuthWrapper.APIURL;
       //resAuthWrapper=OSM_BMS_WS_CustomerLookupOutbound.callOutService(requestWrap);
       System.debug('Response output flag>>>>>>>'+resAuthWrapper.exceptionFlag);
       
       //Handling service response values
       log.Request_Time__c =resAuthWrapper.requestTime;
       log.Response_Time__c =resAuthWrapper.responseTime;
       
      //===Retry logic Starting for Exception ====
       String apiStatusExp=String.valueOf(resAuthWrapper.exceptionFlag);
       Integer callCount=Integer.valueOf(system.Label.IntegrationRetryCount);
       While(retryAPICallForExp<callCount && apiStatusExp=='true')
       {
         retryAPICallForExp++;
         apiStatusExp=OSM_BMS_WS_CustomerLookupOutbound.retryCallOutService(requestWrap);
         system.debug('in retry loop of exception>>>'+retryAPICallForExp);
                   
       }
       if(apiStatusExp!='true') {apiStatusExp = 'false';}
       //===Retry logic End for Exception====
       
       if(apiStatusExp == 'false')
       {
		   log.Account__c = inputWrapperObj.DataArea.AcctId;//'0011F00000bcCHS';//Added by Dhiraj
           log.Response__c = resAuthWrapper.Response;
           log.Status__c = 'Success';
           if(Test.isRunningTest())
           {
               //resAuthWrapper.Response='Response Body: '+'{"Header":{"Target":{"TargetID":"OMS"},"Status":"Success","Sender":{"ServiceName":"BMSCustomerLookupService","SenderID":"Mrktplc"},"ReturnCodeDescription":"Success","Location":{"LocationID":"6718021"}},"DataArea":[{"State":"test","RequirePO":"12345","QuoteCustomer":"test","Postalcode2":"12345","Postalcode1":"12345","PhoneNumber":"12345","PaymentType":"cash","LocationAddressline3":"test","LocationAddressline2":"test","LocationAddressline1":"test","CustomerName":"test","CustomerCode":"12345","CreditLimit":"12345","Country":"test","City":"test","AvailableCredit":12345,"AreaCode":"12345","AmountDue":12345}]}';
               resAuthWrapper.Response='{"Header":{"Target":{"TargetID":"OMS"},"Status":"Success","Sender":{"ServiceName":"BMSCustomerLookupService","SenderID":"Mrktplc"},"ReturnCodeDescription":"Success","Location":{"LocationID":"6718021"}},"DataArea":[{"State":"test","RequirePO":"12345","QuoteCustomer":"test","Postalcode2":"12345","Postalcode1":"12345","PhoneNumber":"12345","PaymentType":"cash","LocationAddressline3":"test","LocationAddressline2":"test","LocationAddressline1":"test","CustomerName":"test","CustomerCode":"12345","CreditLimit":"12345","Country":"test","City":"test","AvailableCredit":12345,"AreaCode":"12345","AmountDue":12345}]}';
               //outputWrapperObj.errorFlag=false;
           }
           //OSM_BMS_WS_CustomerOuboundRes wrprRes = OSM_BMS_WS_CustomerOuboundRes.parse(resAuthWrapper.Response.substringAfterLast('Response Body: '));
           OSM_BMS_WS_CustomerOuboundRes wrprRes = OSM_BMS_WS_CustomerOuboundRes.parse(resAuthWrapper.Response);
           System.debug('outout response wrapper>>>>>>'+wrprRes);
           
           //===Retry logic Starting for error====
           String apiStatus=wrprRes.Header.Status;
           Integer count=Integer.valueOf(system.Label.IntegrationRetryCount);
           While(retryAPICallForErr<count && apiStatus=='ERROR')
           {
               retryAPICallForErr++;
               apiStatus=OSM_BMS_WS_CustomerLookupOutbound.retryCallOutService(requestWrap);
               system.debug('in retry loop of error>>>'+retryAPICallForErr);
               
           }
           //===Retry logic End for error====
           if(apiStatus != null && apiStatus == 'ERROR')
           {
                    
                    outputWrapperObj.errorMsg = wrprRes.Header.ReturnCodeDescription;
                    outputWrapperObj.errorFlag = true;
					log.Account__c = inputWrapperObj.DataArea.AcctId;//'0011F00000bcCHS';//Added by Dhiraj
                    log.Status__c = 'Failure'; 
                    log.Error_Description__c = wrprRes.Header.ReturnCodeDescription;
                    log.Retrial_Count__c=retryAPICallForErr;
           }
           else
           {
              outputWrapperObj.errorFlag = false;
              outputWrapperObj.DataArea=new List<OSM_BMS_WS_GeneralizedOutputWrapper.DataArea>();
              if(wrprRes.DataArea!=null)
              {            
                  for(OSM_BMS_WS_CustomerOuboundRes.DataArea dataAreaList:wrprRes.DataArea)
                  {
                      System.debug('enter into for loop>>>>>'+dataAreaList);
                      OSM_BMS_WS_GeneralizedOutputWrapper.DataArea dataAreaObj=new OSM_BMS_WS_GeneralizedOutputWrapper.DataArea();
                      dataAreaObj.CustomerCode=dataAreaList.CustomerCode;
                      dataAreaObj.LocationAddressline3=dataAreaList.LocationAddressline3;
                      dataAreaObj.PhoneNumber=dataAreaList.PhoneNumber;
                      dataAreaObj.Country=dataAreaList.Country;
                      dataAreaObj.CustomerName=dataAreaList.CustomerName;
                      dataAreaObj.City=dataAreaList.City;
                      dataAreaObj.LocationAddressline2=dataAreaList.LocationAddressline2;
                      dataAreaObj.LocationAddressline1=dataAreaList.LocationAddressline1;
                      dataAreaObj.AreaCode=dataAreaList.AreaCode;
                      dataAreaObj.PaymentType=dataAreaList.PaymentType;
                      dataAreaObj.State=dataAreaList.State;
                      dataAreaObj.Postalcode2=dataAreaList.Postalcode2;
                      dataAreaObj.Postalcode1=dataAreaList.Postalcode1;
                      if(dataAreaList.CreditLimit!=Null && dataAreaList.CreditLimit!=''){
                          dataAreaObj.CreditLimit=Decimal.valueOf(dataAreaList.CreditLimit);
                      }
                      else{
                          dataAreaObj.CreditLimit=0;
                      }
                      dataAreaObj.QuoteCustomer=dataAreaList.QuoteCustomer;
                      dataAreaObj.RequirePO=dataAreaList.RequirePO;
                      dataAreaObj.AmountDue=dataAreaList.AmountDue;
                      dataAreaObj.AvailableCredit=dataAreaList.AvailableCredit;
                      
                      outputWrapperObj.DataArea.add(dataAreaObj);
                  }
             } 
             else
             {
                 outputWrapperObj.errorFlag = true;
				  log.Account__c = inputWrapperObj.DataArea.AcctId;//'0011F00000bcCHS';//Added by Dhiraj
                 log.Status__c = 'Failure';
                 
             }  
                             
           }
       
       }
       else
       {
                log.Account__c = inputWrapperObj.DataArea.AcctId;//'0011F00000bcCHS';//Added by Dhiraj
                log.Response__c = resAuthWrapper.Response;
                outputWrapperObj.errorFlag = true;
                outputWrapperObj.errorMsg = resAuthWrapper.errorMessage;
                log.Status__c = 'Failure'; 
                log.Error_Description__c = resAuthWrapper.errorMessage;
                log.Retrial_Count__c=retryAPICallForExp;
                System.debug('in else block of exception flag>>>>');
                
       }


   }
   Catch(Exception ex)
   {
            System.debug('in catch block>>>>');
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c = msg ;
            log.Response__c = resAuthWrapper.Response;
            outputWrapperObj.errorFlag = true;
            outputWrapperObj.errorMsg = msg;
            log.Status__c = 'Failure';  
 log.Account__c = inputWrapperObj.DataArea.AcctId;//'0011F00000bcCHS';//Added by Dhiraj			
   }
  outputWrapperObj.log=log;
  return outputWrapperObj;
}
    
    //calling service class callout method
    public static String retryCallOutService(OSM_WS_IP_CSWrapper reqWrapper)
    {
        
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(reqWrapper);
        resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(reqWrapper);
        string callStatus;
        if(resAuthWrapper.exceptionFlag == false)
        {
             //OSM_BMS_WS_CustomerOuboundRes wrprRes = OSM_BMS_WS_CustomerOuboundRes.parse(resAuthWrapper.Response.substringAfterLast('Response Body: '));
             OSM_BMS_WS_CustomerOuboundRes wrprRes = OSM_BMS_WS_CustomerOuboundRes.parse(resAuthWrapper.Response);
             callStatus=wrprRes.Header.Status;
        }
        else
        {
            callStatus='true';
        }
        
        return callStatus; 
    }
}