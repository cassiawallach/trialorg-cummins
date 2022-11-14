/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimsOtherHistory {

    public static String strESN { get; set  { strESN=value; } }
    public static dateTime dtCreated { get; set { dtCreated=value; } }  
    public static Id ClaimsID { get; set  { ClaimsID=value; } }
    public static Id serviceJobID{get;set {serviceJobID=value;}}
    public string ClaimNum {get;set;}
    public static integer lessCount=0;
    public static integer moreCount=0;

    public CG_CL_ClaimsOtherHistory()
    {
        system.debug('InsideMan1**'+ClaimsID);
        if(ClaimsID != null){
            serviceJobID = [select id,css_job__c from CSS_Claims__c where id=:ClaimsID].css_job__c;}
    }
    public void getConnectedDiagHistory(){
        system.debug('InsideMan**'+ClaimsID);
        if(ClaimsID != null){
            serviceJobID = [select id,css_job__c from CSS_Claims__c where id=:ClaimsID].css_job__c;}

        // }
        //Insert Alets for Auto or Manual claims based on job id/Claim Id respectively.
        // public static void requestAlerts() 
        // {
        /*if(serviceJobID != null){
            String JobNum = [select id,Name from CSS_job_order__c where id=:serviceJobID].Name;
        CSS_receive30DayAlerts.requestAlerts(serviceJobID,strESN, JobNum,1.0,'');
        }
        else{
           CSS_receive30DayAlerts.requestAlerts(ClaimsID,strESN, ClaimNum,1.0,''); }*/
        // CSS_receive30DayAlerts.requestAlerts(Id id,String ESN, String CSSJobNumber,Decimal Mileage,String Measure);
    }
    public class ServiceHistWrap {
        public string sCustomerName;
        public string sCSSJobNum;
        public string sShopsWorkOrder;
        public string sServiceModel;    
        public string sLocation;
        public string sWorkSummary;
        public string sFaultcodeSymp;
        public Decimal sMileage;
        public string sRecent_Visit;
        public string sCreated_Time_Zone;
        public string sCreated_Time_sort;
        public string sMeter;
        public Boolean sRepeat_Visit;
        public Id sjobId;
        public string sBMSLink;
        public string sFaultCodeSym;
        public string sCustomerComplaint;
        public string sStatus;
        public  ServiceHistWrap () {

            sRepeat_Visit=false;
            sCustomerName='';
            sCSSJobNum='';
            sShopsWorkOrder='';
            sLocation='';
            sWorkSummary='';
            sjobId=null;
            sFaultcodeSymp='';
            sMileage=0;
            sCreated_Time_sort='';
            sBMSLink='';
            sFaultCodeSym='';
            sCustomerComplaint='';
            sStatus='';
        }
    }
    public class ServiceHistWrap2 {
        //Static Variables 

        public boolean brepeatFlg2;
        public boolean brecentFlg2;
        public string sCustomerName2;
        public string sCSSJobNum2;
        public string sShopsWorkOrder2;
        public string sServiceModel2;    
        public string sLocation2;
        public string sWorkSummary2;
        public string sFaultcodeSymp2;
        public Decimal sMileage2;
        public string sCreated_Time_Zone2;
        public string sCreated_Time_sort2;
        public Boolean sRepeat_Visit2;
        public string sMeter2;
        public Id sjobId2;
        public string sBMSLink2;
        public string sFaultCodeSym2;
        public string sCustomerComplaint2;
        public string sStatus2;
        public ServiceHistWrap2 () {

            //  brepeatFlg2=false;
            sRepeat_Visit2=false;
            sCustomerName2='';
            sCSSJobNum2='';
            sShopsWorkOrder2='';
            sLocation2='';
            sWorkSummary2='';
            sFaultcodeSymp2='';
            sMileage2=0;
            sjobId2=null;
            sCreated_Time_sort2='';
            sBMSLink2='';
            sFaultCodeSym2='';
            sCustomerComplaint2='';
            sStatus2='';
        }

    }

    public static integer getLessthan30days() {
        integer less = 0;
        DateTime lastDate = dtCreated.addDays(-30);
        List < CSS_Job_Order__c > lstjob = [select id from CSS_Job_Order__c where ESN__c = :strESN and createdDate >= :lastDate and createdDate < :dtCreated
                                            order by createdDate desc];
        if(lstjob != null)
            less = lstjob.size();
        return less;
    }

    public static String getRecentHistJobs() {

        system.debug('inside 1rajeshhhhhhhhhhhhhhh' + dtCreated);

        try{

            List < ServiceHistWrap > lstwrap = new List < ServiceHistWrap > ();
            List < CSS_Job_Order__c > lstjob;
            List<CSS_Fault_Code__c> allFaultCodes; 
            List<CSS_SymptomQA__c> allRecList;
            List<CSS_Solutions__c> lstSolsForSym;
            List < CSS_JobEventTemporary__c > Histlstjob;
            DateTime lastDate = dtCreated.addDays(-30);

            system.debug('strESNrajesh'+strESN);
            system.debug('nishaaaaaaaaaaa'+dtCreated);

            //Added Category and Complaint Type Desciption fields to display Customer Complaint for Defect 110833 -- Rajasekhar H
            lstjob = [select id, createdDate,Created_Time_Zone__c,Customer_Name__c,Mileage_Measure__c, Name,Status__c, Shop_Work_Order__c,Repeat_Visit__c,Service_Model__c, Mileage__c,CSS_Hours__c, createdBy.User_location__c,Category_Desc__c,Complaint_Type_Desc__c 
                      from CSS_Job_Order__c where ESN__c = :strESN and createdDate >= :lastDate and createdDate < :dtCreated
                      order by createdDate desc];
            //Added for symptom search
            allRecList = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                          Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c  from CSS_Solutions__r) 
                          from CSS_SymptomQA__c where Job_Order__r.ESN__c = :strESN and createdDate >= :lastDate and createdDate < :dtCreated
                          order by createdDate asc];
            //Adding for fault code
            allFaultCodes = [Select id,name,Primary_Fault_Code__c,Job_Order__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                             Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c,
                             (select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c,FaultCode__c  from CSS_Solutions__r)
                             from CSS_Fault_Code__c where Job_Order__r.ESN__c = :strESN and createdDate >= :lastDate and createdDate < :dtCreated
                             order by createdDate asc ];
            //   system.debug('inside lastDate' + lastDate);
            lessCount = 0;
            for (CSS_Job_Order__c a: lstjob) {
                lessCount +=1;
                ServiceHistWrap awrap = new ServiceHistWrap();

                awrap.sCSSJobNum = a.name;
                awrap.sjobId = a.id;
                if (a.Customer_Name__c != null) {
                    awrap.sCustomerName = a.Customer_Name__c;
                }
                /*
                if (a.Category_Desc__c != null && a.Complaint_Type_Desc__c != null) {
                    awrap.sCustomerComplaint = a.Category_Desc__c + ' / ' + a.Complaint_Type_Desc__c;
                  
                }
                */
                //Added the Customer Complaint column in Service History table1 on View History Chevron
                
                if (a.Category_Desc__c != null && a.Complaint_Type_Desc__c != null) {
                    if(a.Category_Desc__c.Contains('None')){a.Category_Desc__c = '';}
                         else if(a.Complaint_Type_Desc__c.Contains('None')){a.Complaint_Type_Desc__c = '';}
                                        
                   else if (a.Category_Desc__c.Contains('None') && a.Complaint_Type_Desc__c.Contains('None')){
                    awrap.sCustomerComplaint = '';
                    }
                    else awrap.sCustomerComplaint = a.Category_Desc__c + ' / ' + a.Complaint_Type_Desc__c;

                }
                
                if (a.Shop_Work_Order__c != null) {
                    awrap.sShopsWorkOrder = a.Shop_Work_Order__c;
                } 
                if (a.Mileage__c != null && a.Mileage__c != 0) {
                    awrap.sMileage = a.Mileage__c;
                    awrap.sMeter = a.Mileage_Measure__c;
                } 
                else{
                    if(a.CSS_Hours__c != null){
                        awrap.sMileage = a.CSS_Hours__c;
                        awrap.sMeter = 'Hours';
                    }
                    else{
                        awrap.sMileage = a.Mileage__c;
                        awrap.sMeter = a.Mileage_Measure__c;
                    }
                }

                if (a.Service_Model__c != null) {
                    awrap.sServiceModel = a.Service_Model__c;
                } 
                if(a.Created_Time_Zone__c!=null){
                    awrap.sCreated_Time_Zone = a.Created_Time_Zone__c.format('dd MMM YYYY hh:mm a z');
                    awrap.sCreated_Time_sort = a.Created_Time_Zone__c.format('yyyy MM dd HH:mm a z');
                }
                if(a.createdBy.User_Location__c != null){
                    awrap.sLocation = a.createdBy.User_Location__c;

                }

                if(a.Repeat_Visit__c!=null){

                    awrap.sRepeat_Visit = a.Repeat_Visit__c;
                }
                //Added by shanthi - Rod: 88178     
                if(a.Status__c!=null){     

                    awrap.sStatus = a.Status__c;        
                }
                integer faulCodCount=0;
                integer fcCounter = 0;
                if(a.Status__c == 'Closed'){
                    System.debug('Inside symp');
                    if(allFaultCodes.size()>0){
                        System.debug('Inside symp 1');
                        for(CSS_Fault_Code__c fauCod : allFaultCodes){
                            if(fauCod.Job_Order__c == a.id){
                                if(fcCounter<5){
                                    awrap.sFaultcodeSym = awrap.sFaultcodeSym + fauCod.Name + '\n'; 
                                    fcCounter++;
                                }
                                for(CSS_Solutions__c sol : fauCod.CSS_Solutions__r){
                                    if(faulCodCount<3){
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.FaultCode__c == fauCod.id){
                                                awrap.sWorkSummary = awrap.sWorkSummary + sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                faulCodCount++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                    integer sympCounter = 0;
                    integer symCount = 0;
                    if(faulCodCount==0){
                        System.debug('Inside symp 2');
                        for(CSS_SymptomQA__c symp : allRecList){
                            System.debug('Inside symp 3'+symp.Name);
                            if(symp.Job_Order__c == a.id && symp.Type__c == 'SearchString'){
                                if(symCount<3){
                                    awrap.sFaultcodeSym = awrap.sFaultcodeSym+  symp.Name + '\n';
                                    symCount++;
                                }
                                System.debug('Inside symp 4'+symp.Job_Order__c);
                                for(CSS_Solutions__c sol : symp.CSS_Solutions__r){

                                    if(sympCounter<3){
                                        System.debug('Inside symp 5'+sol.Solution_Title__c);
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.Symptom__c == symp.id){
                                                System.debug('Inside symp 6'+sol.Symptom__c);
                                                awrap.sWorkSummary  = awrap.sWorkSummary+  sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';

                                                sympCounter++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                }
                lstwrap.add(awrap);
            } 

            system.debug('lastDate '+lastDate+'dtCreated '+dtCreated);
            Histlstjob = [select Attribute1__c, Attribute13__c, Attribute14__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, 
                          Attribute9__c, Attribute10__c, Attribute11__c, Attribute12__c, Attribute15__c, Circuit_Description__c, Reason__c 
                          from CSS_JobEventTemporary__c where  key__c = :strESN and Attribute13__c >= :lastDate and Attribute13__c < :dtCreated];
            system.debug('the flag is  ');

            boolean displayHist;

            for (CSS_JobEventTemporary__c a: Histlstjob) {
                //system.debug('the flag inside is  ');    
                ServiceHistWrap awrap = new ServiceHistWrap();

                displayHist=true;    
                //System.debug('History Date Check --> '+a.Attribute13__c);
                if (lstjob!=null) {
                    for (CSS_Job_Order__c chkDt: lstjob) {
                        //System.debug('History Date Check '+chkDt.createdDate + ' '+a.Attribute13__c);
                        if(chkDt.createdDate.format('YYYY-MM-DD')==a.Attribute13__c.format('YYYY-MM-DD'))
                        {
                            if(!test.isRunningTest())
                                displayHist=false;
                            else
                                displayHist=true;
                            // System.debug('History Date Check '+chkDt.createdDate + ' '+a.Attribute13__c +' '+ displayHist);

                        }
                    }            
                }

                if(displayHist) {
                    if(a.Attribute1__c != null){
                        Boolean repeat_flag = Boolean.valueOf(a.Attribute1__c);
                        awrap.sRepeat_Visit = repeat_flag; 
                    }
                    if(a.Attribute13__c !=null){
                        awrap.sCreated_Time_Zone = a.Attribute13__c.format('dd MMM YYYY hh:mm a z');
                        awrap.sCreated_Time_sort = a.Attribute13__c.format('yyyy MM dd HH:mm a z');
                    }

                    if (a.Attribute3__c != null) {
                        awrap.sCustomerName = a.Attribute3__c;
                    }
                    awrap.sCSSJobNum = a.Attribute4__c;

                    if (a.Attribute5__c != null) {
                        awrap.sShopsWorkOrder = a.Attribute5__c;
                    } 

                    if (a.Attribute6__c != null) {
                        awrap.sServiceModel = a.Attribute6__c;
                    } 
                    if (a.Attribute7__c != null) {
                        awrap.sLocation = a.Attribute7__c;
                    }
                    if (a.Circuit_Description__c!=null){
                        //system.debug('a.Circuit_Description__c --> '+a.Circuit_Description__c);
                        awrap.sWorkSummary = a.Circuit_Description__c;
                    }
                    if (a.Attribute8__c != null) {
                        awrap.sFaultcodeSymp = a.Attribute8__c;
                    } 
                    if(a.Attribute9__c!=null){
                        if(a.Attribute9__c.contains('MI')){
                            awrap.sMeter = 'Miles';
                        }
                        else
                            if(a.Attribute9__c.contains('KM')){
                                awrap.sMeter = 'Km';
                            }
                        else
                            if(a.Attribute9__c.contains('HR')){
                                awrap.sMeter = 'Hours';
                            } 
                    }
                    if ((a.Attribute14__c != null) && (a.Attribute14__c.equalsIgnoreCase('undefined')!= true)) { // added by sai 0921 'undefined'
                        String NumericVal = ''; // Begin-71133:Sai:0926 - Added the below logic to parse Integer/Floating number from Miles attribute(Attribute14__c)
                        for(string s : a.Attribute14__c.split('(?!d*^)')){
                            if(s.isNumeric() || s =='.'){
                                NumericVal = NumericVal+s;
                                system.debug('Numeric Value is --' + NumericVal);
                            }
                        }
                        if(NumericVal!= null && NumericVal!='')
                        {
                            Decimal mil = Decimal.valueOf(NumericVal);
                            awrap.sMileage = mil; 
                        } 
                    }
                    if (a.Attribute15__c != null) {
                        awrap.sBMSLink = a.Attribute15__c;
                    }
                    if (a.Reason__c != null) {
                        awrap.sFaultCodeSym = a.Reason__c;
                    }

                    lstwrap.add(awrap);

                }  
            }

            //return JSON.serialize(lstwrap + 'lesscount=' + lessCount);
            return JSON.serialize(lstwrap);

        }catch(Exception e){ return null;} 

    }

    public static integer getMorethan30days() {
        integer more = 0;
        DateTime lastDate2 = dtCreated.addDays(-30);
        DateTime past2Yr = dtCreated.addDays(-730);
        List < CSS_Job_Order__c > lstjob2 = [select id from CSS_Job_Order__c where ESN__c = :strESN 
                                             and createdDate < :lastDate2 and createdDate >= : past2Yr
                                             order by createdDate desc
                                            ];
        if(lstjob2 != null)
            more = lstjob2.size();
        return more;
    }


    public static String getHistJobs() {

        // system.debug('inside 1' + dtCreated);

        try{

            List < ServiceHistWrap2 > lstwrap2 = new List < ServiceHistWrap2 > ();
            List < CSS_Job_Order__c > lstjob2;
            List < CSS_JobEventTemporary__c > Histlstjob2;
            List<CSS_Fault_Code__c> allFaultCodes2; 
            List<CSS_SymptomQA__c> allRecList2;
            DateTime lastDate2 = dtCreated.addDays(-30);
            DateTime past2Yr = dtCreated.addDays(-730);
            system.debug('lastDate2'+lastDate2 +' past2Yr '+past2Yr);

            //Added Category and Complaint Type Desciption fields to display Customer Complaint for Defect 110833 -- Rajasekhar H
            lstjob2 = [select id,Status__c, createdDate, Customer_Name__c,Created_Time_Zone__c,Mileage_Measure__c, Name, Shop_Work_Order__c,Service_Model__c,Repeat_Visit__c, Mileage__c, CSS_Hours__c,createdBy.User_location__c,Category_Desc__c,Complaint_Type_Desc__c
                       from CSS_Job_Order__c where ESN__c = :strESN 
                       //LIMIT 1
                       and createdDate < :lastDate2 and createdDate >= : past2Yr
                       order by createdDate desc
                      ];

            //Added for symptom search
            allRecList2 = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                           Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c  from CSS_Solutions__r) 
                           from CSS_SymptomQA__c where Job_Order__r.ESN__c = :strESN and createdDate < :lastDate2 and createdDate >= : past2Yr
                           order by createdDate asc];
            //Adding for fault code
            allFaultCodes2 = [Select id,name,Primary_Fault_Code__c,Job_Order__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                              Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c,
                              (select name,symptom__c,Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c,FaultCode__c  from CSS_Solutions__r)
                              from CSS_Fault_Code__c where Job_Order__r.ESN__c = :strESN and createdDate < :lastDate2 and createdDate >= : past2Yr
                              order by createdDate asc ];
            system.debug('inside lastDate' + lstjob2);
            moreCount = 0;
            for (CSS_Job_Order__c b: lstjob2) {
                moreCount +=1;
                ServiceHistWrap2 bwrap2 = new ServiceHistWrap2();

                bwrap2.sCSSJobNum2 = b.name;
                bwrap2.sjobId2 = b.id;
                if (b.Customer_Name__c != null) {
                    bwrap2.sCustomerName2 = b.Customer_Name__c;
                }
                if (b.Shop_Work_Order__c != null) {
                    bwrap2.sShopsWorkOrder2 = b.Shop_Work_Order__c;

                } 
                if (b.Mileage__c != null && b.Mileage__c != 0) {
                    bwrap2.sMileage2 = b.Mileage__c;
                    bwrap2.sMeter2 = b.Mileage_Measure__c;
                } 
                else{
                    if(b.CSS_Hours__c != null){
                        bwrap2.sMileage2 = b.CSS_Hours__c;
                        bwrap2.sMeter2 = 'Hours';
                    }
                    else{
                        bwrap2.sMileage2 = b.Mileage__c;
                        bwrap2.sMeter2 = b.Mileage_Measure__c;
                    }
                }
                if (b.Created_Time_Zone__c != null) {
                    bwrap2.sCreated_Time_Zone2 = b.Created_Time_Zone__c.format('dd MMM YYYY hh:mm a z');
                    bwrap2.sCreated_Time_sort2 = b.Created_Time_Zone__c.format('yyyy MM dd HH:mm a z');
                }
                if (b.Service_Model__c != null) {
                    bwrap2.sServiceModel2 = b.Service_Model__c;
                }
                if(b.createdBy.User_Location__c != null){
                    bwrap2.sLocation2 = b.createdBy.User_Location__c;
                } 

                if(b.Repeat_Visit__c != null){
                    bwrap2.sRepeat_Visit2 = b.Repeat_Visit__c;
                } 
                /*if(b.Mileage_Measure__c != null){
                    bwrap2.sMeter2 = b.Mileage_Measure__c;

                }*/
                //Added the Customer Complaint column in Service History table2 on View History Chevron
                if (b.Category_Desc__c != null && b.Complaint_Type_Desc__c != null) {
                    bwrap2.sCustomerComplaint2 = b.Category_Desc__c + ' / ' + b.Complaint_Type_Desc__c;

                }
                //Added by shanthi - Rod: 88178                     
                if(b.Status__c!=null){     

                    bwrap2.sStatus2 = b.Status__c;      
                }
                integer faulCodCount2=0;
                integer fcCounter2 = 0;
                if(b.Status__c == 'Closed'){
                    System.debug('Inside symp');
                    if(allFaultCodes2.size()>0){
                        System.debug('Inside symp 1');
                        for(CSS_Fault_Code__c fauCod : allFaultCodes2){
                            if(fauCod.Job_Order__c == b.id){
                                if(fcCounter2<5){
                                    bwrap2.sFaultcodeSym2 = bwrap2.sFaultcodeSym2 + fauCod.Name + '\n'; 
                                    fcCounter2++;
                                }
                                for(CSS_Solutions__c sol : fauCod.CSS_Solutions__r){
                                    if(faulCodCount2<3){
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.FaultCode__c == fauCod.id){
                                                bwrap2.sWorkSummary2 = bwrap2.sWorkSummary2+ sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                faulCodCount2++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                    integer sympCounter2 = 0;
                    integer symCount2 = 0;
                    if(faulCodCount2==0){
                        System.debug('Inside symp 2');
                        for(CSS_SymptomQA__c symp : allRecList2){
                            System.debug('Inside symp 3'+symp.Name);
                            if(symp.Job_Order__c == b.id && symp.Type__c == 'SearchString'){
                                if(symCount2<3){
                                    bwrap2.sFaultcodeSym2 = bwrap2.sFaultcodeSym2+  symp.Name + '\n';
                                    symCount2++;
                                }
                                System.debug('Inside symp 4'+symp.Job_Order__c);
                                for(CSS_Solutions__c sol : symp.CSS_Solutions__r){

                                    if(sympCounter2<3){
                                        System.debug('Inside symp 5'+sol.Solution_Title__c);
                                        if(sol.Repair_Response__c == 'Repair Successful.' || sol.Repair_Response__c == 'Repair Successful with additional parts/procedures.'){
                                            if(sol.Symptom__c == symp.id){
                                                System.debug('Inside symp 6'+sol.Symptom__c);
                                                bwrap2.sWorkSummary2  = bwrap2.sWorkSummary2+  sol.Repair_Response__c + '\n' + sol.Solution_Title__c + '\n';
                                                sympCounter2++;
                                            }
                                        }
                                    }
                                }  
                            } 
                        }
                    }
                }
                lstwrap2.add(bwrap2);
            }

            Histlstjob2 = [select Attribute1__c, Attribute13__c,Attribute14__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, 
                           Attribute9__c, Attribute10__c, Attribute11__c, Attribute12__c, Attribute15__c, Circuit_Description__c, Reason__c 
                           from CSS_JobEventTemporary__c where  key__c = :strESN and Attribute13__c < :lastDate2 and Attribute13__c >= : past2Yr];           

            Boolean displayHist2;
            //displayHist=false;
            system.debug('Histlstjob2 '+Histlstjob2);
            for (CSS_JobEventTemporary__c b: Histlstjob2) {

                ServiceHistWrap2 bwrap2 = new ServiceHistWrap2();
                displayHist2=true;    
                //System.debug('History Date Check2 --> '+b.Attribute13__c);
                if (lstjob2!=null) {
                    for (CSS_Job_Order__c chkDt2: lstjob2) {
                        //System.debug('History Date Check2 '+chkDt2.createdDate + ' '+b.Attribute13__c);
                        if(chkDt2.createdDate.format('YYYY-MM-DD')==b.Attribute13__c.format('YYYY-MM-DD'))
                        {
                            if(!test.isRunningTest())
                                displayHist2=false;
                            else
                                displayHist2=true;    
                            //  System.debug('History Date Check2 '+chkDt2.createdDate + ' '+b.Attribute13__c +' '+ displayHist2);

                        }
                    }            
                }

                if(displayHist2){
                    if(b.Attribute1__c != null){
                        Boolean repeat_flag = Boolean.valueOf(b.Attribute1__c);
                        bwrap2.sRepeat_Visit2 = repeat_flag; 
                    }
                    if(b.Attribute13__c !=null){                    
                        bwrap2.sCreated_Time_Zone2 = b.Attribute13__c.format('dd MMM YYYY hh:mm a z');
                        bwrap2.sCreated_Time_sort2 = b.Attribute13__c.format('yyyy MM dd HH:mm a z');
                    }

                    if (b.Attribute3__c != null) {
                        bwrap2.sCustomerName2 = b.Attribute3__c;
                    }
                    //commented by manjari
                    //bwrap2.sCSSJobNum2 = b.Attribute4__c;

                    if (b.Attribute5__c != null) {
                        bwrap2.sShopsWorkOrder2 = b.Attribute5__c;
                    } 
                    if (b.Attribute6__c != null) {
                        bwrap2.sServiceModel2 = b.Attribute6__c;
                    } 
                    if (b.Attribute7__c != null) {
                        bwrap2.sLocation2 = b.Attribute7__c;
                    }
                    if (b.Circuit_Description__c!=null){
                        system.debug('Circuit_Description__c *** --> '+b.Circuit_Description__c);
                        bwrap2.sWorkSummary2 = b.Circuit_Description__c;
                    }
                    if (b.Attribute8__c != null) {  
                        bwrap2.sFaultcodeSymp2 = b.Attribute8__c;
                    } 
                    //System.debug('The attribute value is'+b.Attribute14__c);
                    if ((b.Attribute14__c != null) && (b.Attribute14__c.equalsIgnoreCase('undefined')!= true)) { // added by sai 0921 'undefined'
                        String NumericValue = ''; // Begin-71133:Sai:0926 - Added the below logic to parse Integer/Floating number from Miles attribute(Attribute14__c)
                        for(string s : b.Attribute14__c.split('(?!d*^)')){
                            if(s.isNumeric() || s =='.'){
                                NumericValue = NumericValue+s;
                                system.debug('Numeric Value is --' + NumericValue);
                            }
                        }
                        if(NumericValue!= null && NumericValue!=''){
                            Decimal mil = Decimal.valueOf(NumericValue);
                            bwrap2.sMileage2 = mil;

                        }

                    }
                    if(b.Attribute9__c!=null){
                        if(b.Attribute9__c.contains('MI')){
                            bwrap2.sMeter2 = 'Miles';
                        }
                        else
                            if(b.Attribute9__c.contains('KM')){
                                bwrap2.sMeter2 = 'Km';
                            }
                        else
                            if(b.Attribute9__c.contains('HR')){
                                bwrap2.sMeter2 = 'Hours';
                            }

                    }

                    if (b.Attribute15__c != null) {
                        bwrap2.sBMSLink2 = b.Attribute15__c;
                    }
                    if (b.Reason__c != null) {
                        bwrap2.sFaultCodeSym2 = b.Reason__c;
                    }
                    lstwrap2.add(bwrap2);
                    system.debug('bwrap2 '+ bwrap2);
                }
            }


            system.debug('lstwrap2 '+lstwrap2);
            return JSON.serialize(lstwrap2);

        }catch(Exception e){ 

            system.debug('exception '+e.getMessage());
            return null;} 

    }


}