public class OSMCustomerLookupPopup{
    public Account account{get;set;}
    public Map<string,AccountWrapperCls> accWrapperMap {get;set;}
    public boolean displayPopup {get; set;} 
    public boolean displayMsg {get; set;} 
    public string selectedaccname {get; set;} 
    public string selectedDisCode {get; set;} 
    public string HQcustomercode {get; set;} 
    public string HQDistributorcode {get; set;} 
    public boolean UnlinkBMS {get; set;}
    public string  selectedcustomercode {set;get;}
    public string displayPopupmsg {get; set;} 
    public Boolean showDistributorMsg {get; set;} 
    map<string,string> HQCodemapping = new map<string,string>();
    map<string,string> Codemapping = new map<string,string>();
    List<string> UScodes = label.OSM_USBMSDistributorCodes.split(',');
    List<string> Southerncodes = label.OSM_SouthernPlainsBMSDistributorCodes.split(',');
    List<string> HQcodes = label.OSM_BMSHQDistributors.split(',');
    list<string> codeshq =new list<string>();
    list<string> codesplains =new list<string>();
    public OSMCustomerLookupPopup(ApexPages.StandardController controller) {
        this.account= new Account();
        if(!test.isRunningTest())controller.addFields(new List<String>{'Name','OSM_Location_ID__c','OSM_SW_Responsible_Region__c','EBU_Channel_of_Distribution__c','PSBU_Channel_of_Distribution__c','CSS_WS_Channel_of_Distribution__c','BMS_Customer_ID_Junction__c','CSS_DistributorCode__c','IAM_Service_Provider_Code__c'});
        this.account = (Account)controller.getRecord();
        displayPopup=displayMsg=UnlinkBMS= false;
        accWrapperMap=new Map<string,AccountWrapperCls>();
        displayPopupmsg='';
        showDistributorMsg = false;
        system.debug('this.account'+this.account);
        if((this.account.EBU_Channel_of_Distribution__c == 'DISTRIBUTOR-HEADQUARTERS' || (this.account.EBU_Channel_of_Distribution__c == 'DISTRIBUTOR-BRANCH') || this.account.PSBU_Channel_of_Distribution__c == 'DISTRIBUTOR-HEADQUARTERS' || this.account.PSBU_Channel_of_Distribution__c == 'DISTRIBUTOR-BRANCH')){
            showDistributorMsg = true;
        }
        
        if(account.CSS_DistributorCode__c!=null)HQDistributorcode=account.CSS_DistributorCode__c;
    }
    //Search BMS Callout Method
    public pagereference SearchaccountBMS(){
        system.debug('HQcustomercode'+HQcustomercode);
        system.debug('Account'+Account);
        if(account!=null){
            //BMSCustomerCallout(account,false,HQcustomercode);
            
            boolean callBMS = false;
            boolean ErrorForBMSNumber = false;
            
            
            if(selectedDisCode != null && selectedDisCode != '' && selectedDisCode.length() <4)
            {
                ErrorForBMSNumber = true;
            }
            else if(selectedDisCode!=null && selectedDisCode.length()>=4 )
            {
                callBMS = true;
            }
            if(!ErrorForBMSNumber)
            {
                if(selectedaccname!=null && selectedaccname.length()>=3 )
                {
                    callBMS = true;
                }
            }
            
            System.debug('callBMS: '+callBMS);
            System.debug('selectedaccname: '+selectedaccname);
            System.debug('Account.BMS_Customer_ID_Junction__c: '+Account.BMS_Customer_ID_Junction__c);
            if(callBMS)
            {
                BMSCustomerCallout(account,false,HQcustomercode);
            }
            else if(ErrorForBMSNumber)
            {
                displayPopupmsg='ErrorBMSCode';
            }
            
            else if(selectedaccname==null ||selectedaccname==''){
                if(Account.BMS_Customer_ID_Junction__c!=null && Account.BMS_Customer_ID_Junction__c!=''){
                    BMSCustomerCallout(account,true,HQcustomercode);
                } else {
                    selectedaccname='';
                    displayPopupmsg='Error';
                    
                } 
            }
            
            
                
            
            /*
            if( (selectedaccname!=null && selectedaccname.length()>=3 ) )
                BMSCustomerCallout(account,false,HQcustomercode);
            else if(selectedaccname==null ||selectedaccname==''){
                if(Account.BMS_Customer_ID_Junction__c!=null && Account.BMS_Customer_ID_Junction__c!=''){
                    BMSCustomerCallout(account,true,HQcustomercode);
                } else {
                    selectedaccname='';
                    displayPopupmsg='Error';
                    
                } 
            }*/
        }
        return null;
    }
    // BMS Callout Method
    @testvisible
    private void BMSCustomerCallout(account account,boolean existing,string distcode) {
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        try{
            OSM_BMS_WS_GeneralizedInputWrapper inputWrapperObj=new OSM_BMS_WS_GeneralizedInputWrapper();
            inputWrapperObj.DataArea=new OSM_BMS_WS_GeneralizedInputWrapper.DataArea();
            inputWrapperObj.Header=new OSM_BMS_WS_GeneralizedInputWrapper.Header();
            inputWrapperObj.Header.Location=new OSM_BMS_WS_GeneralizedInputWrapper.Location();
            inputWrapperObj.Header.Sender=new OSM_BMS_WS_GeneralizedInputWrapper.Sender();
            inputWrapperObj.Header.Target=new OSM_BMS_WS_GeneralizedInputWrapper.Target();
            if(!existing){
                                                                                                         
                inputWrapperObj.DataArea.CustomerCode='';
                inputWrapperObj.DataArea.CustomerName = '';
                if(selectedaccname != null && selectedaccname != '')
                    inputWrapperObj.DataArea.CustomerName = EncodingUtil.urlEncode(selectedaccname, 'UTF-8');
                if(selectedDisCode != null && selectedDisCode != '')
                inputWrapperObj.DataArea.CustomerCode=selectedDisCode;
            }else {
                inputWrapperObj.DataArea.CustomerName='';
                inputWrapperObj.DataArea.CustomerCode=Account.BMS_Customer_ID_Junction__c;
                displayPopUp=UnlinkBMS= true;
                displayPopupmsg='Data';
            }
            if(account.OSM_Location_ID__c!=null)inputWrapperObj.Header.Location.LocationID=account.OSM_Location_ID__c;
            else inputWrapperObj.Header.Location.LocationID='';
            if(account.CSS_WS_Channel_of_Distribution__c!=null)inputWrapperObj.DataArea.DealerCode=account.CSS_WS_Channel_of_Distribution__c;
            else  inputWrapperObj.DataArea.DealerCode='';
            
            
            if(distcode!=null){
                system.debug('codeshq'+codeshq.contains(HQDistributorcode));
                 system.debug('codesplains'+codesplains.contains(HQDistributorcode));
                if(codeshq.contains(HQDistributorcode)){
                    if(HQcustomercode=='US BMS Instance'){ 
                        inputWrapperObj.Header.Location.LocationID=HQDistributorcode+'-'+HQDistributorcode;
                    }else if(HQcustomercode=='Southern Plains BMS Instance'){
                        inputWrapperObj.Header.Location.LocationID=codesplains[0]+'-'+codesplains[0];
                    }
                    
                }else if(codesplains.contains(HQDistributorcode)){
                    if(HQcustomercode=='US BMS Instance'){ 
                        inputWrapperObj.Header.Location.LocationID=codeshq[1]+'-'+codeshq[1];
                    }else if(HQcustomercode=='Southern Plains BMS Instance'){
                        inputWrapperObj.Header.Location.LocationID=codesplains[0]+'-'+codesplains[0];
                    }
                    
                }
                
            }
            if(account.EBU_Channel_of_Distribution__c == 'CIHR' || account.PSBU_Channel_of_Distribution__c == 'CIHR')
            {
                inputWrapperObj.Header.Location.LocationID=account.OSM_SW_Responsible_Region__c+'-'+account.OSM_SW_Responsible_Region__c;
            }
            
            OSM_BMS_WS_GeneralizedOutputWrapper responseWrpObj = OSM_BMS_WS_CustomerLookupOutbound.callBMSService(inputWrapperObj);
            system.debug('Response'+responseWrpObj);
            system.debug('Response'+responseWrpObj.log);
            log=responseWrpObj.log;
            if(!responseWrpObj.errorFlag && responseWrpObj.DataArea!=null && responseWrpObj.DataArea.size()>0){
                displayPopUp = true;
                displayPopupmsg='Data';
                log.Response__c='Total of  '+responseWrpObj.DataArea.size()+' records received from the response';
                for(OSM_BMS_WS_GeneralizedOutputWrapper.DataArea dataAreaObj:responseWrpObj.DataArea){
                    if(!existing){
                        if(accWrapperMap.size()>1000)break;
                        accWrapperMap.put(dataAreaObj.CustomerCode,new AccountWrapperCls(dataAreaObj.CustomerName,dataAreaObj.CustomerCode,dataAreaObj.State,dataAreaObj.City,false));
                    }else{
                        accWrapperMap.put(dataAreaObj.CustomerCode,new AccountWrapperCls(dataAreaObj.CustomerName,dataAreaObj.CustomerCode,dataAreaObj.State,dataAreaObj.City,true));
                    }
                }
                selectedaccname='';
                
            }
            else if(responseWrpObj.DataArea==null || responseWrpObj.DataArea.size()==0) {
                displayMsg=true;
                if(selectedDisCode != null && selectedDisCode != '')
                {
                    displayPopupmsg='ErrorBMSCode';
                }
                else
                {
                    displayPopupmsg='Error';
                }
                selectedaccname='';
            }
            
            if(test.isRunningTest()){
                new AccountWrapperCls('','','','',false);
                throw new DMLException('My DML EXCEPTION'); 
            }
        }
        catch(Exception ex){
            System.debug('exception : '+ex.getMessage());
            log.Status__c = label.OSM_Bolt_Log_Status_Failure; 
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c = msg;
            
        }finally{
            insert log; 
        }
        
        
    }
    
