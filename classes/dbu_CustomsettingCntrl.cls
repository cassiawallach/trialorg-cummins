public without sharing class dbu_CustomsettingCntrl {
    @AuraEnabled(cacheable = true)
    public static List<dbu_StateNames__mdt> getStatesData(){
        dbu_StateNames__mdt[] statesMappings = [SELECT MasterLabel,dbu_Country__c,dbu_Country_Code__c,
                                                dbu_State__c,dbu_State_Code__c,dbu_Stateslist__c FROM dbu_StateNames__mdt];
        return statesMappings;
    }

    /*
        *  Description:  To get Home page Banner details  
        *  @name: getHomePageBannersData
        *  @param
        *  @return: All Banner details in string format
        *  @Author: Vishnu 10th June 2021
    */
    @AuraEnabled(cacheable = true)
    public static string getHomePageBannersData(){
        DateTime myDateTime = system.now();//TODAY CHG0078302
        List<dbu_Hero_Slider__c> homeBanners = [SELECT Id,Name,dbu_src_img__c,dbu_header_message__c,dbu_description__c,dbu_href_url__c,dbu_store__c,dbu_banner_serial_number__c,dbu_slide_start_date__c,dbu_slide_end_date__c,dbu_sub_title__c,dbu_Banner_Title__c,dbu_Banner_Position__c,dbu_Button_bg_color__c,dbu_Button_Text_color__c,dbu_Button_text__c,dbu_Button_font_size__c,dbu_Link_Type__c,dbu_Product_Link__c,dbu_Category_Link__c,dbu_New_Window__c FROM dbu_Hero_Slider__c where dbu_store__c != null and dbu_slide_start_date__c <= :myDateTime and dbu_slide_end_date__c >= :myDateTime order by dbu_banner_serial_number__c NULLS LAST];
        return JSON.serialize(homeBanners);
    }
}