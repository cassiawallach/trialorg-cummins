/*
* Block comments with details of changes
*/
public class CSS_GSQParts
{
    public Id Ins_JobId {get; set{Ins_JobId = value;  } }
    public Id JobsolutionId {get; set{JobsolutionId = value;
                                      if(singleRun==1){
                                           listpartWrapper = new List<partWrapperClass>();
                    setpartWrapper = new Set<partWrapperClass>();
                                          listpartWrapper.clear();
                                          setpartWrapper.clear();
                                          
                                          getallCustomPartsData(false);
                                          singleRun+=1;
                                          System.debug('in setter GSQ Parts:1');
                                      }
                                     } 
                            }
   
    //added for part func
    public  boolean ErrorMessage {get; set;}
    public Integer assignedParts{get;set;}
    public Set<partWrapperClass> setpartWrapper {get;set;}
     public List<partWrapperClass> listpartWrapper {get;set;}
    public List<partWrapperClass> listpartWrapper2 {get;set;}
    //end
    
    
    public list<CSS_Parts_Options__c> existPartList{get; set;}
    public list<CSS_Parts_Options__c> customPartlstUI{get; set;}
    public Boolean displayPopup2{get;set;}
    public boolean chkReqField{get;set;}
    public Id recTypeIdpart;
    
    public Map<Id, String> removeIdsMap = new Map<Id, String>();
    
    public integer singleRun=0; 
    public CSS_GSQParts()
    {
        singleRun = 1;
        System.debug('in consturctor GSQ Parts:2');
      
    }
    
