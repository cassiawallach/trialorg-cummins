/************************************************************
Name:  OSM_BAMS_WS_Service
    
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:
This is the service helper which has util methods to create the 
request and parse the responses.

=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vaibhav            79/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_BAMS_WS_ServiceHelper{

    
/** createXMLRequestForRefund
     * This will create the XML request to be fired to the BAMS
	 * @param Order detail wrapper
     * @return SOAP Request
     */

     public static string createXMLRequestForRefund(OSM_BAMS_WS_GeneralizedInputWrapper inpWrapper){
            
            String username;
            String Password;            
            String merchantID = inpWrapper.merchantID;
            String merchantReferenceCode = inpWrapper.merchantReferenceCode;
            String PTcurrency = inpWrapper.PTcurrency;
            Decimal grandTotalAmount = inpWrapper.grandTotalAmount;
            String subscriptionID = inpWrapper.subscriptionID;
            
            username = label.OSM_BAMS_UserName;
            Password = label.OSM_BAMS_PassWord;
        
            String XMLrequest = '<?xml version="1.0" encoding="UTF-8"?>'
                    +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
                    +'<soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
                    +'<wsse:UsernameToken>'
                    +'<wsse:Username>'+username+'</wsse:Username>'
                    +'<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'+Password+'</wsse:Password>'
                    +'</wsse:UsernameToken>'
                    +'</wsse:Security>'
                    +'</soapenv:Header>'
                    +'<soapenv:Body>'
                    +'<requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-1.92">'
                    +'<merchantID>'+merchantID+'</merchantID>'
                    +'<merchantReferenceCode>'+merchantReferenceCode+'</merchantReferenceCode>'
                    +'<purchaseTotals>'
                    +'<currency>'+PTcurrency+'</currency>'
                    +'<grandTotalAmount>'+grandTotalAmount+'</grandTotalAmount>'
                    +'</purchaseTotals>'
                    +'<ccCreditService run="true">'
                   // +'<subscriptionID>'+subscriptionID+'</subscriptionID>'
                    +'<captureRequestID>'+subscriptionID+'</captureRequestID>'
                    +'</ccCreditService>'
                   // +'<ccAuthService run="true"/>'
                   // + '<ccCaptureService run="true" />'
                    +'</requestMessage>'
                    +'</soapenv:Body>'
                    +'</soapenv:Envelope>';
            
            system.debug('XMLrequest'+XMLrequest);
            return XMLrequest; 
           //return null; 
            }
    
    /** parseBAMSResponseForRefund
     * This will parse the XML request to wrapper obj
	 * @param SOAP Response
     * @return Wrapper object
     */
     public static OSM_BAMS_OrderRefundNodes parseBAMSResponseForRefund(String resStr){
        
        system.debug('resStr'+resStr);
        
        OSM_BAMS_OrderRefundNodes resWrapper = new OSM_BAMS_OrderRefundNodes();
        
        //String xmlBody = resStr.substring(44); //Commented by Pooja as we are directly passing responsebody
        //system.debug('xmlBody'+xmlBody); //Commented by Pooja as we are directly passing responsebody
        
        Dom.Document domdoc = new Dom.Document();
        system.debug('domdoc'+domdoc);
        
        //domdoc.load(xmlBody); //Commented by Pooja as we are directly passing responsebody
        domdoc.load(resStr); //Added by Pooja
        system.debug('domdoc'+domdoc);
        
        dom.XmlNode xroot = domdoc.getrootelement() ;
        dom.XmlNode[] xrec = xroot.getchildelements() ; //Get all Record Elements
            
        system.debug('xrec'+xrec);
        ccrz__E_TransactionPayment__c cctpayment = new ccrz__E_TransactionPayment__c();
        
        //create labels for these fields - OSM_BAMS_XXX
        for(Dom.XMLNode child : xrec){ //Loop Through Records
            for(Dom.XMLNode level1 : child.getchildren()){
                if(level1.getname() == label.OSM_BAMS_Security){
                    system.debug('Security-Child Nodes Below'+level1.gettext());
                    resWrapper.Security = level1.gettext();
                    for(Dom.XMLNode level2 : level1.getchildren()){
                        if(level2.getname() == label.OSM_BAMS_TimeStamp){
                            system.debug('Timestamp-Child Nodes Below'+level2.gettext());
                            resWrapper.Timestamp = level2.gettext();
                            for(Dom.XMLNode level3 :level2.getchildren()){
                                if(level3.getname() == label.OSM_BAMS_Created){
                                    system.debug('Created'+level3.gettext());
                                    resWrapper.Created = level3.gettext();
                                }   
                            }
                        }       
                    }
                }
                
                if(level1.getname() == label.OSM_BAMS_replyMessage){
                    system.debug('replyMessage-Child Nodes Below'+level1.gettext());
                    resWrapper.replyMessage = level1.gettext();
                    for(Dom.XMLNode level2 : level1.getchildren()){
                        if(level2.getname() == label.OSM_BAMS_merchantReferenceCode){
                            system.debug('merchantReferenceCode'+level2.gettext());
                            resWrapper.merchantReferenceCode = level2.gettext();
                        }
                        if(level2.getname() == label.OSM_BAMS_requestID){
                            system.debug('requestID'+level2.gettext());
                            resWrapper.requestID = level2.gettext();
                        }
                        if(level2.getname() == label.OSM_BAMS_decision){
                            system.debug('decision'+level2.gettext());
                            resWrapper.decision = level2.gettext();
                        }
                        if(level2.getname() == label.OSM_BAMS_reasonCode){
                            system.debug('reasonCode'+level2.gettext());
                            resWrapper.reasonCode = level2.gettext();
                        }
                        if(level2.getname() == label.OSM_BAMS_requestToken){
                            system.debug('requestToken'+level2.gettext());
                            resWrapper.requestToken = level2.gettext();
                        }
                        if(level2.getname() == label.OSM_BAMS_purchaaseTotals){
                            system.debug('purchaseTotals-Child Nodes Below'+level2.gettext());
                            resWrapper.purchaseTotals = level2.gettext();
                            for(Dom.XMLNode level3 :level2.getchildren()){
                                if(level3.getname() == label.OSM_BAMS_currency){
                                    system.debug('currency'+level3.gettext());
                                    resWrapper.currency_pt = level3.gettext();
                                }
                            }
                        }
                        if(level2.getname() == label.OSM_BAMS_ccAuthReply){
                            system.debug('ccAuthReply-Child Nodes Below'+level2.gettext());
                            resWrapper.ccAuthReply = level2.gettext();
                            for(Dom.XMLNode level3 :level2.getchildren()){
                                if(level3.getname() == label.OSM_BAMS_reasonCode){
                                    system.debug('reasonCode'+level3.gettext());
                                    resWrapper.reasonCode_ccAuth = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_amount){
                                    system.debug('amount'+level3.gettext());
                                    resWrapper.amount_ccAuth = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_authorizationCode){
                                    system.debug('authorizationCode'+level3.gettext());
                                    resWrapper.authorizationCode = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_avsCode){
                                    system.debug('avsCode'+level3.gettext());
                                    resWrapper.avsCode = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_avsCodeRaw){
                                    system.debug('avsCodeRaw'+level3.gettext());
                                    resWrapper.avsCodeRaw = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_authorizedDateTime){
                                    system.debug('authorizedDateTime'+level3.gettext());
                                    resWrapper.authorizedDateTime = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_processorResponse){
                                    system.debug('processorResponse'+level3.gettext());
                                    resWrapper.processorResponse = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_reconciliationID){
                                    system.debug('reconciliationID'+level3.gettext());
                                    resWrapper.reconciliationID_ccAuth = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_accountBalance){
                                    system.debug('accountBalance'+level3.gettext());
                                    resWrapper.accountBalance = level3.gettext();
                                }
                                if(level3.getname() == 'ownerMerchantID'){
                                    system.debug('ownerMerchantID'+level3.gettext());
                                    resWrapper.ownerMerchantID = level3.gettext();
                                }                               
                            }
                        }
                        if(level2.getname() == label.OSM_BAMS_ccCaptureReply){
                            system.debug('ccCaptureReply-Child Nodes Below'+level2.gettext());
                            resWrapper.ccCaptureReply = level2.gettext();
                            for(Dom.XMLNode level3 :level2.getchildren()){
                                if(level3.getname() == label.OSM_BAMS_reasonCode){
                                    system.debug('reasonCode'+level3.gettext());
                                    resWrapper.reasonCode_ccCap = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_requestDateTime){
                                    system.debug('requestDateTime'+level3.gettext());
                                    resWrapper.requestDateTime = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_amount){
                                    system.debug('amount'+level3.gettext());
                                    resWrapper.amount_ccCap = level3.gettext();
                                }
                                if(level3.getname() == label.OSM_BAMS_reconciliationID){
                                    system.debug('reconciliationID'+level3.gettext());
                                    resWrapper.reconciliationID_ccCap = level3.gettext();
                                }                               
                            }//End of level 3
                        }                       
                    }//End of level 2
                }  
            }//End of level 1
        }
        return resWrapper;  
    }
    
     /** parseFailedBAMSResponseForRefund
     * This will parse the failed XML request to wrapper obj
	 * @param SOAP Response
     * @return Wrapper object
     */
    public static OSM_BAMS_OrderRefundNodes parseFailedBAMSResponseForRefund(String resStr){
        
        system.debug('resStr'+resStr);
        
        OSM_BAMS_OrderRefundNodes resWrapper = new OSM_BAMS_OrderRefundNodes();
        
        //String xmlBody = resStr.substring(63); //Commented by Pooja as we are directly passing responsebody
        //system.debug('xmlBody'+xmlBody); //Commented by Pooja as we are directly passing responsebody
        
        Dom.Document domdoc = new Dom.Document();
        system.debug('domdoc'+domdoc);
        
        domdoc.load(resStr); //Added by Pooja
        system.debug('domdoc'+domdoc);
        
        dom.XmlNode xroot = domdoc.getrootelement() ;
        dom.XmlNode[] xrec = xroot.getchildelements() ; //Get all Record Elements
            
        system.debug('xrec'+xrec);
        
        
       for(Dom.XMLNode child : xrec){ //Loop Through Records
            for(Dom.XMLNode level1 : child.getchildren()){
                if(level1.getname() == label.OSM_BAMS_Fault){
                    System.debug('Fault'+level1.getText());
                    resWrapper.Fault = level1.gettext();
                }
                for(Dom.XMLNode level2 : level1.getchildren()){
                    if(level2.getname() == label.OSM_BAMS_faultcode){
                        System.debug('faultcode'+level2.getText());
                        resWrapper.faultcode = level2.gettext();
                    }
                    if(level2.getname() == label.OSM_BAMS_faultstring){
                        System.debug('faultstring'+level2.getText());
                        resWrapper.faultstring = level2.gettext();
                    }
                }
            }   
        }
        return resWrapper;
    }   

    
}