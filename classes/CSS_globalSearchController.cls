/**********************************************************************
Name:CSS_globalSearchController
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Class created for Global search functionality based on Fields and Locations of the current logged user                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                 
1.0 - Sandeep           02-11-2016      INITIAL DEVELOPMENT         
2.0 - Anirudh           02/12/2016      Coding Standards
3.0 - Sandeep           03/15/2016      52267 Task Requirements Fulfilled
4.0 - Sai               10/14/2016      For CFSE Search (CRQ000001110040)
***********************************************************************/

public with sharing class CSS_globalSearchController {
    
    public List<CSS_Job_Order__c> JoList{get;set;}
    public String searchStr{get;set;}
    public String searchStr1{get;set;}
    public String sStr{get;set;}
    public List<User> uList = new List<User>();
    public List<User> uLocs = new List<User>();
    public Set<String> distLocs = new Set<String>();
    public List<String> dfseLoc = new List<String>();
    String sFlag;
    String paramVal;
    String location='';
    public String roleName ='';
    public String dfseRoleId='';
    public Boolean vCFSEFlg = false;
    public Boolean vDFSEFlg = false;
    public Boolean vAdVFlg = false;
    String advTechLocations = '';
    String[] sDFSEloc;
    String sFilter;
    String sFilterFields;
    List<String> multiUserLocationValues = new List<String>();
    List<String> StoringMultiLocation = new List<String>();
    String splitUserLoc;
    //Constructor getting the parameter from the search box.
    public CSS_globalSearchController(){
        sFlag='Page';
        String searchStr=null;
        paramVal = ApexPages.currentPage().getParameters().get('srch');
        sFilter = ApexPages.currentPage().getParameters().get('sFilter');
        system.debug('Selected List Value is ----->'+ sFilter);
        if(sFilter=='ALL')
            sFilterFields='All';
        else if(sFilter=='Job')
            sFilterFields='Name';
        else if(sFilter=='LOC')
            sFilterFields='Creator_Location__c'; //createdBy.user_location__c';
        else if(sFilter=='PSN')
            sFilterFields='ESN__c';
        else if(sFilter=='UN')
            sFilterFields='Unit_Number__c';
        else if(sFilter=='WO')
            sFilterFields='Shop_Work_Order__c';
        else if(sFilter=='Name')
            sFilterFields='Customer_Name__c';
        performingSearch();
    }
    
    public void performingSearch()
    {
        String searchStr1=null;
        String searchQuery=null;
        
        JoList= New List<CSS_Job_Order__c>();
        if (paramVal != Null && paramVal.length() > 1) {
            sFlag='';
            sStr=paramVal;
            searchStr1 = '%'+paramVal+'%';
            paramVal=null;
        }
        else {
            sStr=searchStr;
            searchStr1 = '%'+searchStr+'%' ;
        }
        //searchStr1 = String.escapeSingleQuotes(searchStr1);
        //searchStr1 = '%'+searchStr+'%' ;
        if (searchStr1.length() > 3) {
            try{
                // current User Profile
                Id profileId=userinfo.getProfileId();
                String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
                // current user location 
                Id currentUserID=UserInfo.getUserId();
                //String location=[select id, User_Location__c from user where id=:currentUserID ].User_Location__c; Sai:10142016 Commented for CFSE Search (CRQ000001110040)
                // Begin for CFSE Search (CRQ000001110040)
                uList = [select id,UserRole.Name,UserRoleId,User_Location__c,CSS_User_MultiLocValues__c from user where id=:currentUserID];
                if(uList.size()>0)
                {
                    for(User ul : uList)
                    {
                        roleName = ul.UserRole.Name;                    
                        if(roleName.contains('CFSE') || roleName.contains('Factory') || roleName.contains('Customer Support Organization'))
                            vCFSEFlg = true;
                            //location = '';                                              
                        else if(roleName.contains('DFSE'))
                        {
                            vDFSEFlg = true;
                            dfseRoleId = ul.UserRoleId;
                        }                                                                        
                        else if(roleName.contains('ADVANCED')) 
                        {
                            vAdVFlg = true;
                            StoringMultiLocation = ul.CSS_User_MultiLocValues__c.split(';');
                            for(String userMultiLocVal:StoringMultiLocation){
                                splitUserLoc = userMultiLocVal.subString(0,11);
                                //String splitUserLocQuotes = '\'' + splitUserLoc + '\'';
                                multiUserLocationValues.add(splitUserLoc);
                            }
                            system.debug('** Multilocatio'+multiUserLocationValues);
                            //location = ul.User_Location__c;
                        }                               
                        else{
                            
                            StoringMultiLocation = ul.CSS_User_MultiLocValues__c.split(';');
                            for(String userMultiLocVal:StoringMultiLocation){
                                splitUserLoc = userMultiLocVal.subString(0,11);
                                //String splitUserLocQuotes = '\'' + splitUserLoc + '\'';
                                multiUserLocationValues.add(splitUserLoc);
                            }
                        }
                           // location = ul.User_Location__c;                       
                    }
                }// End CFSE Search.
                // Search logic for CFSE Search
                if(vCFSEFlg == true)
                {
                    if(sFilterFields=='ALL')
                    {                    
                        JoList =[SELECT name, Assigned__c, ESN__c, 
                                        additional_tech1__r.firstname,additional_tech1__r.lastname ,
                                        Add_tech1__c,Customer_name__c ,add_tech2__c,assigned_to__c,
                                        createdBy.name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,Additional_Tech3__r.Name,
                                        Additional_Tech4__r.Name,Additional_Tech5__r.Name,Additional_Tech6__r.Name,Additional_Tech7__r.Name,
                                        Additional_Tech8__r.Name,Additional_Tech9__r.Name,Status__c,Shop_Work_Order__c,Service_Model__c,
                                        Unit_Number__c,Date_In__c 
                         FROM       CSS_Job_Order__c                          
                         WHERE (((name LIKE: searchStr1 
                                        OR Customer_name__c LIKE:searchStr1
                                        OR ESN__c LIKE:searchStr1
                                        OR Unit_Number__c LIKE:searchStr1                                     
                                        OR shop_work_order__c LIKE:searchStr1
                                        OR Creator_Location__c LIKE:searchStr1                                        
                                        OR Assigned_To__r.Name LIKE:searchStr1
                                        OR Additional_Tech1__r.Name LIKE:searchStr1
                                        OR Additional_Tech2__r.Name LIKE:searchStr1
                                        OR Additional_Tech3__r.Name LIKE:searchStr1
                                        OR Additional_Tech4__r.Name LIKE:searchStr1
                                        OR Additional_Tech5__r.Name LIKE:searchStr1
                                        OR Additional_Tech6__r.Name LIKE:searchStr1
                                        OR Additional_Tech7__r.Name LIKE:searchStr1
                                        OR Additional_Tech8__r.Name LIKE:searchStr1
                                        OR Additional_Tech9__r.Name LIKE:searchStr1)
                                    AND (LastModifiedDate >= LAST_N_DAYS: 730)))
                               ORDER BY   LastModifiedDate desc  LIMIT 40000]; 
                    }
                    else
                    {
                        String[] sflist  = new List<String>{'name', 'Assigned__c', 'ESN__c', 
                                        'additional_tech1__r.firstname','additional_tech1__r.lastname',
                                        'Add_tech1__c','Customer_name__c','add_tech2__c','assigned_to__c','createdBy.name','Additional_Tech1__r.Name','Additional_Tech2__r.Name','Additional_Tech3__r.Name',
                                        'Additional_Tech4__r.Name','Additional_Tech5__r.Name','Additional_Tech6__r.Name','Additional_Tech7__r.Name','Additional_Tech8__r.Name','Additional_Tech9__r.Name','Status__c','Shop_Work_Order__c','Service_Model__c',
                                        'Unit_Number__c','Date_In__c'};
                        css_utility oUtl = new css_utility();
                        JoList = oUtl.runQuery('CSS_Job_Order__c', sflist, sFilterFields, searchStr1,'CFSE','',''); 
                        
                    }
                }
                // Search logic for DFSE search
                else if(vDFSEFlg == true)
                {
                    // Query users with same role to get locations.
                    uLocs =[select User_Location__c from user where UserRole.ParentRoleId=:dfseRoleId OR UserRole.Name=:roleName];                    
                    for(User ur: uLocs) // User ur: uLocs)
                    {
                        distLocs.add(string.valueOf(ur.User_Location__c)); // unique locations                       
                    }
                    dfseLoc.addAll(distLocs); // assigning it to List                           
                    if(sFilterFields=='ALL')
                    {
                    System.debug('Inside DFSE Logic=====>' + vDFSEFlg );
                    
                    JoList =[SELECT   name, Assigned__c, ESN__c, 
                                        additional_tech1__r.firstname,additional_tech1__r.lastname ,
                                        Add_tech1__c,Customer_name__c ,add_tech2__c,assigned_to__c,
                                        createdBy.name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,Additional_Tech3__r.Name,
                                        Additional_Tech4__r.Name,Additional_Tech5__r.Name,Additional_Tech6__r.Name,Additional_Tech7__r.Name,
                                        Additional_Tech8__r.Name,Additional_Tech9__r.Name,Status__c,Shop_Work_Order__c,Service_Model__c,
                                        Unit_Number__c,Date_In__c 
                         FROM       CSS_Job_Order__c 
                         // WHERE (    (   (Status__c ='closed' or status__c= 'completed')
                         WHERE ( (name LIKE: searchStr1 
                                  OR Customer_name__c LIKE:searchStr1
                                  OR ESN__c LIKE:searchStr1
                                  OR Unit_Number__c LIKE:searchStr1                                         
                                  OR Creator_Location__c LIKE:searchStr1                                        
                                  OR shop_work_order__c LIKE:searchSTR1                                        
                                  OR Assigned_To__r.Name LIKE:searchStr1
                                  OR Additional_Tech1__r.Name LIKE:searchStr1
                                  OR Additional_Tech2__r.Name LIKE:searchStr1
                                  OR Additional_Tech3__r.Name LIKE:searchStr1
                                  OR Additional_Tech4__r.Name LIKE:searchStr1
                                  OR Additional_Tech5__r.Name LIKE:searchStr1
                                  OR Additional_Tech6__r.Name LIKE:searchStr1
                                  OR Additional_Tech7__r.Name LIKE:searchStr1
                                  OR Additional_Tech8__r.Name LIKE:searchStr1
                                  OR Additional_Tech9__r.Name LIKE:searchStr1) 
                                  AND (createdBy.user_location__c IN: dfseLoc)
                                  AND (LastModifiedDate >= LAST_N_DAYS: 730)                                
                              ) ORDER BY   LastModifiedDate desc  LIMIT 40000];
                    }
                    else
                    {
                        String[] sflist  = new List<String>{'name', 'Assigned__c', 'ESN__c', 
                                        'additional_tech1__r.firstname','additional_tech1__r.lastname',
                                        'Add_tech1__c','Customer_name__c','add_tech2__c','assigned_to__c','createdBy.name','Additional_Tech1__r.Name','Additional_Tech2__r.Name','Additional_Tech3__r.Name',
                                        'Additional_Tech4__r.Name','Additional_Tech5__r.Name','Additional_Tech6__r.Name','Additional_Tech7__r.Name','Additional_Tech8__r.Name','Additional_Tech9__r.Name','Status__c','Shop_Work_Order__c','Service_Model__c',
                                        'Unit_Number__c','Date_In__c'};
                         String dfseLocs = '';                          
                         for(String s: dfseLoc)
                         {
                             dfseLocs +=(dfseLocs==''?'':',')+s;
                             
                         }
                         dfseLocs = dfseLocs.replace(',','\',\'');
                         dfseLocs = '\'' + dfseLocs + '\'';
                         system.debug('dfse locs in String format:'+dfseLocs);                         
                        css_utility oUtl = new css_utility();
                        JoList = oUtl.runQuery('CSS_Job_Order__c', sflist, sFilterFields, searchStr1,'DFSE',location,dfseLocs);                   
                        
                    }
                }
                 // default logic
                else
                {
                    system.debug('** search String'+searchStr1);
                    String advTechLocs = ''; 
                    system.debug('** MultiLocation'+multiUserLocationValues);
                    if(multiUserLocationValues != null) {
                        if(multiUserLocationValues.size() > 1) {
                            //advTechLocs = '(';
                            
                            for(string loc:multiUserLocationValues){
                                advTechLocs = advTechLocs + '\''+ loc + '\',';
                                 
                            }
                            system.debug(advTechLocs);
                            advTechLocs = advTechLocs.left(advTechLocs.length()-1);
                            //advTechLocs = advTechLocs + ')';
                            system.debug(advTechLocs);
                            system.debug('loc'+advTechLocations);
                        } else {
                            advTechLocs = '\'' + multiUserLocationValues[0] + '\'';
                        }
                    }   
                    
                   
                    
                    system.debug('** locations'+advTechLocs );
                    if(sFilterFields=='ALL'){  
                        
                        
                               JoList =[SELECT   name, Assigned__c, ESN__c, 
                                        additional_tech1__r.firstname,additional_tech1__r.lastname ,
                                        Add_tech1__c,Customer_name__c ,add_tech2__c,assigned_to__c,
                                        createdBy.name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,Additional_Tech3__r.Name,
                                        Additional_Tech4__r.Name,Additional_Tech5__r.Name,Additional_Tech6__r.Name,Additional_Tech7__r.Name,
                                        Additional_Tech8__r.Name,Additional_Tech9__r.Name,Status__c,Shop_Work_Order__c,Service_Model__c,
                                        Unit_Number__c,Date_In__c 
                         FROM       CSS_Job_Order__c 
                         
                         WHERE (  
                              (  ( 
                                       // createdBy.user_location__c LIKE: location) 
                                      //   Above line is commented for defect #104394
                                         Creator_Location__c IN: multiUserLocationValues)
                                    AND (  name LIKE: searchStr1 
                                        OR Customer_name__c LIKE:searchStr1
                                        OR ESN__c LIKE:searchStr1
                                        OR Creator_Location__c LIKE:searchStr1
                                        OR Unit_Number__c LIKE:searchStr1                                      
                                        OR createdBy.name LIKE:searchStr1
                                        OR shop_work_order__c LIKE:searchSTR1                                        
                                        OR Assigned_To__r.Name LIKE:searchStr1
                                        OR Additional_Tech1__r.Name LIKE:searchStr1 
                                        OR Additional_Tech2__r.Name LIKE:searchStr1
                                        OR Additional_Tech3__r.Name LIKE:searchStr1
                                        OR Additional_Tech4__r.Name LIKE:searchStr1
                                        OR Additional_Tech5__r.Name LIKE:searchStr1
                                        OR Additional_Tech6__r.Name LIKE:searchStr1
                                        OR Additional_Tech7__r.Name LIKE:searchStr1
                                        OR Additional_Tech8__r.Name LIKE:searchStr1
                                        OR Additional_Tech9__r.Name LIKE:searchStr1)
                                    AND (LastModifiedDate >= LAST_N_DAYS: 730) )
                               OR   (   ( //createdBy.user_location__c =: location ) 
                                     //Above line is commented for defect #104394
                                     Creator_Location__c IN: multiUserLocationValues ) 
                                    AND ( name LIKE: searchStr1 
                                         OR Customer_name__c LIKE:searchStr1
                                         OR ESN__c LIKE:searchStr1
                                         OR Unit_Number__c LIKE:searchStr1                                   
                                         OR createdBy.name LIKE:searchStr1
                                         OR shop_work_order__c LIKE:searchSTR1                                         
                                         OR Assigned_To__r.Name LIKE:searchStr1
                                         OR Additional_Tech1__r.Name LIKE:searchStr1
                                         OR Additional_Tech2__r.Name LIKE:searchStr1
                                         OR Additional_Tech3__r.Name LIKE:searchStr1
                                         OR Additional_Tech4__r.Name LIKE:searchStr1
                                         OR Additional_Tech5__r.Name LIKE:searchStr1
                                         OR Additional_Tech6__r.Name LIKE:searchStr1
                                         OR Additional_Tech7__r.Name LIKE:searchStr1
                                         OR Additional_Tech8__r.Name LIKE:searchStr1
                                         OR Additional_Tech9__r.Name LIKE:searchStr1) ) 
                              ) ORDER BY   LastModifiedDate desc  LIMIT 40000];
                        system.debug('** query data'+JoList);
                    }
                    else
                    {
                        String[] sflist = new List<String>{'name', 'Assigned__c', 'ESN__c', 
                                        'additional_tech1__r.firstname','additional_tech1__r.lastname',
                                        'Add_tech1__c','Customer_name__c','add_tech2__c','assigned_to__c','createdBy.name','Additional_Tech1__r.Name','Additional_Tech2__r.Name','Additional_Tech3__r.Name',
                                        'Additional_Tech4__r.Name','Additional_Tech5__r.Name','Additional_Tech6__r.Name','Additional_Tech7__r.Name','Additional_Tech8__r.Name','Additional_Tech9__r.Name','Status__c','Shop_Work_Order__c','Service_Model__c',
                                        'Unit_Number__c','Date_In__c'};
                        css_utility oUtl = new css_utility();
                        //location
                        JoList = oUtl.runQuery('CSS_Job_Order__c', sflist, sFilterFields, searchStr1,'AdvTech',advTechLocs ,''); 
                         
                    }
                }
                
               searchStr1=null;
               vDFSEFlg=false;
               vCFSEFlg=false;
                
            } catch(Exception e) {}
        } else {
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            
            } 
    }
    // Redirecting to the same page when searching with new Input/string
    public PageReference redirect(){
        PageReference pageRef = new PageReference('/apex/CSS_globalSearch');
        pageRef.setredirect(true);
        return pageRef;
    }
}