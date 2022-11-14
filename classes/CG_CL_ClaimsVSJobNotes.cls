public class CG_CL_ClaimsVSJobNotes {
   
    public string nonSRTnotes{get;set;}
    
    public Id cID {get; set;}
    public CG_CL_ClaimsVSJobNotes(){
        
        cId=ApexPages.CurrentPage().getParameters().get('id');
        system.debug('MyClaimId**'+cID);
        try{
            
            //STORY -145260 Non-SRT Details START     
           List<CSS_SRT__c> nonSRTList = new List<CSS_SRT__c>();
           nonSRTnotes ='';
           for(CSS_SRT__c srt : [SELECT id,SRT_Notes__c FROM CSS_SRT__c 
                                    WHERE css_claims__c=:cid AND Type__c='99Time' 
                                    AND Account_Code_Description__c != null 
                                    AND Fail_Code_Description__c != null ]){
                                            
                
                if(srt.SRT_Notes__c!=null && srt.SRT_Notes__c!= ''){ 
                    nonSRTnotes += srt.SRT_Notes__c + '<br/>';   
                    
                }    
                    
            }
            //STORY -145260 Non-SRT Details END 
            
            
            
        }catch(Exception ex){
            System.debug('Exception in CG_CL_ClaimsVSJobNotes' + ex.getMessage() + '--' + ex.getLineNumber());
        }
        
        
        
        
    }
    
    //Naviagation to Job Notes Chevron On click of Edit link.
    public PageReference redirectToJobNotes(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
             pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); 
        }
        return pageRef;
    }

}