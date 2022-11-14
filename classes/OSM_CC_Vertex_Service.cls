//Subbu updated 6/2/2022 -commented out system.debug statememts of auth token
public class OSM_CC_Vertex_Service{


    public static OSM_VERTEX_WS_GeneralizedoutputWrapper callTaxService(OSM_VERTEX_WS_GeneralizedInputWrapper objVertexGeneralWrapper){
        
        boolean isException = false;
        OSM_VERTEX_WS_GeneralizedoutputWrapper objReturn = new OSM_VERTEX_WS_GeneralizedoutputWrapper();
        
        String jsonStr = '';
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        try
        {
            OSM_VERTEX_WS_CalculateTaxReq objReqVertexWrpr = OSM_CC_Vertex_Service_Helper.populateDynamicData(objVertexGeneralWrapper);
            
            //system.debug('objReqVertexWrpr: '+objReqVertexWrpr);
            jsonStr = JSON.serialize(objReqVertexWrpr);
            //System.debug('previous json string: '+jsonStr);
            jsonStr = jsonStr.replace('Transaction_Z','Transaction');
            if(objVertexGeneralWrapper.isForQuote)
                jsonStr = jsonStr.replace('"InvoiceRequestDocumentNumber":null,','');
            else
                jsonStr = jsonStr.replace('"QuotationRequestDocumentNumber":null,','');
            //System.debug('jsonStr: '+jsonStr);
            
            
            // Call for Quote tax
            OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
            
            if(objVertexGeneralWrapper.isForQuote){
                //requestWrap.serviceName = 'getVertexQuoteTax';
                requestWrap.serviceName = Label.OSM_Vertex_Service_Name;
                log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Quote;
                log.Cart__c = objVertexGeneralWrapper.recordId;
            }
            else
            {
                //requestWrap.serviceName = 'getVertexInvoiceTax';
                requestWrap.serviceName = Label.OSM_Vertex_Inv_Service_Name;
                log.Invoice__c = objVertexGeneralWrapper.recordId;
                if(objVertexGeneralWrapper.isRefundInvoiceReq)
                    log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Invoice_Refund;
                else
                    log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Invoice;
            }
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'OSMVertex';
            requestWrap.AccesTokenRequired = true;
            
            log.Target__c = System.Label.OSM_Vertex_Target;
            log.Request__c = jsonStr;
            log.Source__c = 'OSM';
            log.Logged_In_User__c = userinfo.getuserid();
            
            
            // resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);
            resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
            log.API_URL__c =resAuthWrapper.APIURL;
            if(resAuthWrapper.exceptionFlag == false )
            {
                
                log.Response__c = resAuthWrapper.Response;
                log.Status__c = 'Success'; 
               // System.debug('Web service response body: '+resAuthWrapper.Response);
                //OSM_VERTEX_WS_CalculateTaxRes wrprRes = OSM_VERTEX_WS_CalculateTaxRes.parse(resAuthWrapper.Response.substringAfterLast('Response Body: ').replace('Transaction','Transaction_Z'));
                OSM_VERTEX_WS_CalculateTaxRes wrprRes = OSM_VERTEX_WS_CalculateTaxRes.parse(resAuthWrapper.Response.replace('Transaction','Transaction_Z'));
                //System.debug('wrprRes: '+wrprRes);
               
                //System.debug('wrprRes.Header.Status: '+wrprRes.Header.Status);
                if(wrprRes.Header.Status != null && wrprRes.Header.Status == 'ERROR')
                {
                    objReturn.errorMsg = wrprRes.Header.ReturnCodeDescription;
                    objReturn.errorFlag = true;
                    log.Status__c = 'Failure'; 
                    log.Error_Description__c = wrprRes.Header.ReturnCodeDescription;
                }else
                {
                    objReturn.DataArea = new OSM_VERTEX_WS_GeneralizedoutputWrapper.DataArea();
                    objReturn.DataArea.ProductList = new List<OSM_VERTEX_WS_GeneralizedoutputWrapper.ProductList>();
                    //objReturn.DataArea.ProductList.Taxes = new List<OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes>();
                    objReturn.Header = new OSM_VERTEX_WS_GeneralizedoutputWrapper.Header();
                    objReturn.Header.Transaction_Z = new OSM_VERTEX_WS_GeneralizedoutputWrapper.Transaction_Z();
                    
                    objReturn.DataArea.TotalTax = wrprRes.DataArea.TotalTax;
                    objReturn.Header.Transaction_Z.TransactionID = wrprRes.Header.Transaction_Z.TransactionID;
                    
                    for(OSM_VERTEX_WS_CalculateTaxRes.ProductList  objProductList: wrprRes.DataArea.ProductList)
                    {
                        OSM_VERTEX_WS_GeneralizedoutputWrapper.ProductList newObj = new OSM_VERTEX_WS_GeneralizedoutputWrapper.ProductList();
                        newObj.Product = objProductList.Product;
                        newObj.LineItemTotalTax =objProductList.LineItemTotalTax;
                        newObj.ProductClassCode = objProductList.ProductClassCode;
                        newObj.LineItemNumber = objProductList.LineItemNumber;
                        newObj.ProductCode = objProductList.ProductCode;
                        newObj.Taxes=new List<OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes>();
                        if(objProductList.Taxes!=null){
                        for(OSM_VERTEX_WS_CalculateTaxRes.Taxes tax:objProductList.Taxes){
                         OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes taxObj=new OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes();
                             //system.debug('TAX______'+tax);
                             taxObj.taxResult=tax.taxResult;
                             taxObj.taxType=tax.taxType;
                             taxObj.reasonCode=tax.reasonCode;
                             taxObj.isService=tax.isService;
                             taxObj.situs=tax.situs;
                             taxObj.taxCollectedFromParty=tax.taxCollectedFromParty;
                             taxObj.taxStructure=tax.taxStructure;
                             taxObj.jurisdictionLevel=tax.jurisdictionLevel;
                             taxObj.jurisdictionId=tax.jurisdictionId;
                             taxObj.JurisdictionValue=tax.JurisdictionValue;
                             taxObj.CalculatedTax =tax.CalculatedTax;
                             taxObj.EffectiveRate =tax.EffectiveRate ;
                             taxObj.Taxable =tax.Taxable ;
                             taxObj.NonTaxable =tax.NonTaxable ;
                             taxObj.impositionId =tax.impositionId ;
                             taxObj.impositionValue=tax.impositionValue ;
                             taxObj.impositionTypeId =tax.impositionTypeId ;
                             taxObj.ImpositionTypevalue =tax.ImpositionTypevalue ;
                             taxObj.TaxRuleId=tax.TaxRuleId ;
                             newObj.Taxes.add(taxObj);
                         }
                        
                        //System.debug('objReturn.DataArea.ProductList____'+objReturn.DataArea.ProductList);
                    }
                    objReturn.DataArea.ProductList.add(newObj);
                    objReturn.errorFlag = false;
                }
            }
                    
                
                
                
            }
            else
            {
                log.Response__c = resAuthWrapper.Response;
                objReturn.errorFlag = true;
                objReturn.errorMsg = resAuthWrapper.errorMessage;
                log.Status__c = 'Failure'; 
                log.Error_Description__c = resAuthWrapper.errorMessage;
            }
        }
        catch(Exception ex)
        {
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c = msg ;
            log.Response__c = resAuthWrapper.Response;
            objReturn.errorFlag = true;
            objReturn.errorMsg = msg;
            log.Status__c = 'Failure';
        }
        objReturn.log = log;
        
        //hard code for dummy return
        
        
       
        return objReturn;
        
        
    }
}