    public void getallCustomPartsData(Boolean displayPopup2){
        System.debug('in getallCustomPartsData GSQ Parts:3');
        //displayPopup2 = true;
        chkReqField = false;
        if(displayPopup2){
            ErrorMessage = true;
        }else
        ErrorMessage = false;
        customPartlstUI = new list<CSS_Parts_Options__c>();
        try{
            system.debug('Ins_JobId>>>>>>>>>>:'+Ins_JobId);
            system.debug('JobsolutionId>>>>>>>>>>:'+JobsolutionId);
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
           /* customPartlstUI = new List<CSS_Parts_Options__c>([select Id,Notes__c,OEM__c,Replacement_Reason__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c,Service_Job__c,Solutions__c
                                                              from CSS_Parts_Options__c where Service_Job__c =:Ins_JobId and Solutions__c=:JobsolutionId and RecordTypeId=:recTypeIdpart and Parts_Type__c ='Custom']);*/
           
             customPartlstUI = [select Id,Notes__c,OEM__c,Replacement_Reason__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c,
                                Service_Job__c,Solutions__c from CSS_Parts_Options__c where Service_Job__c =:Ins_JobId and RecordTypeId=:recTypeIdpart and Parts_Type__c ='Custom'];
            system.debug('customPartlstUI size>>>:'+customPartlstUI.size()+'customPartlstUI querry>>>>>>>>>>:'+customPartlstUI);
            
            if(customPartlstUI.size()>0){
                listpartWrapper = new List<partWrapperClass>();
                 setpartWrapper = new Set<partWrapperClass>();
                for(integer i=0;i<customPartlstUI.size();i++){
                    setpartWrapper.add(new partWrapperClass(i,customPartlstUI[i].Id,String.valueof(customPartlstUI[i].Quantity__c),customPartlstUI[i].Service_partnumber__c,customPartlstUI[i].Part_Name__c,customPartlstUI[i].Replacement_Reason__c,customPartlstUI[i].Notes__c,customPartlstUI[i].OEM__c,customPartlstUI[i].Selected_part__c));
                }
                if(customPartlstUI.size()<=4) {
                    for(integer i=0;i<5-customPartlstUI.size();i++){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.Notes__c = '';
                        partsoption.OEM__c = '';
                        //partsoption.Quantity__c = '';
                        partsoption.Selected_part__c = false;
                        partsoption.Part_Name__c = '';
                        partsoption.Replacement_Reason__c='Select One';
                        partsoption.Service_partnumber__c = '';
                        partsoption.Parts_Type__c='Custom';
                        setpartWrapper.add(new partWrapperClass(customPartlstUI.size()+i,null,'',partsoption.Service_partnumber__c,partsoption.Part_Name__c,partsoption.Replacement_Reason__c,partsoption.Notes__c,partsoption.OEM__c,partsoption.Selected_part__c));
                     System.debug('setpartWrapper>>>:'+setpartWrapper);
                    }
                    system.debug('customPartlstUI>>>>>>>>>>:'+customPartlstUI);
                }
                system.debug('setpartWrapper exist>>>>>>>>>>:'+setpartWrapper);
            }else{
                listpartWrapper = new List<partWrapperClass>();
                 setpartWrapper = new Set<partWrapperClass>();
                for(integer i=0;i<5;i++){
                    CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                    partsoption.Notes__c = '';
                    partsoption.OEM__c = '';
                    //partsoption.Quantity__c ='';
                    partsoption.Selected_part__c = false;
                    partsoption.Part_Name__c = '';
                    partsoption.Replacement_Reason__c='Select One';
                    partsoption.Service_partnumber__c = '';
                    partsoption.Parts_Type__c='Custom';
                    setpartWrapper.add(new partWrapperClass(customPartlstUI.size()+i,null,'',partsoption.Service_partnumber__c,partsoption.Part_Name__c,partsoption.Replacement_Reason__c,partsoption.Notes__c,partsoption.OEM__c,partsoption.Selected_part__c));
                }
            
             system.debug('setpartWrapper else>>>>>>>>>>:'+setpartWrapper);
            }
            System.debug('The listpartWrapper list is>>>>>>>>>:'+setpartWrapper+' displayPopup2>>>>:'+displayPopup2);
        }catch(Exception ex){
            System.debug('in catch of getallCustomPartsData of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
         if(setpartWrapper.size()>0){
             
             listpartWrapper.addAll(setpartWrapper);
         }
       
        
    }
    
    
    public void saveCustomParts(){
        system.debug('chakshu');
        System.debug('in saveCustomParts GSQ Parts:4');
        Integer count =0;
        system.debug('############inside saveCustomParts##############');
        chkReqField = false;
        ErrorMessage = false;
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
       
        try{
            system.debug('selectedSol.id>>>>:'+JobsolutionId+' The Listfrom UI is2'+listpartWrapper);
             system.debug('wrapper sizeb'+listpartWrapper.size());
            String solId = JobsolutionId;
            
            System.debug('recTypeIdpart>>>>:'+recTypeIdpart);
           
            //Remove logic here
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            try{
                if(removeIdsMap.keySet().size()>0){
                   deleteParts();
                }
            }catch(Exception e) {
                system.debug('Error in Cust Parts Delete Component ## ' + e.getmessage());
            }
            
            for(partWrapperClass  prtslist:listpartWrapper ){
                 System.debug('The listpartWrapper savelist list is>>>>>>>>>:'+listpartWrapper);
                if(((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') || (prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.replacementReasson!=null && prtslist.replacementReasson!='' && prtslist.replacementReasson!='Select One') || (prtslist.notes!=null && prtslist.notes!='')) && (prtslist.partName == '' || prtslist.partName == null)){
                    ErrorMessage =true;
                    displayPopup2 = true;
                    count=count+1;
                    System.debug('inside error displayPopup2:'+displayPopup2);
return;
                }
            }
            if(count==0){
                System.debug('listpartWrapper size before save>>>:'+listpartWrapper.size()+' The listpartWrapper save list is>>>>>>>>>:'+listpartWrapper);
                for(partWrapperClass  prtslist:listpartWrapper ){
                    system.debug('**Rajesh+ids**'+prtslist.ids);  
                    if((prtslist.servPartNumber==null || prtslist.servPartNumber=='') && (prtslist.quantity==null || prtslist.quantity=='')  && (prtslist.replacementReasson==null || prtslist.replacementReasson=='' || prtslist.replacementReasson=='Select One') && (prtslist.notes==null || prtslist.notes=='') && (prtslist.partName == '' || prtslist.partName == null)){
                            if(prtslist.ids != null && String.valueOf(prtslist.ids).trim() !=''){
                                removeIdsMap.put(prtslist.ids, String.valueOf(prtslist.ids));
                            }
                 }
                     
                      if(prtslist.partName!=null &&  prtslist.partName!=''){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.recordtypeId  = recTypeIdpart;
                        partsoption.Notes__c = prtslist.notes;
                        partsoption.OEM__c = prtslist.oem;
                        if(prtslist.quantity!='' && prtslist.quantity!=null)
                            partsoption.Quantity__c = Decimal.ValueOf(prtslist.quantity);
                        if(prtslist.quantity=='' || prtslist.quantity==null)
                            partsoption.Quantity__c = 0;
                        partsoption.Selected_part__c = prtslist.selectedPart;
                        partsoption.Replacement_Reason__c=prtslist.replacementReasson;
                        partsoption.Part_Name__c = prtslist.partName;
                        partsoption.Id=prtslist.ids;
                        partsoption.Id=prtslist.idStr;
                        
                        System.debug('Existing Id>>:'+prtslist.ids+' Part_Name__c>>>>:'+partsoption.Part_Name__c+' OEM__c>>>>:'+partsoption.OEM__c);
                        //GSSC-255 START
                        if(prtslist.servPartNumber!= null && prtslist.servPartNumber != '') {
                            partsoption.Service_partnumber__c = prtslist.servPartNumber.toUpperCase();
                        }
                        //partsoption.Service_partnumber__c = prtslist.servPartNumber;
                        //GSSC-255 END
                        partsoption.Parts_Type__c='Custom';
                        //partsoption.Solutions__c = solId;
                        partsoption.Service_Job__c = Ins_JobId;
                        //partsoption.Unique_Parts_Option__c = Ins_JobId+recTypeIdpart+prtslist.notes+prtslist.oem+partsoption.Quantity__c+prtslist.selectedPart+prtslist.replacementReasson+prtslist.partName+prtslist.servPartNumber; //Here PartNo will be unique
                        //(or)  do upsert based on id of CSS_Parts_Options__c            
                        selectedCustPartsList.add(partsoption);
                        System.debug('Unique_Parts_Option__c>>>>:'+partsoption.Unique_Parts_Option__c);
                    }
                }
                
                //Remove logic here
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            try{
                if(removeIdsMap.keySet().size()>0){
                   deleteParts();
                }
            }catch(Exception ex) {
                System.debug('first in catch of saveCustomParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            }
            }
            
            if(selectedCustPartsList.size()>0){
                System.debug('upsert selectedCustPartsList size>>>>:'+selectedCustPartsList.size()+' selectedCustPartsList>>>>:'+selectedCustPartsList);
                displayPopup2 = false;
                upsert selectedCustPartsList Id;
            }
            getallCustomPartsData(displayPopup2);
            //Remove logic here
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
          system.debug('chakshu'+displayPopup2);
        }catch(Exception ex) {
            System.debug('second in catch of saveCustomParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        
        /*
        if(displayPopup2!=false)
            return null;
        else{
            pageReference ReturnPage = ApexPages.currentPage(); 
            Id id = ReturnPage.getParameters().get('Id');
            Id symid= ReturnPage.getParameters().get('symid');
            Id fcid= ReturnPage.getParameters().get('fcid');
            String rank= ReturnPage.getParameters().get('rank');  
            ReturnPage.getParameters().clear();
            ReturnPage.getParameters().put('Id', id);
            ReturnPage.getParameters().put('fcid', fcid);
            ReturnPage.getParameters().put('rank', rank);
            ReturnPage.getParameters().put('symid', symid);
            ReturnPage.setRedirect(true);
            return ReturnPage ;
        }
        */
        
    }
    
    
    
    
    public void AddRow(){
        try{
            System.debug('in AddRow... GSQ Parts:5 listpartWrapper size>>>:'+listpartWrapper.size()+' listpartWrapper>>:'+listpartWrapper);
            //listpartWrapper2 = new List<partWrapperClass>();
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();

            listpartWrapper2.add(new partWrapperClass(listpartWrapper2.size(),null,'',null,null,null,null,null,false));
            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
            //listpartWrapper2 = null;
         }catch(Exception ex) {
            System.debug('in catch of AddRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
         }
    } 
    
    
    public void removingRow(){
       System.debug('in removingRow GSQ Parts:6');
       System.debug('listpartWrapper IN REMOVE ROW'+listpartWrapper);
       try{
           //listpartWrapper2 = new List<partWrapperClass>();
           listpartWrapper2=listpartWrapper.clone();
           listpartWrapper.clear();
           for(Integer i=0;i<listpartWrapper2.size();i++){
                if(listpartWrapper2[i].counting==assignedParts){
                     System.debug('assignedParts '+assignedParts);
                     System.debug('listpartWrapper[i].counting '+listpartWrapper2[i].counting);
                    //listpartWrapper[i].ids=null;
                    listpartWrapper2[i].quantity='';
                    listpartWrapper2[i].servPartNumber='';
                    listpartWrapper2[i].partName='';
                    listpartWrapper2[i].replacementReasson='Select one';
                    listpartWrapper2[i].notes='';
                    if(listpartWrapper2[i].ids != null && String.valueOf(listpartWrapper2[i].ids).trim() !=''){
                        removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                    }
                    System.debug('removeIdsMap>>>:'+removeIdsMap);
                }
            }

            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
            //listpartWrapper2 = null;
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    public pageReference closePopup2() { 
        system.debug('in Closepopup2 ');
        displayPopup2 = false;
        pageReference ReturnPage = ApexPages.currentPage(); 
        Id id = ReturnPage.getParameters().get('Id');
        Id symid= ReturnPage.getParameters().get('symid');
        Id fcid= ReturnPage.getParameters().get('fcid');
        String rank= ReturnPage.getParameters().get('rank');  
        ReturnPage.getParameters().clear();
        ReturnPage.getParameters().put('Id', id);
        ReturnPage.getParameters().put('fcid', fcid);
        ReturnPage.getParameters().put('rank', rank);
        ReturnPage.getParameters().put('symid', symid);
        ReturnPage.setRedirect(true);
        return ReturnPage ;
    }
    
    public void closePopup(){    
        getallCustomPartsData(false);
    }
    
    public List<SelectOption> getreplacementReasonOptions()    
    {    
        System.debug('in getreplacementReasonOptions GSQ Parts:7');
        List<SelectOption> options =  new List<SelectOption>();    
        Schema.DescribeFieldResult fieldResult = CSS_Parts_Options__c.Replacement_Reason__c.getDescribe();    
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();    
        for(Schema.picklistEntry f:ple)    
        {    
            options.add(new selectOption(f.getLabel(),f.getValue()));                    
        }    
        return Options;    
    }
    
    public void deleteParts(){
        System.debug('in deleteParts GSQ Parts:8');
        try{
 List<CSS_Parts_Options__c> toDeleteCustPartsList = new list<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> deleteCustPartsList = new List<CSS_Parts_Options__c>([select Id,Notes__c,OEM__c,Replacement_Reason__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c,Service_Job__c,Solutions__c
                                                                                         from CSS_Parts_Options__c where Id in:removeIdsMap.keySet()]);
        if(deleteCustPartsList.size()>0){
            for(CSS_Parts_Options__c d: deleteCustPartsList){
                for(partWrapperClass  prtslist:listpartWrapper ){
                    System.debug('prtslist.servPartNumber'+prtslist.servPartNumber);
                    System.debug('prtslist.servPartNumber'+d.id + '------->'+prtslist.ids);
                    if(d.id==prtslist.ids && prtslist.servPartNumber=='' ){  //why servPartNumber included in if condition?
                        toDeleteCustPartsList.add(d); 
                        System.debug('delete list');}
                    else{
                    }

                }     
            }
            if(toDeleteCustPartsList.size()>0)
                delete toDeleteCustPartsList;
        }
        removeIdsMap = new Map<Id, String>();
        }catch(Exception ex) {
            System.debug('in catch of deleteParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
         }
}
    
    
    
    public class partWrapperClass {
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        public String quantity {get;set;}
        public String servPartNumber {get;set;}
        public String partName {get;set;}
        public String replacementReasson {get;set;}
        public String notes {get;set;}
        public String oem {get;set;}
        public Boolean selectedPart {get;set;}
        public partWrapperClass(Integer counting,Id ids,String quantity,String servPartNumber,String partName,String replacementReasson,String notes,String oem,Boolean selectedPart) {
            this.counting = counting;
            this.ids = ids;
            this.idStr = ids;
            this.quantity = quantity;
            this.servPartNumber = servPartNumber;
            this.partName = partName;
            this.replacementReasson = replacementReasson;
            this.notes = notes;
            this.oem = oem;
            this.selectedPart = selectedPart;
            
        }        
    }
    
    
    
}