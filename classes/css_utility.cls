/**********************************************************************
Name:css_utility
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Global Utility Class for CSS Job Functions                                                        
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Gyan Pany         0513/2016      INITIAL DEVELOPMENT          
2.0   Dinesh Yadav      08/04/2021     CT3-586- change      

***********************************************************************/
global class css_utility {

    public static User userRec;
    public static List<CSS_JobEventTemporary__c> jobEventTempPol; 
    public static List<CSS_JobEventTemporary__c> jobEventTemp; 
    public static Account AccountRecord;
    public static list<User> UsersList;
    public List<Currency_Conversion__c> lstCurrency;
    public Map<decimal, decimal> mapCurrExchange;
    
    public static void setSessionVariables(String UserLocation){
        /*
User u = [select UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:userInfo.getUserId() LIMIT 1];

list<Account> acc = [select Id, Location__c,BMS_Enabled__c, Region__c,Territory__c, IA_CSSEnabled__c from Account where Location__c =: u.User_Location__c];
bmsEnabled1 = acc[0].BMS_Enabled__c; */

        User u = [select Id,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:userInfo.getUserId() LIMIT 1];

        System.debug(' SATISH - User session variables' + u.User_Location__c);

        System.debug('UserLocation' +  '' + UserLocation);
        Cache.Session.put('local.CSSPartition.UserPrimaryLocationCode', u.User_Location__c==null?'':u.User_Location__c);
        Cache.Session.put('local.CSSPartition.UserEDSUserGroup', u.UserGroup__c==null?'':u.UserGroup__c);
        Cache.Session.put('local.CSSPartition.UserEDSRole', u.User_Role__c==null?'':u.User_Role__c);
        Cache.Session.put('local.CSSPartition.UserEDSPorductGroupAccess', u.Product_Group_Access__c==null?'':u.Product_Group_Access__c);
        Cache.Session.put('local.CSSPartition.UserEDSWorkGroupName', u.Work_Group_Name__c==null?'':u.Work_Group_Name__c);

        Cache.Session.put('local.CSSPartition.UserRoleName', u.UserRoleName__c==null?'':u.UserRoleName__c);
        Cache.Session.put('local.CSSPartition.UserFederationIdentifier', u.FederationIdentifier==null?'':u.FederationIdentifier);
        Cache.Session.put('local.CSSPartition.UserLanguageLocaleKey', u.LanguageLocaleKey==null?'':u.LanguageLocaleKey);
        Cache.Session.put('local.CSSPartition.UserLoginCounter', u.UserLoginCounter__c==null?'0':String.valueOf(Integer.valueOf(u.UserLoginCounter__c)));


        // Attributes from User Accounts
        list<Account> acc = new list<Account>();
        if(UserLocation != null && UserLocation != ''){//Anirudh added null condition to avoid 50001 Query Error.
        acc = [select Id, Name, Location__c,BMS_Enabled__c, Region__c,Territory__c, ERP_System__c, IA_CSSEnabled__c from Account where Location__c =: UserLocation];
        }
        if(acc.size()>0){
            Cache.Session.put('local.CSSPartition.UserBMSEnabled', acc[0].BMS_Enabled__c);
            Cache.Session.put('local.CSSPartition.UserIAEnabled', acc[0].IA_CSSEnabled__c);      
            Cache.Session.put('local.CSSPartition.UserRegion', acc[0].Region__c==null?'':acc[0].Region__c);
            Cache.Session.put('local.CSSPartition.UserTerritory', acc[0].Territory__c==null?'':acc[0].Territory__c);
            Cache.Session.put('local.CSSPartition.UserPrimaryLocationName', acc[0].Name==null?'':acc[0].Name);
            Cache.Session.put('UserERPSystem', acc[0].ERP_System__c==null?'':acc[0].ERP_System__c);
            if(Cache.Session.get('oneBMSSystem') == null || Cache.Session.get('oneBMSSystem') == '')
                Cache.Session.put('oneBMSSystem', acc[0].ERP_System__c==null?'':acc[0].ERP_System__c);

        }
        

        String ProflieName = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId() LIMIT 1].Name;
        Cache.Session.put('local.CSSPartition.UserProfileName', ProflieName==null?'':ProflieName);
        //Cache.Session.put('selectedLocation', '');
        
    }



    //Method to Return Time in User's Time zone from Visualforce page.
    public static String getFormattedDate (DateTime dInputDate) {
        System.debug('in utility dInputDate>>:'+dInputDate);
        //Handle NULL
        if (dInputDate ==null) {
            return null;
        } else {
            Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
            mappedValues = mpLocaleValues(); //populate the map with all the locale specific datetime formats
            String user_locale = UserInfo.getLocale(); //grab the locale of the user
            System.debug('UserInfo.getLocale()>>>>>>>>>>>:'+UserInfo.getLocale());
            //String datetime_format = 'M/d/yyyy h:mm a'; //variable for the datetime format defaulted to the US format
           String datetime_format = 'dd MMM yyyy hh:mm a z';  // Anvesh changed year format from YYYY to yyyy as part of defect GSSC -468          
            if (mappedValues.containsKey(user_locale)) { //if the map contains the correct datetime format
                datetime_format = mappedValues.get(user_locale); //grab the datetime format for the locale
            }
            System.debug('in utility datetime_format>>>>:'+datetime_format);
            //String sDate = dInputDate.format(datetime_format,'GMT'); //create a string with the proper format
            //Prabhakar Added below Code (19/03) for Defect#134296
            String sDate = dInputDate.format(datetime_format); //create a string with the proper format
            System.debug('in utility after convertion sDate>>>>:'+sDate);
            return sDate; //return the string
        }
    }

    // public static String getFormattedUserLocaleDate (DateTime dInputDate) {
    //Prabhakar Added below Code (19/03) for Defect#134296
    public static String getFormattedDateGMT (DateTime dInputDate) {
        //Handle NULL
        if (dInputDate ==null) {
            return null;
        } else {
            Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
            mappedValues = mpLocaleValues(); //populate the map with all the locale specific datetime formats
            String user_locale = UserInfo.getLocale(); //grab the locale of the user
            //String datetime_format = 'M/d/yyyy h:mm a'; //variable for the datetime format defaulted to the US format
            String datetime_format = 'dd MMM YYYY hh:mm a z';           
            if (mappedValues.containsKey(user_locale)) { //if the map contains the correct datetime format
                datetime_format = mappedValues.get(user_locale); //grab the datetime format for the locale
            }
            // String sDate = dInputDate.format(datetime_format); //create a string with the proper format
            //Prabhakar Added below Code (19/03) for Defect#134296
            String sDate = dInputDate.format(datetime_format,'GMT');
            return sDate; //return the string
        }
    }

    public static Boolean CheckPhoneNoIsValid(string Phones) {
        Boolean Error = false;
        if(Phones != null) {
            if(phones.contains('('))
                phones = phones.remove('(');
            if(phones.contains(')'))
                phones = phones.remove(')');
            if(phones.contains('-'))
                phones = phones.remove('-');
            if(phones.contains(' '))
                phones = phones.remove(' ');
            system.debug('phones = phones' + phones + '---> Length '+ phones.length());
            if(phones.length() < 10)
                Error = true;
            else
                Error = false;  
        } else
            Error = true;
        return Error;
    }

    //Method to Return Date in User's Date Format from Visualforce page.
    public static String getFormattedDate () {
        Map<String, String> mappedValues = new Map<String, String>(); //map for holding locale to datetime format
        mappedValues = mpLocaleDateValues(); //populate the map with all the locale specific datetime formats
        String user_locale = UserInfo.getLocale(); //grab the locale of the user
        String date_format;
        if (mappedValues.containsKey(user_locale)) { //if the map contains the correct datetime format
            date_format = mappedValues.get(user_locale); //grab the datetime format for the locale
        }
        //String sDate = dInputDate.format(datetime_format); //create a string with the proper format
        system.debug('date_format>>>>>>>>>>>>>>>>>'+date_format);
        return date_format; //return the string
    }

    //method to format the date 
    public static date formatedDate(string sdate){
        list<string> lstpart = new list<string>();
        date dt;
        if(string.isNotBlank(sdate)){
            lstpart = sdate.split('T');
        }
        if(lstpart != null && lstpart.size() > 0) {
            dt= date.valueof(lstPart[0]);
        }
        return dt;
    }

    // Added for Defect 134966
    public static String getRemainingYearsMonthsDays(Date startdate,Date enddate)   
    {
        String TotalCoverage;
        try{
            //Date Today = system.today();
            /*string endDt = '2020-11-05 00:00:00';
enddate = date.parse(endDt);*/
            system.debug('End Date:'+endDate);
            system.debug('Start Date:'+startdate); 
            Integer years = Integer.valueOf(startdate.daysBetween(endDate)/365.2425);
            //Integer years = Integer.valueOf(startdate.monthsBetween(endDate) / 12);
            String coverageyears = String.valueOf(years);
            //Integer coverageyears = years;
            system.debug('Years:'+years);
            startdate = startdate.addYears(years);
            system.debug('Today newDate:'+startdate);
            Integer months = 0;
            if(startdate.Day() <= endDate.Day()){
                months = startdate.monthsBetween(endDate);
                system.debug('monthsnew:'+months);

            }else{
                months = startdate.monthsBetween(endDate)-1;
                system.debug('Months new:'+months);

            }
            startdate = startdate.addMonths(months);
            system.debug('Today newDate2:'+startdate);
            String coveragedays = String.valueOf(startdate.daysBetween(endDate) + 1);
            system.debug('Days Between:'+coveragedays);
            if(months==12)
            {
                //coverageyears+=1;         //CT3-586
                years = years +1;           //CT3-586  
                coverageyears = string.valueOf(years);    //CT3-586
                months-=12;
            }

            // format: 3 Years, 6 Months, 25 Days or 100000 Miles or 3600 Hours

            TotalCoverage = (coverageyears+' Years, '+ months+ ' Months, ' +coveragedays+' Days');

            system.debug( 'Warranty Coverage:' + TotalCoverage);   
        }
        catch(Exception ex){
            system.debug('Exception in Remaining '+ ex.getMessage()+' '+ex.getLineNumber());
        }
        return TotalCoverage;
    }


    //populate a map with locale values and corresponding datetime formats
    public static void insertQSOLDocs (List<CSS_CampTsbTrp__c> lstQSOLDocs) {
        List<Id> idQSOLJob = new List<Id>();
        List<CSS_CampTsbTrp__c> lstNewQSOLDocs = new List<CSS_CampTsbTrp__c>();
        Boolean blnFound = false;
        for (CSS_CampTsbTrp__c recQSOLDocs1 :lstQSOLDocs){
            idQSOLJob.add(recQSOLDocs1.Job_Order__c);
        }
        List<CSS_CampTsbTrp__c> lstExistQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id,Job_Order__c,ESN__c,Doc_Num__c
                                                                                from CSS_CampTsbTrp__c where Job_Order__c = :idQSOLJob]);
        for (CSS_CampTsbTrp__c recQSOLDocs2a :lstQSOLDocs){
            blnFound = false;
            for (CSS_CampTsbTrp__c recQSOLDocs2b :lstExistQSOLDocs){
                if (recQSOLDocs2b.Job_Order__c == recQSOLDocs2a.Job_Order__c && 
                    recQSOLDocs2b.ESN__c == recQSOLDocs2a.ESN__c &&
                    recQSOLDocs2b.Doc_Num__c == recQSOLDocs2a.Doc_Num__c){
                    //Record Match
                    blnFound = true;
                    break;
                }
            }
            if (!blnFound) {
                lstNewQSOLDocs.add(recQSOLDocs2a);
            }
        } // Finish checking for Existing Records
        if (lstNewQSOLDocs.size() >0) { 
            insert lstNewQSOLDocs;
        }
    } // Finish Insert QSOL Docs

    private static Map<String, String> mpLocaleValues() {
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('cs', 'd.M.yyyy H:mm');
        locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
        locale_map.put('da', 'dd-MM-yyyy HH:mm');
        locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
        locale_map.put('de', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('el_GR', 'd/M/yyyy h:mm a');
        locale_map.put('en_AU', 'd/MM/yyyy HH:mm');
        locale_map.put('en_B', 'M/d/yyyy h:mm a');
        locale_map.put('en_BM', 'M/d/yyyy h:mm a');
        locale_map.put('en_CA', 'dd MMM YYYY hh:mm a z');
        locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_GH', 'M/d/yyyy h:mm a');
        locale_map.put('en_ID', 'M/d/yyyy h:mm a');
        locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_NZ', 'd/MM/yyyy HH:mm');
        locale_map.put('en_SG', 'M/d/yyyy h:mm a');
        //locale_map.put('en_US', 'M/d/yyyy h:mm a');
        locale_map.put('en_US', 'dd MMM yyyy hh:mm a z'); // Anvesh changed year format from YYYY to yyyy as part of defect GSSC -468
        locale_map.put('en_ZA', 'yyyy/MM/dd hh:mm a');
        locale_map.put('es', 'd/MM/yyyy H:mm');
        locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
        locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CL', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_EC', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_ES', 'd/MM/yyyy H:mm');
        locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
        locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('et_EE', 'd.MM.yyyy H:mm');
        locale_map.put('fi', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
        locale_map.put('fr', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
        locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
        locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
        locale_map.put('hr_HR', 'yyyy.MM.dd HH:mm');
        locale_map.put('hu', 'yyyy.MM.dd. H:mm');
        locale_map.put('hy_AM', 'M/d/yyyy h:mm a');
        locale_map.put('is_IS', 'd.M.yyyy HH:mm');
        locale_map.put('it', 'dd/MM/yyyy H.mm');
        locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
        locale_map.put('iw', 'HH:mm dd/MM/yyyy');
        locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
        locale_map.put('ja', 'yyyy/MM/dd H:mm');
        locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
        locale_map.put('kk_KZ', 'M/d/yyyy h:mm a');
        locale_map.put('km_KH', 'M/d/yyyy h:mm a');
        locale_map.put('ko', 'yyyy. M. d a h:mm');
        locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
        locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
        locale_map.put('lv_LV', 'yyyy.d.M HH:mm');
        locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
        locale_map.put('nl', 'd-M-yyyy H:mm');
        locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
        locale_map.put('nl_NL', 'd-M-yyyy H:mm');
        locale_map.put('CF', 'd-M-yyyy H:mm');
        locale_map.put('TU', 'd-M-yyyy H:mm');
        locale_map.put('nl_SR', 'd-M-yyyy H:mm');
        locale_map.put('no', 'dd.MM.yyyy HH:mm');
        locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
        locale_map.put('pl', 'yyyy-MM-dd HH:mm');
        locale_map.put('pt', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_AO', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
        locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
        locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
        locale_map.put('ru', 'dd.MM.yyyy H:mm');
        locale_map.put('sk_SK', 'd.M.yyyy H:mm');
        locale_map.put('sl_SI', 'd.M.y H:mm');
        locale_map.put('sv', 'yyyy-MM-dd HH:mm');
        locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
        locale_map.put('th', 'M/d/yyyy h:mm a');
        locale_map.put('th_TH', 'd/M/yyyy, H:mm ?.');
        locale_map.put('tr', 'dd.MM.yyyy HH:mm');
        locale_map.put('ur_PK', 'M/d/yyyy h:mm a');
        locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
        locale_map.put('zh', 'yyyy-M-d ah:mm');
        locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
        locale_map.put('zh_HK', 'yyyy-M-d ah:mm');
        locale_map.put('zh_TW', 'yyyy/M/d a h:mm');

        return locale_map; //return the map
    }

    private static Map<String, String> mpLocaleDateValues() {
        Map<String, String> locale_datemap = new Map<String, String>(); //holds the locale to timedate formats
        locale_datemap.put('ar', 'dd/MM/yyyy');
        locale_datemap.put('ar_AE', 'dd/MM/yyyy');
        locale_datemap.put('ar_BH', 'dd/MM/yyyy');
        locale_datemap.put('ar_JO', 'dd/MM/yyyy');
        locale_datemap.put('ar_KW', 'dd/MM/yyyy');
        locale_datemap.put('ar_LB', 'dd/MM/yyyy');
        locale_datemap.put('ar_SA', 'dd/MM/yyyy');
        locale_datemap.put('bg_BG', 'yyyy-M-d');
        locale_datemap.put('ca', 'dd/MM/yyyy');
        locale_datemap.put('ca_ES', 'dd/MM/yyyy');
        locale_datemap.put('ca_ES_EURO', 'dd/MM/yyyy');
        locale_datemap.put('cs', 'd.M.yyyy');
        locale_datemap.put('cs_CZ', 'd.M.yyyy');
        locale_datemap.put('da', 'dd-MM-yyyy');
        locale_datemap.put('da_DK', 'dd-MM-yyyy');
        locale_datemap.put('de', 'dd.MM.yyyy');
        locale_datemap.put('de_AT', 'dd.MM.yyyy');
        locale_datemap.put('de_AT_EURO', 'dd.MM.yyyy');
        locale_datemap.put('de_CH', 'dd.MM.yyyy');
        locale_datemap.put('de_DE', 'dd.MM.yyyy');
        locale_datemap.put('de_DE_EURO', 'dd.MM.yyyy');
        locale_datemap.put('de_LU', 'dd.MM.yyyy');
        locale_datemap.put('de_LU_EURO', 'dd.MM.yyyy');
        locale_datemap.put('el_GR', 'd/M/yyyy');
        locale_datemap.put('en_AU', 'd/mm/yyyy');
        locale_datemap.put('en_B', 'M/d/yyyy');
        locale_datemap.put('en_BM', 'M/d/yyyy');
        locale_datemap.put('en_CA', 'dd/mm/yyyy');
        locale_datemap.put('en_GB', 'dd/MM/yyyy');
        locale_datemap.put('en_GH', 'M/d/yyyy');
        locale_datemap.put('en_ID', 'M/d/yyyy');
        locale_datemap.put('en_IE', 'dd/MM/yyyy');
        locale_datemap.put('en_IE_EURO', 'dd/MM/yyyy');
        locale_datemap.put('en_NZ', 'd/MM/yyyy');
        locale_datemap.put('en_SG', 'M/d/yyyy');
        //locale_map.put('en_US', 'M/d/yyyy h:mm a');
        locale_datemap.put('en_US', 'mm/dd/yyyy');
        locale_datemap.put('en_ZA', 'yyyy/MM/dd');
        locale_datemap.put('es', 'd/MM/yyyy');
        locale_datemap.put('es_AR', 'dd/MM/yyyy');
        locale_datemap.put('es_BO', 'dd-MM-yyyy');
        locale_datemap.put('es_CL', 'dd-MM-yyyy');
        locale_datemap.put('es_CO', 'd/MM/yyyy');
        locale_datemap.put('es_CR', 'dd/MM/yyyy');
        locale_datemap.put('es_EC', 'dd/MM/yyyy');
        locale_datemap.put('es_ES', 'd/MM/yyyy');
        locale_datemap.put('es_ES_EURO', 'd/MM/yyyy');
        locale_datemap.put('es_GT', 'd/MM/yyyy');
        locale_datemap.put('es_HN', 'MM-dd-yyyy');
        locale_datemap.put('es_MX', 'd/MM/yyyy');
        locale_datemap.put('es_PE', 'dd/MM/yyyy');
        locale_datemap.put('es_PR', 'MM-dd-yyyy');
        locale_datemap.put('es_PY', 'dd/MM/yyyy');
        locale_datemap.put('es_SV', 'MM-dd-yyyy');
        locale_datemap.put('es_UY', 'dd/MM/yyyy');
        locale_datemap.put('es_VE', 'dd/MM/yyyy');
        locale_datemap.put('et_EE', 'd.MM.yyyy');
        locale_datemap.put('fi', 'd.M.yyyy');
        locale_datemap.put('fi_FI', 'd.M.yyyy');
        locale_datemap.put('fi_FI_EURO', 'd.M.yyyy');
        locale_datemap.put('fr', 'dd/MM/yyyy');
        locale_datemap.put('fr_BE', 'd/MM/yyyy');
        locale_datemap.put('fr_CA', 'yyyy-MM-dd');
        locale_datemap.put('fr_CH', 'dd.MM.yyyy');
        locale_datemap.put('fr_FR', 'dd/MM/yyyy');
        locale_datemap.put('fr_FR_EURO', 'dd/MM/yyyy');
        locale_datemap.put('fr_LU', 'dd/MM/yyyy');
        locale_datemap.put('fr_MC', 'dd/MM/yyyy');
        locale_datemap.put('hr_HR', 'yyyy.MM.dd');
        locale_datemap.put('hu', 'yyyy.MM.dd');
        locale_datemap.put('hy_AM', 'M/d/yyyy');
        locale_datemap.put('is_IS', 'd.M.yyyy');
        locale_datemap.put('it', 'dd/MM/yyyy');
        locale_datemap.put('it_CH', 'dd.MM.yyyy');
        locale_datemap.put('it_IT', 'dd/MM/yyyy');
        locale_datemap.put('iw', 'dd/MM/yyyy');
        locale_datemap.put('iw_IL', 'dd/MM/yyyy');
        locale_datemap.put('ja', 'yyyy/MM/dd');
        locale_datemap.put('ja_JP', 'yyyy/MM/dd');
        locale_datemap.put('kk_KZ', 'M/d/yyyy');
        locale_datemap.put('km_KH', 'M/d/yyyy');
        locale_datemap.put('ko', 'yyyy. M. d');
        locale_datemap.put('ko_KR', 'yyyy. M. d');
        locale_datemap.put('lt_LT', 'yyyy.M.d');
        locale_datemap.put('lv_LV', 'yyyy.d.M');
        locale_datemap.put('ms_MY', 'dd/MM/yyyy');
        locale_datemap.put('nl', 'd-M-yyyy');
        locale_datemap.put('nl_BE', 'd/MM/yyyy');
        locale_datemap.put('nl_NL', 'd-M-yyyy');
        locale_datemap.put('TU', 'd-M-yyyy');
        locale_datemap.put('CF', 'd-M-yyyy');
        locale_datemap.put('nl_SR', 'd-M-yyyy');
        locale_datemap.put('no', 'dd.MM.yyyy');
        locale_datemap.put('no_NO', 'dd.MM.yyyy');
        locale_datemap.put('pl', 'yyyy-MM-dd');
        locale_datemap.put('pt', 'dd-MM-yyyy');
        locale_datemap.put('pt_AO', 'dd-MM-yyyy');
        locale_datemap.put('pt_BR', 'dd/MM/yyyy');
        locale_datemap.put('pt_PT', 'dd-MM-yyyy');
        locale_datemap.put('ro_RO', 'dd.MM.yyyy');
        locale_datemap.put('ru', 'dd.MM.yyyy');
        locale_datemap.put('sk_SK', 'd.M.yyyy');
        locale_datemap.put('sl_SI', 'd.M.y');
        locale_datemap.put('sv', 'yyyy-MM-dd');
        locale_datemap.put('sv_SE', 'yyyy-MM-dd');
        locale_datemap.put('th', 'M/d/yyyy');
        locale_datemap.put('th_TH', 'd/M/yyyy');
        locale_datemap.put('tr', 'dd.MM.yyyy');
        locale_datemap.put('ur_PK', 'M/d/yyyy');
        locale_datemap.put('vi_VN', 'dd/MM/yyyy');
        locale_datemap.put('zh', 'yyyy-M-d');
        locale_datemap.put('zh_CN', 'yyyy-M-d');
        locale_datemap.put('zh_HK', 'yyyy-M-d');
        locale_datemap.put('zh_TW', 'yyyy/M/d');
        locale_datemap.put('en_IN', 'dd/mm/yyyy'); // Adding Locale for India
        return locale_datemap; //return the map
    }

    // Method to return whether user belongs to Distributor(DIST) or Dealer (DLR)
    public static string getOrgType (id duserid) {
        System.debug('in getOrgType...'+duserid);
        string sOrgType;
        boolean isDealer;
        try{
isDealer = false;
            css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
            system.debug('cssHeaderObject--- ' + cssHeaderObject);
            if(cssHeaderObject != null)
                isDealer = cssHeaderObject.RSWButtonEnable__c; 
            
            if(isDealer ==  true){
                sOrgType='DLR';
            }else{
                sOrgType='DISTR';
            } system.debug('sOrgType'+sOrgType);
        }catch(Exception ex){
            System.debug('in catch of getOrgType of utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }  
        return sOrgType;
    }

    //Method for getting Account type  using location code after creating the claim record  -By RAJESH 11th Mar 2019
    public static string dealerUserLocation (string locationCode) {
        system.debug('*****Inside acctyDealer Method******:');
        String dealerLocation;
        String locCode;
        Account[] accounType;
        system.debug('locationCode***'+locationCode);
        if(locationCode!=null && locationCode!=''){
            accounType = [Select id, Location__c, Type from Account where Location__c=: locationCode LIMIT 1];
            system.debug('accounType***'+accounType);
            boolean DealerTypeFlag = getAccounttype(accounType[0].Type);
            // if(accounType!=null && accounType.size() >0 && accounType[0].Type=='Dealer Account'){
            if(accounType!=null && accounType.size() >0){ // Roopa Gadipudi AccountId__r.Type replaced by Custom Label as part of IAM code change
                system.debug('**SHJEAR+inside if ***');
                if(DealerTypeFlag==true){
                    dealerLocation='true';
                }
                else{
                    dealerLocation='false';
                    system.debug('**SHJEAR+inside else ***');
                }
            }
        }
        return dealerLocation;
    }

    //End
    public static string getFederationId (id sUsrId) {
        // Method to return whether user belongs to Distributor(DIST) or Dealer (DLR)

        string sFedId = [select FederationIdentifier from user where id=:sUsrId LIMIT 1].FederationIdentifier;

        return sFedId;
    }

    public static void createJobhistory(List<CSS_JobHistory__c> jobHistoryList){
        if(jobHistoryList!=null && !jobHistoryList.isEmpty()){
            insert jobHistoryList;
        }        
    }

    public static List<CSS_JobEventTemporary__c> getJobEventTempPolicy() {
        if(jobEventTempPol == null) {
            jobEventTempPol = new List<CSS_JobEventTemporary__c>();
            jobEventTempPol = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c 
                                FROM CSS_JobEventTemporary__c 
                                WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('POL','NPW','RPW')];
            return jobEventTempPol;
        } else {
            return jobEventTempPol;
        }
    }

    public static List<CSS_JobEventTemporary__c> getJobEventTemp() {
        if(jobEventTemp == null) {
            jobEventTemp = new List<CSS_JobEventTemporary__c>();
            jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c 
                                FROM CSS_JobEventTemporary__c 
                                WHERE Key__c = 'AccountCodes'];
            return jobEventTemp;
        } else {
            return jobEventTemp;
        }
    }

    public static User getUserAttributes(ID userID){
        if(userRec==null)
        {
            //Added DefaultCurrencyIsoCode, CurrencyIsoCode fields in below query as part of 101 SOQL issue fix
            userRec= [select DefaultCurrencyIsoCode,UserRole.Name, CurrencyIsoCode, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey,profile.name from user where id=:userID LIMIT 1];
            return userRec;
        }
        else
        {
            return userRec;
        }
    }
    
    public static list<User> getUserRecords() {
        if(UsersList != null && UsersList.size() > 0) 
            return UsersList;
        else {
            UsersList = new list<User>();
            UsersList = [SELECT Id, Username, LastName, FirstName, FederationIdentifier FROM User WHERE isActive = true AND FederationIdentifier != null];
        return UsersList;
        }
    }
    
    public static Account getAccountloc(string location) {
        if(AccountRecord == null) {
            if(location != null && location != ''){
                AccountRecord = [select Id,Region__c,Territory__c,Type from Account where Location__c = :location];
            }
            return AccountRecord;
        } else {
            return AccountRecord;
        }
    }
    
    public static string getCodes(string type,string value1,string value2,string value3){
        string strQuery;
        string code;
        strQuery = 'select code__c from CSS_List_Of_Values__c';
        try{
            if(value1!=null && value2!=null && value3==null){
                strQuery = [select code__c from CSS_List_Of_Values__c where Picklist_Values_1__c=:value1 and Picklist_Values_2__c=:value2 and Type__c=:type limit 1].code__c;
                system.debug('Vamshi>>>>--->'+strQuery);
            }else if(value1!=null && value2==null && value3==null){
                system.debug('Vam--->'+strQuery);                
                strQuery = [select code__c from CSS_List_Of_Values__c where Picklist_Values_1__c=:value1 and Type__c=:type limit 1].code__c;
                //strQuery = [select code__c from CSS_List_Of_Values__c where code__c=:value1 and Type__c=:type limit 1].code__c;
                system.debug('strQuery1><--->'+strQuery);
            }else if(value1!=null && value2!=null && value3!=null){
                strQuery = [select code__c from CSS_List_Of_Values__c where Picklist_Values_1__c=:value1 and Picklist_Values_2__c=:value2 and Picklist_Values_3__c=:value3 and Type__c=:type limit 1].code__c;
                system.debug('Vamshi--->'+strQuery);
            }else if(value1!=null && value2==null && value3!=null){
                strQuery = [select code__c from CSS_List_Of_Values__c where Picklist_Values_3__c=:value3 and Type__c=:type limit 1].code__c;
            }else if(value1==null && value2!=null && value3==null){
                strQuery = [select Picklist_Values_1__c from CSS_List_Of_Values__c where Picklist_Values_2__c=:value2 and Type__c=:type limit 1].Picklist_Values_1__c;
                system.debug('Vamshi1--->'+strQuery);
            }
            else {
                strQuery=''; }
        }
        catch( exception e){

            strQuery='';
            system.debug('strQuery2--->'+e.getmessage());
        }
        return strQuery;
    }

    public static string getSubStringValue(string input, integer FromLen, integer ToLen)
    {
        string sSubStr='';
        if(input!=null && input!=''){
            if(input.length()>ToLen)
                sSubStr=input.substring(FromLen,ToLen);
            else
                sSubStr=input;
        }
        return sSubStr;
    } 
    public static string getCountryDesc(string cd){
        string strQuery;

        strQuery = [select CountryName__c from CSS_CountryStateValues__c where CountryCode__c=:cd LIMIT 1].CountryName__c;
        //CountryCode__c
        return strQuery;

    }

    /*
    Method Name: getStateDesc
    Modified By: Rajesh Narra
    Modified Reason: Modfied the existing logic for the story number 174846

    */
    public static string getStateDesc(string ctcd, string stcd){
        //string strQuery;  commented by Rajesh Narra
        List<CSS_CountryStateValues__c> strQuery;
        String noStateValue = System.Label.CSS_State_and_Country_Error;
        strQuery = [select StateName__c from CSS_CountryStateValues__c where CountryCode__c=:ctcd and StateCode__c=:stcd LIMIT 1];

        if(strQuery.size()>0){
            return strQuery[0].StateName__c;
        }else{
            return noStateValue;
        }
        //return strQuery; commented by Rajesh Narra
    }        
    public static void LogInbIntError(string CSSResp, string sysError, string SrcMsg,string sSource){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + CSSResp;
        errObj.Source__c = sSource;
        errObj.Processed_Data__c = SrcMsg;
        insert errObj;
    }
    public static void LogOutIntError(string CSSReq, string sysError, string SrcMsg,string sSource){ // GSSC-86,Added few lines in the method to cature Service Job
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        system.debug('sSource***'+sSource);
        string[] Source;
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + SrcMsg;
        //errObj.Source__c = sSource;
        errObj.Processed_Data__c = CSSReq;
        errObj.Response_Body__c = SrcMsg;
        //string d = '05-11-2019 11:00:00'; // for testing
        //errObj.Service_Call_Time__c = decimal.valueof(d);
        //errObj.Service_Call_Time__c = decimal.valueof(string.valueof(system.now()));
        //errObj.FailureDate__c = system.now();
        if(sSource != null && sSource.contains(';;')){
        Source = sSource.split(';;');
        if(Source != null && Source.size() >0){
        errObj.Source__c = Source[0];
        errObj.Service_Job_Number__c = Source[1];
        }
        }
        else
        errObj.Source__c = sSource;
        insert errObj;
    }

    public static void setUserLang (id sUserId, string sLang) {
        user u= new user();
        u.LanguageLocaleKey=sLang;
        u.id=sUserId;
        update u;       
    }
    public static CSS_accountLanguage__c getLanguage(string lang){
        CSS_accountLanguage__c aLang;
        try{
            system.debug('Lang**'+lang);
            aLang = CSS_accountLanguage__c.getValues(lang);
            system.debug('aLang**'+aLang);
            //aLang = [select CSS_QsolLanguage__c,CSS_userLanguage__c,CSS_EDSLanguage__c from CSS_accountLanguage__c where name=:lang];
        }
        catch(exception e){   
        }
        return aLang;
    }
    public static void updateDSID(string dsi,string fedID,string custName,string make,string model,string accessC,string equipID,decimal fPoint,string fMeasure,string uNum,string esn,string wOrder){
        CSS_EDSAuthentication.getEDSUpdate(dsi, fedID, custName, make, model, accessC, equipID, fPoint, fMeasure, uNum,esn,wOrder);        
    }
    //Added as per DSID Readonly requirement
    //Method to return DSIDEditIndicator(True or False)
    public static string getDSIDEditIndicator(ID UserId, string DSID, string JobWGName){
        string DSIDOwner;
        string DSIDEditIndicator;
        try{

            if((DSID=='') || (DSID== null))
            {
                DSIDEditIndicator = 'O';
            }
            else
            {
                //User usr = getUserAttributes(userId);
                User u = [select Work_Group_Name__c,FederationIdentifier  from user where id=:UserId LIMIT 1];
                //string usrFedId = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
                //string usrWGName = (String)Cache.Session.get('local.CSSPartition.UserEDSWorkGroupName');
                string usrFedId;
                string usrWGName;
                if(u != null){
                    usrFedId = u.FederationIdentifier;
                    usrWGName = u.Work_Group_Name__c;
                    system.debug('usrFedId><>'+usrFedId);
                    system.debug('usrWGName><>'+usrWGName);
                }
                DSIDOwner = CSS_WS_EDS.getDSIDDetails(DSID, 'en');

                // Logged in user is DSID owner
                if(DSIDOwner == usrFedId){
                    DSIDEditIndicator = 'O';
                }
                else //Logged in user is not DSID owner
                {
                    if (usrWGName == JobWGName) // Logged in User WG is same as Job WG
                        DSIDEditIndicator = 'G';
                    else DSIDEditIndicator = 'N'; // Logged in User WG is not same as Job WG
                }

            }
            Cache.Session.put('local.CSSPartition.DSIDIndicator', DSIDEditIndicator);

            System.debug('DSIDEditIndicator ' + DSIDEditIndicator);
        }
        catch(Exception e){}
        return DSIDEditIndicator;    
    }
    ///commenting the method due to multilocation implementation. 76192
    // Method to get the BMS flag
    /*public static boolean getBMSEnabled(ID userId){
Boolean bmsFlag;
try{
User user = getUserAttributes(userId);
bmsFlag = false;
String userLoc = user.User_Location__c;          
system.debug('userLoc'+userLoc);
Account acc = [select Id,Location__c,BMS_Enabled__c from Account where Location__c = :userLoc];
system.debug('AccountList'+acc);
if (acc!=null){    
bmsFlag = acc.BMS_Enabled__c;}
system.debug('bmsFlag'+bmsFlag);
Cache.Session.put('BMSEnabled', bmsFlag);
}
catch(exception e){   
}
return bmsFlag;        
}*/
    // Method to get the BMS flag
    public static boolean getBMSEnabled(string locCode){
        Boolean bmsFlag;
        system.debug('locCode>>>>'+locCode);
        if(string.isNotBlank(locCode)){
            bmsFlag = [select id,BMS_Enabled__c from CSS_UserLocation__c where Location_code__c =: locCode and Location_Source__c != 'ARF' limit 1 ].BMS_Enabled__c; 
        }
        return bmsFlag;
    }
    /*
* This method is used for preparing REST Response for given input wrapper/string object data
* Author: Surender M
**/
    public static RestResponse prepareRESTResponse(Object sObj, Integer statusCode){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareRESTResponse method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        RestResponse res = null;
        try{
            res = RestContext.response;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(sObj));
            res.statusCode = statusCode;
        }catch(Exception ex){
            System.debug('in catch of prepareRESTResponse of CSS_Utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return res;
    }



    /*
* This method is used for checking key exists in the map or not
* Author: Surender M
**/
    public static Boolean isMapContainsKey(Map<String, Object> inputMap, String key){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into isMapContainsKey method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        Boolean flag = false;
        try{
            if(inputMap != null && inputMap.size() >0 && inputMap.containsKey(key)){
                //if(inputMap.containsKey(key)){
                flag = true;
                //}
            }
        }catch(Exception ex){
            System.debug('in catch of isMapContainsKey of CSS_Utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        System.debug('returning flag>>>>>>>:'+flag);
        return flag;
    }

    //helper method to get recordsTypeId //pass Object name like >>> css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
    public static Id getRecordTypeId(SObjectType entity, String recordTypeName) {
        try {
            return entity.getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        } catch(Exception e) {
            return null;
        }
    }

    // Begin-  Added by Satish, a generic method to get picklist values and its dependancy relations

    public static string getStdPicklistCode(String pObjName, String pFieldName, String pPickVal, string pLBLorCD){
        string pklstCode;
        Schema.SObjectType pType = Schema.getGlobalDescribe().get(pObjName);
        system.debug('pType-->'+pType);
        if ( pType == null ) return null;

        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();

        //verify field names
        if (!objFieldMap.containsKey(pFieldName)){
            return null;  
        }      

        system.debug('objFieldMap--->'+objFieldMap);

        //get the control & dependent values   
        List<Schema.PicklistEntry> ple = objFieldMap.get(pFieldName).getDescribe().getPicklistValues();

        for( Schema.PicklistEntry pkl : ple){
            if(pLBLorCD=='CD'){
                if(pkl.getLabel()==pPickVal){
                    pklstCode=pkl.getValue();
                    //system.debug('My selected Picklist Code -->'+ pklstCode);
                }
            }
            if(pLBLorCD=='LBL'){
                if(pkl.getValue()==pPickVal){
                    pklstCode=pkl.getLabel();
                    //system.debug('My selected Picklist Code -->'+ pklstCode);
                }
            }
        }
        return pklstCode;
    }
    //Generic method to get the Controlling and dependend picklist values
    public static Map<String,List<String>> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName) {
        system.debug('ObjectName -->'+pObjName+' '+pControllingFieldName+ ' '+pDependentFieldName );

        Map<String,List<String>> mapResults = new Map<String,List<String>>();

        //verify/get object schema
        Schema.SObjectType pType = Schema.getGlobalDescribe().get(pObjName);
        system.debug('pType-->'+pType);
        if ( pType == null ) return mapResults;

        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();

        //verify field names
        if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName)){
            System.debug('Inside check- mapResults'+mapResults);
            return mapResults;  
        }      
        system.debug('objFieldMap--->'+objFieldMap);

        //get the control & dependent values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();

        system.debug('ctrl_ple -->'+ctrl_ple);
        system.debug('ctrl_ple -->'+dep_ple);

        //clear heap
        objFieldMap = null;

        //initialize results mapping
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){           
            mapResults.put( ctrl_ple[pControllingIndex].getLabel(), new List<String>());
        }

        //cater for null and empty
        mapResults.put('', new List<String>());
        mapResults.put(null, new List<String>());

        //serialize dep entries        
        List<TPicklistEntry> objDS_Entries = new List<TPicklistEntry>();
        objDS_Entries = (List<TPicklistEntry>)JSON.deserialize(JSON.serialize(dep_ple), List<TPicklistEntry>.class);
        system.debug('objDS_Entries'+objDS_Entries);

        List<Integer> validIndexes;
        for (TPicklistEntry objDepPLE : objDS_Entries){
            //system.debug('objDepPLE.validFor'+objDepPLE.validFor);

            validIndexes = cnvBits(objDepPLE.validFor);
            //System.Debug('cnvBits: [' + objDepPLE.label + '] = ' + validIndexes);

            for (Integer validIndex : validIndexes){ 
                //System.Debug('validIndex--->'+validIndex);
                //system.debug(ctrl_ple[validIndex-1].getLabel());
                mapResults.get( ctrl_ple[validIndex-1].getLabel()).add( objDepPLE.label );
            } 
        }

        //clear heap
        objDS_Entries = null; 
        //system.debug('mapResults-->'+mapResults.get('India'));
        return mapResults;
    }
    //Method used in generic methods 
    public static List<Integer> B64ToBytes (String sIn) {
        Map<Integer,Integer> base64 = new Map<Integer,Integer>{65=>0,66=>1,67=>2,68=>3,69=>4,70=>5,71=>6,72=>7,73=>8,74=>9,75=>10,76=>11,77=>12,78=>13,79=>14,80=>15,81=>16,82=>17,83=>18,84=>19,85=>20,86=>21,87=>22,88=>23,89=>24,90=>25
            ,97=>26,98=>27,99=>28,100=>29,101=>30,102=>31,103=>32,104=>33,105=>34,106=>35,107=>36,108=>37,109=>38,110=>39,111=>40,112=>41,113=>42,114=>43,115=>44,116=>45,117=>46,118=>47,119=>48,120=>49,121=>50,122=>51
                ,48=>52,49=>53,50=>54,51=>55,52=>56,53=>57,54=>58,55=>59,56=>60,57=>61,43=>62,47=>63};

        List<Integer> lstOut = new List<Integer>();
        if ( sIn == null || sIn == '' ) return lstOut;

        sIn += '='.repeat( 4 - Math.mod( sIn.length(), 4) );

        for ( Integer idx=0; idx < sIn.length(); idx += 4 ) {
            if ( base64.get(sIn.charAt(idx+1)) != null ) lstOut.add( (base64.get(sIn.charAt(idx)) << 2) | (base64.get(sIn.charAt(idx+1)) >>> 4) );
            if ( base64.get(sIn.charAt(idx+2)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+1)) & 15)<<4) | (base64.get(sIn.charAt(idx+2)) >>> 2) );
            if ( base64.get(sIn.charAt(idx+3)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+2)) & 3)<<6) | base64.get(sIn.charAt(idx+3)) );
        }

        //System.Debug('B64ToBytes: [' + sIn + '] = ' + lstOut);
        return lstOut;
    }//B64ToBytes
    public static List<Integer> BlobToBytes (Blob input) {
        return B64ToBytes( EncodingUtil.base64Encode(input) );
    }//BlobToBytes

    // Converts a base64 string into a list of integers indicating at which position the bits are on
    public static List<Integer> cnvBits (String b64Str) {
        List<Integer> lstOut = new List<Integer>();
        if ( b64Str == null || b64Str == '' ) return lstOut;

        List<Integer> lstBytes = B64ToBytes(b64Str);

        Integer i, b, v;
        for ( i = 0; i < lstBytes.size(); i++ ) {
            v = lstBytes[i];
            //System.debug ( 'i['+i+'] v['+v+']' );
            for ( b = 1; b <= 8; b++ ) {
                //System.debug ( 'i['+i+'] b['+b+'] v['+v+'] = ['+(v & 128)+']' );
                if ( ( v & 128 ) == 128 ) lstOut.add( (i*8) + b );
                v <<= 1;
            }
        }

        //System.Debug('cnvBits: [' + b64Str + '] = ' + lstOut);
        return lstOut;
    }//cnvBits


    //The below method converts string into minutes--used in CSS_ADMIN_SRTs class

    public static integer convertStrToMin(String str){

        integer minutes=0;

        if(str.contains(':')){

            List<String> strList= str.split(':');
            if(strList.size()==2){
                minutes=integer.valueof(strList[0])*60+integer.valueof(strList[1]);
            }
        }
        if (str.contains('.')){
            List<String> strList= str.split('\\.');
            system.debug('>>>strListDot'+strList);
            if(strList.size()==2){
                minutes=integer.valueof(strList[0])*60+integer.valueof(strList[1]);
            }

        }
        if(!str.contains(':') && !str.contains('.')){
            minutes=integer.valueof(str); 
            system.debug('>>>NoSplit'+minutes);
        }

        return minutes;
    }

    public static string getMake(string makeName, String engineFamilyCode, String equipmentId ){
        string retMakeName = '';
        try{
            // List<CSS_Make_Model__c> lstMake = [select make__c from CSS_Make_Model__c where make__c=:makeName LIMIT 1];  Modified by roopa due to CSS_Make_Model__c is replaced by CSS_Make_Model_Access__c
            List<CSS_Make_Model_Access__c> lstMake = new List<CSS_Make_Model_Access__c>([select make__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:makeName and EngineFamilyCode__c=:engineFamilyCode and EquipmentId__c=:equipmentId LIMIT 1]);       
            if (lstMake.size() >0){
                retMakeName = lstMake[0].make__c;} 
        }catch(Exception ex){
            System.debug('in catch of getMake method of css_utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return retMakeName;
    }
    //This method need to be deleted
    public static string getMake(string makeName ){
        string retMakeName = '';
        try{
            // List<CSS_Make_Model__c> lstMake = [select make__c from CSS_Make_Model__c where make__c=:makeName LIMIT 1];  Modified by roopa due to CSS_Make_Model__c is replaced by CSS_Make_Model_Access__c
            List<CSS_Make_Model_Access__c> lstMake = new List<CSS_Make_Model_Access__c>([select make__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:makeName LIMIT 1]);       
            if (lstMake.size() >0){
                retMakeName = lstMake[0].make__c;} 
        }catch(Exception ex){
            System.debug('in catch of getMake method of css_utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return retMakeName;
    }

    //This method need to be deleted
    public static string getModel(string makeName , string modelName ){ 
        string retModelName = '';
        try{
            //  List<CSS_Make_Model__c> lstModel = [select model__c from CSS_Make_Model__c where make__c=:makeName and model__c=:modelName LIMIT 1]; Modified by roopa due to CSS_Make_Model__c is replaced by CSS_Make_Model_Access__c
            List<CSS_Make_Model_Access__c> lstModel = new List<CSS_Make_Model_Access__c>([select model__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:makeName and model__c=:modelName LIMIT 1]);        
            if (lstModel.size() >0){
                retModelName = lstModel[0].model__c;}   
        }catch(Exception ex){
            System.debug('in catch of getModel method of css_utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return retModelName;
    }

    public static string getModel(string makeName, string modelName, String engineFamilyCode, String equipmentId ){
        string retModelName = '';
        try{
            //  List<CSS_Make_Model__c> lstModel = [select model__c from CSS_Make_Model__c where make__c=:makeName and model__c=:modelName LIMIT 1]; Modified by roopa due to CSS_Make_Model__c is replaced by CSS_Make_Model_Access__c
            List<CSS_Make_Model_Access__c> lstModel = new List<CSS_Make_Model_Access__c>([select model__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:makeName and model__c=:modelName and EngineFamilyCode__c=:engineFamilyCode and EquipmentId__c=:equipmentId LIMIT 1]);        
            if (lstModel.size() >0){
                retModelName = lstModel[0].model__c;}   
        }catch(Exception ex){
            System.debug('in catch of getModel method of css_utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return retModelName;
    }

    public static string getUnitype(string makeName , string modelName, String engineFamilyCode, String equipmentId){
        string retUnitType = '';
        try{
            system.debug('makeName:' + makeName);
            system.debug('modelName:' + modelName);
            system.debug('engineFamilyCode:' + engineFamilyCode);
            system.debug('equipmentId:' + equipmentId);
            List<CSS_Make_Model_Access__c> reConfig;
            //if((engineFamilyCode != '' || engineFamilyCode != null) && (equipmentId != '' || equipmentId != null)){
            if(engineFamilyCode != null && equipmentId != null){
                system.debug('inner engineFamilyCode:' + engineFamilyCode+' equipmentId:'+equipmentId);
                reConfig = new List<CSS_Make_Model_Access__c>([select Configuration__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:makeName and model__c=:modelName and EngineFamilyCode__c=:engineFamilyCode and EquipmentId__c=:equipmentId LIMIT 1]);
            }
            //commenting below code bcz it's not valid to pull Configuration based only Make & Model for story #170609
            /*else{
                reConfig = new List<CSS_Make_Model_Access__c>([select Configuration__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:makeName and model__c=:modelName LIMIT 1]);        
            }*/
            if (reConfig !=null && reConfig.size() >0){
                retUnitType = reConfig[0].Configuration__c; 
            }
            system.debug('retUnitType:' + retUnitType);
        }catch(Exception ex){
            System.debug('in catch of getUnitype method of css_utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return retUnitType;
    }


    //Story #145255 new Configuration search added by Surender
    public static string getUnitype(string makeName , string modelName, String config, String engineFamilyCode, String equipmentId ){
        string retUnitType = '';
        try{
            List<CSS_Make_Model_Access__c> reConfig;
            reConfig = new List<CSS_Make_Model_Access__c>([select Configuration__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:makeName and model__c=:modelName and Configuration__c=:config and EngineFamilyCode__c=:engineFamilyCode and EquipmentId__c=:equipmentId  LIMIT 1]);        
            if (reConfig.size() >0){
                retUnitType = reConfig[0].Configuration__c; 
            }
        }catch(Exception ex){
            System.debug('in catch of getUnitype method of css_utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return retUnitType;
    }
    //Story #145255 END

    //Wrapper class
    public class TPicklistEntry{
        public string active {get;set;}
        public string defaultValue {get;set;}
        public string label {get;set;}
        public string value {get;set;}
        public string validFor {get;set;}
        public TPicklistEntry(){
        }
    }//TPicklistEntry

    // Sai: 2/2/2107: Generic method which can query any object
    Public List<sObject> runQuery(String objname,String[] fieldnames,String crField,String condition, String sRole, String sLoc, String dfseLocs)
    {
        system.debug('locations are ===>'+ dfseLocs);
        List<sObject> queryresult;
        String fieldslist = '';
        condition = String.escapeSingleQuotes(condition);
        // Generate the fieldslist from the string array
        if (fieldnames != NULL)
        {
            if(fieldnames.size() > 0)
            {
                for (Integer i=0; i < fieldnames.size(); i++)
                {
                    if( i <= (fieldnames.size() - 2))
                        fieldslist = fieldslist+fieldnames[i]+',';
                    else
                        fieldslist = fieldslist+fieldnames[i];    
                }
            }
        }
        system.debug('fields'+fieldslist+'objName'+objname+'where clause'+crField+'Condition'+condition+'Location'+sLoc);
        String soqlquery = 'Select '+fieldslist+' from '+objname+' where '+crField+' LIKE \''+'%'+String.escapeSingleQuotes(condition)+'%'+'\'';  // CFSE Query      
        system.debug('** Query'+soqlquery);
        String soqlquery1 = soqlquery + 'AND createdBy.user_location__c IN ('+ dfseLocs+')';  // DFSE query      
        //String soqlquery2 = soqlquery + 'AND createdBy.user_location__c LIKE \''+String.escapeSingleQuotes(sLoc)+'\''; // Adv-Tech Query
        // Above line commented and below line added for defect#104394
        //String soqlquery2 = soqlquery + 'AND Creator_Location__c LIKE \''+String.escapeSingleQuotes(sLoc)+'\''; // Adv-Tech Query
        String soqlquery2 = soqlquery + 'AND Creator_Location__c IN (' + sLoc+ ')'; 
        /*\''+String.escapeSingleQuotes(sLoc)+'\''; // Adv-Tech Query*/
        system.debug('** soql'+soqlquery +'SoqlQuery 2'+soqlquery2 );
        system.debug('** fixing'+soqlquery2);
        if(sRole == 'CFSE')                
            queryresult = Database.query(soqlquery);
        else if(sRole == 'DFSE')
            queryresult = Database.query(soqlquery1);
        else 
            queryresult = Database.query(soqlquery2);
        return queryresult;               
    }


    /*
    public static Account getRegionTerritory(string userloc){

        try{
            Account regionTerritory;
            if(regionTerritory == null) {
                system.debug('======userloc====='+userloc);
                if(userloc!= null && userloc != ''){
                    regionTerritory = [select Id,Region__c,Territory__c,Type from Account where Location__c = :userLoc];
                    system.debug('regionTerritory**'+regionTerritory);
                }
                else{
                    User usr = getUserAttributes(userInfo.getUserId());
                    string user = usr.User_Location__c;
                    regionTerritory = [select Id,Region__c,Territory__c,Type from Account where Location__c = :user];
                }
                return regionTerritory;
            } else 
                return regionTerritory;
            
        }catch(exception e){
            system.debug('Entered into catch of getRegionTerritory in Utility Class>>>>>'+e.getLineNumber() + ' ' +e.getMessage());
        }
        return null;
    }
    */
    
    public static Account getRegionTerritory(string userloc){

        try{
            Account regionTerritory;
            if(regionTerritory == null) {
                system.debug('======userloc====='+userloc);
                if(userloc!= null && userloc != ''){
                    regionTerritory = getAccountloc(userloc);
                    system.debug('regionTerritory**'+regionTerritory);
                }
                else{
                    User usr = getUserAttributes(userInfo.getUserId());
                    string user = usr.User_Location__c;
                    regionTerritory = getAccountloc(user);
                }
                return regionTerritory;
            } else 
                return regionTerritory;
            
        }catch(exception e){
            system.debug('Entered into catch of getRegionTerritory in Utility Class>>>>>'+e.getLineNumber() + ' ' +e.getMessage());
        }
        return null;
    }

    //Method to get Data Exchange Admin enabled account
    public static boolean getDEEnabled(ID userId){
        Boolean deFlag;
        try{
            User user = getUserAttributes(userId);
            deFlag = false;
            String userLoc = user.User_Location__c;          
            system.debug('userLoc'+userLoc);
            Account acc = [select Id, Location__c, Data_Exchange_Enabled__c from Account where Location__c = :userLoc];
            system.debug('AccountList'+acc);
            if (acc!=null){    
                deFlag = acc.Data_Exchange_Enabled__c;}
            system.debug('deFlag'+deFlag);
        }
        catch(exception e){ 
            system.debug('e.getMessage()---'+e.getMessage()+'e.getlinenumber()'+e.getLineNumber());
        }
        return deFlag;        
    }


    //Method to create a case to Report a Problem with the Solutions 
    public static Id createCase(String caseComment, String jobName, String serviceModel, String solutionTitle, String solutionId){
        system.debug('**in createCase method** caseComment:'+caseComment+' jobName:'+jobName+' serviceModel:'+serviceModel+' solutionTitle:'+solutionTitle+' solutionId:'+solutionId);
        Case problemCase = new Case();
        try{
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;
            problemCase.recordtypeId = getRecordTypeId(Case.sObjectType,'Reported Problem');
            problemCase.Status = 'New';
            problemCase.Description = caseComment;
            problemCase.Origin = 'Web';
            problemCase.CSS_Job__c = jobName;
            problemCase.Service_Model__c = serviceModel;
            problemCase.Solution_Title__c = solutionTitle;
            problemCase.Solution_Id__c = solutionId;
            problemCase.Subject = solutionId + ': ' + solutionTitle;
            problemCase.Location__c = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            problemCase.setOptions(dmo);
            insert problemCase;
            system.debug('**problemCase.id**'+problemCase.id);
        }catch(Exception ex){
            System.debug('in catch of createCase of Utility>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return problemCase.id; 
    }

    //Method to return profile name for a particular user
    public static string getProfileName(Id profileId){
        String profileName = [SELECT Id,Name FROM Profile where Id= : profileId].Name;
        return profileName;
    }

    //Method to find Recon Engine

    public static Boolean getReconEngine(Decimal ESN){
        system.debug('ESN'+ESN);
        Boolean ReconEng;
        ReconEng = false;
        //List<CSS_Recon_Engine_Ranges__c> RER = new List<CSS_Recon_Engine_Ranges__c>();
        List<CSS_Recon_Engine_Ranges__c> RER = CSS_Recon_Engine_Ranges__c.getall().values();
        //RER = [select Id, Name, Min_Value__c, Max_Value__c from CSS_Recon_Engine_Ranges__c];
        system.debug('RER'+RER);
        for(CSS_Recon_Engine_Ranges__c r: RER){
            system.debug('RER'+RER);
            system.debug('ESN----'+ESN);

            if(r.Min_Value__c <= ESN && r.Max_Value__c >= ESN){

                ReconEng = true;
                system.debug('inside of range>>' + ReconEng);
            } 
        }
        return ReconEng;
    }

    //Method to validate customer email
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) 
            res = false;
        return res;
    }
    //Method to convert date format to DD-MON-YYYY
    public static String FormatDate(Date d){
        String FormattedDate;
        try{
            Integer Month;
            if(d!= null)
                Month  = d.month();
            String strMon = '';
            if(Month == 1)
                strMon = 'JAN';
            else if(Month == 2)
                strMon = 'FEB';
            else if(Month == 3)
                strMon = 'MAR';
            else if(Month == 4)
                strMon = 'APR';
            else if(Month == 5)
                strMon = 'MAY';
            else if(Month == 6)
                strMon = 'JUN';
            else if(Month == 7)
                strMon = 'JUL';
            else if(Month == 8)
                strMon = 'AUG';
            else if(Month == 9)
                strMon = 'SEP';
            else if(Month == 10)
                strMon = 'OCT';
            else if(Month == 11)
                strMon = 'NOV';
            else 
                strMon = 'DEC';
            system.debug('Month**'+strMon);
            if(d!= null)
                FormattedDate = d.day() + ' ' + strMon + ' ' + d.year();
        }catch(exception e){ 
            system.debug('in catch DateModel exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return FormattedDate;
    }


    //method to format the date 
    public static date formatedDateOfSiebelDate(string sdate){
        list<string> lstpart = new list<string>();
        date dt;
        if(string.isNotBlank(sdate)){
            lstpart = sdate.split('T');
        }
        if(lstpart != null && lstpart.size() > 0) {
            dt= date.valueof(lstPart[0]);
        }
        return dt;
    }

    //method to format the date 
    public static Date convertStringToDate(string sdate){ // 09/28/2018
        Date dateObj = null;
        try{
            //dateObj = Date.valueof(sdate); this is not working
            list<string> lstpart = new list<string>();
            if(string.isNotBlank(sdate)){
                lstpart = sdate.split('/');
            }
            if(lstpart != null && lstpart.size() > 1) {
                // System.debug('lstpart[0]>>:'+lstpart[0]+' 1>>:'+lstpart[1]+' 2>>:'+lstpart[2]);
                //dt= date.valueof(lstPart[0]);
                dateObj = date.newinstance(Integer.valueOf(lstpart[2]), Integer.valueOf(lstpart[0]), Integer.valueOf(lstpart[1])); //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                // date d = Date.newInstance(dateObj.year(),dateObj.month(),dateObj.day());

                system.debug('dateObj**'+dateObj);
                //system.debug('NewDated**'+d);
            }
        }catch(exception e){ 
            system.debug('in catch convertStringToDate exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return dateObj;
    }

    public static Date formatDateFromGuidanzFormat(String dateStr){ //2 AUG 1999
        Date dateObj = null;
        try{
            system.debug('dateStr**'+dateStr);
            if(dateStr == null) 
                return null;
            //Date d = Date.Valueof(dateStr);
            String[] arrExt = dateStr.split(' ');   //split(Pattern.quote(".")
            System.debug('Array arrExt>>:'+arrExt+' size>>:'+arrExt.size());
            system.debug('arrExt[0]**'+arrExt[0]);


            //Added code below, to handle the date with '/'
            if(arrExt.size()==1){
                arrExt = dateStr.split('/');
                system.debug('arrExt1**'+arrExt);
                system.debug('arrExt0**'+arrExt[0]);
                system.debug('arrExt1**'+arrExt[1]);
                system.debug('arrExt2**'+arrExt[2]);
                // dateObj = date.newinstance(Integer.valueOf(arrExt[0]), Integer.valueOf(arrExt[1]), Integer.valueOf(arrExt[2])); //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                //dateObj = new date(arrExt);
                //dateObj = Date.valueof(arrExt);
                dateObj = date.ValueOf(arrExt[2]+'-'+arrExt[1]+'-'+arrExt[0]);
                //dateObj = date.ValueOf('1968-09-21');
                system.debug('dateObj in Utility***'+dateObj);
            }

            else if(arrExt.size()>2){ 
                // if(arrExt.size()>2){ 
                String strMon = '';
                if(arrExt[1] == 'JAN')
                    strMon = '01';
                else if(arrExt[1] == 'FEB')
                    strMon = '02';
                else if(arrExt[1] == 'MAR')
                    strMon = '03';
                else if(arrExt[1] == 'APR')
                    strMon = '04';
                else if(arrExt[1] == 'MAY')
                    strMon = '05';
                else if(arrExt[1] == 'JUN')
                    strMon = '06';
                else if(arrExt[1] == 'JUL')
                    strMon = '07';
                else if(arrExt[1] == 'AUG')
                    strMon = '08';
                else if(arrExt[1] == 'SEP')
                    strMon = '09';
                else if(arrExt[1] == 'OCT')
                    strMon = '10';
                else if(arrExt[1] == 'NOV')
                    strMon = '11';
                else if(arrExt[1] == 'DEC')
                    strMon = '12';



                dateObj = date.newinstance(Integer.valueOf(arrExt[2]), Integer.valueOf(strMon), Integer.valueOf(arrExt[0])); //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                system.debug('dateObj in Utility***'+dateObj);
            }
            // if(arrExt.size()==1)
            // dateObj = Date.valueof(dateStr);
        }catch(exception e){ 
            system.debug('in catch of formatDateFromGuidanzFormat exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return dateObj;
    }

    public static Date formatDateIntoLocale(String dateStr){ //input: MM/DD/YYYY (or) '2 AUG 1999'
        Date dateObj = null;
        try{
            system.debug('dateStr**'+dateStr);
            if(dateStr == null) 
                return null;
            //Date d = Date.Valueof(dateStr);
            String[] arrExt = dateStr.split(' ');   //split(Pattern.quote(".")
            System.debug('Array arrExt>>:'+arrExt+' size>>:'+arrExt.size());
            system.debug('arrExt[0]**'+arrExt[0]);

            //Added code below, to handle the date with '/'
            if(arrExt.size()==1){ //For User Locale

                //New code startDate
                // dateObj = Date.valueof(dateStr);
                system.debug('dateObj value>>>>:'+dateObj);
                //return dateObj;



                arrExt = dateStr.split('/');
                system.debug('arrExt1**'+arrExt);
                system.debug('arrExt0**'+arrExt[0]);
                system.debug('arrExt1**'+arrExt[1]);
                system.debug('arrExt2**'+arrExt[2]);
                // dateObj = date.newinstance(Integer.valueOf(arrExt[0]), Integer.valueOf(arrExt[1]), Integer.valueOf(arrExt[2])); //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                //dateObj = new date(arrExt);
                //dateObj = Date.valueof(arrExt);

                String userLocaleFormat = getFormattedDate();
                if(userLocaleFormat !=null){
                    if(userLocaleFormat.contains('mm/dd/yyyy')){
                        dateObj = date.ValueOf(arrExt[2]+'-'+arrExt[0]+'-'+arrExt[1]);

                    }else if(userLocaleFormat.contains('dd/mm/yyyy')){
                        dateObj = date.ValueOf(arrExt[2]+'-'+arrExt[1]+'-'+arrExt[0]);

                    }
                }
                //End
                //dateObj = date.ValueOf(arrExt[2]+'-'+arrExt[1]+'-'+arrExt[0]);
                //dateObj = date.ValueOf('1968-09-21');
                system.debug('dateObj in Utility***'+dateObj);
            }else if(arrExt.size()>2){  // For format '2 AUG 1999'
                // if(arrExt.size()>2){ 
                String strMon = '';
                if(arrExt[1] == 'JAN')
                    strMon = '01';
                else if(arrExt[1] == 'FEB')
                    strMon = '02';
                else if(arrExt[1] == 'MAR')
                    strMon = '03';
                else if(arrExt[1] == 'APR')
                    strMon = '04';
                else if(arrExt[1] == 'MAY')
                    strMon = '05';
                else if(arrExt[1] == 'JUN')
                    strMon = '06';
                else if(arrExt[1] == 'JUL')
                    strMon = '07';
                else if(arrExt[1] == 'AUG')
                    strMon = '08';
                else if(arrExt[1] == 'SEP')
                    strMon = '09';
                else if(arrExt[1] == 'OCT')
                    strMon = '10';
                else if(arrExt[1] == 'NOV')
                    strMon = '11';
                else if(arrExt[1] == 'DEC')
                    strMon = '12';



                dateObj = date.newinstance(Integer.valueOf(arrExt[2]), Integer.valueOf(strMon), Integer.valueOf(arrExt[0])); //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                system.debug('dateObj in Utility***'+dateObj);
            }
            // if(arrExt.size()==1)
            // dateObj = Date.valueof(dateStr);
        }catch(exception e){ 
            system.debug('in catch of formatDateFromGuidanzFormat exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return dateObj;
    }


    public static String calculateYearsMonthsDays(Date startDate, Date endDate){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into calculateYearsMonthsDays method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        String calculatedStr;
        Integer daysBetween = 0;
        try{
            if(endDate>startDate){
                Integer totalMonthsBetween = startDate.monthsBetween(endDate);
                Integer yearsBetween = totalMonthsBetween/12;
                Integer monthsBetween = Math.mod(totalMonthsBetween,12);

                Integer totalDaysBetween = startDate.daysBetween(endDate);

                System.debug('yearsBetween>>>>'+yearsBetween+' monthsBetween>>>:'+monthsBetween+' totalDaysBetween>>>:'+totalDaysBetween);

                if(monthsBetween>0){
                    //daysBetween = totalDaysBetween/30;
                    daysBetween = Math.mod(totalDaysBetween,30);
                    //Decimal daysBetween1 = (startDate - endDate)/30.43685;
                    //daysBetween = Math.mod(totalDaysBetween,30.43685); //https://salesforce.stackexchange.com/questions/132961/how-to-calculate-duration-between-two-datesin-months-and-days-using-formula-fi
                    System.debug('daysBetween>>>>'+daysBetween);
                }else
                    daysBetween = totalDaysBetween;

                Integer startDateMonth = startDate.month();
                Integer endDateMonth = endDate.month();
                System.debug('startDateMonth>>>>:'+startDateMonth+' endDateMonth>>>>:'+endDateMonth);

                if(startDateMonth<endDateMonth){
                    for(Integer m=0;m<=yearsBetween;m++){
                        System.debug('startDateMonth<endDateMonth m value>>>>>>>>>>>:'+m);
                        for(Integer i=startDateMonth;i<endDateMonth;i++){
                            if(i==1)
                                daysBetween = daysBetween-1;
                            else if(i==2)
                                daysBetween = daysBetween-2;
                            else if(i==5)
                                daysBetween = daysBetween-1;
                            else if(i==7)
                                daysBetween = daysBetween-1;
                            else if(i==8)
                                daysBetween = daysBetween-1;
                            else if(i==10)
                                daysBetween = daysBetween-1;
                            else if(i==12)
                                daysBetween = daysBetween-1;
                        }
                    }
                }else if(startDateMonth>endDateMonth){
                    for(Integer m=0;m<=yearsBetween;m++){
                        System.debug('startDateMonth>endDateMonth m value>>>>>>>>>>>:'+m);
                        for(Integer i=endDateMonth;i<startDateMonth;i--){
                            if(i==1)
                                daysBetween = daysBetween-1;
                            else if(i==2)
                                daysBetween = daysBetween-2;
                            else if(i==5)
                                daysBetween = daysBetween-1;
                            else if(i==7)
                                daysBetween = daysBetween-1;
                            else if(i==8)
                                daysBetween = daysBetween-1;
                            else if(i==10)
                                daysBetween = daysBetween-1;
                            else if(i==12)
                                daysBetween = daysBetween-1;
                        }
                    }
                }else if(startDateMonth==endDateMonth){

                }

                calculatedStr = yearsBetween+' Years, '+monthsBetween+' Months, '+daysBetween+' Days'+' totalDaysBetween>>>>:'+totalDaysBetween;
            }else{
                calculatedStr = '0 Years, 0 Months, 0 Days';
            }
        }catch(Exception ex){
            System.debug('in catch of calculateYearsMonthsDays of CSS_Utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return calculatedStr;
    }

    public static void insertAccountPayCodes(){
        try{
            String reqBody = '{"Header": {"Sender": {"ServiceName": "GetAccountCodes","SenderID": "CSS"},"Target": {"TargetID": "SIEBEL"}},"DataArea": {"LAST_PROCESSED_DATE": "2017-01-01"}}';
            String endPointURL = 'https://services-stg.cummins.com/csswarranty/accountpaycode';
            String accessToken = 'Jr2BR4GkTWyvyj2Ul5HeDnD6Fofu2ZPljDTRCR6gsR6G1gmK5qMbEM';

            HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(reqBody, endPointURL, accessToken);
            system.debug('httpRes>>>>>>'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200)
            {
                css_utility.LogOutIntError('CSS_FN_Siebel-GetAccountCodesService', 'Siebel GetAccountCodes HttpResponse is null', 'Siebel GetAccountCodes Webservice Execution failed', 'Siebel');
                //return null;
            }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') )
            {
                System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_Siebel-GetAccountCodesService', 'Siebel GetAccountCodes HttpResponse is null', 'OSB Service Callout action received SOAP Fault response', 'Siebel');
                //return null;
            }
            //accountCodeRes = (CSS_SiebelAccountCodeResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_SiebelAccountCodeResponseJ2A.class);
            //return accountCodeRes;   
            //below logic of save response data & weekly basis
            if(httpRes.getStatusCode() == 200){
                CSS_FN_SIEBEL.insertResponse(httpRes.getBody(), 'GetAccountCodes');
            }


        }catch(Exception ex){
            System.debug('in catch of insertAccountPayCodes of CSS_Utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

    }

    //Method to return boolean for Enable Claims field using user location//
    public static boolean claimEnabledd;
    public static User userProfile;
    public static boolean getclaimsapprove(Id userId)
    {
        try{
            List<CSS_UserLocation__c> checkclaims;

            system.debug('Id userId' + userId);
            if(userId!=null)
            {
                if(userProfile == null){
                    //userProfile = [select id, name, profile.name from User where id = :userId];
                    userProfile = getUserAttributes(userId);
                }

                system.debug('userProfile' + userProfile.profile.name);
                if(!userProfile.profile.name.contains('Technician')){
                    system.debug('inside not tech');
                    system.debug('claimEnabledd'+claimEnabledd);
                    if(claimEnabledd == null){
                        checkclaims =[select Enable_Claim__c,isClaims__c,Location_Source__c from CSS_UserLocation__c where UserId__c=:userId and Enable_Claim__c = true and isActive__c = true and Location_Source__c = 'ARF'];
                        if(checkclaims != null && checkclaims.size()>0){
                            system.debug('checkclaims'+checkclaims);
                            claimEnabledd = true;
                            //return true;
                        }else{
                            claimEnabledd = false;
                        }
                    }


                    return claimEnabledd;
                }
                else
                    return false;
            }
            return false;
        }catch(exception e){
            system.debug('Entered into catch block of getClaimsApprove method in css_utility>>>'+e.getMessage() + ' ' +e.getLineNumber() + ' ' + e.getCause());
        }
        return false;
    }
    public static boolean showQuotePage(Id userId, string userLocation) {
        List<CSS_UserLocation__c> checkclaims;
        //if(userId!=null && userId!='')
        if(userId!=null && userLocation != null && userLocation != '') {
            checkclaims =[select Id, name, Location_code__c,isClaims__c,Location_Source__c, Enable_Claim__c from CSS_UserLocation__c where UserId__c=:userId and Enable_Claim__c = true and Location_Source__c != 'ARF' and isActive__c = true AND Location_code__c = : userLocation];
            if(checkclaims.size()>0){
                return true;
            }
            else{
                return false;
            }
        }
        return false;
    }

    public static Decimal getCustomRoundValue(Decimal toround){
        try{
            //toround = 3.14159265;
            System.debug('Original Value>>:'+toround);
            String extHrsStr = String.valueOf(toround);
            String[] arrExt;
            if(extHrsStr != null && extHrsStr != '')
                arrExt = extHrsStr.split('\\.');   //split(Pattern.quote(".")
            //System.debug('Array arrExt>>:'+arrExt+' size>>:'+arrExt.size());

            if(toround > 0 && arrExt.size()>1){ //for this ELSE ex is like 3 (or) 0
                if(arrExt[1] !=null && arrExt[1].length()>1){ //for this ELSE ex is like 3.1
                    String str1 = arrExt[1].substring(0,1);
                    String str2 = arrExt[1].substring(1, arrExt[1].length());
                    System.debug('arrExt[0]>>:'+arrExt[0]);
                    System.debug('1st decimal str1>>:'+str1);
                    System.debug('Next Decimal str2>>:'+str2+' str2.length>>>:'+str2.length());
                    if(str2.length() >6){
                        str2 = str2.substring(0, 6); //considering 6 digits after 1st decimal for custom round up
                        System.debug(' 22 Next Decimals>>:'+str2+' str2.length>>>:'+str2.length());
                    }

                    //Decimal rounded = toround.setScale(1);
                    Decimal rounded = Integer.valueOf(arrExt[0]) + (Decimal.valueOf(str1)/10);
                    System.debug('rounded>>:'+rounded);
                    if(Integer.valueOf(str2)>0){
                        toround = rounded + 0.1;
                        System.debug('toround>>:'+toround);
                    }else{
                        toround = rounded;
                    }
                }
            }
            //System.debug('33 toround>>:'+toround);
            //toround = toround.setScale(1);
            System.debug('Final Custom Rounded Value>>:'+toround);
            if(toround<0){
                toround = 0.0;
            }
        }catch(Exception ex){
            System.debug('in catch of getCustomRoundValue of CSS_Utility >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return toround;
    }

    public static void webserviceExecutionTest(String accessToken){
        String endPointURL;
        HttpResponse respose;
        try{
            //String accessToken = ''; //token add here
            Http h1 = new Http();
            HttpRequest request = new HttpRequest();
            endPointURL = 'https://cumminscss--cssdev.my.salesforce.com/services/apexrest/RSW/V02/CSS/ControlNumber/';
            String requestBody = '{"DataArea":{"CSSJobIdRecords":{"CSSJobIdRecord":[{"ControlNumbers":{"ControlNumber":["13661734"]},"CSSJobId":"CSS-00078865"},{"CSSJobId":[]},{"CSSJobId":[]}]}}}';
            request.setHeader('Authorization','Bearer '+accessToken);

            request.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
            //request.setTimeout(Integer.valueOf(conDetails.Timeout__c));
            request.setHeader('Content-Type','application/json');
            request.setMethod('PUT');
            //request.setMethod(conDetails.Method_Type__c);
            request.setEndpoint(endPointURL);
            request.setBody(requestBody);              
            System.debug('req1.getBody======'+request.getBody());
            //Sending request and mapping the response 
            //startDt = System.now();
            respose = h1.send(request);
            System.debug('%%%%-----OAutAuthURL :: '+endPointURL );
            System.debug('%%%%%%%%%%%res1 getStatusCode is :: '+respose.getStatusCode());
            system.debug('######################################RESPONSE_BODY:'+respose.getbody());

        }catch(Exception ex){
            System.debug('in catch of dummyTest of CSS_Utility getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }

    public static boolean getAccounttype(String Acctype){
        system.debug('Acctype>>' + Acctype);
        boolean DealerTypeFlag=False;
        string DealerAcounttype = label.CSS_AccType;
        string DistiAcounttype = label.CSS_InternalAccountType;        
        if(DealerAcounttype != null && DealerAcounttype != ''){
            if(Acctype != null && DealerAcounttype.contains(Acctype)){
                return true;
            }
        }
        if(DistiAcounttype != null && DistiAcounttype != ''){
            if( Acctype != null && DistiAcounttype.contains(Acctype)){
                return false;
            }
        }
        return false;
    }
    
    
    //########### New Azure Insite Images Code Start ################
    public List<String> getInsiteImageAzureFile(String sFileName, String Wid){
        System.debug('in getInsiteImageAzureFile method...');
        String attachId;
        System.debug('sFileName>>>>>>>>>>>>>:'+sFileName);
        //sFileName = Apexpages.currentPage().getParameters().get('fileName');
        //sFileName = 'I-20170330-083317843.eif'; //file in STG Server
        //sFileName = 'I-20190421-111230101-EB2C1D72.eif'; //file in STG Server
        ////I-20190609-111230668-EB2C1D72.eif 
//I-20190601-121230702-EB2C1D84.eif 
//SI-20190501-101230703-EB2C1D90.eif 
//I-20190121-211426769-EB2C1D71.eif 
        //string sEndPoint = 'https://fetchecmimages-dev.cummins.com/api/ECMimage?FileName=I-20190421-111230101-EB2C1D72.eif';
        CG_IP_OAGWrapper reqWrapper;
        CG_OP_OAGWrapper resWrapper;
        List<String> outputs = new List<String>();
        try {
            //Prepare Request Wrapper
            reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.serviceName = 'InsiteImageAzure'; //AzureAuthDev //InsiteImageAzure
            //reqWrapper.jsonReqBody = sFileName; //no request body but FileName as query param needed so assigning it to jsonReqBody;
            Map<String,String> reqParams = new Map<String,String>();
            reqParams.put('FileName', sFileName);
            reqWrapper.jsonReqBody=JSON.serialize(reqParams); //no request body but FileName as query param needed so assigning it to jsonReqBody;
            System.debug('reqWrapper.jsonReqBody>>>:'+reqWrapper.jsonReqBody);
            
            //Call CG_WS_Azure class to call the calloutGeneric() method which will fire the callout
            if(reqWrapper.serviceName != null ){
                resWrapper = CG_WS_Azure.calloutGeneric(reqWrapper);
            }
            //(OR) //resWrapper = callInsiteImageAzureService('InsiteImageAzure'); //calling InsiteImageAzure service
            System.debug('resWrapper.response>>>:'+resWrapper.response);
            
            //Download code
            //Here's where the magic happens. First get the response as a blob:
            if(resWrapper.response !=null && resWrapper.response.getStatusCode()==200 && resWrapper.response.getBodyAsBlob() !=null){
                Blob bImage = resWrapper.response.getBodyAsBlob();
                System.debug('blob Image>>>:'+bImage);
                //String sBlob = res.getBody();
                //sBlob = EncodingUtil.base64Encode(res.getBodyAsBlob());
               
                attachId = createAttachment(bImage, sFileName, Wid);
                outputs.add(attachId); //1st Param AttachmentId
                outputs.add(String.valueOf(resWrapper.response.getStatusCode())); //2nd Param StausCode
            }else{
                outputs.add(attachId); //1st Param AttachmentId
                if(resWrapper.response !=null && resWrapper.response.getStatusCode() !=null && resWrapper.response.getStatusCode()>0)
                outputs.add(String.valueOf(resWrapper.response.getStatusCode())); //2nd Param StausCode
                else
                    outputs.add('500');
            }
            System.debug('final attachId>>>:'+attachId);
            
        }catch(exception ex) {
            System.debug('in catch of getFile of CSS_Utility is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            outputs.add(attachId); //1st Param AttachmentId
            if(resWrapper.response !=null && resWrapper.response.getStatusCode() !=null && resWrapper.response.getStatusCode()>0)
                outputs.add(String.valueOf(resWrapper.response.getStatusCode())); //2nd Param StausCode
            else
                outputs.add('500');
        }
        return outputs; //returning List of Response Params
    }
    
    /*
* This method is used for creating a new Attachment
*/ 
    public String createAttachment(Blob bImage, String sFileName, String Wid){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createAttachment method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        String attachId;
        try{
            Attachment attachObj = new Attachment();
            attachObj.Name = sFileName;
            attachObj.Description = 'CG_'+sFileName;
            attachObj.ParentId = Wid; //Label.CSS_SampleRecordId;
            attachObj.ContentType = 'application/octet-stream';
            //String encodedString = sBlob;
            //Blob fileBlobData = EncodingUtil.base64Decode(encodedString);
            attachObj.Body = bImage;
            insert attachObj;      
            System.debug('created successfully New AttachmentId>>>>>>>>>>>>>>>>>>>>>>>>>>:'+attachObj.Id);
            
            attachId = getAttachment(attachObj.Id);
            
        }catch(Exception ex){
            System.debug('in catch of createAttachment of CSS_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return attachId;
    }
    
    public String getAttachment(String attachObjId){
        String attachId;
        try{
            List<Attachment> attachList = new List<Attachment>([Select Id, Name, ParentId, Body, BodyLength, LastModifiedDate from Attachment where Id=:attachObjId order By LastModifiedDate DESC limit 1]);
            System.debug('attachList size>>>>>>>>>>>>>>>:'+attachList.size());
            if(attachList.size()<=0)
                return null;
            Attachment attachObj = attachList.get(0);
            attachId = attachObj.Id;
            System.debug('retrieved Attachment Id:'+attachId);
            //System.debug('sFileName>>>>>>>>>>>>>:'+sFileName);
        }catch(Exception ex){
            System.debug('in catch of getAttachment of CSS_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return attachId;
    }
    //########### New Azure Insite Images Code End
    
    
     // Method to get the FSL flag added by roopa for FSL story
  public static boolean getFSLEnabled(Id userId) {
        List<CSS_UserLocation__c> checkFSLEnabled;
        //if(userId!=null && userId!='')
        if(userId!=null) {
            checkFSLEnabled =[select Id, name, Location_code__c,Location_Source__c, Enable_FSL__c from CSS_UserLocation__c where UserId__c=:userId and Enable_FSL__c = true and Location_Source__c != 'ARF' and isActive__c = true];
            if(checkFSLEnabled.size()>0){
                return true;
            }
            else{
                return false;
            }
        }
        return false;
    } 
    
    //Method to get part price/amount in logged in user's local currency as part of the story GSSC-138
    public Map<id, Map<decimal,decimal>> displayParts(List<CSS_Parts_Options__c> lstParts){
        
        Map<id, Map<decimal,decimal>> mapResults = new Map<id, Map<decimal,decimal>>();
        string userPrefCurrency = userinfo.getDefaultCurrency();
        
        List<decimal> lstVersions = new List<decimal>();
        
        if(lstParts != null && lstParts.size() > 0){
            for(CSS_Parts_Options__c parts : lstParts){
                if(!lstVersions.contains(parts.Exchange_Rate_Version__c)){
                    lstVersions.add(parts.Exchange_Rate_Version__c);
                }
            }
            
            Map<decimal, decimal> mapVersionExchangeRate = fetchCurrExchange(lstVersions);
    
            system.debug('lstParts-->'+lstParts.size());
            system.debug('mapVersionExchangeRate-->'+mapVersionExchangeRate);
            Id recTypeIdOC = getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            Id recTypeIdTTML = getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            Id recTypeParts = getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            for(CSS_Parts_Options__c p : lstParts){
                system.debug(lstParts + 'lstParts');
                decimal locUnitPrice;
                decimal locAmount;
                if(p.Service_Job__c != null){
                    if(p.RecordTypeId == recTypeIdOC){
                        if(userPrefCurrency != p.Currency_Type__c){
                            system.debug('inside if');
                            Decimal tempExRate = mapVersionExchangeRate.get(p.Exchange_Rate_Version__c);
                            system.debug(p.Sell_Price__c + 'Selling Price');
                            system.debug(tempExRate + 'tempExRate');
                            locUnitPrice = p.Sell_Price__c * tempExRate;
                            locAmount = p.Amount__c * tempExRate;
                        }
                        else{
                            system.debug('inside else');
                            locUnitPrice = p.Unit_Price_Local_Currency__c;
                            locAmount = p.Amount_Local_Currency__c;
                        }
                    }
                    else if(p.RecordTypeId == recTypeIdTTML){
                        if(userPrefCurrency != p.Currency_Type__c){
                            system.debug('inside if');
                            Decimal tempExRate = mapVersionExchangeRate.get(p.Exchange_Rate_Version__c);
                            if(p.Unit_Price__c!=null && p.Unit_Price__c!=''){
                            locUnitPrice = decimal.valueof(p.Unit_Price__c) * tempExRate;
                            }
                            locAmount = p.ExpenseTotal__c * tempExRate;
                        }
                        else{
                            system.debug('inside else');
                            locUnitPrice = p.Unit_Price_Local_Currency__c;
                            locAmount = p.Amount_Local_Currency__c;
                        }
                    }
                    system.debug('locUnitPrice-->'+locUnitPrice);
                    system.debug('locAmount-->'+locAmount);
                    Map<decimal, decimal> mapLocalCurrencies = new Map<decimal, decimal>();
                    mapLocalCurrencies.put(locUnitPrice, locAmount);
                    mapResults.put(p.id, mapLocalCurrencies);
                }
                else if(p.CSS_Claims__c != null){
                    if(p.RecordTypeId == recTypeIdOC || p.RecordTypeId == recTypeIdTTML){
                        if(userPrefCurrency != p.Currency_Type__c){
                            system.debug('inside if');
                            Decimal tempExRate = mapVersionExchangeRate.get(p.Exchange_Rate_Version__c);
                            locUnitPrice = (p.Unit_Price__c != null && p.Unit_Price__c != '' && tempExRate != null) ? (decimal.valueof(p.Unit_Price__c) * tempExRate) : 0;
                            locAmount = (p.ExpenseTotal__c != null && tempExRate != null) ? (p.ExpenseTotal__c * tempExRate) : 0;
                        }
                        else{
                            system.debug('inside else');
                            locUnitPrice = p.Unit_Price_Local_Currency__c;
                            locAmount = p.Amount_Local_Currency__c;
                        }
                    }
                    /*else if(p.RecordTypeId == recTypeIdTTML){
                        if(userPrefCurrency != p.Currency_Type__c){
                            system.debug('inside if');
                            Decimal tempExRate = mapVersionExchangeRate.get(p.Exchange_Rate_Version__c);
                            locUnitPrice = decimal.valueof(p.Unit_Price__c) * tempExRate;
                            locAmount = p.ExpenseTotal__c * tempExRate;
                        }
                        else{
                            system.debug('inside else');
                            locUnitPrice = p.Unit_Price_Local_Currency__c;
                            locAmount = p.Amount_Local_Currency__c;
                        }
                    }*/
                    else if(p.RecordTypeId == recTypeParts){
                        if(userPrefCurrency != p.Currency_Type__c){
                            system.debug('inside if');
                            Decimal tempExRate = mapVersionExchangeRate.get(p.Exchange_Rate_Version__c);
                            system.debug('p.Unit_Price__c-->'+p.Unit_Price__c);
                            system.debug('tempExRate-->'+tempExRate);
                            locUnitPrice = ((p.Unit_Price__c != null && p.Unit_Price__c != '') ? decimal.valueof(p.Unit_Price__c) : 0) * ((tempExRate != null) ? tempExRate : 0);
                            locAmount = (p.ExpenseTotal__c != null && tempExRate != null) ?  (p.ExpenseTotal__c * tempExRate) : 0;
                        }
                        else{
                            system.debug('inside else');
                            locUnitPrice = p.Unit_Price_Local_Currency__c;
                            locAmount = p.Amount_Local_Currency__c;
                        }
                    }
                    system.debug('locUnitPrice-->'+locUnitPrice);
                    system.debug('locAmount-->'+locAmount);
                    Map<decimal, decimal> mapLocalCurrencies = new Map<decimal, decimal>();
                    mapLocalCurrencies.put(locUnitPrice, locAmount);
                    mapResults.put(p.id, mapLocalCurrencies);
                }
            }
        }
        return mapResults;
    }
    
    public Map<decimal, decimal> fetchCurrExchange(List<decimal> lstVersions){
        system.debug('lstVersions-->'+lstVersions);
        lstCurrency = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() and Bolt_Version__c IN: lstVersions];
        system.debug('lstCurrency-->'+lstCurrency);
        mapCurrExchange = new Map<decimal, decimal>();
        
        if(userinfo.getDefaultCurrency() != 'USD'){
            for(Currency_Conversion__c c: lstCurrency){
                if(!mapCurrExchange.containskey(c.Bolt_Version__c)){
                    mapCurrExchange.put(c.Bolt_Version__c, c.Bolt_Conversion_Rate__c);
                }
            }
        }
        else{
            for(Decimal v: lstVersions){
                if(!mapCurrExchange.containskey(v)){
                    mapCurrExchange.put(v, 1);
                }
            }
        }
        return mapCurrExchange;
    }
}