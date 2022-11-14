public class css_dsidclose {
    
    
    public   css_dsidclose(){
        Wid = ApexPages.CurrentPage().getParameters().get('id');        
        cldsjob= [Select id,Job_Order__c,Type__c,Doc_Num__c,performed_review__c,performed__c from CSS_CampTsbTrp__c where Type__c = 'CAM' and  Job_Order__c= :Wid];
    }
    public id Wid;
    public list<CSS_CampTsbTrp__c> cldsjob{get; set;}
    public CSS_J2Adsidclose_EDS solDet{get;set;}
    public Boolean solDetFailed{set;get;}
    public string campids;
    public user  wrkgrp;
    public boolean dsidstatus{set;get;}
    public String solErrorMsg{set;get;}
    
    public boolean Closedsid(string resolution, string feedbackcm, string Dsid){ 
       // 
        string userId = UserInfo.getUserId();
        user wrkgrp = [Select id,Name,Work_Group_Name__c from user where id= :userId  LIMIT 1];
        system.debug('workgroup'+wrkgrp );
        system.debug('query'+cldsjob);
        if(wrkgrp != null   ){
              campids = '';
            if(cldsjob != null){
            for(CSS_CampTsbTrp__c camps : cldsjob){
                
                if(camps.Type__c.equalsIgnoreCase('CAM')){
                if(camps.performed_review__c == True && camps.performed__c == True){
                    
                    if(campids != null ){
                        campids+= ','+camps.Doc_Num__c; 
                    }
                    else{
                        campids = camps.Doc_Num__c;
                    }
                    }
                }    
            }  
            system.debug('campids1'+campids );
            HttpResponse res = CSS_EDSAuthentication.getDsidclose(feedbackcm,wrkgrp.Work_Group_Name__c,campids,resolution,Dsid);
            system.debug('Response for close dsid1' +res);
            if(res.getStatusCode() == 200){
                solDetFailed = false; 
                dsidstatus = true;
                solDet = (CSS_J2Adsidclose_EDS)JSON.deserializeStrict(res.getBody(),CSS_J2Adsidclose_EDS.class);
                System.debug('The soldet is#!#!@'+solDet);
            }else{
                solDetFailed = true;
                dsidstatus = false;
                solErrorMsg = res.getStatus();
            } 
           }
          }
        return dsidstatus;
        }       
    }