public without sharing class dbu_IStToESTDateTimeDayConvevrsion {
    @AuraEnabled
    public static string getloginTime(String storeName){
        system.debug('');
        String loginTime='false';
        storeName=(storeName=='CA' ||storeName=='EN')?'Canda English':(storeName=='FR'?'Canada French':storeName);
            /*String ManualDisable;
String startTime = System.Label.dbu_startTime;
String endTime = System.Label.dbu_endTime; 
String ManualOption = Test.isRunningTest()? 'ON' :System.Label.dbu_manualDisableChatOption; */
            List<dbu_Manage_Chat__c> manageChatRecs= new List<dbu_Manage_Chat__c>();
            System.debug('Outside for--- storeName' + storeName);

        manageChatRecs=[Select Id,dbu_StartTime__c,dbu_End_Time__c,dbu_Disable_Start_Time__c,dbu_Disable_End_Time__c,dbu_Time_Zone__c,dbu_Day_Of_The_Week__c,dbu_Disable_Chat__c from dbu_Manage_Chat__c where dbu_Store_Name__c=: storeName ];
        System.debug('Outside for--- manageChatRecs' + manageChatRecs);
        Datetime dt = System.now();
        String dayofWeek =  Test.isRunningTest()? 'Monday':DateTime.now().format('EEEE');
        
        System.debug('Outside for---' + loginTime);

        for(dbu_Manage_Chat__c chatRec:manageChatRecs){
            System.debug('Inside for---' + loginTime);

            if(chatRec.dbu_Day_Of_The_Week__c==dayofWeek && !chatRec.dbu_Disable_Chat__c){
                String dtEST = dt.format('HH:mm:ss', chatRec.dbu_Time_Zone__c!=null?chatRec.dbu_Time_Zone__c:'EST');
                integer dtESTHour = Integer.valueOf(dtEST.split(':')[0]);

                if(chatRec.dbu_Disable_Start_Time__c!=null && chatRec.dbu_Disable_End_Time__c!=null && 
                dtESTHour >= Integer.valueOf(chatRec.dbu_Disable_Start_Time__c.split(':')[0]) && dtESTHour < =Integer.valueOf(chatRec.dbu_Disable_End_Time__c.split(':')[0])){
                       loginTime ='false';
                   }else if(dtESTHour >= Integer.valueOf(chatRec.dbu_StartTime__c.split(':')[0]) && dtESTHour < =Integer.valueOf(chatRec.dbu_End_Time__c.split(':')[0])){
                       loginTime ='true';
                       System.debug('loginTime If---' + loginTime);
                   }
                break;
            }        
        }
        
        
        /* if(ManualOption == 'ON'){

if(dayofWeek == 'Mon' || dayofWeek == 'Tue' || dayofWeek =='Wed' ||dayofWeek =='Thu' || dayofWeek == 'Fri')
{
System.debug('Inside If');
loginTime ='true';
System.debug('loginTime If---' + loginTime);

if(dtEST >= startTime && dtEST < =endTime){
loginTime ='true';
System.debug('loginTime If---' + loginTime);
}
else
{
loginTime ='false';
System.debug('loginTime else---' + loginTime);
}

}
else if(dayofWeek == 'Sat' || dayofWeek == 'Sun')
{
System.debug('Inside else if');
loginTime ='false';
System.debug('loginTime else For Weekend---' + loginTime);
}
}else{

loginTime ='ManualDisable';
}*/
        return loginTime;
    }
}