public Without Sharing class  dbu_ProcessShippingLabelEmail  implements Queueable {
    private List<dbu_OrderItemShippingLabelEmailData> EmailData = new List<dbu_OrderItemShippingLabelEmailData>();
    private List<ccrz__E_Order__c> orders = new List<ccrz__E_Order__c>();
    
    public dbu_ProcessShippingLabelEmail(List<dbu_OrderItemShippingLabelEmailData> emailData)
    {
        this.EmailData = emailData;
        System.debug('EmailData=>'+JSON.serialize(this.EmailData));
    }
    public void execute(QueueableContext context) {
        for(dbu_OrderItemShippingLabelEmailData item: this.EmailData)
        {
            this.orders.add(sendEmail(item.orderObject,item.template,  item.shippingInstructions, item.contactId,item.owea , item.pdf_ShippingIns , item.localData));
        }
        System.debug('OrderItems to be updated=>'+orders);
        update this.orders;
    }
    private static ccrz__E_Order__c sendEmail(ccrz__E_Order__c orderObj, EmailTemplate emailTemplate, String shippingInstructions, String contactId,OrgWideEmailAddress[] owea , String pdf_ShippingIns, String localData){
        try{
            system.debug('pdf_ShippingIns ' + pdf_ShippingIns);
            String locName;
            String locName2;
            String city;
            String state;
            String zipCode;
            String country;
            String street;
            String countryByName;
            String storeLocationCountry;
            String countryFlag;
            String dropOffLocName;
            String dropOffLocName2;
            String dropOffCity;
            String dropOffState;
            String dropOffCountry;
            String dropOffStreet;
            String dropOffzipCode;
            String lineItemHTML;
            String body;
            String droppLocation;
            boolean flag;
            boolean isShippingLabel;
            Boolean isCountryCanada = false;
            Boolean isNotShippingLabel = false;
            Boolean isDropOffLoc = false;
            List<String> dropOffLoc;
            String orderInformationText;
            String coreOrderInformationText;
            String orderConfirmationCodeText;
            String coreOrderConfirmationCodeText;
            String shipToLocationText;
            String returnOrderItemsText;
            String coreReturnOrderItemsText;
            String productNameText;
            String productQuantityText;
            String returnReasonText;
            String returnMethodText;
            String returnEstimatedAmountText;
            String shipToMethodText;
            String dropOffLocationText;
            String returnOrderInformationText;
            String ShippingLabelText;
            String USAFlag = System.Label.dbu_USFLAG_File;
            String CAFlag = System.Label.dbu_CAFLAG_File;
            String reasonForReturn = System.Label.dbu_Return_Reason_for_Return;
            String reasonDamageInShipping = System.Label.dbu_Return_Damaged_in_shipping;
            String reasonOrderedWronPart = System.Label.dbu_Return_Ordered_the_wrong_part; 
            String reasonPartNoLongerWanted = System.Label.dbu_Return_Part_no_longer_wanted; 
            String reasonInCorrectPart = System.Label.dbu_Return_Incorrect_part_was_received;
            
            
            String reasonDamageInShipping_FR = System.Label.dbu_DamagedInShipping_Pdf_FR;
            String reasonOrderedWronPart_FR = System.Label.dbu_OrderedTheWrongPart_Pdf_FR; 
            String reasonPartNoLongerWanted_FR = System.Label.dbu_reason_partNoLongerWanted_Pdf_FR; 
            String reasonInCorrectPart_FR = System.Label.dbu_IncorrectPartWasReceived_Pdf_FR;
            
            List<TaxSummery> taxSummeryList;
            String taxInnerHtml;
            Decimal totalAmount = 0.00;
            Decimal handlingFees = 0.00;
            Decimal productCost = 0.00;
            String GST_number_Text;
            String GST_Number;
            String currencySign;
            String productCostText;
            String handlingFeesText;
            String taxAndFeesText;
            String totalRefundText;
            String refundDetailsText;
            
            
            if(orderObj.ccrz__CurrencyISOCode__c =='USD' && shippingInstructions != 'core'){
                //countryByName = 'In U.S.A.:';
                // Christopher CECI-1101 Start
                locName = '';
                locName2 = System.Label.dbu_CoreReturnAddress1_US;
                // Christopher CECI-1101 End
                street =System.Label.dbu_CoreReturnStreet_US;
                city =System.Label.dbu_CoreReturnCity_US;
                state =System.Label.dbu_CoreReturnState_US;
                zipCode =System.Label.dbu_CoreReturnZipCode_US;
            }
            if(orderObj.ccrz__CurrencyISOCode__c =='CAD' && shippingInstructions != 'core'){
                // countryByName = 'In Canada:';
                locName = System.Label.dbu_CoreReturnAddress;
                locName2 = System.Label.dbu_CoreReturnAddress1_EN;
                street = System.Label.dbu_CoreReturnStreet_EN;
                city = System.Label.dbu_CoreReturnCity_EN;
                state = System.Label.dbu_CoreReturnState_EN;
                zipCode = System.Label.dbu_CoreReturnZipCode_EN;
            }
            if(orderObj.ccrz__CurrencyISOCode__c =='USD' && shippingInstructions == 'core'){
                //countryByName = 'In U.S.A.:';
                // Christopher CECI-1101 Start
                locName = '';
                locName2 = System.Label.dbu_CoreReturnAddress1_US;
                // Christopher CECI-1101 End
                street =System.Label.dbu_CoreReturnStreet_US;
                city =System.Label.dbu_CoreReturnCity_US;
                state =System.Label.dbu_CoreReturnState_US;
                zipCode =System.Label.dbu_CoreReturnZipCode_US;
            }else if(orderObj.ccrz__CurrencyISOCode__c =='CAD' && shippingInstructions == 'core'){
                //countryByName = 'In Canada:';
                locName = System.Label.dbu_CoreReturnAddress;
                locName2 = System.Label.dbu_CoreReturnAddress1_EN;
                street = System.Label.dbu_CoreReturnStreet_EN;
                city = System.Label.dbu_CoreReturnCity_EN;
                state = System.Label.dbu_CoreReturnState_EN;
                zipCode = System.Label.dbu_CoreReturnZipCode_EN;
            }
            if(localData == 'US' || localData == 'EN'){
                orderInformationText = System.Label.dbu_return_order_information_Eng;
                coreOrderInformationText = System.Label.dbu_CoreReturnInstruction;
                coreOrderConfirmationCodeText = System.Label.dbu_CoreReturnConfirmationInstruction;
                orderConfirmationCodeText = System.Label.dbu_return_confirmation_code_Eng; 
                coreReturnOrderItemsText =System.Label.dbu_CoreReturnInformation;
                shipToLocationText = System.Label.dbu_shipTo_location_pdf_Eng;
                returnOrderItemsText = System.Label.dbu_return_order_items_pdf_Eng;
                productNameText = System.Label.dbu_return_productName_pdf_ENG;
                productQuantityText = System.Label.dbu_return_productQuantity_pdf_ENG;
                returnReasonText = System.Label.dbu_return_reason_Pdf_ENG;
                returnMethodText = System.Label.dbu_return_method_pdf_Eng;
                returnEstimatedAmountText = System.Label.dbu_estimated_refund_amount_Pdf_Eng;
                dropOffLocationText = System.Label.dbu_DropOffLocation_Pdf_Eng;
                returnOrderInformationText = System.Label.dbu_ReturnOrderInformation_Pdf_Eng;
                ShippingLabelText = System.Label.dbu_ShippingLabel_Pdf_Eng;
                GST_number_Text = System.Label.dbu_GST_Number_Text;
                productCostText = System.Label.dbu_Product_Cost_Pdf_Eng;
                handlingFeesText = System.Label.dbu_Handling_Fees_Pdf_Eng;
                taxAndFeesText = System.Label.dbu_Taxes_And_Fees_Pdf_Eng;
                totalRefundText = System.Label.dbu_Total_Refund_Pdf_Eng;
                refundDetailsText = System.Label.dbu_Refund_Details_Pdf_Eng;
                if(localData == 'US'){
                    countryFlag = USAFlag;
                    countryByName = System.Label.dbu_country_return_Pdf_US;
                    GST_Number = System.Label.Dbu_US_GST_Number;
                    currencySign = '$';
                }else if(localData == 'EN'){
                    countryFlag = CAFlag;
                    countryByName = System.Label.dbu_country_return_Pdf_Eng;
                    GST_Number = System.Label.Dbu_Canada_GST_Number;
                    currencySign = 'CAD $';
                }
            }else if(localData == 'FR'){
                countryFlag = CAFlag;
                orderInformationText = System.Label.dbu_return_order_information_FR; 
                coreOrderInformationText = System.Label.dbu_CoreReturnInstruction_FR;
                orderConfirmationCodeText = System.Label.dbu_return_confirmation_code_FR;
                coreOrderConfirmationCodeText = System.Label.dbu_CoreReturnConfirmationInstruction_FR;
                coreReturnOrderItemsText =System.Label.dbu_CoreReturnInformation_FR;
                shipToLocationText = System.Label.dbu_shipTo_location_pdf_FR;
                countryByName = System.Label.dbu_country_return_Pdf_FR;
                returnOrderItemsText = System.Label.dbu_return_order_items_pdf_FR;
                productNameText = System.Label.dbu_return_productName_pdf_FR;
                productQuantityText = System.Label.dbu_return_productQuantity_pdf_FR;
                returnReasonText = System.Label.dbu_return_reason_Pdf_FR;
                returnMethodText = System.Label.dbu_return_method_pdf_FR;
                returnEstimatedAmountText = System.Label.dbu_estimated_refund_amount_Pdf_FR;
                dropOffLocationText = System.Label.dbu_DropOffLocation_Pdf_FR;
                returnOrderInformationText = System.Label.dbu_ReturnOrderInformation_Pdf_FR;
                ShippingLabelText = System.Label.dbu_ShippingLabel_Pdf_FR;
                GST_number_Text = System.Label.dbu_GST_Number_Text_FR;
                GST_Number = System.Label.Dbu_Canada_GST_Number;
                productCostText = System.Label.dbu_Product_Cost_Pdf_FR;
                handlingFeesText = System.Label.dbu_Handling_Fees_Pdf_FR;
                taxAndFeesText = System.Label.dbu_Taxes_And_Fees_Pdf_FR;
                totalRefundText = System.Label.dbu_Total_Refund_Pdf_FR;
                refundDetailsText = System.Label.dbu_Refund_Details_Pdf_FR;
                currencySign = 'CAD $';
            }
            
            for(ccrz__E_OrderItem__c oItem : orderObj.ccrz__E_OrderItems__r){
                String returnReason;
                String shipToCountry;
                if(oItem.ccrz__Price__c !=Null && oItem.ccrz__Quantity__c !=Null){
                    productCost = productCost + oItem.ccrz__Price__c * oItem.ccrz__Quantity__c;
                }
                if(localData == 'FR'){
                    if(oItem.dbu_Reason_for_Return__c == System.Label.dbu_reason_partNoLongerWanted_Pdf_FR){
                        returnReason = System.Label.dbu_reason_partNoLongerWanted_Pdf_FR;
                    }else if(oItem.dbu_Reason_for_Return__c == System.Label.dbu_OrderedTheWrongPart_Pdf_FR){
                        returnReason = System.Label.dbu_OrderedTheWrongPart_Pdf_FR;
                    }else if(oItem.dbu_Reason_for_Return__c == System.Label.dbu_DamagedInShipping_Pdf_FR){
                        returnReason = System.Label.dbu_DamagedInShipping_Pdf_FR;
                    }else if(oItem.dbu_Reason_for_Return__c == System.Label.dbu_IncorrectPartWasReceived_Pdf_FR){
                        returnReason = System.Label.dbu_IncorrectPartWasReceived_Pdf_FR;
                    }else{
                        returnReason = System.Label.dbu_Return_CoreRefund_Pdf_FR;
                    }
                    if(oItem.dbu_Shipto__c == true){
                        shipToMethodText = System.Label.dbu_ShipTo_returnMethod_Pdf_FR;
                    }else{
                        shipToMethodText = System.Label.dbu_DropOff_returnMethod_Pdf_FR;
                    }
                }else{
                    if(oItem.dbu_Reason_for_Return__c == NULL){
                        returnReason = System.Label.dbu_Return_CoreRefund_Pdf_Eng;
                    }else{
                        returnReason = oItem.dbu_Reason_for_Return__c;
                    }
                    
                    if(oItem.dbu_Shipto__c == true){
                        shipToMethodText = System.Label.dbu_ShipTo_returnMethod_Pdf_Eng;
                    }else{
                        shipToMethodText = System.Label.dbu_DropOff_returnMethod_Pdf_Eng;
                    }
                    
                }
                if(oItem.dbu_Estimated_Return_Amount__c != Null){
                    totalAmount = totalAmount + oItem.dbu_Estimated_Return_Amount__c;
                }
                if(oItem.dbu_Reason_for_Return__c == reasonDamageInShipping || oItem.dbu_Reason_for_Return__c == reasonInCorrectPart || oItem.dbu_Reason_for_Return__c == reasonDamageInShipping_FR || oItem.dbu_Reason_for_Return__c == reasonInCorrectPart_FR){
                    isShippingLabel = true;
                }else if(oItem.dbu_Reason_for_Return__c == reasonPartNoLongerWanted || oItem.dbu_Reason_for_Return__c == reasonOrderedWronPart || oItem.dbu_Reason_for_Return__c == reasonPartNoLongerWanted_FR || oItem.dbu_Reason_for_Return__c == reasonOrderedWronPart_FR){
                    isNotShippingLabel = true;
                    if(oItem.ccrz__Price__c != Null && oItem.ccrz__Quantity__c != Null){
                        handlingFees = handlingFees + (oItem.ccrz__Price__c * oItem.ccrz__Quantity__c)*15/100;
                    }
                }
                if(oItem.dbu_Dropoff_Location__c != Null){
                    droppLocation=oItem.dbu_Dropoff_Location__c;
                    
                    if(isDropOffLoc == false){ 
                        isDropOffLoc = true;
                        dropOffLoc = droppLocation.split(',', droppLocation.length());
                        system.debug('dropOffLoc ' + dropOffLoc + ' length ' + droppLocation.length());
                        if(dropOffLoc[0] != Null){
                            if(dropOffLoc[0].contains('and Service')){
                                system.debug('dropOffLoc[0] ' + dropOffLoc[0]);
                                dropOffLocName = dropOffLoc[0].substring(0,dropOffLoc[0].indexOf('Service'));
                                dropOffLocName2 = dropOffLoc[0].substring(dropOffLoc[0].indexOf('Service'));
                            }else if(dropOffLoc[0].contains('& Service')){
                                dropOffLocName = dropOffLoc[0].substring(0,dropOffLoc[0].indexOf('Service'));
                                dropOffLocName2 = dropOffLoc[0].substring(dropOffLoc[0].indexOf('Service'));
                            }else if(dropOffLoc[0].contains('et service')){
                                dropOffLocName = dropOffLoc[0].substring(0,dropOffLoc[0].indexOf('service'));
                                dropOffLocName2 = dropOffLoc[0].substring(dropOffLoc[0].indexOf('service'));
                            }
                            else{
                                dropOffLocName = dropOffLoc[0];
                            }
                        }else{
                            dropOffLocName = '';
                            dropOffLocName2 = '';
                        }
                        if(dropOffLocName2 == NULL){
                            dropOffLocName2 = '';
                        }
                        system.debug('dropOffLocName ' + dropOffLocName);
                        system.debug('dropOffLocName2 ' + dropOffLocName2);
                        if(dropOffLoc[1] != NULL){
                            dropOffCity = dropOffLoc[1];  
                            system.debug('City ' + dropOffCity);
                        }else{
                            dropOffCity = '';
                        }
                        if(dropOffLoc[2] != NULL){
                            dropOffStreet = dropOffLoc[2];
                            system.debug('Street ' + dropOffStreet);
                        }else{
                            dropOffStreet = '';
                        }
                        if(dropOffLoc[3] != null){
                            dropOffState = dropOffLoc[3];
                            system.debug('state ' + dropOffState);
                        }else{
                            dropOffState = '';
                        }
                        system.debug('dropOffLoc[5] ' + dropOffLoc[5]);
                        if(dropOffLoc[5] != null){
                            dropOffzipCode = dropOffLoc[5];
                            system.debug('zipCode ' + dropOffLoc[5]);
                        }
                        if(dropOffLoc[4] != null){
                            system.debug('Country ' + dropOffLoc[4]);
                            shipToCountry = dropOffLoc[4];
                        }
                        
                    }
                }
                if(orderObj.ccrz__ShipTo__r.ccrz__Country__c != NULL){
                    shipToCountry = orderObj.ccrz__ShipTo__r.ccrz__Country__c;
                    system.debug('shipToCountry ' + shipToCountry);
                }
                
                system.debug('oItem.dbu_Shipto__c ' + oItem.dbu_Shipto__c);
                //String taxTable =  '<tr> <td style="vertical-align:top"> hello 1</td> <td style="vertical-align:top">hello 2</td> <td style="vertical-align:top">hello 3</td> <td style="vertical-align:top">hello 4</td> <td style="vertical-align:top">hello 4</td> </tr>';
                
                if(oItem.dbu_Shipto__c == false ){
                    flag = true;
                    if(shipToCountry.equalsIgnoreCase('US') || shipToCountry.equalsIgnoreCase('United States') || shipToCountry.equalsIgnoreCase('U.S.A') || shipToCountry.equalsIgnoreCase('U.S.A.') || shipToCountry.equalsIgnoreCase('USA')){    
                        if(oItem.dbu_Reason_for_Return__c != null){
                            lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+oItem.dbu_Reason_for_Return__c+'</td> <td style="vertical-align:top">'+shipToMethodText+'</td> <td style="vertical-align:top">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                        }
                        else{
                            lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+returnReason+'</td> <td style="vertical-align:top">'+shipToMethodText+'</td> <td style="vertical-align:top">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                        }
                    }else if(shipToCountry.equalsIgnoreCase('CA') || shipToCountry.equalsIgnoreCase('CANADA') && (oItem.dbu_Reason_for_Return__c == reasonPartNoLongerWanted || oItem.dbu_Reason_for_Return__c == reasonOrderedWronPart)){
                        lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+returnReason+'</td> <td style="vertical-align:top">'+shipToMethodText+'</td> <td style="vertical-align:top">'+'CAD $'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                    }else if(shipToCountry.equalsIgnoreCase('CA') || shipToCountry.equalsIgnoreCase('CANADA')){
                        lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+returnReason+'</td> <td style="vertical-align:top">'+shipToMethodText+'</td> <td style="vertical-align:top">'+'CAD $'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                    }
                }else{
                    flag = false;
                    
                    if(shipToCountry.equalsIgnoreCase('US') || shipToCountry.equalsIgnoreCase('United States') || shipToCountry.equalsIgnoreCase('U.S.A') || shipToCountry.equalsIgnoreCase('U.S.A.') || shipToCountry.equalsIgnoreCase('USA')){
                        if(oItem.dbu_Reason_for_Return__c != Null){
                            lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+returnReason+'</td> <td style="vertical-align:top">Ship To</td> <td style="vertical-align:top">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                        }
                        else{
                            lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+returnReason+'</td> <td style="vertical-align:top">Ship To</td> <td style="vertical-align:top">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                        }
                        
                    }else if((shipToCountry.equalsIgnoreCase('CA') || shipToCountry.equalsIgnoreCase('CANADA')) && (oItem.dbu_Reason_for_Return__c == reasonPartNoLongerWanted || oItem.dbu_Reason_for_Return__c == reasonOrderedWronPart)){
                        lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+returnReason+'</td> <td style="vertical-align:top">'+shipToMethodText+'</td> <td style="vertical-align:top">'+'CAD $'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                    }else if((shipToCountry.equalsIgnoreCase('CA') || shipToCountry.equalsIgnoreCase('CANADA')) ){
                        lineItemHTML=lineItemHTML + '<tr> <td style="vertical-align:top">'+oItem.ccrz__Product_Name__c + '</td> <td style="vertical-align:top">'+oItem.ccrz__Quantity__c+'</td> <td style="vertical-align:top">'+returnReason+'</td> <td style="vertical-align:top">'+shipToMethodText+'</td> <td style="vertical-align:top">'+'CAD $'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td> </tr>';
                    }
                }
            }
            
            taxSummeryList = dbu_TaxSummaryCtrl.getOderTax(orderObj.id);
            system.debug('taxSummeryList ' + taxSummeryList);
            if(!taxSummeryList.isEmpty()){
                for(TaxSummery taxObj : taxSummeryList){
                    taxInnerHtml = taxInnerHtml + '<tr><td align="left">'+taxObj.TaxType+'('+taxObj.taxPercentage+'%):</td><td align="right">'+currencySign+''+taxObj.calculatedTax.setScale(2)+'</td></tr>';
                }
            }
			
			String  TaxTable;           
            if(!taxSummeryList.isEmpty()){
                 TaxTable ='<h3 style="margin:0 0 5px 0"><strong>'+refundDetailsText+':</strong></h3><br /><table   border="0" cellpadding="0" cellspacing="0" width="100%" ><tr> <td style="width:70%" width="70%"> <table border="1" cellpadding="5" width="100%"> <tr><td style="width:70%" width="70%">'+productCostText+':</td><td align="right" width="30%">'+currencySign+''+productCost.setScale(2)+'</td></tr>  <tr><td align="left">'+handlingFeesText+':</td><td align="right">'+currencySign+''+handlingFees.setScale(2)+'</td></tr> <tr><td colspan="2"><strong>'+taxAndFeesText+':</strong></td></tr>'+taxInnerHtml+'<tr><td align="left"><strong>'+totalRefundText+':</strong></td><td align="right">'+currencySign+''+totalAmount.setScale(2)+'</td></tr></table></td><td style="width:30%" width="30%">&nbsp;</td></tr></table>';
            }else{
                 TaxTable ='<h3 style="margin:0 0 5px 0"><strong>'+refundDetailsText+':</strong></h3><br /><table   border="0" cellpadding="0" cellspacing="0" width="100%" ><tr> <td style="width:70%" width="70%"> <table border="1" cellpadding="5" width="100%"> <tr><td style="width:70%" width="70%">'+productCostText+':</td><td align="right" width="30%">'+currencySign+''+productCost.setScale(2)+'</td></tr>  <tr><td align="left">'+handlingFeesText+':</td><td align="right">'+currencySign+''+handlingFees.setScale(2)+'</td></tr> <tr><td colspan="2"></td></tr>'+taxInnerHtml+'<tr><td align="left"><strong>'+totalRefundText+':</strong></td><td align="right">'+currencySign+''+totalAmount.setScale(2)+'</td></tr></table></td><td style="width:30%" width="30%">&nbsp;</td></tr></table>';
            }
            //String TaxTable ='<h3 style="margin:0 0 5px 0"><strong>'+refundDetailsText+':</strong></h3><br /><table   border="0" cellpadding="0" cellspacing="0" width="100%" ><tr> <td style="width:70%" width="70%"> <table border="1" cellpadding="5" width="100%"> <tr><td style="width:70%" width="70%">'+productCostText+':</td><td align="right" width="30%">'+currencySign+''+productCost.setScale(2)+'</td></tr>  <tr><td align="left">'+handlingFeesText+':</td><td align="right">'+currencySign+''+handlingFees.setScale(2)+'</td></tr> <tr><td colspan="2"><strong>'+taxAndFeesText+':</strong></td></tr>'+taxInnerHtml+'<tr><td align="left"><strong>'+totalRefundText+':</strong></td><td align="right">'+currencySign+''+totalAmount.setScale(2)+'</td></tr></table></td><td style="width:30%" width="30%">&nbsp;</td></tr></table>';
            
            if(flag == True && shippingInstructions != 'core'){
                if(GST_Number == 'null'){
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+orderInformationText+'</h1><br /><br /> <p>'+orderConfirmationCodeText+' : '+orderObj.Name+'</p> <table cellpadding="2" style="margin-left: -10px;"> <tr>  <td style="vertical-align:top; text-align: left;"> <strong>'+dropOffLocationText+ '</strong><br /> '+countryByName+'<br /> '+dropOffLocName+'<br /> '+dropOffLocName2+'<br /> '+dropOffStreet+'<br /> '+dropOffCity +',  '+dropOffState+' '+ dropOffzipCode +' </td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+returnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }else{
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+orderInformationText+'</h1><br /><br /> <p>'+orderConfirmationCodeText+' : '+orderObj.Name+'</p> <table cellpadding="0" border="0" cellspacing="0" width="100%"> <tr>  <td style="text-align:left" width="70%" valign="top"> <strong>'+dropOffLocationText+'</strong><br /> '+countryByName+'<br /> '+dropOffLocName+'<br /> '+dropOffLocName2+'<br /> '+dropOffStreet+'<br /> '+dropOffCity +',  '+dropOffState+' '+ dropOffzipCode +' </td><td width="30%" style="text-align:left" valign="top"><strong>'+GST_number_Text+'</strong><br />'+GST_Number+'</td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+returnOrderItemsText+'</strong</h3> <table border="1" cellpadding="5">';
                }
                body = body + '<thead> <tr> <th style="text-align:left;vertical-align:top"><strong>'+productNameText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+productQuantityText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnReasonText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnMethodText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnEstimatedAmountText+'</strong></th> </tr> </thead><tbody>';
                body = body + lineItemHTML + '</tbody></table> <br />' + TaxTable;
                body = body + pdf_ShippingIns + '</body></html>';
                system.debug('drop off body ' + body);
            }else if(flag == True && shippingInstructions == 'core'){
                if(GST_Number == 'null'){
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+coreOrderInformationText+'</h1><br /><br /> <p>'+coreOrderConfirmationCodeText+''+orderObj.Name+'</p> <table cellpadding="2" style="margin-left: -10px;"> <tr>  <td style="vertical-align:top; text-align: left;"> <strong>'+dropOffLocationText+'</strong>  <br /> '+countryByName+'<br /> '+dropOffLocName+'<br /> '+dropOffLocName2+'<br /> '+dropOffStreet+'<br /> '+dropOffCity +',  '+dropOffState+' '+ dropOffzipCode +' </td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+coreReturnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }else{
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+coreOrderInformationText+'</h1><br /><br /> <p>'+coreOrderConfirmationCodeText+''+orderObj.Name+'</p> <table cellpadding="0" border="0" cellspacing="0" width="100%"> <tr>  <td style="text-align:left" width="70%" valign="top"> <strong>'+dropOffLocationText+'</strong>'+GST_number_Text+'</strong>'+GST_Number+'<br /> '+countryByName+'<br /> '+dropOffLocName+'<br /> '+dropOffLocName2+'<br /> '+dropOffStreet+'<br /> '+dropOffCity +',  '+dropOffState+' '+ dropOffzipCode +' </td>><td width="30%" style="text-align:left" valign="top"><strong>'+GST_number_Text+'</strong><br />'+GST_Number+'</td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+coreReturnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }
                body = body + '<thead> <tr> <th style="text-align:left;vertical-align:top"><strong>'+productNameText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+productQuantityText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnReasonText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnMethodText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnEstimatedAmountText+'</strong></th> </tr> </thead><tbody>';
                body = body + lineItemHTML + '</tbody></table>' + TaxTable;
                body = body + pdf_ShippingIns + '</body></html>';
            }else if(flag == false && shippingInstructions == 'core'){
                if(GST_Number == 'null'){
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+coreOrderInformationText+'</h1><br /><br /> <p>'+coreOrderConfirmationCodeText+''+orderObj.Name+'</p> <table cellpadding="2" style="margin-left: -10px;"> <tr>  <td style="vertical-align:top; text-align: left;"> <strong>'+shipToLocationText+'</strong> <br /> ' +countryByName+'<br /> '+locName+'<br /> '+ locName2 +'<br />'+street+'<br /> '+city +'  '+state+ ' '+zipCode+' </td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+coreReturnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }else{
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+coreOrderInformationText+'</h1><br /><br /> <p>'+coreOrderConfirmationCodeText+''+orderObj.Name+'</p> <table cellpadding="0" border="0" cellspacing="0" width="100%"> <tr>  <td style="text-align:left" width="70%" valign="top"> <strong>'+shipToLocationText+  '</strong><br />'+countryByName+'<br /> '+locName+'<br /> '+ locName2 +'<br />'+street+'<br /> '+city +'  '+state+ ' '+zipCode+' </td><td width="30%" style="text-align:left" valign="top"><strong>'+GST_number_Text+'</strong><br />'+GST_Number+'</td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+coreReturnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }
                body = body + '<thead> <tr> <th style="text-align:left;vertical-align:top"><strong>'+productNameText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+productQuantityText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnReasonText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnMethodText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnEstimatedAmountText+'</strong></th> </tr> </thead><tbody>';
                body = body + lineItemHTML + '</tbody></table>' + TaxTable;
                body = body + pdf_ShippingIns + '</body></html>';
            }else if(flag == false && isNotShippingLabel == true){
                if(GST_Number == 'null'){
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+orderInformationText+'</h1><br /><br /> <p>'+orderConfirmationCodeText+' : '+orderObj.Name+'</p> <table cellpadding="2" style="margin-left: -10px;"> <tr>  <td style="vertical-align:top; text-align: left;"> <strong>'+shipToLocationText+'</strong> <br /> '+countryByName+'<br /> '+locName+'<br /> '+ locName2 +'<br />'+street+'<br /> '+city +'  '+state+ ' '+zipCode+' </td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+returnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }else{
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+orderInformationText+'</h1><br /><br /> <p>'+orderConfirmationCodeText+' : '+orderObj.Name+'</p> <table cellpadding="0" border="0" cellspacing="0" width="100%"> <tr>  <td style="text-align:left" width="70%" valign="top"> <strong>'+shipToLocationText+'</strong><br /> '+countryByName+'<br /> '+locName+'<br /> '+ locName2 +'<br />'+street+'<br /> '+city +'  '+state+ ' '+zipCode+' </td><td width="30%" style="text-align:left" valign="top"><strong>'+GST_number_Text+'</strong><br />'+GST_Number+'</td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+returnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }
                body = body + '<thead> <tr> <th style="text-align:left;vertical-align:top"><strong>'+productNameText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+productQuantityText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnReasonText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnMethodText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnEstimatedAmountText+'</strong></th> </tr> </thead><tbody>';
                body = body + lineItemHTML + ' </tbody> </table> <br />' + TaxTable;
                body = body + pdf_ShippingIns + '</body></html>';
            }
            else{
                
                if(GST_Number == 'null'){
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+orderInformationText+'</h1><br /><br /> <p>'+orderConfirmationCodeText+' : '+orderObj.Name+'</p> <table cellpadding="2" style="margin-left: -10px;"> <tr>  <td style="vertical-align:top; text-align: left;"> <strong>'+shipToLocationText+'</strong> <br /> '+countryByName+'<br /> '+locName+'<br /> '+locName2+'<br />'+street+'<br /> '+city +'  '+state+ ' '+zipCode+' </td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+returnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }else{
                    body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"><br/> <h1 style="text-align:center">'+orderInformationText+'</h1><br /><br /> <p>'+orderConfirmationCodeText+' : '+orderObj.Name+'</p> <table cellpadding="0" border="0" cellspacing="0" width="100%"> <tr>  <td style="text-align:left" width="70%" valign="top"> <strong>'+shipToLocationText+'</strong><br /> '+countryByName+'<br /> '+locName+'<br /> '+locName2+'<br />'+street+'<br /> '+city +'  '+state+ ' '+zipCode+' </td><td width="30%" style="text-align:left" valign="top"><strong>'+GST_number_Text+'</strong><br />'+GST_Number+'</td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0"><strong>'+returnOrderItemsText+'</strong></h3> <table border="1" cellpadding="5">';
                }
                body = body + '<thead> <tr> <th style="text-align:left;vertical-align:top"><strong>'+productNameText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+productQuantityText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnReasonText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnMethodText+'</strong></th> <th style="text-align:left;vertical-align:top"><strong>'+returnEstimatedAmountText+'</strong></th> </tr> </thead><tbody>';
                body = body + lineItemHTML + ' </tbody> </table> <br />' + TaxTable;
                body = body + pdf_ShippingIns + '</body></html>';
                system.debug('New body ' + body);
            }   
            // body = '<html> <body> <img src="https://cumminscss--fulluat--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0681b000000qi4A&operationContext=DELIVERY&contentId=05T1b000004iLmF&page=0&d=/a/1b00000006Dc/IUiMrNDNZqgeotFifZWEc5sgFdNqhiWlDl5zemVmcbM&oid=00D1b000000Dd2W&dpt=null&viewId=" alt="Cummins" width="40" height="40"> <br/> <h1 style="text-align:center">shop.cummins.com Return Order Information</h1> <br /> <br /> <p>Return Confirmation Code : O-0000000714</p> <table cellpadding="0" border="0" cellspacing="0" width="100%"> <tr> <td style="text-align:left" width="70%" valign="top"> <strong>Drop off Location:</strong><br /> In U.S.A.:<br /> Cummins Sales & Service - Fairbanks<br /> 1921 Sanduri Avenue<br /> Fairbanks, AK 99701</td> <td width="30%" style="text-align:left" valign="top"> <strong>GST Number</strong><br/> GST20492s9849x84gb3434 </td> </tr> </table> <br /> <h3 style="margin:0 0 5px 0">Return order items:</h3> <table border="1" cellpadding="5"> <thead> <tr> <th style="text-align:left;vertical-align:top" valign="top"><strong>Product</strong> </th> <th style="text-align:left;vertical-align:top" valign="top"><strong>Quantity</strong> </th> <th style="text-align:left;vertical-align:top" valign="top"><strong>Reason for Return</strong> </th> <th style="text-align:left;vertical-align:top" valign="top"><strong>Return method</strong> </th> <th style="text-align:left;vertical-align:top" valign="top"><strong>Estimated refund amount</strong> </th> </tr> </thead> <tbody> <tr> <td style="vertical-align:top">Cummins 4952223CLAMP,WIRE TIE</td> <td style="vertical-align:top">1</td> <td style="vertical-align:top">Damaged in shipping</td> <td style="vertical-align:top">Drop Off</td> <td style="vertical-align:top">$81.90</td> </tr> </tbody> </table> <br /> <h3 style="margin:0 0 5px 0">Refund Details:</h3> <table border="0" cellpadding="0" cellspacing="0" width="100%"> <tr> <td style="width:70%" width="70%" ><table border="1" cellpadding="5" width="100%"> <tr> <td align="left" width="70%" >Product Cost:</td> <td align="right" width="30%">$90.00</td> </tr> <tr> <td align="left">Handling Fees:</td> <td align="right">$0.00</td> </tr> <tr> <td colspan="2"><strong>Taxes and Fees:</strong> </td> </tr> <tr> <td align="left">&nbsp;&nbsp;&nbsp; Retail Sales and Use Tax(4.3%):</td> <td align="right">$7.74</td> </tr> <tr> <td align="left">&nbsp;&nbsp;&nbsp; Local Sales and Use Tax(1.7%):</td> <td align="right">$3.06</td> </tr> <tr> <td align="left"><strong>Total Refund:</strong> </td> <td align="right"><strong>$81.90</strong></td> </tr> </table></td> <td style="width:30%" width="30%" >&nbsp;</td> </tr> </table> <h4><strong>Here is what you need to do next:</strong></h4> <ul> <li>Pack the item(s) you are returning.</li> <li>Print this return document and pack inside return package.</li> <li>Drop off at the Cummins location you selected above.</li> </ul> <h4>Reminders:</h4> <ul> <li>Eligible parts can be returned for up to 30 days from the date of purchase. Products purchased on shop.cummins.com must be returned in saleable condition — in other words, unused, in the original packaging, and undamaged. Please note, all accepted returns will incur a 15% handling fee.</li> <li>We will let you know when your return is received and a decision on approval or rejection has been made.</li> </ul> </body> </html>'; 
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            List<Messaging.EmailFileAttachment> attchaments = new List<Messaging.EmailFileAttachment>();
            if(flag == false && isShippingLabel == true ){
                
                Blob labelBody = EncodingUtil.base64Decode(orderObj.dbu_Shipping_Label__c);
                Messaging.EmailFileAttachment LabelAttach = new Messaging.EmailFileAttachment();
                LabelAttach.setContentType('application/pdf');
                LabelAttach.setFileName(ShippingLabelText+'.pdf');
                LabelAttach.Body = labelBody;
                attchaments.add(LabelAttach);
                
                Messaging.EmailFileAttachment sippingAttach = new Messaging.EmailFileAttachment();
                sippingAttach.setContentType('application/pdf');
                sippingAttach.setFileName(returnOrderInformationText +'.pdf');
                sippingAttach.Body = Blob.toPDF(body);
                attchaments.add(sippingAttach);
            }else if(flag == false && isShippingLabel == false && isNotShippingLabel == true){
                Messaging.EmailFileAttachment sippingAttach = new Messaging.EmailFileAttachment();
                sippingAttach.setContentType('application/pdf');
                sippingAttach.setFileName(returnOrderInformationText +'.pdf');
                sippingAttach.Body = Blob.toPDF(body);
                attchaments.add(sippingAttach);
            }
            else{
                Messaging.EmailFileAttachment sippingAttach = new Messaging.EmailFileAttachment();
                sippingAttach.setContentType('application/pdf');
                sippingAttach.setFileName(returnOrderInformationText +'.pdf');
                sippingAttach.Body = Blob.toPDF(body);
                attchaments.add(sippingAttach);
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setToAddresses(new String[] {'ranadipjha@outlook.com'});
            
            String[] toaddress = new String[]{}; 
                toaddress.add(orderObj.ccrz__BuyerEmail__c);
            if(orderObj.ccrz__Contact__c == null){
                mail.setToAddresses(toaddress);
                mail.setTargetObjectId(contactId);
                mail.setTreatTargetObjectAsRecipient(false); //INC3850360
            }else{
                mail.setTargetObjectId(orderObj.ccrz__Contact__c); 
            }
            if(flag == true && droppLocation != NULL){
                String htmlBody = emailTemplate.HtmlValue; 
                String emailSubject = emailTemplate.Subject;
                system.debug('subject ' + emailTemplate.Subject);
                if(countryByName != NULL){
                    htmlBody = htmlBody.replace('Apex_countryByName', countryByName);
                }else{
                    htmlBody = htmlBody.replace('Apex_countryByName', '');
                }
                
                if(locName != NUll){
                    htmlBody = htmlBody.replace('Apex_DropOfflocName1', dropOffLocName);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOfflocName1', '');
                }
                
                if(locName2 != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOfflocName2', dropOffLocName2);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOfflocName2', '');
                }
                
                if(street != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffstreet', dropOffStreet);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffstreet', '');
                }
                
                if(city != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffcity', dropOffCity);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffcity', '');
                }
                
                if(state != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffstate', dropOffState);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffstate', '');
                }
                
                if(dropOffzipCode != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffzipCode', dropOffzipCode);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffzipCode', '');
                }
                htmlBody = htmlBody.replace('Apex_FLAG', countryFlag);
                htmlBody = htmlBody.replace('{!ccrz__E_Order__c.ccrz__BuyerFirstName__c}', orderObj.ccrz__BuyerFirstName__c);
                htmlBody = htmlBody.replace('{!ccrz__E_Order__c.ccrz__OrderName__c}', orderObj.Name);
                mail.setSubject(emailSubject);
                mail.setHtmlBody(htmlBody);
            }else if(flag == false && shippingInstructions == 'core'){
                String htmlBody = emailTemplate.HtmlValue; 
                String emailSubject = emailTemplate.Subject;
                system.debug('subject core ' + emailTemplate.Subject);
                if(countryByName != NULL){
                    htmlBody = htmlBody.replace('Apex_countryByName', countryByName);
                }else{
                    htmlBody = htmlBody.replace('Apex_countryByName', '');
                }
                
                if(locName != NUll){
                    htmlBody = htmlBody.replace('Apex_DropOfflocName1', locName);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOfflocName1', '');
                }
                
                if(locName2 != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOfflocName2', locName2);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOfflocName2', '');
                }
                
                if(street != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffstreet', street);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffstreet', '');
                }
                
                if(city != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffcity', city);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffcity', '');
                }
                
                if(state != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffstate', state);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffstate', '');
                }
                
                if(zipCode != NULL){
                    htmlBody = htmlBody.replace('Apex_DropOffzipCode', zipCode);
                }else{
                    htmlBody = htmlBody.replace('Apex_DropOffzipCode', '');
                }
                htmlBody = htmlBody.replace('Apex_FLAG', countryFlag);
                htmlBody = htmlBody.replace('{!ccrz__E_Order__c.ccrz__BuyerFirstName__c}', orderObj.ccrz__BuyerFirstName__c);
                htmlBody = htmlBody.replace('{!ccrz__E_Order__c.ccrz__OrderName__c}', orderObj.Name);
                mail.setSubject(emailSubject);
                mail.setHtmlBody(htmlBody);
            }
            
            mail.setWhatId(orderObj.Id);
            mail.setOrgWideEmailAddressId(owea[0].Id);
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);
            mail.setTemplateID(emailTemplate.Id);
            mail.setFileAttachments(attchaments); 
            
            mails.add(mail);
            if(!mails.isEmpty()){
                Messaging.SendEmail(mails);   
            } 
            if(isShippingLabel == true && flag == false){
                orderObj.dbu_IsShippingLabelSent__c = true;
            }
        }
        catch(Exception e)
        {
            system.debug('erroe ' + e.getMessage());
            system.debug('erroe line no  ' + e.getLineNumber());
            orderObj.dbu_IsShippingLabelSent__c = false;
        }
        return orderObj;
    }
}