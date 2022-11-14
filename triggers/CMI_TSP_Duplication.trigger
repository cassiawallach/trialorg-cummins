//System made changes
trigger CMI_TSP_Duplication on CMI_TSP__c (before insert,before update,before delete) {

    id AccId;
    map<id,string> mapTsp=new map<id,string>();
    map<id,string> mapNewTsp=new map<id,string>();
    list<id> lstAccid=new list<id>();
    if (Trigger.isInsert && CSS_checkRecursive.runOnce()){
        for(CMI_TSP__c  obj:trigger.new){
            lstAccid.add(obj.CMI_Account_Name__c);
        }
        string name='';
        
        string oTSP='';
        for(CMI_TSP__c objAcc:[select CMI_TSP_Id__c,CMI_TSP_Name__c,CMI_Other_TSP_Name__c from CMI_TSP__c where CMI_Account_Name__c=:lstAccid]){
            
            name+=objAcc.CMI_TSP_Name__c!=null && objAcc.CMI_TSP_Name__c!=''?objAcc.CMI_TSP_Name__c+';':'';
            
            if(objAcc.CMI_TSP_Name__c=='Other TSP'){
            System.debug('other TSP =='+objAcc.CMI_TSP_Name__c);
            oTSP=objAcc.CMI_Other_TSP_Name__c;
            }
        }
        
        for(CMI_TSP__c  obj:trigger.new){
            
                name+=obj.CMI_TSP_Name__c!=null && obj.CMI_TSP_Name__c!=''?obj.CMI_TSP_Name__c+';':'';
                if(obj.CMI_TSP_Name__c=='Other TSP')
                oTSP=obj.CMI_Other_TSP_Name__c;
            
    
        } 
       
    
        list<Account> lstAcc=[select CMI_Telematics_Service_Provider__c,CMI_Other_TSP__c from Account where id=:lstAccid];
        for(Account obj:lstAcc){
                        //Added by Lavanya to handle exception on TSP clone
            obj.CMI_Telematics_Service_Provider__c =name.removeEnd(';');
             obj.CMI_Other_TSP__c=oTSP;
                }
        if(!lstAcc.isEmpty()){
            update lstAcc;
        }
       
    }else if(Trigger.isUpdate){
    map<id,CMI_TSP__c> mapold=Trigger.oldMap;
    list<id> tspids=new list<id>();
    list<id> lstAcc=new list<id>();
    for(CMI_TSP__c  obj:trigger.new){
        if(obj.CMI_TSP_Name__c!=mapold.get(obj.id).CMI_TSP_Name__c){
            lstAcc.add(obj.CMI_Account_Name__c);
            tspids.add(obj.id);
            
        }
    
    }
    system.debug(tspids+'lstAcc===='+lstAcc);
    string name='';
    string oTSP='';
    
        for(CMI_TSP__c objAcc:[select CMI_TSP_Id__c,CMI_TSP_Name__c,CMI_Other_TSP_Name__c from CMI_TSP__c where CMI_Account_Name__c=:lstAcc and id!=:tspids]){
            
            
            name+=objAcc.CMI_TSP_Name__c+';';
            
             
            
        }
       system.debug('lstAcc=1==='+name);
            for(CMI_TSP__c  obj:trigger.new){
                
                    name+=obj.CMI_TSP_Name__c+';';
                    if(obj.CMI_TSP_Name__c=='Other TSP')
                    oTSP=obj.CMI_Other_TSP_Name__c;
                
    
            }
        
        if(name!=''){
    
        list<Account> lstAcc1=[select CMI_Telematics_Service_Provider__c,CMI_Other_TSP__c from Account where id=:lstAcc];
        for(Account obj:lstAcc1){
            obj.CMI_Telematics_Service_Provider__c =name;
             obj.CMI_Other_TSP__c=oTSP;
        }
           if(!lstAcc.isEmpty()){
                update lstAcc1;
            }
        }
    
    
    
    }
    else if(Trigger.isDelete) {
            list<id> tspids=new list<id>();
            list<id> lstAcc=new list<id>();
            string name='';
            string oTSP='';
            for(CMI_TSP__c  obj:trigger.old){
                lstAcc.add(obj.CMI_Account_Name__c);
                tspids.add(obj.id);
            }
            
    
            for(CMI_TSP__c objAcc:[select CMI_TSP_Name__c,CMI_Other_TSP_Name__c from CMI_TSP__c where CMI_Account_Name__c=:lstAcc and id!=:tspids]){
                name+=objAcc.CMI_TSP_Name__c+';';
                if(objAcc.CMI_TSP_Name__c=='Other TSP'){
            System.debug('other TSP =='+objAcc.CMI_TSP_Name__c);
            oTSP=objAcc.CMI_Other_TSP_Name__c;
                }
            }
      
            list<Account> lstAcc1=[select CMI_Telematics_Service_Provider__c,CMI_Other_TSP__c from Account where id=:lstAcc];
            for(Account obj:lstAcc1){
                obj.CMI_Telematics_Service_Provider__c =name;
                 obj.CMI_Other_TSP__c=oTSP;
            }
            if(!lstAcc.isEmpty()){
                update lstAcc1;
            }
    
    }
     if(trigger.isInsert || trigger.isUpdate) {
    
    //List<CMI_TSP__c> tsplist = [select id,CMI_TSP_Id__c,CMI_TSP_Name__c,CMI_Account_Name__c from CMI_TSP__c LIMIT 2000];
          set<string> tspName = new set<string>();
         set<string> tspRefernce = new set<string>();
        set<Id> tspAccountId = new Set<Id>();
        Map<Id,CMI_TSP__c> existingRecords = new Map<Id,CMI_TSP__c>();
    for(CMI_TSP__c c:Trigger.new)
      {
          if(c.CMI_TSP_Id__c != null && c.CMI_TSP_Name__c!=null){
              tspName.add(c.CMI_TSP_Name__c); 
			  tspRefernce.add(c.CMI_TSP_Id__c); // adding new TSP Name and Creference by Lavanya Javvadi
              tspAccountId.add(c.CMI_Account_Name__c); // adding Accounts for TSP by Lavanya Javvadi
          }
      }
        
    system.debug('====>'+tspName+'====>'+tspRefernce);
        if(tspName.size()>0 && tspRefernce.size()>0 ){
            //Get all existing records having Tname & Creference by Lavanya Javvadi
            existingRecords = new Map<Id,CMI_TSP__c>([select id,CMI_TSP_Id__c,CMI_TSP_Name__c,CMI_Account_Name__c from CMI_TSP__c WHERE CMI_TSP_Id__c=:tspRefernce AND CMI_TSP_Name__c=:tspName ]);// AND CMI_Account_Name__c =:tspAccountId ]);
           system.debug('====>'+existingRecords);
        }
        if(existingRecords.size()>0){for(CMI_TSP__c recList : Trigger.new){
            if(recList.CMI_TSP_Name__c!=null && recList.CMI_TSP_Id__c!=null){
                //checking the condition for an existing records available with same Tname & Creference
                
                    recList.adderror('we already have this TSP & Customer Reference combination');
              
            }
            
        }}
        
      /*for(CMI_TSP__c c:Trigger.new)
      {
        for(CMI_TSP__c cc: tsplist)
        {
          if(c.CMI_TSP_Id__c != null)
          {
          if(c.CMI_TSP_Name__c==cc.CMI_TSP_Name__c && c.CMI_TSP_Id__c == cc.CMI_TSP_Id__c)
          {   
             c.adderror('we already have this TSP & Customer Reference combination');
          }
          }
        }
      }
    */
    
    }
    }