/************************************************************
Name:  OSM_Generic_Utility 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is generic utility class to return datetime string in UTC
timezone for all datetime input paramters. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT
Subbu comment          


*************************************************************/
Public Class OSM_Generic_Utility{

    //DateTime to String
    public static String getUTCDate(DateTime dt){
    Datetime GMTDate = Datetime.newInstanceGmt(
                            dt.year(),
                            dt.month(),
                            dt.day(),
                            dt.hour(),
                            dt.minute(),
                            dt.second());
                            
    String strConvertedDateUTC = GMTDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'','UTC');   
    return strConvertedDateUTC;
    }

    //Date to String    
    public static String getDate(Date d){
        String dateFormatString = 'yyyy-MM-dd';
        Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
        String dateString = dt.format(dateFormatString);
        return dateString;
    }

    //Get incremental count
    public static String getIncrementalCount(){
        try
        {
            OSM_Incremental_Count__c countRec = OSM_Incremental_Count__c.getAll().Values();
            String currentCount;
            if(countRec != null){
                currentCount = string.valueOf(countRec.Current_Count__c);
                return currentCount; 
            }else{
                return '000';
            }
        }
        catch(Exception e)
        {
            return '000';
        }
        
    }
    
    //Update incremental batch number
    public static void UpdateIncrementalCount(){
        
        String publishValue;
        Integer count = 001;
        Integer currentCount;
        OSM_Incremental_Count__c countRec = OSM_Incremental_Count__c.getAll().Values();
        system.debug('countRec'+countRec);
        
        if(countRec != null){
            currentCount = Integer.valueOf(countRec.Current_Count__c);
            system.debug('currentCount'+currentCount);
            if(currentCount != null && currentCount < 1000){
                currentCount = currentCount + 1;
            }
            if(currentCount != null && currentCount == 999){
                currentCount = count;
            }
            
            if(string.valueOf(currentCount).length()==1){
                publishValue = string.valueOf('00' + currentCount);    
            }
            if(string.valueOf(currentCount).length()==2){
                publishValue = string.valueOf('0' + currentCount);
            }
            if(string.valueOf(currentCount).length()==3){
                publishValue = string.valueOf(currentCount);
            }
            
            countRec.Current_Count__c = publishValue;
        }
        system.debug('countRec'+countRec);
        update countRec;
        //return publishValue;
    }   
      
    public static String getRequiredDateFormat(Date d, String format)
    {
        Datetime myDT = datetime.newInstance(d.year(), d.month(),d.day());
        String myDate = myDT.format(format);
        System.debug(myDate);
        
        return myDate;
    }
    
    public static String fieldSizeRestriction(String s, Integer maxSize, String direction)
    {
        if(null != s)
        {
            if(s.length() > maxSize)
            {
                if(direction == 'back')
                {
                    return s.substring(s.length()-maxSize, s.length());
                }
                else
                {
                    return s.substring(0, maxSize);
                }
            }
            else
            {
                return s;
            }
        }
        else
        {
            return s;
        }
    }
    
    public static String removeSymbols(String value)
    {
        List<String> symbolList = Label.OSM_Symbols.split(',');
        
        for(String symbol : symbolList)
        {
            if(value.contains(symbol))
            {
                value = value.remove(symbol);
            }
        }
        
        return value;
    }
    
//Added by Pooja story 1054
public static String truncateRequesterId(String str){
    Integer defaultLength = 50; //default length
    String definedLendgth = System.Label.OSM_RequesterId_Max_Length; //length defined in custom label
    if(definedLendgth != null && definedLendgth.isNumeric()){ 
        try{ //to prevent any parsing error, used try catch
            defaultLength = Integer.valueOf(definedLendgth);
        }catch(Exception ex){}
    }
    return str!=null&&str.length()>50?str.substring(0, defaultLength):str;
  }
}