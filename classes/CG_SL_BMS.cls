/**********************************************************************
Name:CG_SL_BMS
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is the Service Layer for BMS End points.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Krishnamoorthi      12/20/2017      INITIAL DEVELOPMENT    
1.1 - Surender M          03/06/2018      Added Code for Customer Credit Messages & Private SRTs functionality
1.2 - Kalpana V  20/04/2018  Added Method to send Job Details, to be deleted,to BMS System
***********************************************************************/
public class CG_SL_BMS {

    //Fetching BMS Customer Details.
    public static CG_OP_OAGWrapper fetchBMSCustomerDetails(String custName,String custCode,String location) {
        CG_OP_OAGWrapper returnWrapper;
        string endPointURL;
        String bmsUsername;
        String bmsPassword;
        try { 
            //Prepare Request Wrapper
           system.debug('karthikBMSsend');
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //karthik Added mule migration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('BMSCustomer'); 
             system.debug('karthikBMSsendconnnnnnn>>'+conDetails);
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;
            endPointURL = conDetails.End_Point__c+'?sender=CSS&target=BMS&locationId='+location+'&customerName='+custName+'&customerCode='+custCode+'&dealerCode=';
            string endpoint = endPointURL.replace(' ','%20');
            reqWrapper.endPoint = endpoint;
            //String requeststring = '{"Header": {"Sender": { "ServiceName": "GetCustomer", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "CustomerName": "'+custName+'", "CustomerCode": "'+custCode+'" }}';
           // reqWrapper.jsonReqBody = requeststring;
            reqWrapper.methodType = 'GET';
            reqWrapper.serviceName='BMSCustomer';
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            system.debug('karthik>>>returnWrapper>>'+returnWrapper);
             if(Test.isRunningTest() && custName == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
        } catch(exception e){
            system.debug('Entered into catch block of BMSWebservice method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
        }
        return returnWrapper;
    }

    //Create BMS Account.
    public static CG_OP_OAGWrapper createBMSAccount(String custName, String custAddr1, String custAddr2, String custAddr3, String AreaCode, String Phone, String city, String state, String postCode, String postalcodesuffix, String cusContact, String countryCd, String lang, String application, string location) {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();

        try { 
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            String distrCode = '';
            String brnchCode = '';
            String[] locArray;
            String bmsUsername;
            String bmsPassword;
            String endPointURL;
            if(location != null && location != '')
                locArray = location.split('-');
            if(locArray != null && locArray.size()>0) {
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }      
             CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
               conDetails = CSS_getConnnectionDetails.getConnection('BMSCustomer');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;   
                endPointURL = conDetails.End_Point__c;
            string requeststring = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"'+location+'"}},"DataArea":{"CustomerName":"'+custName+'","CustomerAddressline1":"'+custAddr1+'","CustomerAddressline2":"'+custAddr2+'","CustomerAddressline3":"'+custAddr3+'","AreaCode":"'+AreaCode+'","Phone":"'+Phone+'","City":"'+city+'","State":"'+state+'","PostalCode":"'+postCode+'","PostalCodeSuffix":"'+postalcodesuffix+'","CustomerContact":"'+cusContact+'","BranchCode":"'+brnchCode+'","CountryCode":"'+countryCd+'","Language":"'+lang+'","Application":"'+application+'"}}';
            System.debug('requeststring ******* '+ requeststring);
            reqWrapper.jsonReqBody = requeststring;
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.serviceName = 'BMSCustomer';
             //karthik Added mule migration
             returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            //returnWrapper = CG_WS_OAG.createBMSAccount(reqWrapper);
        } catch(exception e){
            system.debug('Entered into catch block of createBMSCustomerDetails method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
        }
        return returnWrapper;
    }

