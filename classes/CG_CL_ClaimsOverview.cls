/*
* Block comments with details of changes
*/
/*VERSION    
AUTHOR                          DATE                  DETAIL
1.0         Kalpana Vemula                  07-02-2018          Initial Development
2.0         Rupesh Pande                    28-03-2018          Modified for the location code
*/
public class CG_CL_ClaimsOverview
{
    
    public String LocationCode {get;set;}
    public CG_CL_ClaimsIntake mainContr{set; get;}
    
    public String modifyDT{get;set;}
    public string createdDT{get;set;}
    public string jobCreatedDT{get;set;}
    
    
    
    public CSS_Claims__c claimsRec{get;  
                                   set
                                   {    
                                       String CreatorLocation;
                                       String LocationOverviewSection;
                                       claimsRec = value;
                                       system.debug('Claim Record1:'+value);
                                       if(claimsRec != null && claimsRec.Id != null ) 
                                       {
                                           system.debug('Claim Record2:'+claimsRec);
                                           createdDT = css_utility.getFormattedDate(claimsRec.CreatedDate); 
                                           createdDT=createdDT.touppercase();
                                           modifyDT = css_utility.getFormattedDate(claimsRec.LastModifiedDate);
                                           modifyDT=modifyDT.touppercase();
                                           
                                        system.debug('CreatorLocation in if' + ' ' + claimsRec.Location_Code__c);
                                           if(claimsRec.Location_Code__c!=null)
                                           {
                                               CreatorLocation = claimsRec.Location_Code__c;  
                                               system.debug('CreatorLocation in if' + ' ' + CreatorLocation);
                                           }
                                           else
                                           {
                                               LocationOverviewSection = (String)Cache.Session.get('ManualClaimsSelectedLocation');
                                               CreatorLocation = LocationOverviewSection;
                                                system.debug('CreatorLocation inside if else' + ' ' + CreatorLocation);
                                               
                                              /* User user = css_utility.getUserAttributes(userInfo.getUserId());
                                               CreatorLocation = user.User_Location__c;  */                             
                                           }
                                           
                                           //System.debug('modifyDTTemp'+ modifyDT);  
                                           if(claimsRec.css_job__r<>null)
                                           {
                                               jobCreatedDT=css_utility.getFormattedDate(claimsRec.css_job__r.createddate);
                                               jobCreatedDT=jobCreatedDT.touppercase();
                                               //system.debug('The formatted job created date is'+jobCreatedDT);
                                           }
                                       } 
                                       else
                                       {
                                           //User user = css_utility.getUserAttributes(userInfo.getUserId());
                                          /* list<CSS_UserLocation__c> userLocationList = new List<CSS_UserLocation__c>();
                                           userLocationList = [SELECT AccountId__c,isActive__c,isPrimary__c,Location_Name__c,BMSApplicationURL__c,
                                                               UserId__c,BMS_Enabled__c,Location_code__c
                                                               FROM CSS_UserLocation__c
                                                               WHERE UserId__c = : userInfo.getUserId() AND isActive__c = true AND Enable_Claim__c = true 
                                                               AND AccountId__r.ERP_System__c = 'One BMS' AND isPrimary__c = true LIMIT 1];
                                           // ORDER BY Location_Name__c asc];
                                           system.debug('userInfo.getUserId:'+userInfo.getUserId());
                                           system.debug('userLocationList'+userLocationList);
                                           
                                           if(userLocationList!=null && userLocationList.size()>0)
                                            CreatorLocation = userLocationList[0].Location_code__c;
                                           system.debug('CreatorLocation else'+CreatorLocation);
                                        */   
                                           
                                           LocationOverviewSection = (String)Cache.Session.get('ManualClaimsSelectedLocation');
                                               CreatorLocation = LocationOverviewSection;
                                                system.debug('CreatorLocation in main else' + ' ' + CreatorLocation);
                                       }
                                       
                                       if(CreatorLocation!=null && CreatorLocation != ''){
                                       Integer JobLocLength = CreatorLocation.Length();
                                       Integer Index = JobLocLength-5;
                                       
                                       LocationCode = CreatorLocation.substring(Index,CreatorLocation.Length());
                                       }
                                       system.debug('LocationCode End' + ' ' + LocationCode);
                                       
                                   }   
                                  }
    
    
}