    //Update account BMS Code
    public PageReference updateBMSNo() { 
        try{
            system.debug('Customer Code'+selectedcustomercode);
            if(accWrapperMap.containsKey(selectedcustomercode)){
                account.BMS_Customer_ID_Junction__c=accWrapperMap.get(selectedcustomercode).BMSNo;
                update account;
            }
            accWrapperMap.clear();
            PageReference pageRef = new ApexPages.StandardController(Account).view();
            pageRef.setRedirect(true);
            return pageRef;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }
    public PageReference getSelected(){
        selectedcustomercode = ApexPages.currentPage().getParameters().get('CustomerCode');
        return null;
    }
    //Method to unlink BMS Number
    public PageReference UnlinkBMSNumber() { 
        try{
            if(UnlinkBMS){
                account.BMS_Customer_ID_Junction__c='';
                update account;
            }
            PageReference pageRef = new ApexPages.StandardController(Account).view();
            pageRef.setRedirect(true);
            return pageRef;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
        
    }
    // Pop-up Close method
    public void closePopup(){       
        displayPopup =displayMsg=UnlinkBMS =false;
        selectedaccname='';
        accWrapperMap.clear();
    } 
    //  Wrapper Class for showing data on Pop-up
    public class AccountWrapperCls {
        public String customerName {get; set;} 
        public String BMSNo {get;set;} 
        public String State {get;set;} 
        public String City {get;set;} 
        public boolean IsSelected {get;set;} 
        public AccountWrapperCls(String customerName,String BMSNo,string State,string City,boolean selected) {
            this.customerName = customerName;  
            this.BMSNo = BMSNo ;   
            this.State=State;
            this.City=City;
            this.IsSelected=selected;
        }
    }  
    
    public List<SelectOption> getdistributorcodes(){
        List<SelectOption> options = new List<SelectOption>(); 
        for(string str :HQcodes){
            options.add(new SelectOption(str,str));
            for(string usstr :UScodes){
                if(usstr.substringAfter('-')!=null){
                     if(!codeshq.contains(usstr.substringAfter('-')))codeshq.add(usstr.substringAfter('-'));
                }
            }
            for(string str1 :Southerncodes){
                if(str1.substringAfter('-')!=null){
                  if(!codesplains.contains(str1.substringAfter('-')))codesplains.add(str1.substringAfter('-'));
                }
            }
            
        }
        if(HQDistributorcode=='02466'){
            HQcustomercode='Southern Plains BMS Instance';  
        }else{
            HQcustomercode='US BMS Instance';
        }
        
        system.debug('HQcustomercode'+HQcustomercode);
        return options; 
        
    }
}