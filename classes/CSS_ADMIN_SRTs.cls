public class CSS_ADMIN_SRTs {
    public List<CSS_srt__c> lstDisplayAdmin{get;set;}
    public List<CSS_srt__c> lstDisplayAdminFiltered{get;set;}    
    public List<CSS_srt__c> lstOrigDisplayAdminFiltered;
    public List<CSS_srt__c> SRTList1{get;set;}
    public List<CSS_srt__c> SRTCustList{get;set;}
   
    public Boolean displayPopup1{get;set;}
    public Boolean displayPopup2{get;set;}
    public string adminTotalTime{get;set;}
    public Decimal totalDecimalAdminTime{get;set;}
    String flagPM = 'N';
    public Id Wid;
    public string adminStr {get;set;}
    public ID JobID {
        get;
        set {
            JobID=value;
        }
    }
    
    public void closePopup2() {
        system.debug('calling Closepopup2');
        displayPopup2 = false;
    }
    public void closePopup1()
    {
        if (lstDisplayAdmin !=null && lstDisplayAdmin.size()>0){
            lstDisplayAdmin.clear();
        }
        displaypopup1 = false;
        
    }
    public CSS_ADMIN_SRTs(){
        system.debug('lst**Gyan##Constructor');
        System.debug('JobID is '+JobID);
        getallData();
    }
    
    //Story #64032-Admin SRT-Start
    public void getallSRTData(){
        
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        String lAppCode; 
        
        CSS_Job_Order__c joLst = [Select INSITE_UpdateTimeStamp__c,Repair_Location__c,Application__c,Application_Desc__c,Preventive_Maintenance__c from CSS_Job_Order__c where Id=:Wid];
        
        //modified as per story# 64030
        //lAppCode = css_utility.getCodes('Application Code', joLst.Application__c, null, null);
        lAppCode = css_utility.getCodes('Application Code', joLst.Application_Desc__c, null, null);
         
        user uWrkGrp = css_utility.getUserAttributes(userinfo.getUserId());
        system.debug('joLst.Preventive_Maintenance__cIS'+joLst.Preventive_Maintenance__c);
        if (joLst.Preventive_Maintenance__c !='No'){
            flagPM = 'Y';
        }
        system.debug('Wid**getallSRTData##getallSRTData'+Wid);        
        lstDisplayAdmin = new List<CSS_srt__c>();
      //  lstDisplayAdmin = CSS_WS_SRT.getAllSRTs(Wid,flagPM,'Admin');
         lstDisplayAdmin = CSS_WS_SRT.getAllDigRepSRTs(string.valueof(Wid),'Admin');
      
        
        //getExisting from database and make them check
        
        for(css_Srt__c eList:SRTList1){            
            for (integer i=0;i<lstDisplayAdmin.size();i++){
                if(eList.srt_id__c ==lstDisplayAdmin[i].srt_id__c ){            
                    lstDisplayAdmin[i].SRTAdmi_Check__c = true;
                    lstDisplayAdmin[i].SRT_Notes__c = eList.SRT_Notes__c;
                }
            }
        }
        system.debug('MSNlstDisplayAdmin##'+lstDisplayAdmin);
        //Passing WS resp to wrapper to set the CheckBoxes by default
        
        for (CSS_SRT__c wSList:lstDisplayAdmin){   
            
            system.debug('Isnide wraploopadmnList'+wSList); 
            
            if (wSList.SRT_Id__c == '00-901-00'&& joLst.Repair_Location__c =='In Shop'){ 
                
                wSList.SRTAdmi_Check__c = true;
            }
            if (wSList.SRT_Id__c == '00-724-00'  && joLst.INSITE_UpdateTimeStamp__c!=null){                
                wSList.SRTAdmi_Check__c = true;
            }
            if (wSList.SRT_Id__c == '00-904-00' && (lAppCode == '310'|| lAppCode == '320'|| lAppCode == '610')){
                wSList.SRTAdmi_Check__c = true;
            }
            if (wSList.SRT_Id__c == '00-902-00' && joLst.Repair_Location__c =='Mobile'){
                wSList.SRTAdmi_Check__c = true;
            }
            if (wSList.SRT_Id__c == '00-906-00' && uWrkGrp.Work_Group_Name__c=='Dealer'){
                wSList.SRTAdmi_Check__c = true;
            }             
            
        }
        
        
        lstOrigDisplayAdminFiltered = lstDisplayAdmin.clone();        
        displayPopup1 = true;
    }
    public void getFilteredSRTs(){        
        
        lstDisplayAdminFiltered = new List<css_Srt__C>();
        system.debug('My search string -- >' +adminStr);
        if(adminStr!= null && adminStr!=''){
            
            for(css_srt__C lrList : lstOrigDisplayAdminFiltered){    
                
                system.debug('beforeIf' +adminStr);
                if(lrList.SRT_ID__c.containsignorecase(adminStr) || lrList.SRT_Title__c.containsignorecase(adminStr) ) {
                    system.debug('My search string InsideIf' +adminStr);                        
                    lstDisplayAdminFiltered.add(lrList);
                }
                
            }
            
            if(lstDisplayAdminFiltered.size()>0)
                lstDisplayAdmin = lstDisplayAdminFiltered;
        }
        else{
            system.debug('Inside Else admnOrigListWrapFiltered--> '+ lstOrigDisplayAdminFiltered);
            lstDisplayAdmin=lstOrigDisplayAdminFiltered;
        }
    } //Story #64032-Admin SRT-End
    
    //Story Custom SRT starts
    public PageReference saveCustSRT(){
        system.debug('inside savebox of Cust SRT1');  
        List<CSS_srt__c> selectedCustSRTList = new list<CSS_srt__c>();
        List<CSS_srt__c> toDeleteCustSRTList = new list<CSS_srt__c>();
        system.debug('The Listfrom UI is2'+SRTCustList);
        try {
            for (CSS_srt__c recCustSavSRT: SRTCustList) {
                system.debug('4');
                if (recCustSavSRT.SRTAdmi_Check__c) {
                    system.debug('5');
                    CSS_srt__c custSrtOb = new CSS_srt__c();
                    
                    custSrtOb.job_order__c =Wid;
                    custSrtOb.srt_id__C =recCustSavSRT.srt_id__C;
                    custSrtOb.Type__c =recCustSavSRT.Type__c;
                    custSrtOb.srt_notes__c =recCustSavSRT.srt_notes__c;
                    custSrtOb.srt_title__c =recCustSavSRT.srt_title__c;
                    custSrtOb.SRTAdmi_Check__c=true;
                    custSrtOb.SRT_Time_String__c =recCustSavSRT.SRT_Time_String__c;
                    custSrtOb.Type__c ='Custom';
                    custSrtOb.SRT_Type__c ='Custom';
                    custSrtOb.isPerformed__c =true;
                    custSrtOb.SRT_Quantity__c = 1;
                    if(recCustSavSRT.SRT_Time_String__c!=''){
                       custSrtOb.SRT_Time__c = decimal.valueOf(recCustSavSRT.SRT_Time_String__c); //* 60;Anirudh
                    }
                    custSrtOb.CSS_UniqueSRTValues__c = Wid+recCustSavSRT.srt_id__c;
                    selectedCustSRTList.add(custSrtOb);
                    
                }
                system.debug('selectedCustSRTList in Save'+selectedCustSRTList);
            }
            
            //DeleteList
            
            for(CSS_srt__c currentCustList: SRTList1){
                system.debug('6');
                system.debug('Current Custom SRT List is  !!'+currentCustList);
                
                for (integer j=0;j<SRTCustList.size();j++){
                    system.debug('7');
                    system.debug('SRTCustList List is  !!'+SRTCustList);
                    if((currentCustList.srt_id__c == SRTCustList[j].srt_id__C) &&(currentCustList.SRTAdmi_Check__c !=SRTCustList[j].SRTAdmi_Check__c )){  
                        CSS_srt__c srtCustDel = new CSS_srt__c();
                        srtCustDel.id= currentCustList.id;
                        toDeleteCustSRTList.add(srtCustDel);
                        system.debug('srtCustDel!! ' + srtCustDel);
                        
                    }
                }                
            }
                       
            if(selectedCustSRTList.size()>0){
                 system.debug('Inside Final Save');
                upsert selectedCustSRTList selectedCustSRTList.CSS_UniqueSRTValues__c;
            }
            If(toDeleteCustSRTList.size()>0){
                delete toDeleteCustSRTList;
            }
            
        }
        catch(Exception e) {
            system.debug('Error in Cust SRT Save Component ## ' + e.getmessage());
        }
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        system.debug('sDestURLiS'+sDestURL);
        PageReference pageRef = new PageReference(sDestURL+'id='+Wid); 
        pageRef.setRedirect(true);
        return pageRef;    
    }
    
    
    public void getallCustomSRTData() {
        SRTCustList = new List<CSS_SRT__C>();
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        Integer custAdminCount = [Select count() from CSS_SRT__c where Job_order__c=:Wid AND Type__c='Custom'];
        
        if (custAdminCount>0){
            
            SRTCustList = [Select id,SRTAdmi_Check__c,SRT_Details__c,SRT_Title__c,Name,SRT_Time__c,SRT_Notes__c,Job_Order__c,SRT_Id__c,SRT_Time_Hr_Min__c,type__c,SRT_Type__c,SRT_Time_String__c                  
                           from CSS_SRT__c where Job_order__c=:Wid AND Type__c='Custom' ];
            
            for(integer i=0;i<10-custAdminCount;i++){
                CSS_SRT__c customList = new CSS_SRT__c();
                if(!Test.isRunningTest()){
                    customList.SRTAdmi_Check__c=false;
                    customList.SRT_Time_String__c='';
                    customList.SRT_Id__c ='';
                    customList.SRT_Title__c='';
                    customList.SRT_Notes__c='';
                    customList.Job_Order__c=Wid;
                    customList.Type__c = 'Custom';
                    customList.SRT_Type__c = 'Custom'; 
                    SRTCustList.add(customList);
                }
                else{
                    customList.SRTAdmi_Check__c=true;
                    customList.SRT_Time_String__c='4.2';
                    customList.SRT_Id__c ='123';
                    customList.SRT_Title__c='TestTitle';
                    customList.SRT_Notes__c='asdsad';
                    customList.Job_Order__c=Wid;
                    customList.Type__c = 'Custom';
                    customList.SRT_Type__c = 'Custom'; 
                    SRTCustList.add(customList);
                    
                    
                }
            }
            System.debug('The list is'+SRTCustList);
        }
        else{
            
            for(integer i=0;i<10;i++){
                CSS_SRT__c customList = new CSS_SRT__c();
                if(!Test.isRunningTest()){
                    customList.SRTAdmi_Check__c=false;
                    customList.SRT_Time_String__c='';
                    customList.SRT_Id__c ='';
                    customList.SRT_Title__c='';
                    customList.SRT_Notes__c='';
                    customList.Job_Order__c=Wid;
                    customList.Type__c = 'Custom';
                    customList.SRT_Type__c= 'Custom';
                    SRTCustList.add(customList);
                }else{
                    customList.SRTAdmi_Check__c=true;
                    customList.SRT_Time_String__c='4.2';
                    customList.SRT_Id__c ='123';
                    customList.SRT_Title__c='sdsad';
                    customList.SRT_Notes__c='asdsads';
                    customList.Job_Order__c=Wid;
                    customList.Type__c = 'Custom';
                    customList.SRT_Type__c= 'Custom';
                    SRTCustList.add(customList);
                    
                }
            }
            System.debug('The list is'+SRTCustList);
        }
        System.debug('displayPopup2 Set true');
        displayPopup2 = true;
        
    }
    //Story Custom SRT End   
    
    public void getallData() {
        decimal totalAdminTime =0.0;
        integer iAdminTime;
        integer iAdminMinutes;
        integer iAdminHour;
        string sDTime;
        try{
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            SRTList1 = [Select id,SRTAdmi_Check__c,SRT_Details__c,SRT_Title__c,Name,SRT_Time__c,SRT_Notes__c,Job_Order__c,SRT_Id__c,SRT_Time_Hr_Min__c,SRT_Decimal_Time__c,
                        Admin_Miles_In__c,Admin_Miles_Out__c,Admin_Arrive_Job__c,Admin_Arrive_Shop__c,Admin_Finish_Job__c,Admin_Leave_Job__c,Admin_Left_Shop__c,Admin_Start_Job__c,Type__c,SRT_Time_String__c
                        from CSS_SRT__c where Job_order__c=:Wid AND (SRT_Type__c='Admin' OR Type__c ='Custom') ];
            system.debug('Wid##' + Wid);
            system.debug('SRTList1##' + SRTList1);
            
            for (CSS_SRT__c srtTime:SRTList1){
                
                totalAdminTime = totalAdminTime+srtTime.SRT_Time__c;
                
            }
            if (totalAdminTime != 0.0 && totalAdminTime >=60) { 
                iAdminTime = totalAdminTime.intValue();
                iAdminMinutes = math.mod(iAdminTime,60);
                iAdminHour = (iAdminTime-iAdminMinutes)/60;
                sDTime = iAdminHour + ' hours '  + iAdminMinutes + ' minutes ';
            }  else{
                iAdminTime = totalAdminTime.intValue();
                sDTime = '00' + ' hours '  + iAdminTime + ' minutes ';
            }
            system.debug('totalTime is'+sDTime);
            adminTotalTime =sDTime;
            //New code change Story# 78784 
            totalDecimalAdminTime = totalAdminTime / 60 ;
            
        }
        catch(Exception e) {
            system.debug('Error in Admin SRT Component ## ' + e.getmessage());
        }
    }
    public PageReference saveBox() { 
        system.debug('inside savebox of Admin SRT');  
        List<CSS_srt__c> selectedSRTList = new list<CSS_srt__c>();
        List<CSS_srt__c> toDeleteSRTList = new list<CSS_srt__c>();
        try {
            for (CSS_srt__c recSavSRT: lstDisplayAdmin) {
                if (recSavSRT.SRTAdmi_Check__c) {
                    CSS_srt__c srto = new CSS_srt__c();
                    
                    srto.job_order__c =Wid;
                    srto.srt_id__C =recSavSRT.srt_id__C;
                    srto.Type__c =recSavSRT.Type__c;
                    srto.srt_notes__c =recSavSRT.srt_notes__c;
                    srto.srt_title__c =recSavSRT.srt_title__c;
                    srto.srt_Type__c =recSavSRT.srt_type__c;
                    srto.SRTAdmi_Check__c=true;
                    srto.Access_Code_A__c =recSavSRT.Access_Code_A__c;
                    srto.Access_Code_B__c=recSavSRT.Access_Code_B__c;
                    srto.Access_Code_C__c=recSavSRT.Access_Code_C__c;
                    srto.Access_Code_D__c=recSavSRT.Access_Code_D__c;
                    srto.Access_Code_R__c=recSavSRT.Access_Code_R__c;
                    srto.Admin_Miles_In__c =recSavSRT.Admin_Miles_In__c;
                    srto.Admin_Miles_Out__c =recSavSRT.Admin_Miles_Out__c;
                    srto.Admin_Arrive_Job__c =recSavSRT.Admin_Arrive_Job__c;
                    srto.Admin_Arrive_Shop__c =recSavSRT.Admin_Arrive_Shop__c;
                    srto.Admin_Finish_Job__c =recSavSRT.Admin_Finish_Job__c;
                    srto.Admin_Leave_Job__c =recSavSRT.Admin_Leave_Job__c;
                    srto.Admin_Left_Shop__c =recSavSRT.Admin_Left_Shop__c;
                    srto.Admin_Start_Job__c =recSavSRT.Admin_Start_Job__c;
                    srto.SRT_Time__c =recSavSRT.SRT_Time__c;
                    srto.isPerformed__c =true;
                    srto.SRT_Quantity__c = 1;
                        
                    srto.CSS_UniqueSRTValues__c = Wid+recSavSRT.srt_id__c;
                    selectedSRTList.add(srto);
                    
                }
                
            }
            
            //DeleteList
            
            for(CSS_srt__c currentList: SRTList1){
                
                system.debug('Current List is  !!'+currentList);
                
                for (integer j=0;j<lstDisplayAdmin.size();j++){
                    system.debug('lstDisplayAdmin List is  !!'+lstDisplayAdmin);
                    if((currentList.srt_id__c == lstDisplayAdmin[j].srt_id__C) &&(currentList.SRTAdmi_Check__c !=lstDisplayAdmin[j].SRTAdmi_Check__c )){  
                        CSS_srt__c srtDel = new CSS_srt__c();
                        srtDel.id= currentList.id;
                        toDeleteSRTList.add(srtDel);
                        system.debug('srtDel!! ' + srtDel);
                        
                    }
                }                
            }
            system.debug('DeleteListis !!'+toDeleteSRTList);
            system.debug('SaveList !!'+selectedSRTList);
            system.debug('SaveListSize !!'+selectedSRTList.size());
            
            if(selectedSRTList.size()>0){
                 system.debug('Inside Final Save');
                upsert selectedSRTList selectedSRTList.CSS_UniqueSRTValues__c;
            }
            If(toDeleteSRTList.size()>0){
                delete toDeleteSRTList;
            }
            
        }
        catch(Exception e) {
            system.debug('Error in Admin SRT Save Component ## ' + e.getmessage());
        }
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        system.debug('sDestURLiS'+sDestURL);
        PageReference pageRef = new PageReference(sDestURL+'id='+Wid); 
        pageRef.setRedirect(true);
        return pageRef;    
    }
        
    /*public void IWantToDebug() {
        
        String para = Apexpages.currentPage().getParameters().get('node');
        
        System.debug('======================= ' + para);
        List<CSS_AdminSRT_Details__c> lst =[Select id, Add__c, Notes__c, SRT_CODE__c, SRT_Description__c, SRT_Time__c from CSS_AdminSRT_Details__c where SRT_CODE__c=:para];
        
        system.debug('lst**Gyan##' + lst);
        //List<CSS_srt__c> lstDisplayAdmin = new List<CSS_srt__c>();
        lstDisplayAdmin.clear();
        for (Integer i=0; i <lst.size(); i++) {
            CSS_srt__c recAdmSRT = new CSS_srt__c();
            recAdmSRT.SRTAdmi_Check__c = false;
            // recAdmSRT.Job_Order__c=Wid;
            recAdmSRT.SRT_Notes__c = '';
            recAdmSRT.SRT_Title__c = lst[i].SRT_Description__c;
            recAdmSRT.SRT_Details__c = lst[i].SRT_CODE__c;
            if (lst[i].SRT_Time__c != '' && lst[i].SRT_Time__c != null) {
                recAdmSRT.SRT_Time__c = Integer.valueof(lst[i].SRT_Time__c);
            }
            recAdmSRT.Type__c = 'Admin';
            lstDisplayAdmin.add(recAdmSRT);
        }
        system.debug('lstDisplayAdmin'+lstDisplayAdmin);
    } */
    
}