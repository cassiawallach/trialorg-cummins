@isTest
global class Mock_OSM_MuleSoft_MW_Services implements HttpCalloutMock {
    protected String serviceName;
    
    public Mock_OSM_MuleSoft_MW_Services(String serviceName){
        this.serviceName = serviceName;
    }
    
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse httpRes = new HttpResponse();
        httpRes.setHeader('Content-Type', 'application/json');
        if(serviceName == Label.OSM_Vertex_Inv_Service_Name){
            httpRes.setBody('{"DataArea":{"TotalTax":"0.0","ProductList":[{"ProductCode":"1234567-BUS","LineItemTotalTax":"0.0","ProductClassCode":"SW-Web Access","LineItemNumber":"798"}]},"Header":{"Transaction":{"TransactionID":"","InvoiceResponseDocumentNumber":"I-0000000948"}}}');   
        }
        else if(serviceName == Label.OSM_Vertex_Service_Name){
            httpRes.setBody('{"DataArea":{"ProductList":[{"LineItemNumber":"103012","Taxes":[{"TaxRuleId":"","ImpositionValue":"General Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"MINNESOTA","JurisdictionLevel":"STATE","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18122","NonTaxable":"1500.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"NEW ULM","JurisdictionLevel":"CITY","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18215","NonTaxable":"1500.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"BROWN COUNTY TRANSIT TAX AREA","JurisdictionLevel":"DISTRICT","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"101381","NonTaxable":"1500.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"}],"ProductClassCode":"SW-Web Access","Product":"CG-Base-004","LineItemTotalTax":"0.0"},{"LineItemNumber":"2952","Taxes":[{"TaxRuleId":"","ImpositionValue":"General Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"MINNESOTA","JurisdictionLevel":"STATE","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18122","NonTaxable":"720.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"NEW ULM","JurisdictionLevel":"CITY","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18215","NonTaxable":"720.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"BROWN COUNTY TRANSIT TAX AREA","JurisdictionLevel":"DISTRICT","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"101381","NonTaxable":"720.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"}],"ProductClassCode":"SW-Web Access","Product":"CG-Lite-004","LineItemTotalTax":"0.0"},{"LineItemNumber":"2953","Taxes":[{"TaxRuleId":"","ImpositionValue":"General Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"MINNESOTA","JurisdictionLevel":"STATE","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18122","NonTaxable":"3420.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"NEW ULM","JurisdictionLevel":"CITY","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18215","NonTaxable":"3420.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"BROWN COUNTY TRANSIT TAX AREA","JurisdictionLevel":"DISTRICT","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"101381","NonTaxable":"3420.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"}],"ProductClassCode":"SW-Web Access","Product":"CG-Lite-004","LineItemTotalTax":"0.0"}],"TotalTax":"0.0"},"Header":{"Transaction":{"QuotationResponseDocumentNumber":"00000601","TransactionID":""}}}');
        }
        else if(serviceName == Label.OSM_Create_Order_POST){
            httpRes.setBody('{"Header":{"Sender":{"ServiceName":"CreateOrder","SenderID":"Mrktplc"},"Target":{"TargetID":"OMS"}},"CreateOrderOutput":{"OMSOrderID":77903}}');
        }
        else if(serviceName == Label.OSM_Order_Get){
            httpRes.setBody('{"Header":{"Sender": {"ServiceName": "GetOrder","SenderID": "Mrktplc"},"Target": {"TargetID": "OMS"}},"ItemInfoList": {"ItemInfo": [{"LicenseInfo": {"LicenseName": "MR-HD Automotive Pro","ActivationKey": "Z5CWMUXUUFZA"},"ItemId": 78395}]}}');
        }
        else if(serviceName == Label.CSO_IntraCompanyInv){
            httpRes.setBody('{"Header":{"Sender":{"ServiceName":"IntercompanyRequest","SenderID":"Mrktplc"},"Status":"Success","StatusMessage":"success","Target":{"TargetID":"BMS"}},"DataArea":{"DistributorCode":"02850","CustomerCode":"22925","Attribute01":"","Attribute03":"","Attribute02":""}}');
        }        
        else if(serviceName == Label.OSM_SubmitOrder_ServiceName){
            httpRes.setBody('{"header":{"status":"Success","returnCodeDescription":"","sender":{"messageID":"2-c3bd34a1-d376-11ea-9fde-12e0d26de8c8","serviceName":"FSD SubmitOrder","senderId":"Mrktplc"},"target":{"targetId":"ONEBMS"},"location":{"locationId":"02680"}},"dataArea":{"distributorCode":"02680","customerCode":"472849","headerList":{"branchLocation":"07","orderSourceType":"OSMCM","remitToName":"PACIFIC REGION CORPORATE","remitToAddress":"4711 N BASIN AVE (97217)","remitToState":"OR","remitToCity":"PORTLAND","remitToPostalCode":"97217","PdfRemittoAddress":"REMIT TO: Lockbox 138324 POB 398324 San Francisco, CA  94139","purchaseOrderNumber":"0707010312","totalDiscount":"","invoiceTotal":"-1200","invoiceNumber":"1417","orderReferenceNumber":"67710","invoiceDate":"2020-07-31T00:00:00.000-05:00","createDate":"2020-07-31T00:00:00.000-05:00"}}}');
        }
        else if(serviceName == 'Fluidwatch'){
            httpRes.setBody('{"header": {"status": "SUCCESS","returnCodeDescription": "SUCCESS","sender": {"messageID": "1-e674b8e0-eeb2-11ea-9814-024ce88bbcc4","serviceName": "SubmitOrder","senderId": "Marketplace"},"target": {"targetId": "WINLIMS"}}}');
        }
        else if(serviceName == 'BMS_CustomerGetAPI'){
            httpRes.setBody('{"DataArea":[{"LocationAddressline3":"","RequirePO":"Y","AmountDue":"186704.67","CustomerCode":"278840","CreditLimit":"555000","QuoteCustomer":"N","City":"SAN LEANDRO","AvailableCredit":"368295.33","State":"CA","Country":"US","AreaCode":"510","PhoneNumber":"836-6100","PaymentType":"CHARGE","CustomerName":"NORCAL KENWORTH BAY AREA","Postalcode1":"94577","LocationAddressline1":"1755 ADAMS AVE","LocationAddressline2":"","Postalcode2":"1001"}],"Header":{"Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Status":"SUCCESS","Target":{"TargetID":"BMS"},"Location":{"LocationID":"02680-02680"}}}');
        }
        else {
            httpRes.setBody('"Status":"Success","StatusMessage":"success"');
        }
        httpRes.setStatusCode(200);
        return httpRes;
    }
}