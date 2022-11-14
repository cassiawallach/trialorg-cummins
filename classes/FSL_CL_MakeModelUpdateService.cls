/**********************************************************************
Name: FSL_CL_MakeModelUpdateService
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is Service it is used to send Make and Model values from FSL Guidanz to Siebel
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                  
1.0     Ravikanth Macherla         07/30/2019                        
***********************************************************************/

public class FSL_CL_MakeModelUpdateService {

    public static List<FSL_MakeModelResWrap> exposeMakemodel(List<FSL_MakeModel_Stage__c> lstMakeModel) {
        
        system.debug('check---1'+lstMakeModel);
        List<FSL_MakeModelRequestWrapper> lstMakModReWrapper = new List<FSL_MakeModelRequestWrapper>();
        List<FSL_MakeModelResWrap> FSL_MakeModelWrap = new List<FSL_MakeModelResWrap>();
        FSL_MakeModelRequestWrapper modelwrap = new FSL_MakeModelRequestWrapper();
        List<FSL_MakeModelRequestWrapper.cls_MakeModel> lstmake  = new List<FSL_MakeModelRequestWrapper.cls_MakeModel>();
        
        FSL_MakeModelRequestWrapper.cls_Header clsheader = new FSL_MakeModelRequestWrapper.cls_Header();
        FSL_MakeModelRequestWrapper.cls_DataArea clsdata = new FSL_MakeModelRequestWrapper.cls_DataArea();
        
        for(FSL_MakeModel_Stage__c objMakeModel : lstMakeModel) {
            FSL_MakeModelRequestWrapper.cls_MakeModel make = new  FSL_MakeModelRequestWrapper.cls_MakeModel();
            FSL_MakeModelRequestWrapper.cls_Target makemodel = new FSL_MakeModelRequestWrapper.cls_Target();
            FSL_MakeModelRequestWrapper.cls_Sender clssend = new FSL_MakeModelRequestWrapper.cls_Sender();
            
            makemodel.TargetID = 'SIEBEL';
            clssend.ServiceName = 'updateMakeModel';
            clssend.SenderID = 'CSS';
            make.Type = objMakeModel.Type__c;
            make.ModelSeries = objMakeModel.ModelSeries__c;
            make.PSN = objMakeModel.PSN__c;
            make.Manufacturer = objMakeModel.Manufacturer__c;
            make.ProductApplicationCode = objMakeModel.ProductApplicationCode__c;
            make.VIN = objMakeModel.VIN__c;                                 
            lstmake.add(make);
            system.debug('lstmake--->'+lstmake);
            clsdata.MakeModel = lstmake; 
            clsheader.Target = makemodel;
            clsheader.Sender = clssend ;
            system.debug('clsdata==='+JSON.serialize(clsdata));
        }
        modelwrap.DataArea = clsdata;
        modelwrap.Header = clsheader;
        lstMakModReWrapper.add(modelwrap);
        String jsonreq = JSON.serialize(lstMakModReWrapper);
        system.debug('json------->'+jsonreq);
        String strReq = jsonreq.removeStart('[');
       strReq = strReq.removeEnd(']');
       system.debug('strs------->'+strReq);
       FSL_MakeModelWrap = sendMakeupdated(strReq,lstMakeModel);
        return FSL_MakeModelWrap;
    }
    
