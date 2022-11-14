public without sharing class CSS_RecentHistoryClass {
    
    /*
 Service History
*/
 public String ServiceHistList { get; set; }
    
    public static String strESN { get; set
    {
        strESN=value;
        system.debug('set sESN' + strESN);
    }
         }
    
   public static dateTime dtCreated { get; set
    {
        dtCreated=value;
        system.debug('set dtCreated' + dtCreated);
    
    }
         }  
         
    public static String strhESN { get; set
    {
        strhESN=value;
        //system.debug('set sESN' + strESN);
    }
         }
    
   public static dateTime dthCreated { get; set
    {
        dthCreated=value;
       // system.debug('set dtCreated' + dtCreated);
    
    }
         }         
         
    
/*    public CSS_ServiceHistoryClass()
    {
        
        system.debug('sESN' + strESN);
    } */
    
    public class ServiceHistWrap {
        //Static Variables 
        
        public boolean brepeatFlg;
        public boolean brecentFlg;
        public string sCustomerName;
        public string sCSSJobNum;
        public string sShopsWorkOrder;
        public string sServiceModel;    
        public string sLocation;
        public string sWorkSummary;
        public string sFaultcodeSymp;
        public Decimal sMileage;

        @TestVisible
        ServiceHistWrap () {
			
            brepeatFlg=false;
            brecentFlg=false;
            sCustomerName='';
            sCSSJobNum='';
            sShopsWorkOrder='';
            sLocation='';
            sWorkSummary='';
            sFaultcodeSymp='';
            sMileage=0;
            
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

        @TestVisible
        ServiceHistWrap2 () {
			
            brepeatFlg2=false;
            brecentFlg2=false;
            sCustomerName2='';
            sCSSJobNum2='';
            sShopsWorkOrder2='';
            sLocation2='';
            sWorkSummary2='';
            sFaultcodeSymp2='';
            sMileage2=0;
            
        }
        
    }
    
    
     public static String getRecentHistJobs() {
         
         system.debug('inside 1' + dtCreated);
        system.debug('StrESNNNNN'+strESN);
         
         try{
             
         	List < ServiceHistWrap > lstwrap = new List < ServiceHistWrap > ();
         	List < CSS_Job_Order__c > lstjob;
            List < CSS_JobEventTemporary__c > Histlstjob;
             
            DateTime lastDate = dtCreated.addDays(-30);
             system.debug('LastDate*******'+lastDate);
             if(!Test.isRunningTest()){
            lstjob = [select id, createdDate, Customer_Name__c, Name, Shop_Work_Order__c, Mileage__c
                          from CSS_Job_Order__c where ESN__c = :strESN and createdDate >= :lastDate order by createdDate desc];
             }
             
                
             else{
                lstjob =  [select id, createdDate, Customer_Name__c, Name, Shop_Work_Order__c, Mileage__c from CSS_Job_Order__c where ESN__c = :strESN and createdDate>= LAST_N_DAYS:30];
             }
             system.debug('outside' + lstjob);
            //system.debug('inside lastDate' + lastDate);
             
             for (CSS_Job_Order__c a: lstjob) {
                
                ServiceHistWrap awrap = new ServiceHistWrap();

                awrap.sCSSJobNum = a.name;
                if (a.Customer_Name__c != null) {
                    awrap.sCustomerName = a.Customer_Name__c;
                }
                if (a.Shop_Work_Order__c != null) {
                    awrap.sShopsWorkOrder = a.Shop_Work_Order__c;
                } 
                if (a.Mileage__c != null) {
                    awrap.sMileage = a.Mileage__c;
                } 
                
                lstwrap.add(awrap);
            }
             
            Histlstjob = [select Attribute1__c, Attribute2__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c from CSS_JobEventTemporary__c where  key__c = :strESN];

             for (CSS_JobEventTemporary__c a: Histlstjob) {
                
                ServiceHistWrap awrap = new ServiceHistWrap();

                awrap.sCSSJobNum = a.Attribute2__c;
                if (a.Attribute3__c != null) {
                    awrap.sCustomerName = a.Attribute3__c;
                }
                if (a.Attribute4__c != null) {
                    awrap.sShopsWorkOrder = a.Attribute4__c;
                } 
                if (a.Attribute5__c != null) {
                    awrap.sMileage = 0;
                } 
                
                lstwrap.add(awrap);
            }
             
                          
             
            return JSON.serialize(lstwrap);
            
        }catch(Exception e){ return null;} 
     
     }
    
/*    
    public static String getHistJobs() {
         
        // system.debug('inside 1' + dtCreated);
         
         try{
             
         	List < ServiceHistWrap2 > lstwrap2 = new List < ServiceHistWrap2 > ();
         	List < CSS_Job_Order__c > lstjob;
            List < CSS_JobEventTemporary__c > Histlstjob;
             
            DateTime lastDate = dthCreated.addDays(-30);
             
            lstjob = [select id, createdDate, Customer_Name__c, Name, Shop_Work_Order__c, Mileage__c
                          from CSS_Job_Order__c where ESN__c = :strhESN and createdDate < :lastDate
                          order by createdDate desc];
             
          //   system.debug('inside lastDate' + lastDate);
             
             for (CSS_Job_Order__c b: lstjob) {
                
                ServiceHistWrap2 bwrap = new ServiceHistWrap2();

                bwrap.sCSSJobNum2 = b.name;
                if (b.Customer_Name__c != null) {
                    bwrap.sCustomerName2 = b.Customer_Name__c;
                }
                if (b.Shop_Work_Order__c != null) {
                    bwrap.sShopsWorkOrder2 = b.Shop_Work_Order__c;
                } 
                if (b.Mileage__c != null) {
                    bwrap.sMileage2 = b.Mileage__c;
                } 
                
                lstwrap2.add(bwrap);
            }
             
            Histlstjob = [select Attribute1__c, Attribute2__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c from CSS_JobEventTemporary__c where  key__c = :strhESN];

             for (CSS_JobEventTemporary__c b: Histlstjob) {
                
                ServiceHistWrap2 bwrap = new ServiceHistWrap2();

                bwrap.sCSSJobNum2 = b.Attribute2__c;
                if (b.Attribute3__c != null) {
                    bwrap.sCustomerName2 = b.Attribute3__c;
                }
                if (b.Attribute4__c != null) {
                    bwrap.sShopsWorkOrder2 = b.Attribute4__c;
                } 
                if (b.Attribute5__c != null) {
                    bwrap.sMileage2 = 0;
                } 
                
                lstwrap2.add(bwrap);
            }
             
                          
             
            return JSON.serialize(lstwrap2);
            
        }catch(Exception e){ return null;} 
     
     }*/
    
}