    //Fetching BMS PrivateSRTs
    public static CG_OP_OAGWrapper getBMSPrivateSRTs(String distributorCode, String branchCode, String engineFamily, String locationId) {
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
        try { 
            //Prepare Request Wrapper
            reqWrapper = new CG_IP_OAGWrapper();
            //String serviceName = 'GetBMSPrivateSRTs';
            //String senderId = 'CSS';
            //String targetId = 'BMS';

            //CG_IP_BMSPrivateSRTsReqJSON reqJson;
            /*reqWrapper.jsonReqBody = '{"Header":{"Sender":{"ServiceName":"GetBMSPrivateSRTs","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"'+locationId+'"}},"DataArea":{"DistributorCode":"'+distributorCode+'","BranchCode":"'+branchCode+'","EngineFamily":"'+engineFamily+'"}}';
            System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);*/
            reqWrapper.serviceName = 'BMSPrivateSRTs';
            reqWrapper.methodType=CSS_getConnnectionDetails.getConnection('BMSPrivateSRTs').method_type__c;
            reqWrapper.endpoint=CSS_getConnnectionDetails.getConnection('BMSPrivateSRTs').end_point__c+'?sender=CSS&target=BMS&locationId='+locationId+'&distributorCode='+distributorCode+'&branchCode='+branchCode+'&engineFamily='+engineFamily+'';
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            resWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            System.debug('resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper.response);
        } catch(exception e){
            system.debug('Entered into catch block of getBMSCustomerCreditMsgs method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            resWrapper.exceptionFlag=true;
            resWrapper.errorMessage = e.getMessage();
        }
        return resWrapper;
    }

    //Fetching BMS Customer Credit Messaages
    public static CG_OP_OAGWrapper getBMSCustomerCreditMsgs(String customerNo, String location) {
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
        try { 
            //Prepare Request Wrapper
            reqWrapper = new CG_IP_OAGWrapper();
            String serviceName = 'GetCustomerCreditMessage';
            //String senderId = 'CSS';
           // String targetId = 'BMS';
            //CG_IP_CustCreditMsgReqJSON reqJson = prepareReqWprForCustCreditMsgs(customerNo, location, serviceName, senderId, targetId);
            //reqWrapper.jsonReqBody = JSON.serialize(reqJson);
            //System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);
            reqWrapper.serviceName = serviceName;
            reqWrapper.endpoint=CSS_getConnnectionDetails.getConnection('GetCustomerCreditMessage').end_point__c+'?sender=CSS&target=MOVEX&locationId='+location+'&customerNumber='+customerNo+'';
            reqWrapper.methodType=CSS_getConnnectionDetails.getConnection('GetCustomerCreditMessage').Method_Type__c;
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            //if(reqJson != null)
                resWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper); // MuleAuth
            System.debug('resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper.response);
        } catch(exception e){
            system.debug('Entered into catch block of getBMSCustomerCreditMsgs method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            resWrapper.exceptionFlag=true;
            resWrapper.errorMessage = e.getMessage();
        }
        return resWrapper;
    }


    /**
     * This is used for Preparing Request JSON For Customer Credit Msgs
     * 
     */
    public static CG_IP_CustCreditMsgReqJSON prepareReqWprForCustCreditMsgs(String customerNo, String location, String serviceName, String senderId, String targetId){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareReqWprForCustCreditMsgs method of CG_SL_BMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_IP_CustCreditMsgReqJSON reqJSONWrapper = null;
        CG_IP_CustCreditMsgReqJSON.Header headerObj = null;
        CG_IP_CustCreditMsgReqJSON.Sender senderObj = null;
        CG_IP_CustCreditMsgReqJSON.Target targetObj = null;
        CG_IP_CustCreditMsgReqJSON.Location locationObj = null;
        CG_IP_CustCreditMsgReqJSON.DataArea dataAreaObj = null;
        try{
            //Prepare Request JSON
            reqJSONWrapper = new CG_IP_CustCreditMsgReqJSON();
            headerObj = new CG_IP_CustCreditMsgReqJSON.Header();
            senderObj = new CG_IP_CustCreditMsgReqJSON.Sender();
            targetObj = new CG_IP_CustCreditMsgReqJSON.Target();
            locationObj = new CG_IP_CustCreditMsgReqJSON.Location();
            dataAreaObj = new CG_IP_CustCreditMsgReqJSON.DataArea();

            senderObj.SenderID = senderId;
            senderObj.ServiceName = serviceName;
            targetObj.TargetID = targetId;
            locationObj.LocationID = location;
            dataAreaObj.CustomerNumber = customerNo;

            headerObj.Sender =  senderObj;
            headerObj.Target =  targetObj;
            headerObj.Location =  locationObj;
            reqJSONWrapper.Header = headerObj;
            reqJSONWrapper.DataArea = dataAreaObj;

        }catch(Exception ex){
            System.debug('in catch of prepareReqWprForCustCreditMsgs of CG_SL_BMS >>>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            headerObj=null;senderObj=null;
        }
        return reqJSONWrapper;
    }

    //Get Misc Charge LOV's Details.
    /*public static CG_OP_OAGWrapper getMISCChargeLOVs_Existing(String HQCode,String BranchCode,String location) {
        CG_OP_OAGWrapper returnWrapper;
        CG_MiscChargeLOVResWrapper respWrapper;
        CG_MiscChargeLOVResWrapper respOCWrapper = new CG_MiscChargeLOVResWrapper();
        CG_MiscChargeLOVResWrapper respTTMLWrapper = new CG_MiscChargeLOVResWrapper();
        List<CG_MiscChargeLOVResWrapper.DataArea> lstdtOCObj = new List<CG_MiscChargeLOVResWrapper.DataArea>();
        List<CG_MiscChargeLOVResWrapper.DataArea> lstdtTTMLObj = new List<CG_MiscChargeLOVResWrapper.DataArea>();
        CG_MiscChargeLOVResWrapper.DataArea dtTTMLObj;
        CG_MiscChargeLOVResWrapper.DataArea dtOCObj;

        try { 

            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            String requeststring = '{"Header": {"Sender": { "ServiceName": "getMISCChargeLOVs", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "HQCode": "'+HQCode+'", "BranchCode": "'+BranchCode+'" }}';
            reqWrapper.jsonReqBody = requeststring;
            reqWrapper.serviceName = 'getMISCChargeLOVs';
            returnWrapper = CG_WS_OAG.getMISCChargeLOVs(reqWrapper);
            system.debug('returnWrapper--'+returnWrapper);
            system.debug('returnWrapper response--'+returnWrapper.response.getbody());

            respWrapper = (CG_MiscChargeLOVResWrapper)JSON.deserializeStrict(returnWrapper.response.getBody(), CG_MiscChargeLOVResWrapper.class);
            system.debug('respWrapper--'+respWrapper);



            for(CG_MiscChargeLOVResWrapper.DataArea dt : respWrapper.DataArea){
                if(dt.ChargeCategory != 'TRVL'){
                    dtOCObj = new CG_MiscChargeLOVResWrapper.DataArea();
                    dtOCObj.ChargeCategory = dt.ChargeCategory;
                    dtOCObj.MiscName = dt.MiscName;
                    dtOCObj.MiscDescription = dt.MiscDescription;
                    dtOCObj.Multiplier = dt.Multiplier;
                    dtOCObj.FlatAmount = dt.FlatAmount;
                    dtOCObj.Maximum = dt.Maximum;
                    dtOCObj.AutoCharage = dt.AutoCharage;
                    dtOCObj.CreditType = dt.CreditType;
                    dtOCObj.NewWarrantyClass = dt.NewWarrantyClass;
                    lstdtOCObj.add(dtOCObj);
                }
                else{
                    dtTTMLObj = new CG_MiscChargeLOVResWrapper.DataArea();
                    dtTTMLObj.ChargeCategory = dt.ChargeCategory;
                    dtTTMLObj.MiscName = dt.MiscName;
                    dtTTMLObj.MiscDescription = dt.MiscDescription;
                    dtTTMLObj.Multiplier = dt.Multiplier;
                    dtTTMLObj.FlatAmount = dt.FlatAmount;
                    dtTTMLObj.Maximum = dt.Maximum;
                    dtTTMLObj.AutoCharage = dt.AutoCharage;
                    dtTTMLObj.CreditType = dt.CreditType;
                    dtTTMLObj.NewWarrantyClass = dt.NewWarrantyClass;
                    lstdtTTMLObj.add(dtTTMLObj);
                }
            }

            respOCWrapper.dataArea = lstdtOCObj;
            respTTMLWrapper.dataArea = lstdtTTMLObj;

            CSS_JobEventTemporary__c jobEventTempOC = new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c jobEventTempTTML = new CSS_JobEventTemporary__c();
			list<CSS_JobEventTemporary__c> lstJobEveTemp = new list<CSS_JobEventTemporary__c>();
            lstJobEveTemp = [select id,key__c from CSS_JobEventTemporary__c where Key__c = 'OtherClaimables'];
            
            list<CSS_JobEventTemporary__c> lstJobEveTTML = new list<CSS_JobEventTemporary__c>();
            lstJobEveTTML = [select id,key__c from CSS_JobEventTemporary__c where Key__c = 'TTML'];
            
            if(lstJobEveTemp != null && lstJobEveTemp.size()>0){
                jobEventTempOC.Id = lstJobEveTemp[0].Id;
            }
            jobEventTempOC.Key__c = 'OtherClaimables';
            jobEventTempOC.Reason__c = JSON.serialize(respOCWrapper);
            upsert jobEventTempOC;
			
            if(lstJobEveTTML != null && lstJobEveTTML.size()>0){
                jobEventTempTTML.Id = lstJobEveTTML[0].Id;
            }
            jobEventTempTTML.Key__c = 'TTML';
            jobEventTempTTML.Reason__c = JSON.serialize(respTTMLWrapper);
            upsert jobEventTempTTML;

            //system.debug('dtOCObj--'+lstdtOCObj);
            //system.debug('dtTTMLObj--'+dtTTMLObj);
            system.debug('respOCWrapper--'+respOCWrapper);

        } catch(exception e){
            system.debug('Entered into catch block of getMISCChargeLOVs method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
        }
        return returnWrapper;
    }*/
    public static CG_OP_OAGWrapper getMISCChargeLOVs(String HQCode,String BranchCode,String location) {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        CG_MiscChargeLOVResWrapper respWrapper;
        CG_MiscChargeLOVResWrapper respOCWrapper = new CG_MiscChargeLOVResWrapper();
        CG_MiscChargeLOVResWrapper respTTMLWrapper = new CG_MiscChargeLOVResWrapper();
        List<CG_MiscChargeLOVResWrapper.DataArea> lstdtOCObj = new List<CG_MiscChargeLOVResWrapper.DataArea>();
        List<CG_MiscChargeLOVResWrapper.DataArea> lstdtTTMLObj = new List<CG_MiscChargeLOVResWrapper.DataArea>();
        CG_MiscChargeLOVResWrapper.DataArea dtTTMLObj;
        CG_MiscChargeLOVResWrapper.DataArea dtOCObj;

        try { 

            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            /*String requeststring = '{"Header": {"Sender": { "ServiceName": "getMISCChargeLOVs", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "HQCode": "'+HQCode+'", "BranchCode": "'+BranchCode+'" }}';
            reqWrapper.jsonReqBody = requeststring;*/
            reqWrapper.serviceName = 'getMISCChargeLOVs';
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('getMISCChargeLOVs').method_type__c;
            reqWrapper.endpoint = CSS_getConnnectionDetails.getConnection('getMISCChargeLOVs').end_point__c+'?sender=CSS&target=BMS&locationId='+location+'&hqCode='+HQCode+'&branchCode='+BranchCode+'';
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            system.debug('returnWrapper--'+returnWrapper);
            system.debug('returnWrapper response--'+returnWrapper.response.getbody());

            respWrapper = (CG_MiscChargeLOVResWrapper)JSON.deserializeStrict(returnWrapper.response.getBody(), CG_MiscChargeLOVResWrapper.class);
            system.debug('respWrapper--'+respWrapper);



            for(CG_MiscChargeLOVResWrapper.DataArea dt : respWrapper.DataArea){
                if(dt.ChargeCategory != 'TRVL'){
                    dtOCObj = new CG_MiscChargeLOVResWrapper.DataArea();
                    dtOCObj.ChargeCategory = dt.ChargeCategory;
                    dtOCObj.MiscName = dt.MiscName;
                    dtOCObj.MiscDescription = dt.MiscDescription;
                    dtOCObj.Multiplier = dt.Multiplier;
                    dtOCObj.FlatAmount = dt.FlatAmount;
                    dtOCObj.Maximum = dt.Maximum;
                    dtOCObj.AutoCharage = dt.AutoCharage;
                    dtOCObj.CreditType = dt.CreditType;
                    dtOCObj.NewWarrantyClass = dt.NewWarrantyClass;
                    lstdtOCObj.add(dtOCObj);
                }
                else{
                    dtTTMLObj = new CG_MiscChargeLOVResWrapper.DataArea();
                    dtTTMLObj.ChargeCategory = dt.ChargeCategory;
                    dtTTMLObj.MiscName = dt.MiscName;
                    dtTTMLObj.MiscDescription = dt.MiscDescription;
                    dtTTMLObj.Multiplier = dt.Multiplier;
                    dtTTMLObj.FlatAmount = dt.FlatAmount;
                    dtTTMLObj.Maximum = dt.Maximum;
                    dtTTMLObj.AutoCharage = dt.AutoCharage;
                    dtTTMLObj.CreditType = dt.CreditType;
                    dtTTMLObj.NewWarrantyClass = dt.NewWarrantyClass;
                    lstdtTTMLObj.add(dtTTMLObj);
                }
            }

            respOCWrapper.dataArea = lstdtOCObj;
            respTTMLWrapper.dataArea = lstdtTTMLObj;

            CSS_JobEventTemporary__c jobEventTempOC = new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c jobEventTempTTML = new CSS_JobEventTemporary__c();
			list<CSS_JobEventTemporary__c> lstJobEveTemp = new list<CSS_JobEventTemporary__c>();
            lstJobEveTemp = [select id,key__c from CSS_JobEventTemporary__c where Key__c = 'OtherClaimables'];
            
            list<CSS_JobEventTemporary__c> lstJobEveTTML = new list<CSS_JobEventTemporary__c>();
            lstJobEveTTML = [select id,key__c from CSS_JobEventTemporary__c where Key__c = 'TTML'];
            
            if(lstJobEveTemp != null && lstJobEveTemp.size()>0){
                jobEventTempOC.Id = lstJobEveTemp[0].Id;
            }
            jobEventTempOC.Key__c = 'OtherClaimables';
            jobEventTempOC.Reason__c = JSON.serialize(respOCWrapper);
            upsert jobEventTempOC;
			
            if(lstJobEveTTML != null && lstJobEveTTML.size()>0){
                jobEventTempTTML.Id = lstJobEveTTML[0].Id;
            }
            jobEventTempTTML.Key__c = 'TTML';
            jobEventTempTTML.Reason__c = JSON.serialize(respTTMLWrapper);
            upsert jobEventTempTTML;

            //system.debug('dtOCObj--'+lstdtOCObj);
            //system.debug('dtTTMLObj--'+dtTTMLObj);
            system.debug('respOCWrapper--'+respOCWrapper);

        } catch(exception e){
            system.debug('Entered into catch block of getMISCChargeLOVs method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
        }
        return returnWrapper;
    }

    //Send Misc Charges.
    public static CG_OP_OAGWrapper sendMISCCharges(String Location,String CSSJobID,String DistributorCode,String BranchCode,String CustomerCode, String OrderType, String BMSReferenceNumber, List<CSS_Parts_Options__c> MiscDetails, String MiscOC) {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();

        try { 
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();


            CG_BMSSendMiscChargesReqWrapper sendMISCChargesReqJSON = new CG_BMSSendMiscChargesReqWrapper();

            CG_BMSSendMiscChargesReqWrapper.Header headerObj = new CG_BMSSendMiscChargesReqWrapper.Header();
            CG_BMSSendMiscChargesReqWrapper.Sender senderObj = new CG_BMSSendMiscChargesReqWrapper.Sender();
            CG_BMSSendMiscChargesReqWrapper.Target targetObj = new CG_BMSSendMiscChargesReqWrapper.Target();
            CG_BMSSendMiscChargesReqWrapper.Location locationObj = new CG_BMSSendMiscChargesReqWrapper.Location();
            CG_BMSSendMiscChargesReqWrapper.DataArea dataAreaObj = new CG_BMSSendMiscChargesReqWrapper.DataArea();
            // CG_BMSSendMiscChargesReqWrapper.MiscDetails miscDetailObj = new CG_BMSSendMiscChargesReqWrapper.MiscDetails();
            // CG_BMSSendMiscChargesReqWrapper.Details lstDetailswrap = new CG_BMSSendMiscChargesReqWrapper.Details();

            senderObj.ServiceName = 'CG_BMSSendMiscCharges';
            senderObj.SenderID = 'CSS';
            headerObj.Sender =  senderObj;

            targetObj.TargetID = 'BMS';
            headerObj.Target = targetObj;

            locationObj.LocationID = Location;
            headerObj.Location = locationObj;

            sendMISCChargesReqJSON.Header = headerObj;

            dataAreaObj.CSSJobID = CSSJobID;
            dataAreaObj.DistributorCode = DistributorCode;
            dataAreaObj.BranchCode = BranchCode;
            dataAreaObj.CustomerCode = CustomerCode;
            dataAreaObj.OrderType = OrderType;
            dataAreaObj.BMSReferenceNumber = BMSReferenceNumber;
            dataAreaObj.MiscDetails = new List<CG_BMSSendMiscChargesReqWrapper.MiscDetails>();

            for (CSS_Parts_Options__c listParts : MiscDetails){
                //if(listParts.Item__c != listParts.Siebel_Value__c)// Modified by Rajesh Narra on 6/27/2018 and made it to ==
                if(listParts.Item__c == listParts.Siebel_Value__c)
                    continue;
                CG_BMSSendMiscChargesReqWrapper.MiscDetails miscParts = new  CG_BMSSendMiscChargesReqWrapper.MiscDetails();
                if(listParts.Claim_Type__c != null)
                    miscParts.ClaimType = listParts.Claim_Type__c;
                else
                    miscParts.ClaimType = '';

                //This RecordType criteria is added by Rajesh Narra on 6-28-2018, based on the recordtype name we are sending the type Misc Name
                if(listParts.RecordType.Name == 'OtherClaimables'){
                    miscParts.MiscName = listParts.Item__c;
                    if(listParts.Sell_Price__c != null)
                        miscParts.Amount = listParts.Sell_Price__c; //Added as part of story 153976
                    else
                        miscParts.Amount = 0;
                }else if(listParts.RecordType.Name == 'TTML'){
                    miscParts.MiscName = listParts.Type__c;
                    if(listParts.Sell_Price__c != null)
                        miscParts.Amount = decimal.valueof(listParts.Unit_Price__c); //Added as part of story 153976
                    else
                        miscParts.Amount = 0;
                }else {
                    miscParts.MiscName = '';
                }
                //This ternary operator is added by Rajesh Narra on 6-28-2018 to not to send blank value for the quantity 
                miscParts.Quantity = (integer.valueOf(listParts.Quantity__c) != Null) ? integer.valueOf(listParts.Quantity__c): 0;
                // miscParts.Amount =integer.valueOf(listParts.Amount__c); //Commented as part of story 153976

                miscParts.MiscOC = MiscOC;
                //miscParts.CreateUser =listParts.Create_User__c;//
                //miscParts.ChangeUser =listParts.Change_User__c;
                User crtdUser = css_utility.getUserAttributes(listParts.CreatedById);
                miscParts.CreateUser = crtdUser.FederationIdentifier;
                User mdfdUser = css_utility.getUserAttributes(listParts.LastModifiedById);
                miscParts.ChangeUser = mdfdUser.FederationIdentifier;
                dataAreaObj.MiscDetails.add(miscParts);  
                // sendMISCChargesReqJSON.DataArea.MiscDetails.add(miscParts);
            }

            sendMISCChargesReqJSON.dataArea = dataAreaObj;
            system.debug('sendMISCChargesReqJSON' + ' ' + sendMISCChargesReqJSON);
            String requeststring = JSON.serialize(sendMISCChargesReqJSON);
            system.debug('requeststring Json' + ' ' + requeststring);
            //String requeststring = '{"Header": {"Sender": { "ServiceName": "getMISCChargeLOVs", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "HQCode": "'+HQCode+'", "BranchCode": "'+BranchCode+'" }}';
            reqWrapper.jsonReqBody = requeststring;
            reqWrapper.serviceName = 'CG_BMSSendMiscCharges';
            reqWrapper.methodtype=CSS_getConnnectionDetails.getConnection('CG_BMSSendMiscCharges').method_type__c; //Added methodtype and endpoint to wrapper as part of Mule Integration
            reqWrapper.endpoint=CSS_getConnnectionDetails.getConnection('CG_BMSSendMiscCharges').end_point__c;
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);

            String OAGWrapResp = returnWrapper.response.getBody();

            //   String OAGWrapResp = '{\"Header\": {\r\n   \"ReturnCodeDescription\": \"Message If Any\",\r\n   \"Status\": \"SUCCESS\",\r\n   \"Sender\":    {\r\n      \"ServiceName\": \"sendMiscCharges \",\r\n      \"MessageID\": \"bac053ab-5b99-4301-8895-aeb67c10a2c9\",\r\n      \"SenderID\": \"CSS\"\r\n   },\r\n   \"Target\": {\"TargetID\": \"BMS\"},\r\n   \"Location\": {\"LocationID\": \"56270-56255\"}\r\n}}\r\n';

            CG_BMSSendMiscChargesRespWrapper sendMiscRespJSON = new CG_BMSSendMiscChargesRespWrapper();

            sendMiscRespJSON =  (CG_BMSSendMiscChargesRespWrapper)JSON.deserializeStrict(OAGWrapResp, CG_BMSSendMiscChargesRespWrapper.class);

            system.debug('Response of sendMiscCharges ' + ' ' + sendMiscRespJSON);

            // system.debug('output-->'+returnWrapper.);
        } catch(exception e){
            system.debug('Entered into catch block of sendMISCCharges method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = e.getMessage();
        }
        return returnWrapper;
    }

    //Send Job Details. to be deleted to BMS System
    public static CG_OP_OAGWrapper deleteBMSJob(string JobId,string location,string CustomerCode,string OrderType,string BMSRefNum,string JobStatus){
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();

        try { 
            system.debug('****insidedeleteBMSJob_CG_SL');
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            String distrCode = '';
            String brnchCode = '';
            String[] locArray;

            if(location != null && location != '')
                locArray = location.split('-');
            if(locArray != null && locArray.size()>0) {
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }      
            OrderType = 'WO'; //As per the Requirement: 133127
            string Action = '';
            if(JobStatus == 'Cancelled')
            { 
                Action = 'DELETE';
            }
            if(JobStatus == 'Closed')
            {
                Action = 'CLOSE';
            }
            string requeststring = '{"Header":{"Sender":{"ServiceName":"DeleteBMSJob","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"'+location+'"}},"DataArea":{"CSSJobID":"'+JobId+'","DistributorCode":"'+distrCode+'","BranchCode":"'+brnchCode+'","CustomerCode":"'+CustomerCode+'","OrderType":"'+OrderType+'","BMSReferenceNumber":"'+BMSRefNum+'","Action":"'+Action+'"}}';
            System.debug('requeststring ******* '+ requeststring);
            reqWrapper.jsonReqBody = requeststring;
            reqWrapper.serviceName = 'DeleteBMSJob';
            returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            System.debug('returnWrapper ******* '+ returnWrapper);
        } 
        catch(exception e){
            system.debug('Entered into catch block of DeleteBMSJob method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
        }
        return returnWrapper;
    }

    public static CG_OP_OAGWrapper sendClaimHeadertoBMS(String Location,String CSSJobID,String DistributorCode,String BranchCode,String CustomerCode, String OrderType, String BMSReferenceNumber, List<CSS_Solution_Component__c> lstsolwrapper, CSS_Job_Order__c servjob){
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
        try { 
            //Prepare Request Wrapper
            reqWrapper = new CG_IP_OAGWrapper(); 
            CG_IP_sendClaimHeadertoBMSReqJSON reqJson = prepareReqWprForClaimHeadertoBMS(Location, CSSJobID, DistributorCode, BranchCode, CustomerCode, OrderType, BMSReferenceNumber, lstsolwrapper, servjob);
            reqWrapper.jsonReqBody = JSON.serialize(reqJson);
            reqWrapper.endPoint = CSS_getConnnectionDetails.getConnection('CG_SendClaimHeadertoBMS').end_point__c;
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('CG_SendClaimHeadertoBMS').Method_Type__c;
            
            System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);
            reqWrapper.serviceName = 'CG_SendClaimHeadertoBMS';
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null)
                resWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            //System.debug('resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper.response);
        } catch(exception e){
            system.debug('Entered into catch block of sendClaimHeadertoBMS method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            resWrapper.exceptionFlag=true;
            resWrapper.errorMessage = e.getMessage();
        }
        return resWrapper;
    }

    public static CG_IP_sendClaimHeadertoBMSReqJSON prepareReqWprForClaimHeadertoBMS(String Location,String CSSJobID,String DistributorCode,String BranchCode,String CustomerCode, String OrderType, String BMSReferenceNumber, List<CSS_Solution_Component__c> lstsolwrapper, CSS_Job_Order__c servjob){

        CG_IP_sendClaimHeadertoBMSReqJSON reqJSONWrapper = null;
        CG_IP_sendClaimHeadertoBMSReqJSON.Header headerObj = null;
        CG_IP_sendClaimHeadertoBMSReqJSON.Sender senderObj = null;
        CG_IP_sendClaimHeadertoBMSReqJSON.Target targetObj = null;
        CG_IP_sendClaimHeadertoBMSReqJSON.Location locationObj = null;
        CG_IP_sendClaimHeadertoBMSReqJSON.DataArea dataAreaObj = null;
        try{
            //Prepare Request JSON
            reqJSONWrapper = new CG_IP_sendClaimHeadertoBMSReqJSON();
            headerObj = new CG_IP_sendClaimHeadertoBMSReqJSON.Header();
            senderObj = new CG_IP_sendClaimHeadertoBMSReqJSON.Sender();
            targetObj = new CG_IP_sendClaimHeadertoBMSReqJSON.Target();
            locationObj = new CG_IP_sendClaimHeadertoBMSReqJSON.Location();
            dataAreaObj = new CG_IP_sendClaimHeadertoBMSReqJSON.DataArea();

            senderObj.SenderID = 'CSS';
            senderObj.ServiceName = 'CG_SendClaimHeadertoBMS';
            targetObj.TargetID = 'BMS';
            locationObj.LocationID = Location;
            //Prepare DataArea Obj

            headerObj.Sender =  senderObj;
            headerObj.Target =  targetObj;
            headerObj.Location =  locationObj;
            reqJSONWrapper.Header = headerObj;
            reqJSONWrapper.DataArea = dataAreaObj;

            dataAreaObj.CSSJobID = CSSJobID;
            dataAreaObj.DistributorCode = DistributorCode;
            dataAreaObj.BranchCode = BranchCode;
            dataAreaObj.CustomerCode = CustomerCode;
            dataAreaObj.OrderType = OrderType;
            dataAreaObj.BMSReferenceNumber = BMSReferenceNumber;
            dataAreaObj.ClaimDetails = new List<CG_IP_sendClaimHeadertoBMSReqJSON.ClaimDetails>();

            for(CSS_Solution_Component__c lstsolcomp : lstsolwrapper){
                CG_IP_sendClaimHeadertoBMSReqJSON.ClaimDetails lstsolwr =  new CG_IP_sendClaimHeadertoBMSReqJSON.ClaimDetails();
                lstsolwr.ClaimType = lstsolcomp.Claim_Type__c;
                if(lstsolcomp.CSS_Account_Formula__c !=null)
                	lstsolwr.AccountCode = lstsolcomp.CSS_Account_Formula__c.RIGHT(2);
                lstsolwr.PayCode= lstsolcomp.Pay_Code__c;
                lstsolwr.ESN = servjob.ESN__c;
                if(lstsolcomp.CertificateNumber__c == null )
                    lstsolwr.Certificate = '';
                else
                    lstsolwr.Certificate = lstsolcomp.CertificateNumber__c;
                if(lstsolcomp.Authorization_Number__c == null)
                    lstsolwr.AuthorizationNumber = '';
                else
                    lstsolwr.AuthorizationNumber = lstsolcomp.Authorization_Number__c;
                //If(String.valueof(lstsolcomp.Failure_Date__c) == null)
                // lstsolwr.FailureDate= '';

                //else 
                lstsolwr.FailureDate= String.valueof(servjob.Failure_Date__c);
                //lstsolwr.FailureDate= '';
                /* if(lstsolcomp.Failure_Date__c != null){
                    lstsolwr.FailureDate = DateTime.newInstance(Date.valueof(lstsolcomp.Failure_Date__c).year(),Date.valueof(lstsolcomp.Failure_Date__c).month(),Date.valueof(lstsolcomp.Failure_Date__c).day()).format('MM/d/YYYY');
                }
                else
                        lstsolwr.FailureDate = ''; */
                lstsolwr.WarrantyStarDate = String.valueof(servjob.Warranty_Start_Date__c);
                /*if(servjob.Warranty_Start_Date__c != null){
                    lstsolwr.WarrantyStarDate = DateTime.newInstance(Date.valueof(servjob.Warranty_Start_Date__c).year(),Date.valueof(servjob.Warranty_Start_Date__c).month(),Date.valueof(servjob.Warranty_Start_Date__c).day()).format('MM/d/YYYY');
                }
                else
                    lstsolwr.WarrantyStarDate = ''; */

                // need to check 
                //If(lstsolwr.MissionDisabling == true)  
                //lstsolwr.MissionDisabling = 'A';
                //Else
                //lstsolwr.MissionDisabling = 'B';

                lstsolwr.SMN = String.valueof(servjob.Service_Model__c);
                lstsolwr.Make=  servjob.Make__c;
                lstsolwr.Model = servjob.Model__c;
                lstsolwr.EquipmentConfiguration = servjob.Unit_Type__c;
                lstsolwr.ApplicationCode = servjob.ApplicationCode__c;
                lstsolwr.Distance = integer.valueof(servjob.Mileage__c);
                lstsolwr.DistanceType = servjob.Mileage_Measure__c;
                lstsolwr.Hours = servjob.CSS_Hours__c;
                if(lstsolcomp.Approval_Code__c == null)
                    lstsolwr.ApprovalCode = '';
                else
                    lstsolwr.ApprovalCode =  lstsolcomp.Approval_Code__c;
                //  if(lstsolcomp.Create_User__c == null)
                // lstsolwr.DistributorAuthorization ='';
                // else 
                if(lstsolcomp.CreatedById != null)
                	lstsolwr.DistributorAuthorization = String.valueof(css_utility.getUserAttributes(lstsolcomp.CreatedById).FederationIdentifier).toUpperCase();
                // lstsolwr.DistributorAuthorization = lstsolcomp.Create_User__c;
                lstsolwr.MissionDisabling = 'B';

                if(lstsolcomp.DeductibleAmount__c != null && integer.valueof(lstsolcomp.DeductibleAmount__c) > 0)
                    lstsolwr.DeductibleApply = 'Y';
                else
                    lstsolwr.DeductibleApply = 'N';
                lstsolwr.TravelHoursAllowed = integer.valueof(lstsolcomp.CoveredTravelLabor__c);
                if(lstsolcomp.Type__c != 'TRP' && lstsolcomp.Type__c !=  'ATC' && lstsolcomp.Type__c != 'CAMPAIGN'){
                    if(lstsolcomp.CoveredTravelMiles__c != null && integer.valueof(lstsolcomp.CoveredTravelMiles__c) > 0)  
                        lstsolwr.TravelAllowed = 'Y';
                    else
                        lstsolwr.TravelAllowed = 'N';

                    if(lstsolcomp.CoveredTowingMiles__c != null && integer.valueof(lstsolcomp.CoveredTowingMiles__c) > 0)
                        lstsolwr.TowingAllowed = 'Y'; 
                    else
                        lstsolwr.TowingAllowed = 'N';
                }
                else{
                    if(lstsolcomp.CoveredTravelMiles__c != null && integer.valueof(lstsolcomp.CoveredTravelMiles__c) == 100)  
                        lstsolwr.TravelAllowed = 'Y';
                    else
                        lstsolwr.TravelAllowed = 'N';

                    if(lstsolcomp.CoveredTowingMiles__c != null && integer.valueof(lstsolcomp.CoveredTowingMiles__c) == 100)
                        lstsolwr.TowingAllowed = 'Y'; 
                    else
                        lstsolwr.TowingAllowed = 'N';
                }
                // if(lstsolcomp.Create_User__c == null)
                //  lstsolwr.CreateUser =  '';
                // else
                if(lstsolcomp.CreatedById != null)
                	lstsolwr.CreateUser =  String.valueof(css_utility.getUserAttributes(lstsolcomp.CreatedById).FederationIdentifier).toUpperCase();

                if(lstsolcomp.Change_User__c == null)
                    lstsolwr.ChangeUser =  '';
                else
                    lstsolwr.ChangeUser = lstsolcomp.Change_User__c;

                dataAreaObj.ClaimDetails.add(lstsolwr); 
            }    

            return reqJSONWrapper;
        }catch(Exception ex){
            System.debug('in catch of prepareReqWprForClaimHeadertoBMS of CG_SL_BMS >>>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return null;
    }



    public static CG_OP_OAGWrapper sendFailurecode(String Location,String CSSJobID,String DistributorCode,String BranchCode,String CustomerCode, String OrderType, String BMSReferenceNumber,List<CSS_Solution_Component__c> FailuresList) {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();

        try { 
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();

            CG_SendFailurecodestoBMSWrapper sendFAILURECODEReqJSON = new CG_SendFailurecodestoBMSWrapper();
            CG_SendFailurecodestoBMSWrapper.Header headerObj = new CG_SendFailurecodestoBMSWrapper.Header();
            CG_SendFailurecodestoBMSWrapper.Sender senderObj = new CG_SendFailurecodestoBMSWrapper.Sender();
            CG_SendFailurecodestoBMSWrapper.Target targetObj = new CG_SendFailurecodestoBMSWrapper.Target();
            CG_SendFailurecodestoBMSWrapper.Location locationObj = new CG_SendFailurecodestoBMSWrapper.Location();
            CG_SendFailurecodestoBMSWrapper.DataArea dataAreaObj = new CG_SendFailurecodestoBMSWrapper.DataArea();

            senderObj.ServiceName = 'CG_BMSSendFailurecodes';
            senderObj.SenderID = 'CSS';
            headerObj.Sender =  senderObj;

            targetObj.TargetID = 'BMS';
            headerObj.Target = targetObj;

            locationObj.LocationID = Location;
            headerObj.Location = locationObj;

            sendFAILURECODEReqJSON.Header = headerObj;

            dataAreaObj.CSSJobID = CSSJobID;
            dataAreaObj.DistributorCode = DistributorCode;
            dataAreaObj.BranchCode = BranchCode;
            dataAreaObj.CustomerCode = CustomerCode;
            dataAreaObj.OrderType = OrderType;
            dataAreaObj.BMSReferenceNumber = BMSReferenceNumber;
            dataAreaObj.FailuresList = new List<CG_SendFailurecodestoBMSWrapper.FailuresList>();

            for (CSS_Solution_Component__c lisSolCom : FailuresList){
                CG_SendFailurecodestoBMSWrapper.FailuresList Fcodes = new  CG_SendFailurecodestoBMSWrapper.FailuresList();
                Fcodes.ProductGroup = 'HH';
                Fcodes.GroupNo ='00';
                Fcodes.SystemCode =lisSolCom.system_code__c;
                Fcodes.ComponentCode =lisSolCom.Component_Code__c; 
                If(lisSolCom.Failure_Mode__c== null)
                    Fcodes.FailureMode='';
                else
                    Fcodes.FailureMode =lisSolCom.Failure_Mode__c;
                Fcodes.FailLocation='AA';

                // Claim Type Logic is modified by Rajesh Narra on 6/19/2018 to send the claim type value to BMS as part of sendparts to BMS inbound service
                if(lisSolCom.Claim_Type__c!=null && lisSolCom.Claim_Type__c!=''){
                    Fcodes.ClaimType = lisSolCom.Claim_Type__c;
                }else if(lisSolCom.Selected_Claim_Type__c != null && lisSolCom.Selected_Claim_Type__c!=''){
                    Fcodes.ClaimType = lisSolCom.Selected_Claim_Type__c;
                }else{
                    Fcodes.ClaimType='';
                }

                /*If(lisSolCom.Selected_Claim_Type__c== null)
                    Fcodes.ClaimType='';
                else
                Fcodes.ClaimType=lisSolCom.Selected_Claim_Type__c;*/

                If(lisSolCom.Create_User__c== null)
                    Fcodes.CreateUser='';
                else
                    Fcodes.CreateUser =lisSolCom.Create_User__c;
                If(lisSolCom.Change_User__c== null)
                    Fcodes.ChangeUser='';
                else
                    Fcodes.ChangeUser =lisSolCom.Change_User__c;
                dataAreaObj.FailuresList.add(Fcodes);  

            }

            sendFAILURECODEReqJSON.dataArea = dataAreaObj;
            system.debug('sendFAILURECODEReqJSON' + ' ' + sendFAILURECODEReqJSON);
            String requeststring = JSON.serialize(sendFAILURECODEReqJSON);
            system.debug('requeststring Json' + ' ' + requeststring);
            // String requeststring = '{"Header": {"Sender": { "ServiceName": "CG_BMSSendFailurecodes", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "CSSJobID": "'+CSSJobID+'", "BranchCode": "'+BranchCode+'","DistributorCode":"'+DistributorCode+'","CustomerCode":"'+CustomerCode+'","OrderType":"'+OrderType+'","BMSReferenceNumber":"'+BMSReferenceNumber+'","FailuresList":""}}';
            reqWrapper.jsonReqBody = requeststring;
            reqWrapper.serviceName = 'CG_BMSSendFailurecodes';
            //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper)
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('CG_BMSSendFailurecodes').Method_Type__c; 
            reqWrapper.endPoint = CSS_getConnnectionDetails.getConnection('CG_BMSSendFailurecodes').end_point__c; 
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            system.debug('returnWrapper**'+returnWrapper);
            CG_SendFailurecodestoBMSOutPutWrapper CSWrap;
            if(returnWrapper !=null && returnWrapper.response!=null){
                CSWrap = (CG_SendFailurecodestoBMSOutPutWrapper)JSON.deserialize(returnWrapper.response.getBody(), CG_SendFailurecodestoBMSOutPutWrapper.class);
            }
            CSS_Job_Order__c jobOrd=[select id,BMSStatus__c from CSS_Job_Order__c where name=:CSSJobID];
            If(CSWrap !=null && CSWrap.Header.status=='SUCCESS'){
                system.debug('output-->23');
                if(jobOrd.BMSStatus__c != null && jobOrd.BMSStatus__c.Contains(',QTFI1'))
                    jobOrd.BMSStatus__c = jobOrd.BMSStatus__c.Remove(',QTFI1');
                Else if(jobOrd.BMSStatus__c != null && jobOrd.BMSStatus__c.Contains('QTFI1'))
                    jobOrd.BMSStatus__c = jobOrd.BMSStatus__c.Remove('QTFI1');

                if(jobOrd.BMSStatus__c != null && jobOrd.BMSStatus__c != '' && !jobOrd.BMSStatus__c.Contains('QTFI0')){
                    If(jobOrd.BMSStatus__c !=null)
                        jobOrd.BMSStatus__c =jobOrd.BMSStatus__c+',QTFI0';
                    Else
                        jobOrd.BMSStatus__c = 'QTFI0';
                }
                Else
                    jobOrd.BMSStatus__c = 'QTFI0';
            }
            Else{
                if(jobOrd.BMSStatus__c != null && jobOrd.BMSStatus__c.Contains(',QTFI0'))
                    jobOrd.BMSStatus__c = jobOrd.BMSStatus__c.Remove(',QTFI0');
                Else if(jobOrd.BMSStatus__c != null && jobOrd.BMSStatus__c != null && jobOrd.BMSStatus__c.Contains('QTFI0'))
                    jobOrd.BMSStatus__c = jobOrd.BMSStatus__c.Remove('QTFI0');

                if(jobOrd.BMSStatus__c != null && jobOrd.BMSStatus__c != '' && !jobOrd.BMSStatus__c.Contains('QTFI1')){
                    If(jobOrd.BMSStatus__c !=null)
                        jobOrd.BMSStatus__c =jobOrd.BMSStatus__c+',QTFI1';
                    Else
                        jobOrd.BMSStatus__c = 'QTFI1';
                }
                Else
                    jobOrd.BMSStatus__c = 'QTFI1';

                system.debug('output-->24' +jobOrd);
            }
            system.debug('jobOrd>>>>'+jobOrd.BMSStatus__c);
            returnWrapper.bmsStatus = jobOrd.BMSStatus__c;
            //Update jobOrd;  
            system.debug('After Update jobOrd>>>>'+jobOrd.BMSStatus__c);
            //String OAGWrapResp = returnWrapper.response.getBody();
            //String OAGWrapResp =  '{\"Header\": {\r\n   \"ReturnCodeDescription\": \"Message If Any\",\r\n   \"Status\": \"SUCCESS\",\r\n   \"Sender\":    {\r\n      \"ServiceName\": \"sendMiscCharges \",\r\n      \"MessageID\": \"bac053ab-5b99-4301-8895-aeb67c10a2c9\",\r\n      \"SenderID\": \"CSS\"\r\n   },\r\n   \"Target\": {\"TargetID\": \"BMS\"},\r\n   \"Location\": {\"LocationID\": \"56270-56255\"}\r\n}}\r\n';
            system.debug('output-->'+returnWrapper);
        } catch(exception e){
            system.debug('Entered into catch block of sendMISCCharges method in CG_SL_BMS class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
        }
        return returnWrapper;
    }
    /*public static void callMiscLOVService(List<CSS_UserLocation__c> Locations){
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        string HQCode = '';
        string BranchCode = '';
        string[] LocCodes;
        for(integer i=0;i<Locations.size();i++){
        if(Locations[i].Location_code__c!=null && Locations[i].Location_code__c!='')
        {
            
            LocCodes = Locations[i].Location_code__c.split('-');
            HQCode = LocCodes[0];
            BranchCode = LocCodes[1];
        
            if(LocCodes!=null)
               returnWrapper = CG_SL_BMS.getMISCChargeLOVs(HQCode,BranchCode,Locations[i].Location_code__c);
        }
    }
    }*/
}