public class CG_SL_QSOL {
    
    public static CG_OP_OAGWrapper callGetQsolService(String ESN,String serviceName,String faultCode,String faType,String qsolLang,String businessUnit,String documentType,String documentId){
        CG_IP_OAGWrapper reqWrapper;
        CG_OP_OAGWrapper resWrapper;
        try{
            reqWrapper = new CG_IP_OAGWrapper(); 
            map<string,string> reqparameters = new map<string,string>();
            reqWrapper.serviceName = serviceName;
            reqparameters.put('ESN',ESN);  
            reqparameters.put('faultCode',faultCode);   
            reqparameters.put('faType',faType);  
            reqparameters.put('qsolLang',qsolLang); 
            reqparameters.put('businessUnit',businessUnit);
            reqparameters.put('documentType',documentType);
            reqparameters.put('documentId',documentId);
            system.debug('reqParams before Serialize**'+reqparameters);
            reqWrapper.jsonReqBody=JSON.serialize(reqparameters);
            system.debug('myRequest**'+reqWrapper.jsonReqBody);
            resWrapper = CG_WS_QSOL.calloutGeneric(reqWrapper);
            System.debug('resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper.response);
            
        }catch(exception e){
            system.debug('Entered into catch block of callGetInfoService method in CG_SL_SIEBEL class:'+e.getMessage()+' Line No:'+e.getLineNumber());
            resWrapper.exceptionFlag=true;
            resWrapper.errorMessage = e.getMessage();
            return resWrapper;
        }
        return resWrapper;
    }
    public static List<List<CSS_CampTsbTrp__c>> getQSOLWarrantyDocs(Id wId,id claimid, String esn, String qsolLanguage,list<string> factions) {
        return getQSOLMapWarrantyDocs(wId,claimid,esn,qsolLanguage,factions).values();
    }  
    public static map<string,List<CSS_CampTsbTrp__c>> getQSOLMapWarrantyDocs(Id wId,id claimid, String esn, String qsolLanguage,list<string> factions) {
        map<string,List<CSS_CampTsbTrp__c>> campaignsmap = new map<string,List<CSS_CampTsbTrp__c>> ();
        try {
            List<CSS_CampTsbTrp__c> lstCAM= new List<CSS_CampTsbTrp__c>() ,lstTRP= new List<CSS_CampTsbTrp__c>() ,lstTSB= new List<CSS_CampTsbTrp__c>() ,lstATC= new List<CSS_CampTsbTrp__c>();
            
            list<CG_OP_GetWarrantyDocsRespWrapper> campaigns= new list<CG_OP_GetWarrantyDocsRespWrapper>();
            for(string atype :factions){
                CG_OP_OAGWrapper resp = CG_SL_QSOL.callGetQsolService(esn,'GetWattantyDocsforQsolREST',null,atype,qsolLanguage,'','','');
                if(!resp.exceptionFlag && resp.response.getStatusCode() != 204  && resp.response.getBody()!=null)campaigns.addall(CG_OP_GetWarrantyDocsRespWrapper.ParseData(resp.response.getBody()));  
            }
            CSS_CampTsbTrp__c cam ;
            for(CG_OP_GetWarrantyDocsRespWrapper doc:campaigns){
                cam= new CSS_CampTsbTrp__c();cam.ESN__c = esn;cam.Doc_Num__c =doc.documentNum;cam.Doc_Title__c = doc.documentDesc;cam.URL__c = doc.documentLink;cam.Cu_Language__c = qsolLanguage;
                if(wId!=null ) cam.Job_Order__c = wId;
                if(claimid!=null) cam.CSS_Claims__c = claimid;
                switch on doc.type {
                    when 'CAMPAIGN' {   
                        cam.Name = 'CAM';
                        cam.Type__c = 'CAM';
                        lstCAM.add(cam);
                    }when 'TSB' {
                        cam.Name = 'TSB';
                        cam.Type__c = 'TSB';
                        lstTSB.add(cam);
                    } when 'ATC' {  
                        cam.Name = 'ATC';
                        cam.Type__c = 'ATC';
                        lstTSB.add(cam);
                    } when 'TRP' {  
                        cam.Name = 'TRP';
                        cam.Type__c = 'TRP';
                        lstTRP.add(cam);
                    }
                }
            }
            campaignsmap.put('CAM',lstCAM);
            campaignsmap.put('TSB',lstTSB);
            campaignsmap.put('TRP',lstTRP);
            campaignsmap.put('ATC',lstATC);
        }catch(exception e) {
            system.debug('EXCEPTION of CG_Sl_Qsol - getQSOLMapWarrantyDocs Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return campaignsmap;
    }  
    
}