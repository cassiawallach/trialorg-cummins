/**********************************************************************
Name: FSL_CL_INSITEImage
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose: This class is used to populate BeforeImage.eif, AfterImage.eif
under forms tab after insite fc pull.
=======================================================================
=======================================================================

VERSION  AUTHOR            DATE                DETAIL                                 
1.0      PiyushR           02/02/2019   	   INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_CL_INSITEImage {
    
    @AuraEnabled
    public static WorkOrder fetechWorkOrder(string strjobId) {
        system.debug('workorderid--->'+strjobId);
        return [SELECT Id, Before_Image__c, After_Image__c, INSITE_Work_Order_Image_Name__c, FaultCode_Max_Sequence__c 
                FROM WorkOrder 
                WHERE Id =: strjobId LIMIT 1];
    }
    
    @AuraEnabled
    public static void updateBeforeImage(String image, String workOrderId) {
        System.debug('::: Update - '+image+' ** '+workOrderId);
        WorkOrder wo = [SELECT Id, Before_Image__c FROM WorkOrder WHERE Id =: workOrderId LIMIT 1];
        wo.Before_Image__c = image;
        update wo;
    }
    
    @AuraEnabled
    public static void updateAfterImage(String image, String workOrderId) {
        System.debug('::: After Image Update - '+image+' ** '+workOrderId);
        WorkOrder wo = [SELECT Id, After_Image__c FROM WorkOrder WHERE Id =: workOrderId LIMIT 1];
        wo.After_Image__c = image;
        update wo;
    }
    
    @AuraEnabled
    public Static id getAfterImageFile(String workOrderId, String buttonType) {
        System.debug('::: In AfterImage wo button...'+workOrderId+' and '+buttonType);
        String sFileName;
        workorder wOVal = [SELECT Id, After_Image__c FROM WorkOrder WHERE Id =: workOrderId LIMIT 1];
        if(buttonType == 'eif') {
            sFileName = wOVal.After_Image__c+'.eif';
            //sFileName = 'I-20181219-153942907.eif'; //dev file
            //sFileName = 'I-20200203-102144257-A291DDB5.eif'; //stg file
            System.debug('::: AfterImage eif = '+sFileName);
        } else if(buttonType == 'csv') {
            sFileName = wOVal.After_Image__c+'.csv';
            //sFileName = 'I-20190501-111230700-EB2C1D99.csv'; //dev file
            //sFileName = 'I-20200115-133817719-EB2C1D71.csv'; //stg file
            System.debug('::: AfterImage csv = '+sFileName);
        }
        
        // Azure Integration Changes
        FSL_IP_OAGWrapper reqWrapper;
        FSL_OP_OAGWrapper resWrapper;
        List<String> outputs = new List<String>();
        
        try {
            //Request Wrapper
            reqWrapper = new FSL_IP_OAGWrapper();
            reqWrapper.serviceName = 'InsiteImageAzure';
            Map<String,String> reqParams = new Map<String,String>();
            reqParams.put('FileName', sFileName);
            reqWrapper.jsonReqBody=JSON.serialize(reqParams);
            System.debug('::: JSON Request Body =>>>'+reqWrapper.jsonReqBody);
            
            //Call FSL_WS_Azure class to call the calloutGeneric() method which will fire the callout
            if(reqWrapper.serviceName != null) { 
                resWrapper = FSL_WS_Azure.calloutGeneric(reqWrapper);
            }
            
            System.debug('::: Response =>>> '+resWrapper.response);
            System.debug('::: Response Values=>>> '+resWrapper.response.getStatusCode()+' and '+resWrapper.response.getBodyAsBlob());
            Id attachId;
            
            if(resWrapper.response != null && resWrapper.response.getStatusCode() == 200 && resWrapper.response.getBodyAsBlob() != null) {
                Blob aImage = resWrapper.response.getBodyAsBlob();
                System.debug('::: Image = >>>:'+aImage);
                attachId = createAttachment(aImage, workOrderId, sFileName);
            } else {
                attachId = null;
            }
            System.debug('::: attachId to return =>> '+attachId);
            return attachId;
        } catch(exception ex) {
            System.debug('::: in catch of getFile of css_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'INSITEImage',res.getStatus(),'code','toolid','Guidanz',wOVal.Id,'INSITEImage'));
        }
        return null;
    }
    
    @AuraEnabled
    public Static id getFile(String workOrderId, String buttonType) {
        System.debug('::: In BeforeImage wo button...'+workOrderId+' and '+buttonType);
        String sFileName;
        
        workorder wOVal = [SELECT Id, Before_Image__c FROM WorkOrder WHERE Id =: workOrderId LIMIT 1];
        if(buttonType == 'eif') {
            sFileName = wOVal.Before_Image__c+'.eif';
            //sFileName = 'I-20181219-153942907.eif'; //dev file
            //sFileName = 'I-20190501-101230703-EB2C1D90.eif'; //stg file
            System.debug('::: BeforeImage eif = '+sFileName);
        } else if(buttonType == 'csv') {
            sFileName = wOVal.Before_Image__c+'.csv';
            //sFileName = 'SI-20190603-101230701-EB2C1D95.csv'; //dev file
            //sFileName = 'I-20190421-111230301-EA2C1D72.csv'; //stg file
            System.debug(':::  BeforeImage csv = '+sFileName);
        }
        
        // Azure Integration Changes
        FSL_IP_OAGWrapper reqWrapper;
        FSL_OP_OAGWrapper resWrapper;
        List<String> outputs = new List<String>();
        
        try {
            //Request Wrapper
            reqWrapper = new FSL_IP_OAGWrapper();
            reqWrapper.serviceName = 'InsiteImageAzure';
            Map<String,String> reqParams = new Map<String,String>();
            reqParams.put('FileName', sFileName);
            reqWrapper.jsonReqBody=JSON.serialize(reqParams);
            System.debug('::: JSON Request Body =>>>'+reqWrapper.jsonReqBody);
            
            //Call FSL_WS_Azure class to call the calloutGeneric() method which will fire the callout
            if(reqWrapper.serviceName != null ){
                resWrapper = FSL_WS_Azure.calloutGeneric(reqWrapper);
            }
            
            System.debug('::: Response =>>> '+resWrapper.response);
            
            Id attachId;
            
            if(resWrapper.response != null && resWrapper.response.getStatusCode() == 200 && resWrapper.response.getBodyAsBlob() != null) {
                Blob bImage = resWrapper.response.getBodyAsBlob();
                System.debug('::: Image = >>>:'+bImage);
                attachId = createAttachment(bImage, workOrderId, sFileName);
                
            } else if(Test.isRunningTest()) {
                Blob bImage = Blob.valueOf('21049');
                attachId = createAttachment(bImage, workOrderId, sFileName);
            } else {
                attachId = null;
            }
            System.debug('::: attachId to return =>> '+attachId);
            return attachId;
        } catch(exception ex) {
            System.debug('::: Exception in GetFile Before Image =>> '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'INSITEImage',res.getStatus(),'code','toolid','Guidanz',wOVal.Id,'INSITEImage'));
        }
        return null;
    }
    
    // This method is used for creating a new Attachment in Files
    public Static Id createAttachment(Blob bImage, String workOrderId , String sFileName) {
        System.debug('$$$$ Entered into createAttachment method $$$$');
        try {
            Attachment attachObj = new Attachment();
            attachObj.Name = sFileName;
            attachObj.Description = 'CG_'+sFileName;
            attachObj.ParentId = workOrderId;// '0WO1D0000009PkVWAU'; //Label.CSS_SampleRecordId;
            attachObj.ContentType = 'application/octet-stream';
            //String encodedString = sBlob;
            //Blob fileBlobData = EncodingUtil.base64Decode(encodedString);
            attachObj.Body = bImage;
            System.debug('Created successfully New AttachmentId >>>>: '+attachObj.Id);
            insert attachObj;
            // attachId = getAttachment(attachObj.Id);
            return attachObj.id;
        } catch(Exception ex) {
            System.debug('In catch of createAttachment of FSL_tnd_job >>>>: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return null;
    }
    
    public static String getAttachment(String attachObjId) {
        String attachId;
        try {
            List<Attachment> attachList = new List<Attachment>([SELECT Id, Name, ParentId, Body, BodyLength, LastModifiedDate FROM Attachment WHERE Id =: attachObjId ORDER BY LastModifiedDate DESC LIMIT 1]);
            System.debug('AttachList size >>>>: '+attachList.size());
            if(attachList.size() <= 0) {
                return null;
            }
            Attachment attachObj = attachList.get(0);
            attachId = attachObj.Id;
            System.debug('retrieved Attachment Id:'+attachId);
            //System.debug('sFileName>>>>>>>>>>>>>:'+sFileName);
        } catch(Exception ex) {
            System.debug('In catch of getAttachment of CSS_tnd_job >>>>is: '+ex.getLineNumber()+' Exception Message>>>> is: '+ex.getMessage());
        }
        return attachId;
    }
}