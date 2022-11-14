@isTest
public class OSM_Wrapper_Test 
{
    public static testMethod void wrapperTest()
    {
        OSM_WS_GeneralizedSubmitOrderOutputWrap a = new OSM_WS_GeneralizedSubmitOrderOutputWrap();
        a.errorMsg = '';
        String jsonBody = '';
        
        try
        {
            jsonBody = '{"Header": {"Target": {"TargetID": "BMS"},"Sender": {"ServiceName": "SubmitOrder","SenderID": "MRKTPLC"}},"DataArea": {"TaxList": [{"TAX_AUTHORITIES": "56073-MN-18122","TAX_AMOUNT": 0.0,"SALES_CATEGORIES": "SW-Web Access","SALE_AMOUNT": 90.0,"PRINT_GROUP": "STATE","Attribute03": "","Attribute02": "","Attribute01": 0}, {"TAX_AUTHORITIES": "56073-MN-18215","TAX_AMOUNT": 0.0,"SALES_CATEGORIES": "SW-Web Access","SALE_AMOUNT": 90.0,"PRINT_GROUP": "CITY","Attribute03": "","Attribute02": "","Attribute01": 0}, {"TAX_AUTHORITIES": "56073-MN-101381","TAX_AMOUNT": 0.0,"SALES_CATEGORIES": "SW-Web Access","SALE_AMOUNT": 90.0,"PRINT_GROUP": "DISTRICT","Attribute03": "","Attribute02": "","Attribute01": 0}],"Sender": "MRKTPLC","R_PARTSLIST_SUBMIT": [{"UOM": "EA","SELLING_PRICE": 90.00,"QUANTITY": 1,"PRODUCT": "MRKTPLC","NONSTOCK_TYPE": "","LINE_TYPE": "","ITEM_NUMBER": "5678902-OHT","ITEM_COST": 0,"DESCRIPTION": "CA Base-OHT","Attribute03": "","Attribute02": "","Attribute01": 0}],"LocationID": "02860-02860","FSDList": [{"VENDOR": "MRKTPLC","TAX_DISTRICT": "56073-MN","STATUS": "","SHIP_TO_STATE": "MN","SHIP_TO_POSTAL_CODE": "56073","SHIP_TO_NAME": "J & R SCHUGEL TRUCKING","SHIP_TO_COUNTRY": "US","SHIP_TO_CITY": "NEW ULM","SHIP_TO_ADDRESS3": "","SHIP_TO_ADDRESS2": "","SHIP_TO_ADDRESS1": "2026 N BROADWAY ST","SALES_ORDER_ID": "0005003288","PAYMENT_TYPE": "CHARGE","ORDER_SOURCE_TYPE": "OSM","OE_COMMENT": "Testing","INVOICE_TOTAL": 90.0,"INVOICE_NUMBER": "00502795","INVOICE_DATE": "2019-04-05","CUSTOMER_PO_NUMBER": "PO1234","CUSTOMER_LOCATION_CODE": "02860","BILL_TO_NAME": "J & R SCHUGEL TRUCKING","BILL_TO_CUST_NUMBER": "22925","Attribute03": "","Attribute02": "","Attribute01": 0}],"CustomerCode": "22925","ChargeList": [{"MISC_CHARGE_AMOUNT": 0,"MISC_CHARGE": "Discount","Attribute02": "","Attribute01": 0}],"Attribute03": "","Attribute02": "","Attribute01": ""}}';
            
            OSM_WS_SubmitOrderInfo_REQ reqObj = OSM_WS_SubmitOrderInfo_REQ.parse(jsonBody);
            
            reqObj.Header=new OSM_WS_SubmitOrderInfo_REQ.Header();
            reqObj.Header.Sender=new OSM_WS_SubmitOrderInfo_REQ.Sender();
            reqObj.Header.Target=new OSM_WS_SubmitOrderInfo_REQ.Target();        
            reqObj.DataArea=new OSM_WS_SubmitOrderInfo_REQ.DataArea();
            reqObj.DataArea.FSDList=new List<OSM_WS_SubmitOrderInfo_REQ.FSDList>();
            OSM_WS_SubmitOrderInfo_REQ.FSDList fsdList=new OSM_WS_SubmitOrderInfo_REQ.FSDList();
            reqObj.DataArea.TaxList =new List<OSM_WS_SubmitOrderInfo_REQ.TaxList>();
            OSM_WS_SubmitOrderInfo_REQ.TaxList taxList=new OSM_WS_SubmitOrderInfo_REQ.TaxList();
            reqObj.DataArea.ChargeList=new List<OSM_WS_SubmitOrderInfo_REQ.ChargeList>();
            OSM_WS_SubmitOrderInfo_REQ.ChargeList chargeList=new OSM_WS_SubmitOrderInfo_REQ.ChargeList();
            reqObj.DataArea.R_PARTSLIST_SUBMIT=new List<OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT>();
            OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT partList=new OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT();
            
            reqObj.Header.Sender.ServiceName='abc';
            reqObj.Header.Sender.SenderID='abc';
            reqObj.Header.Target.TargetID='abc';
            reqObj.DataArea.LocationID='abc';
            reqObj.DataArea.CustomerCode='abc';
            reqObj.DataArea.Sender='abc';
            
            // Start : Changes - Juhi - Feb 27 - Addition of Attribute01 field when Refund 
            reqObj.DataArea.Attribute01 = 'abc';
            reqObj.DataArea.Attribute02 = 'abc';
            reqObj.DataArea.Attribute03 = 'abc';
            // End : Changes - Juhi - Feb 27 - Addition of Attribute01 field when Refund 
            
            for(Integer i=0; i<1; i++){
                OSM_WS_SubmitOrderInfo_REQ.FSDList objFSDrequest=new OSM_WS_SubmitOrderInfo_REQ.FSDList();
                objFSDrequest.VENDOR='abc';
                // Start - Changes Made : Juhi : Jan 15 2019 : Addition of a field Customer Location Code in Account Object to Json Request for Submit Order
                objFSDrequest.CUSTOMER_LOCATION_CODE = 'abc';
                // End - Changes Made : Juhi : Jan 15 2019
                objFSDrequest.SALES_ORDER_ID='abc';
                objFSDrequest.ORDER_SOURCE_TYPE='abc';
                //objFSDrequest.ORDER_SOURCE_TYPE='OESD';
                objFSDrequest.TAX_DISTRICT='abc';
                objFSDrequest.PAYMENT_TYPE='abc';
                //   objFSDrequest.PAYMENT_TYPE='CHARGE';
                objFSDrequest.STATUS='';
                objFSDrequest.INVOICE_NUMBER='abc';
                objFSDrequest.INVOICE_DATE=System.TODAY();
                objFSDrequest.INVOICE_TOTAL=123;
                objFSDrequest.BILL_TO_CUST_NUMBER='abc';
                objFSDrequest.BILL_TO_NAME='abc';
                objFSDrequest.SHIP_TO_NAME='abc';
                objFSDrequest.SHIP_TO_ADDRESS1='abc';
                
                // Start : Mar 11, 2019 - Juhi - Addition of 3 fields for address in Submit Order request
                
                    objFSDrequest.SHIP_TO_ADDRESS2='abc';
                
                    objFSDrequest.SHIP_TO_ADDRESS3='abc';
                
                    objFSDrequest.SHIP_TO_COUNTRY='abc';
                // End : Mar 11, 2019 - Juhi - Addition of 3 fields for address in Submit Order request
                
                objFSDrequest.SHIP_TO_CITY='abc';
                objFSDrequest.SHIP_TO_STATE='abc';
                objFSDrequest.SHIP_TO_POSTAL_CODE='abc';
                objFSDrequest.OE_COMMENT='abc';
                objFSDrequest.CUSTOMER_PO_NUMBER='abc';
                objFSDrequest.Attribute01=0;
                objFSDrequest.Attribute02='';
                objFSDrequest.Attribute03='';
                reqObj.DataArea.FSDList.add(objFSDrequest);
                
            }
            //  reqObj.DataArea.FSDList.add(objFSDrequest);
            
            for(Integer i=0; i<1; i++){
                OSM_WS_SubmitOrderInfo_REQ.TaxList objTaxRequest=new OSM_WS_SubmitOrderInfo_REQ.TaxList();
                objTaxRequest.TAX_AUTHORITIES='abc';
                objTaxRequest.PRINT_GROUP='abc';
                objTaxRequest.SALES_CATEGORIES='abc';
                objTaxRequest.TAX_AMOUNT=123;
                objTaxRequest.SALE_AMOUNT=123;
                objTaxRequest.Attribute01=12;
                objTaxRequest.Attribute02='';
                objTaxRequest.Attribute03='123'; 
                reqObj.DataArea.TaxList.add(objTaxRequest);
                
            }
            for(Integer i=0; i<1; i++){
                OSM_WS_SubmitOrderInfo_REQ.ChargeList objChargeRequest=new OSM_WS_SubmitOrderInfo_REQ.ChargeList();
                objChargeRequest.MISC_CHARGE='Discount';
                objChargeRequest.MISC_CHARGE_AMOUNT=123;
                objChargeRequest.Attribute01=123;
                objChargeRequest.Attribute02='abc';
                reqObj.DataArea.ChargeList.add(objChargeRequest);
                
            }
            for(Integer i=0; i<1; i++){
                OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT objPartListRequest=new OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT();
                objPartListRequest.ITEM_NUMBER='abc';
                objPartListRequest.PRODUCT='abc';
                objPartListRequest.DESCRIPTION='abc';
                objPartListRequest.QUANTITY=123;
                objPartListRequest.UOM='abc';
                objPartListRequest.SELLING_PRICE=123;
                objPartListRequest.ITEM_COST=123;
                objPartListRequest.NONSTOCK_TYPE='abc';
                objPartListRequest.LINE_TYPE='abc';
                objPartListRequest.Attribute01=0;
                objPartListRequest.Attribute02='';
                objPartListRequest.Attribute03='';
                reqObj.DataArea.R_PARTSLIST_SUBMIT.add(objPartListRequest); 
            }
            
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        /*
        try
        {
            jsonBody = '{"Header": {"Target": {"TargetID": "OMS"},"Sender": {"ServiceName": "CreateOrder","SenderID": "Mrktplc"},"Message": {"Timestamp": "2019-03-11","MessageID": "O-0000001371"}},"CreateOrderInput": {"ToolName": "INSITE","RequesterId": "30645","LicenseInfoList": {"LicenseInfo": [{"TotalCopies": "2","StartDate": "","LicPolicy": {"RevalidationPeriod": "1825","NumberOfRepairs": "6","NumberOfReinstalls": "0","NumberOfRehosts": "5"},"LicenseName": "Fleet Count","LicAttributes": {"Products": {"Product": "Fleet Count"},"ProductGroups": [{"ProductGroup": [""]}],"Features": {"Feature": "Fleet"},"FeatureGroups": {"FeatureGroup": ""}},"Duration": "36135","CountsPerCopy": "12","AdminId": "30645"}]}}}';
            OSM_OMS_WS_CreateOrderReq createOrderReq = OSM_OMS_WS_CreateOrderReq.parse(jsonBody);
            
            createOrderReq.Header = new OSM_OMS_WS_CreateOrderReq.Header();
            
            createOrderReq.Header.Sender = new OSM_OMS_WS_CreateOrderReq.Sender();
            createOrderReq.Header.Sender.ServiceName = 'CreateOrder';
            createOrderReq.Header.Sender.SenderID = 'Mrktplc';
            
            createOrderReq.Header.Target = new OSM_OMS_WS_CreateOrderReq.Target();
            createOrderReq.Header.Target.TargetID = 'OMS';
            
            createOrderReq.Header.Message = new OSM_OMS_WS_CreateOrderReq.Message();
            createOrderReq.Header.Message.MessageID = 'abc';
            createOrderReq.Header.Message.Timestamp = 'abc';
            
            createOrderReq.CreateOrderInput = new OSM_OMS_WS_CreateOrderReq.CreateOrderInput();
            createOrderReq.CreateOrderInput.ToolName = 'INSITE';
            createOrderReq.CreateOrderInput.RequesterId = 'abc';
            
            createOrderReq.CreateOrderInput.LicenseInfoList = new OSM_OMS_WS_CreateOrderReq.LicenseInfoList();
            createOrderReq.CreateOrderInput.LicenseInfoList.LicenseInfo = new List<OSM_OMS_WS_CreateOrderReq.LicenseInfo>();
            
            for(Integer i=0; i<1; i++)
            {
                OSM_OMS_WS_CreateOrderReq.LicenseInfo licenseInfo = new OSM_OMS_WS_CreateOrderReq.LicenseInfo();
                licenseInfo.AdminId = 'abc';
                licenseInfo.LicenseName = 'abc';
                licenseInfo.TotalCopies = 'abc';
                licenseInfo.CountsPerCopy = 'abc';
                licenseInfo.Duration = 'abc';
                licenseInfo.StartDate = 'abc';
                
                licenseInfo.LicAttributes = new OSM_OMS_WS_CreateOrderReq.LicAttributes();
                licenseInfo.LicAttributes.Features = new OSM_OMS_WS_CreateOrderReq.Features();
                licenseInfo.LicAttributes.Features.Feature = 'abc';
                
                licenseInfo.LicAttributes.FeatureGroups = new OSM_OMS_WS_CreateOrderReq.FeatureGroups();
                licenseInfo.LicAttributes.FeatureGroups.FeatureGroup = 'abc';
                
                licenseInfo.LicAttributes.Products = new OSM_OMS_WS_CreateOrderReq.Products();
                licenseInfo.LicAttributes.Products.Product = 'abc';
                
                licenseInfo.LicAttributes.ProductGroups = new List<OSM_OMS_WS_CreateOrderReq.ProductGroups>();
                
                
                OSM_OMS_WS_CreateOrderReq.ProductGroups productGroups = new OSM_OMS_WS_CreateOrderReq.ProductGroups();
                productGroups.ProductGroup = new List<String>();
                
                
                productGroups.ProductGroup.add('SIR');
                productGroups.ProductGroup.add('RMI');
                
                
                licenseInfo.LicAttributes.ProductGroups.add(productGroups);
                
                licenseInfo.LicPolicy = new OSM_OMS_WS_CreateOrderReq.LicPolicy();
                licenseInfo.LicPolicy.NumberOfRehosts = '5';
                licenseInfo.LicPolicy.NumberOfRepairs = '6';
                licenseInfo.LicPolicy.NumberOfReinstalls = 'abc';
                
                
                licenseInfo.LicPolicy.RevalidationPeriod = '1825';
                
                
                createOrderReq.CreateOrderInput.LicenseInfoList.LicenseInfo.add(licenseInfo);
            } 
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        */
        try
        {
            jsonBody = '{"Header":{"Target":{"TargetID":"BOLT"},"Sender":{"ServiceName":"Journal Entry","SenderID":"OSM"},"JE_CTRL_TBL_ROW":{"SYSTEM_CODE":"OSM_01","STATUS":null,"Order_Number":"00008214","LAST_UPDATED_BY":"-1","LAST_UPDATE_DATE":"2019-04-10","CREATION_DATE":"2019-04-10","CREATED_BY":"-1","BATCH_ID":"20190410043350","BATCH_AMOUNT":"32.58"}},"DataArea":{"JE_INV_INBND_STG_ROW":{"USER_JE_SOURCE_NAME":"US OSM","USER_JE_CATEGORY_NAME":"Sales Invoices","USER_CURRENCY_CONVERSION_TYPE":"User","SYSTEM_CODE":"OSM_01","SEGMENT7":"0000","SEGMENT6":"00000","SEGMENT5":"000","SEGMENT3":"2076903","SEGMENT2":"207","SEGMENT1":"598","REFERENCE9":null,"REFERENCE8":null,"REFERENCE7":null,"REFERENCE6":"20190410043350","REFERENCE5":null,"REFERENCE4":null,"REFERENCE3":null,"REFERENCE2":null,"REFERENCE10":null,"REFERENCE1":null,"LEDGER_NAME":"US Primary USD","LEDGER_ID":"2041","LAST_UPDATED_BY":"-1","LAST_UPDATE_DATE":"2019-04-10","JOURNAL_ID":null,"JE_INV_INBND_STG_ROW_LINES":[{"SEGMENT4":"1791000","ENTERED_DR":"0","ENTERED_CR":"30.00","ACCOUNTED_DR":"0","ACCOUNTED_CR":"30.00"},{"SEGMENT4":"0574000","ENTERED_DR":"0","ENTERED_CR":"2.58","ACCOUNTED_DR":"0","ACCOUNTED_CR":"2.58"},{"SEGMENT4":"2796000","ENTERED_DR":"0","ENTERED_CR":"0","ACCOUNTED_DR":"0","ACCOUNTED_CR":"0"},{"SEGMENT4":"0020009","ENTERED_DR":"32.58","ENTERED_CR":"0","ACCOUNTED_DR":"32.58","ACCOUNTED_CR":"0"}],"INVOICE_DATE":"2019-04-10","GROUP_ID":"20190410043350","DATE_CREATED":"2019-04-10","CURRENCY_CONVERSION_RATE":"1","CURRENCY_CONVERSION_DATE":"2019-04-10","CURRENCY_CODE":"USD","CREATION_DATE":"2019-04-10","CREATED_BY":"-1","CHART_OF_ACCOUNTS_ID":"50368","ACTUAL_FLAG":"A","ACCOUNTING_DATE":"2019-04-10"}}}';
            OSM_BOLT_WS_JournalEntryOutboundReq c = OSM_BOLT_WS_JournalEntryOutboundReq.parse(jsonBody);
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        
        try
        {
            throw new OSM_SW_IntercompanyDNPriceException();
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        
    }
}