/************************************************************
Name:  IAM_RSW_OutBoundReqParser
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Request Parser Class for RSW out bound service                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakaram       09/02/2020        INITIAL DEVELOPMENT 
1.1 -    Chetan Gaikwad          07/01/2021    Made changes for tracking failure call records   
*****************************************************/
Public class IAM_RSW_OutBoundReqParser{

    //Wrapper class begins//
     Public static String IAM_RSW_ReqParserClass(id appId){
     String JSONstring;
     IAM_Contact_Provisioning__c rswUseRecords = [select id,IAM_RSW_Preferred_Service_Code__c,IAM_Contact__r.Username__c,IAM_Contact__r.FirstName,IAM_Contact__r.LastName,
                 IAM_Contact__r.Email,IAM_Status__c,IAM_Role__c,IAM_RSW_Reason__c,IAM_RSW_Other_Reason__c,IAM_Contact__r.IAM_Ext_Legacy_UID__c,
                 IAM_Account_Application__r.IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Additional_Service_Provider__c from IAM_Contact_Provisioning__c where id=:appId];
    
    List<String> spCodes=new List<String>();
    if(rswUseRecords.IAM_Additional_Service_Provider__c!=null&&rswUseRecords.IAM_Additional_Service_Provider__c!=''){
    spCodes=rswUseRecords.IAM_Additional_Service_Provider__c.Split(';');
    }
    spCodes.add(rswUseRecords.IAM_RSW_Preferred_Service_Code__c);
    System.debug('Printing spCodes'+spCodes);
    registrationInformation lstWapperforPut;
    lstWapperforPut=new registrationInformation(rswUseRecords,spCodes);
        System.debug('Printing list wrapper info'+lstWapperforPut);
        if(lstWapperforPut!=null){
            JSONString = JSON.serialize(lstWapperforPut);
        }
      System.debug('Printing return string '+JSONstring);
        return JSONstring;
    }
    
        Public class registrationInformation{
            Public registrationInfo registrationInfo{set;get;}
            
            Public registrationInformation(IAM_Contact_Provisioning__c a,List<String> sp){
            this.registrationInfo=new registrationInfo(a,sp);
            }
        }    
        //code start - method to store response received from MW in Wrapper class - Chetan Gaikwad 07/01/2021
        public DataArea DataArea;
    
       public static DataArea getResponseuserrequest(String response){
            //DataArea reqData = (DataArea)JSON.deserializeStrict(response, DataArea.class);
            return (IAM_RSW_OutBoundReqParser.DataArea) System.JSON.deserialize(response, DataArea.class);
            //var jsonobject = JsonConvert.DeserializeObject<IAM_RSW_OutBoundReqParser.DataArea>(json);
            //return reqData;
        }
        //code end - method to store response received from MW in Wrapper class - Chetan Gaikwad 07/01/2021
    
        Public Class registrationInfo{
            
            
            public String reason{get;set;}
             public String role{get;set;}
             public String status{get;set;}
             public String otherReason{get;set;}
             public String email{get;set;}
             public String userName{get;set;}
             public String lastName{get;set;}
             public String firstName{get;set;}
             public String UID{get;set;}  
             public list<ServiceProviderList> ServiceProviderList{get;set;}
             
                Public registrationInfo(IAM_Contact_Provisioning__c conApp,List<String> codes){
                    
                    This.reason=conApp.IAM_RSW_Reason__c;
                    This.role=ConApp.IAM_Role__c;
                    This.status=conApp.IAM_Status__c;
                    This.otherReason=conApp.IAM_RSW_Other_Reason__c;
                    This.email=conApp.IAM_Contact__r.Email;
                    
                    //This.userName=conApp.IAM_Contact__r.Username__c;
                    if(!String.isEmpty(conApp.IAM_Contact__r.IAM_Ext_Legacy_UID__c)){
                        This.userName=conApp.IAM_Contact__r.IAM_Ext_Legacy_UID__c;
                    }else{
                      	This.userName=conApp.IAM_Contact__r.Username__c;  
                    }
                    This.lastName=conApp.IAM_Contact__r.LastName;
                    This.firstName=conApp.IAM_Contact__r.FirstName;
                    if(!String.isEmpty(conApp.IAM_Contact__r.IAM_Ext_Legacy_UID__c)){
                        This.UID=conApp.IAM_Contact__r.IAM_Ext_Legacy_UID__c;
                    }else{
                      	This.UID=conApp.IAM_Contact__r.Username__c;  
                    }
                    
                    ServiceProviderList= new List<ServiceProviderList>();
                    for(String a:codes){
                        this.ServiceProviderList.add(new ServiceProviderList(conApp,a));
                    }
                    
                }
        }
        
        
        public class ServiceProviderList{
            public String preferred{get;set;}
            public String spCode{get;set;}
            
            Public ServiceProviderList(IAM_Contact_Provisioning__c c,string s){
                //Setting value
                This.spCode=s;
                if(c.IAM_RSW_Preferred_Service_Code__c==s){
                    preferred='Y';
                }else{
                    preferred='N';
                }
            }
        }

        //code start - adding wrapper class to store response received from MW - Chetan Gaikwad - 07/01/2021
    public class DataArea {
        public String Description;
        public Integer StatusCode;
    }
        //code end - adding wrapper class to store response received from MW - Chetan Gaikwad - 07/01/2021
       
}