    public static  list<FSL_MakeModelResWrap> sendMakeupdated(String strReq, List<FSL_MakeModel_Stage__c> lstMakeModel) {
        
         //------------ Below code added By Ghanshyam from Story Phoen-269---//
		
		system.debug('Make Model Functionality');
        DateTime startTime = System.Now();
		
		FSL_IP_NamedCredentialWrapper reqWrapper = null;
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/makemodel';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
        
       List<FSL_MakeModelResWrap> lstMakeModelResWrap = new list<FSL_MakeModelResWrap>();
	    FSL_MakeModelRequestWrapper fsrt=new FSL_MakeModelRequestWrapper();
		
      //  FSL_MakeModelRequestWrapper.cls_DataArea da = new FSL_MakeModelRequestWrapper.cls_MakeModel();
		FSL_MakeModelRequestWrapper.cls_Target makemodel = new FSL_MakeModelRequestWrapper.cls_Target();
        FSL_MakeModelRequestWrapper.cls_Sender clssend = new FSL_MakeModelRequestWrapper.cls_Sender();	
        FSL_MakeModel_Stage__c  objectModel= New FSL_MakeModel_Stage__c();

		makemodel.TargetID = 'SIEBEL';
        clssend.ServiceName = 'updateMakeModel';
        clssend.SenderID = 'CSS';
		List<FSL_MakeModelRequestWrapper.cls_MakeModel> lstmake  = new List<FSL_MakeModelRequestWrapper.cls_MakeModel>();
        FSL_MakeModelRequestWrapper.cls_MakeModel make = new  FSL_MakeModelRequestWrapper.cls_MakeModel();
	
		make.Type = objectModel.Type__c;
		make.ModelSeries = objectModel.ModelSeries__c;
		make.PSN = objectModel.PSN__c;
		make.Manufacturer = objectModel.Manufacturer__c;
		make.ProductApplicationCode = objectModel.ProductApplicationCode__c;
		make.VIN = objectModel.VIN__c;                                 
		lstmake.add(make);
       
		FSL_MakeModelRequestWrapper.cls_Header clsheader = new FSL_MakeModelRequestWrapper.cls_Header();
        FSL_MakeModelRequestWrapper.cls_DataArea clsdata = new FSL_MakeModelRequestWrapper.cls_DataArea();
        
		clsdata.MakeModel = lstmake; 
		clsheader.Target = makemodel;
		clsheader.Sender = clssend ;
		
        List<FSL_MakeModelRequestWrapper> lstMakModReWrapper = new List<FSL_MakeModelRequestWrapper>();
        FSL_MakeModelRequestWrapper modelwrap = new FSL_MakeModelRequestWrapper();
		
		modelwrap.DataArea = clsdata;
        modelwrap.Header = clsheader;
        lstMakModReWrapper.add(modelwrap);
		reqWrapper.jsonReqBody=strReq.replace('null','""');
        system.debug('json- data#####------>'+strReq);
		reqWrapper.timeOut = 120000;
	     String responseBody;
        if(!Test.isRunningTest())
        {
            CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            system.debug('outputWrapper#########::::'+outputWrapper);	
            responseBody =outputWrapper.response.getBody();
            system.debug('response for fsl_siebel service :: '+responseBody);
            responseBody = ' [ ' + responseBody + ' ] ';
            
        //} Commented by Naga Anusha Devi Malepati,8/29/22,for test Class code coverage for FSLMakeModelBatch_Test
        lstMakeModelResWrap = (List<FSL_MakeModelResWrap>)JSON.deserialize(responseBody, List<FSL_MakeModelResWrap>.Class);
        system.debug('check resss'+lstMakeModelResWrap);
            //if(!Test.isRunningTest()){   Commented by Naga Anusha Devi Malepati,8/29/22,for test Class code coverage for FSLMakeModelBatch_Test
            getStatus(strReq, String.valueof(responseBody), lstMakeModelResWrap, lstMakeModel);
        }
			  return lstMakeModelResWrap;
			
     }
		
        //---- Above code Added by Ghanshyam phoen-269-----End Here 
    private static void  getStatus(String req, String res, List<FSL_MakeModelResWrap> lstMakeModelResWrap, List<FSL_MakeModel_Stage__c> lstMakeModel) {
        
        system.debug('out--->'+lstMakeModelResWrap);
        boolean deleteflag = false;
        for(FSL_MakeModelResWrap objMResWrapOut : lstMakeModelResWrap) {
            system.debug('Delete--->'+objMResWrapOut.Header.Status);
            if(objMResWrapOut.Header.Status=='Success') {
                deleteflag = true;
            }
                    }
        if(deleteflag) {
            Delete lstMakeModel;
        }
    }
}