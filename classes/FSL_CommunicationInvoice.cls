@RestResource(urlMapping='/Communications/Text/CommunicationContacts/*')
global class FSL_CommunicationInvoice {
    @HttpPOST
    global static ResponseDataAreaWrapper doPostOperation() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String reqBody = req.requestBody.toString();
        System.debug('reqBody :' + reqBody);
        
        CommunicationContactsWrapper ccw = (CommunicationContactsWrapper)JSON.deserialize(reqBody, CommunicationContactsWrapper.class);
        System.debug('ccw :' + ccw);
        
        //get the contacts from contact Ids list and update each of them with 'Invoice Ready' on status field
        System.debug('Contact List :' + ccw.DataArea.ContactIds);

        Map<String, Boolean> socIDMap = new Map<String, Boolean>();
        Set<String> socIDSet = new set<String>();
        List<String> contactIDsFromJSON = ccw.DataArea.ContactIDS;//1,2,2,3
        //Make the list into set so as to perform contains and also to get only unique values
        Set<String> contactIDsJSONSet = new Set<String>();
        if(contactIDsFromJSON != null) contactIDsJSONSet.addAll(contactIDsFromJSON);//1,2,3
        
        String cSSJobID = ccw.DataArea.CSSJobID;
        String refNumber = ccw.DataArea.BMSReferenceNumber;
        String InvoiceAdhocEmails = ccw.DataArea.AdhocEmails;
        //Query for data only if a list is sent
        Map<String, Boolean> FSLConIdMap = new Map<String, Boolean>();
        if(contactIDsJSONSet.size() > 0 && contactIDsJSONSet != null) {
            List<Contact> conList = [SELECT Id, FSL_Contact_Id__c 
                                        FROM Contact WHERE 
                                        FSL_Contact_Id__c in: contactIDsJSONSet];
            for(Contact conId : conList) {
                FSLConIdMap.put(conId.FSL_Contact_Id__c, true);//1,2
            }
        }

        ResponseDataAreaWrapper rw = new ResponseDataAreaWrapper();
        List<ResponseDataHeader> ResponseDataHeaderList = new List<ResponseDataHeader>();

        rw.Status = 'SUCCESS';

        //loop over the JSON and check if they are returned in query and mark desc accordingly
        for(String s : contactIDsJSONSet) {
            ResponseDataHeader rh = new ResponseDataHeader();

            rh.ContactID = s;
          //   System.debug('jsonResponse :'+  s);
            if(FSLConIdMap.containsKey(s)) {
                rh.ReturnCodeDescription = 'Record Processed Succesfully';
            } else {
                rh.ReturnCodeDescription = 'Contact is not available';
            }
            ResponseDataHeaderList.add(rh);
        }
        rw.Header = ResponseDataHeaderList;

        //pass this over REST as response
        System.debug('rw as wrapper :'+ rw);

        String jsonResponse = JSON.serialize(rw);
        System.debug('jsonResponse :'+ jsonResponse);    
        
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS(contactIDsJSONSet, refNumber);
          if(InvoiceAdhocEmails !='') {
       //FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS_Adhoc(contactIDsJSONSet, refNumber,InvoiceAdhocEmails);
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS_Adhoc(refNumber,InvoiceAdhocEmails);
          }
        return rw;
    }

    //JSON Structure for receiving from 3rd party
    global class CommunicationContactsWrapper{
        Header Header;
        DataArea DataArea;
        public void CommunicationContactsWrapper(Header Header, DataArea DataArea) {}
    }
    global class Header {
        String Status;
        Sender Sender;
        String Target;
        String Location;
        public void Header() {}
    }
    global class DataArea {
        String DistributorCode;
        String BranchCode;
        String CSSJobId;
        String OrderType;
        String BMSReferenceNumber;
        String PayerID;
        String Status;
        String AdhocEmails;
        List<String> ContactIds = new List<String>();
        public void DataArea() {}
    }
    global class Sender {
        String ServiceName;
        String SenderID;
        public void Sender() {}
    }
    //Response Wrapper    
    global class ResponseDataAreaWrapper {
        String Status;
        List<ResponseDataHeader> Header;
        public void ResponseDataAreaWrapper() {}
    }
    global class ResponseDataHeader {
        String ContactID;
        String ReturnCodeDescription;
        public void ResponseDataHeader() {}
    }
}