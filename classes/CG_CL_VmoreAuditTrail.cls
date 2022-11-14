public class CG_CL_VmoreAuditTrail {
  
    string strField;
    public Id vMore_JobId {
        get;
        set {
            vMore_JobId = value;
            system.debug('VmoreAudit**');
            last_hist1 = getOneHistory(vMore_JobId);           
        }
    }
    //public static String sortBy {get; set;}
    public CG_CL_VmoreAuditTrail() {
        Wid=ApexPages.CurrentPage().getParameters().get('id');
     
    }
    public transient list<cHistories> last_hist1 {get;set;}

    public final css_job_order__c J;
    public ID Wid;
    
    
    
    
    // Method getOneHistory rewritten for the fix - 99104 - "The latest record event is not updated in 'Audit Trail' section for Advanced and Technician user."

    
 
    public list<cHistories> getOneHistory(Id JID)
    {    

        // Initialize list to be returned
        list<cHistories> list_ch = new list<cHistories>();

        // Loop through all field history records
        for (css_job_order__history jh: [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
                                         CreatedBy.Name From css_job_order__history where parentId = :JID Order by CreatedDate desc ]) 
        {
            system.debug('**jh**'+jh);
            Boolean show=true;
            cHistories ch = new cHistories();
            // Set the Date
            ch.theDate = String.valueOf(jh.createddate);
            // Set who performed the action
            ch.who = jh.createdby.name;
            // Set the Action value
            if (String.valueOf(jh.Field) == 'created') 
            {    // on Creation
                ch.action = 'Created.';
            } 
            else if (jh.OldValue != null && jh.NewValue == null)
            { // when deleting a value from a field
                // Format the Date and if there's an error, catch it and re
                try {
                    String fromText = 'Blank';    
                    fromText = Date.valueOf(jh.OldValue).format();
                    system.debug('**fromText **'+fromText );                    

                    String toText = '';

                    toText = Date.valueOf(jh.NewValue).format();
                    system.debug('**toText **'+toText );
                    strField=String.valueOf(jh.Field);
                    strField=strField.replace('__c', '');

                    //Checking if value starts with 005 or not
                    if(strField=='Assigned_To' || strField=='Additional_Tech1' || strField=='Additional_Tech2'){
                        if((fromText.startsWith('005')))
                            show=false; 
                        if(toText!=null){ 
                            if(toText.startsWith('005'))   
                                show=false;
                        } 
                    }
                    //.action = 'Deleted ' + String.valueOf(jh.OldValue) + ' in <b>' + strField  + '</b>.';
                    ch.action = 'Deleted ' + '<b>' + String.valueOf(jh.OldValue) + '</b>' + ' in <b>' + strField  + '</b>.';

                }
                catch (Exception e){

                    strField=String.valueOf(jh.Field);
                    strField=strField.replace('__c', '');
                    //Checking if value starts with 005 or not
                    if((strField=='Assigned_To' || strField=='Additional_Tech1' || strField=='Additional_Tech2') && (String.valueOf(jh.OldValue).startsWith('005')))                   
                    {
                        show=false; 
                    }  

                    else {
                        //h.action = 'Deleted ' + String.valueOf(jh.OldValue) + ' in <b>' + strField  + '</b>.';  
                        ch.action = 'Deleted ' +'<b>'+ String.valueOf(jh.OldValue)+'</b>' + ' in <b>' + strField  + '</b>.'; 
                    }

                }
            } 




            else 
            {             // all other scenarios
                String fromText = 'Blank';
                if (jh.OldValue != null) 
                {
                    try {
                        fromText = Date.valueOf(jh.OldValue).format();
                        system.debug('**fromText **'+fromText );
                    } 
                    catch (Exception e) {
                        fromText = String.valueOf(jh.OldValue);
                        system.debug('**fromTextCatch **'+fromText );
                    }
                }
                String toText = '';
                try {
                    toText = Date.valueOf(jh.NewValue).format();
                    system.debug('**toText **'+toText );
                } 
                catch (Exception e) 
                {
                    toText = String.valueOf(jh.NewValue);
                    system.debug('**toTextcatch **'+toText );
                }

                strField=String.valueOf(jh.Field);
                strField=strField.replace('__c', '');

                //Checking if value starts with 005 or not
                if(strField=='Assigned_To' || strField=='Additional_Tech1' || strField=='Additional_Tech2'){
                    if((fromText.startsWith('005')))
                        show=false; 
                    if(toText!=null){ 
                        if(toText.startsWith('005'))   
                            show=false;
                    } 
                } 
                ch.action = 'Changed <b>' + strField + '</b>' + ' from <b>' + fromText  + '</b>' + ' to <b>' + toText + '</b>.';

            }    
            if(show)
                list_ch.add(ch);            

        }
        /*** Starting Code for printing the Field Values from Job history object. ***/
        Transient List<CSS_JobHistory__c> jobHistoryList = [Select Id,CreatedDate,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c from CSS_JobHistory__c where CSS_Job_Id__c=:wID];
        system.debug('jobHistoryList>>>>>>>' + jobHistoryList);
        if(jobHistoryList != null && !jobHistoryList.isEmpty()){
            for(CSS_JobHistory__c jobHisRec : jobHistoryList){
                cHistories ch = new cHistories();
                // Set the Date
                ch.theDate = String.valueOf(jobHisRec.createddate);
                // Set who performed the action
                ch.who = jobHisRec.createdby.name;
                // Set the Action value
                String fromText = 'Blank';
                String OldValue = 'Blank';
                String NewValue = 'Blank';
                
                OldValue = (String.valueOf(jobHisRec.CSS_Old_Value__c) == null ? 'Blank' : String.valueOf(jobHisRec.CSS_Old_Value__c));
                NewValue = String.valueOf(jobHisRec.CSS_New_Value__c);
                fromText = String.valueOf(jobHisRec.CSS_New_Value__c); 
                if (jobHisRec.CSS_Old_Value__c=='Added' && jobHisRec.CSS_Old_Value__c != null) 
                {    // on Creation

                    ch.action = 'Added Attachment <b>'  + fromText + '</b>.';
                }

                else if (jobHisRec.CSS_Old_Value__c != null && jobHisRec.CSS_Old_Value__c == 'Deleted')
                { 
                    ch.action = 'Deleted  Attachment <b>'  + fromText + '</b>.';
                }   
                //Rajesh Added code  for JSA Audit Trail
                
                 else if (jobHisRec.CSS_Old_Value__c != null && jobHisRec.CSS_Old_Value__c == 'Added JSA form')
                { 
                     ch.action = 'Added JSAForm <b> '  + fromText + '</b>.';
                }   
                
                 else if (jobHisRec.CSS_Old_Value__c != null && jobHisRec.CSS_Old_Value__c=='Added In Shop JSA form') 
                {   
                    ch.action = 'Added In-Shop JSA Form <b> '  + fromText + '</b>.';
                }
                
                 else if (jobHisRec.CSS_Old_Value__c != null && jobHisRec.CSS_Old_Value__c=='Added FieldService JSA') 
                {   
                     ch.action = 'Added Field Service JSA Form <b> '  + fromText + '</b>.';
                }
                
                 else if (jobHisRec.CSS_Old_Value__c=='Added Marine JSA' && jobHisRec.CSS_Old_Value__c != null) 
                {    
                     ch.action = 'Added Marine JSA Form <b> '  + fromText + '</b>.';
                }
                
                 else if (jobHisRec.CSS_Old_Value__c=='Added PowerGen JSA' && jobHisRec.CSS_Old_Value__c != null) 
                {    
                     ch.action = 'Added Power Gen JSA Form <b> '  + fromText + '</b>.';
                }

                // DSID Owner tracking: Sai 3/22 for Q1 UAT Defect
                else if(jobHisRec.CSS_Field_Name__c=='DSID_Owner__c') // && jobHisRec.CSS_Old_Value__c != null)
                {
                    ch.action = 'Changed <b> DSID owner </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                }
                // End of DSID Owner Track.
                // VIN Audit, only If it is changed manually by user: Sai 4/11/2017 for CUBS story # 88616
                else if(jobHisRec.CSS_Field_Name__c=='VIN__c') // && jobHisRec.CSS_Old_Value__c != null)
                {
                    ch.action = 'Changed <b> VIN </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                }
                // End of VIN Audit
                // Sub Status AuditSub_Status__c
                else if(jobHisRec.CSS_Field_Name__c=='Sub_Status__c') // && jobHisRec.CSS_Old_Value__c != null)
                {
                    ch.action = 'Changed <b> Sub Status </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                }
                // End of Sub Status Audit
                // 76192 start
                else if(jobHisRec.CSS_Field_Name__c=='JobLocation__c') 
                {
                    ch.action = 'Changed <b> Location </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                }
                // 76192 End

                //90900 Start
                if(jobHisRec.CSS_Field_Name__c=='Additional_Tech3__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech4__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech5__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech6__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech7__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech8__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech9__c'){
                    ch.action = 'Changed <b>' + jobHisRec.CSS_Field_Name__c + '</b>' + ' from '  + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';

                }

                if((jobHisRec.CSS_New_Value__c == null || jobHisRec.CSS_New_Value__c == '' ) && (jobHisRec.CSS_Old_Value__c !=''||jobHisRec.CSS_Old_Value__c !=null)){
                    ch.action = 'Deleted ' + '<b>' + OldValue + '</b>' + ' in <b>' + jobHisRec.CSS_Field_Name__c  + '</b>.';

                }
                //90900 End

                if(ch.action != null && ch.action != '')
                    list_ch.add(ch);             
            }
        }
        list_ch.sort();
        list<cHistories> list_ch2 = new list<cHistories>();

        for(Integer i = list_ch.size() - 1; i >= 0; i--){
            //Start-Added below line as per defect #154137,-By RAJESH 29th Oct 2018[working in test org]
            list_ch[i].action = (list_ch[i].action).replace('ESN', 'PSN');
            //End 
            list_ch2.add(list_ch[i]);
        }
         list<cHistories> list_ch3 = new list<cHistories>();
         if(list_ch2 != null && list_ch2.size() > 0){
            list_ch3.add(list_ch2[0]);
         }
         system.debug('**list_ch3**'+list_ch3);
        return list_ch3;     
    }
 

    public class cHistories  implements Comparable{
        public String theDate {get; set;}
        public String who {get; set;}
        public String action {get; set;}
        public cHistories(){}
        public cHistories(String dte,String Name, String act) {
            theDate = dte;
            who = Name;
            action = act;
        }
        public Integer compareTo(Object ObjToCompare) {
           // cHistories compareToHis = (cHistories)compareTo;
            return theDate.CompareTo(((cHistories)ObjToCompare).theDate);
        }
    }
}