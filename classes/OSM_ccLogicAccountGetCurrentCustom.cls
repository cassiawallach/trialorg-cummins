global class OSM_ccLogicAccountGetCurrentCustom extends ccrz.ccLogicAccountGetCurrent 
{
   /**
     * @usage
     *    This method is used for associating any account of your choosing to the current logged in user
     *    This acccount will subsequently degtermine the entitlements (product and pricing) for the user
     *   For this POC, we used a hard-coded account SFID.
     *   Ensure you update the section of the code as needed.
     *  Finally, ensure you configure this logic service class in CC Admin
     */
     
 global  override Map<String,Object> process(Map<String,Object> inpData)
 {
     Map<String,Object> ret = new Map<String,Object>()  ;
    //Vineet - added !ccrz.cc_CallContext.isGuest) to avoid execute below code for Guest User
    //added on 15th July 2019
    //System.debug('ccrz.cc_CallContext:'+ccrz);
    
    Id currUserId = UserInfo.getUserId();
        List<Contact> currCont = new List<Contact>();
        currCont = [SELECT Id, AccountId from Contact WHERE IAM_Contact_Owner__c =:currUserId];
        
     if (null ==  ccrz.cc_CallContext.currUser.AccountId && !ccrz.cc_CallContext.isGuest && currCont.size() > 0)
     { 
         // POC - hard-coding the account id below for now
         // Yubo update below
        

        
         ret =  ccrz.ccApiAccount.fetch(new Map<String,Object>{ccrz.ccApi.API_VERSION => inpData.get(ccrz.ccApi.API_VERSION) ,ccrz.ccApiAccount.ID => currCont[0].AccountId,ccrz.ccAPI.SIZING=>ccrz.ccUtil.defv(inpData, ccrz.ccAPI.SIZING, new Map<String, Object>())
        });
        
         
     }
     else
     {
         ret =  super.process(inpData);
     }
      ccrz.ccLog.log(LoggingLevel.DEBUG, 'Jamiu:inputData_getcurrent', ret);
     
     return ret;
  }
}