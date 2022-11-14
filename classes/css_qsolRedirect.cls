public class css_qsolRedirect {
    Public String documentId{Set;get;}
    Public String docType{Set;get;}
    Public String lang{Set;get;}
    Public String qsolResp {set;get;}
    public css_qsolRedirect(){
        documentId = ApexPages.CurrentPage().getParameters().get('docid');
        docType = ApexPages.CurrentPage().getParameters().get('doctype');
        lang = ApexPages.CurrentPage().getParameters().get('pgroup');
    }
    public PageReference redirect(){
        PageReference pageRef = null;
        try{
            String sReferrer = ApexPages.currentPage().getHeaders().get('Referer');
            String Wid = 'B';
            if(sReferrer!=null){
                //System.debug('The sReferrer inside Outer If'+sReferrer);  
                if(sReferrer.indexOf('&rank=')>0){
                    if(sReferrer.indexOf('?id=')>0){
                        Wid = sReferrer.substring(sReferrer.indexof('?id=')+4,sReferrer.indexof('&rank='));
                    }
                    //Defect Fix - 68048
                    else if(sReferrer.indexOf('&id=')>0){
                        //System.debug('The sReferrer inside inner else'+sReferrer);                   
                        Wid = sReferrer.substring(sReferrer.indexof('&id=')+4,sReferrer.indexof('&rank='));
                        System.debug(' Wid Inside else is :'+Wid);
                    }
                }else{              
                    if(sReferrer.indexOf('?id=')>0){
                        Wid = sReferrer.substring(sReferrer.indexof('?id=')+4,sReferrer.indexof('&'));
                    }
                    //Defect Fix - 68048
                    else if(sReferrer.indexOf('&id=')>0){
                        //System.debug('The sReferrer inside inner else'+sReferrer);                   
                        Wid = sReferrer.substring(sReferrer.indexof('&id=')+4,123);
                        //System.debug(' Wid Inside else is :'+Wid);
                    }
                }
            }
            system.debug('The wid is'+Wid);
            if (Wid == 'B') {
                //return null;
            }
            else {
                System.debug('The sReferrer inside outer else'+sReferrer);
                user userlang = css_utility.getUserAttributes(userinfo.getUserId());
                CSS_accountLanguage__c accountlang = css_utility.getLanguage(userlang.LanguageLocaleKey); 
                system.debug('Wid is: --->'+Wid);
                qsolResp = CSS_QuickServe.linkMgmt(accountlang.CSS_QsolLanguage__c, docType, documentId,Wid);
                system.debug('checking the link'+qsolResp);
                pageRef = new PageReference(qsolResp); 
                pageRef.setRedirect(true); 
            }
        }
        
        catch(Exception e){  
            system.debug('Exception Message'+e.getMessage()+' '+e.getLineNumber());
        }
        return pageRef;
    }
}