/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimHistory
{
    public static String claimID {get; set;}
    public static List<CSS_JobEventTemporary__c> claimList{get;set;}
    public static String claimESN { get; set; }

    public class ClaimHistoryWrapper {

        public string sFailure_date;
        public string sWarranty_Start_Date;
        public decimal sFailure_Pointc; 
        public string sRoot_Cause;    
        public string sRepair_Location;
        public string sClaim;
        public string sDistributor_s_Invoice_Paid;
        public string sFailure_Measure; //Added as part of story# 161394
        public string sFailure_dateSort;

        public ClaimHistoryWrapper() {
            sFailure_date = '';
            sWarranty_Start_Date = '';
            sFailure_Pointc = 0;
            sRoot_Cause = '';
            sRepair_Location = '';
            sClaim = '';
            sDistributor_s_Invoice_Paid = '';
            sFailure_Measure = '';
            sFailure_dateSort = '';
        }
    }  

    public static String getRecentClaimHistory() {
        List<ClaimHistoryWrapper> ClaimHistoryWrapperList = new List<ClaimHistoryWrapper>();
        try {
            system.debug('ESN**'+claimESN);
            string key = claimESN + ':' + claimID;
            system.debug('key**'+key);
            claimList = new List<CSS_JobEventTemporary__c>();
            claimList = [select id, type__c,key__c,Attribute1__c,Attribute3__c,Attribute2__c,
                         Attribute7__c,Attribute8__c,Circuit_Description__c,
                         Service_Model_Name__c,Attribute10__c,Attribute4__c,Attribute6__c,
                         Attribute11__c,Attribute5__c,Attribute9__c 
                         from CSS_JobEventTemporary__c 
                         where type__c='ClaimHistory' AND key__c = : key AND Attribute9__c IN ('Paid','Denied','Info Only') Limit 500];
            system.debug('claimList >>> ' + claimList);
            for(CSS_JobEventTemporary__c tempClaims : claimList) {
                ClaimHistoryWrapper wrapper = new ClaimHistoryWrapper();
                string sfailureDate = tempClaims.Attribute1__c;
                String sfailDateLocale = '';
                datetime failDate;
                If(sfailureDate != null && sfailureDate != '') {
                    if(sfailureDate.contains('T')) 
                        sfailureDate = sfailureDate.replace('T', ' ');
                    system.debug('sfailureDate ' + sfailureDate);
                    failDate = datetime.valueof(sfailureDate);
                    system.debug('FailureDate **'+failDate);
                    //sfailDateLocale = css_utility.getFormattedUserLocaleDate(failDate); //Get formatted String from Utility Class
                    //Prabhakar Added below Code (19/03)
                    sfailDateLocale = css_utility.getFormattedDate(failDate); //Get formatted String from Utility Class
                    system.debug('sfailDateLocale **'+sfailDateLocale);
                }
                wrapper.sFailure_date = sfailDateLocale;
                wrapper.sFailure_dateSort= failDate.format('yyyy MM dd HH:mm a z');
				//Below warrantyStartDate logic is commented as part of story# 161394
                /*string sWarrantyStartDate = tempClaims.Attribute11__c;
                String sWSDLocale = '';
                If(sWarrantyStartDate != null && sWarrantyStartDate != '') {
                    if(sWarrantyStartDate.contains('T')) 
                        sWarrantyStartDate = sWarrantyStartDate.replace('T', ' ');
                    system.debug('sWarrantyStartDate ' + sWarrantyStartDate);
                    datetime WSDDate = datetime.valueof(sWarrantyStartDate);
                    system.debug('WSDDate **'+WSDDate);
                    // sWSDLocale = css_utility.getFormattedUserLocaleDate(WSDDate); //Get formatted String from Utility Class
                    //Prabhakar Added below Code (19/03)
                    sWSDLocale = css_utility.getFormattedDate(WSDDate); //Get formatted String from Utility Class
                    system.debug('sWSDLocale **'+sWSDLocale);
                }
                wrapper.sWarranty_Start_Date = sWSDLocale;*/

                //wrapper.sWarranty_Start_Date = tempClaims.Attribute11__c;
                wrapper.sFailure_Pointc = Decimal.valueOf(tempClaims.Attribute4__c);
                //wrapper.sRoot_Cause = tempClaims.Attribute5__c; //tempClaims.Circuit_Description__c; //Changed as part of story# 161394
                wrapper.sRoot_Cause = (tempClaims.Attribute5__c == null ? '' : tempClaims.Attribute5__c)+' '+'-'+' '+(tempClaims.Circuit_Description__c == null ?  '' : tempClaims.Circuit_Description__c); //Changed as part of story# 161420
                wrapper.sRepair_Location = (tempClaims.Attribute2__c == null ? '' :  tempClaims.Attribute2__c) + ' ' + (tempClaims.Attribute3__c == null ? '' : tempClaims.Attribute3__c); //Attribute2 added as part of story# 161394
                //Below sClaim and Distributor Invoice Paid logic is commented as part of story# 161394
                /*wrapper.sClaim = tempClaims.Attribute8__c;
                wrapper.sDistributor_s_Invoice_Paid = tempClaims.Attribute9__c;*/
                wrapper.sFailure_Measure = tempClaims.Attribute6__c == null ? '' : tempClaims.Attribute6__c; //Added as part of story# 161394
                ClaimHistoryWrapperList.add(wrapper);
            }
            system.debug('ClaimHistoryWrapperList**'+ClaimHistoryWrapperList);
            system.debug('JSON.serialize(ClaimHistoryWrapperList) ' + JSON.serialize(ClaimHistoryWrapperList));
            return JSON.serialize(ClaimHistoryWrapperList);
        } catch(Exception e){ 
            system.debug('EXCEPTION of getRecentClaimHistory Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            return null;
        } 
    }
}