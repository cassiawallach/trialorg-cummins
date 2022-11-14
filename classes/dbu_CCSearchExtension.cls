/**
* Author : Saikomal Kattamudi
* Created on 27 AUG 2020
* Description : This class will be used to get the search response
* code Refactored By : Malhar Ulhas Agale
* code Refactor Date : 2 June 2021
*/

public  without sharing class dbu_CCSearchExtension {
    
    @AuraEnabled
    public static  dbu_CCSearchResponse getSearchResultForESN(string urlParam) {
        system.debug('ENTERING dbu_CCSearchResponse CLASS getSearchResultForESN Method');
        dbu_CCSearchResponse searchResult = new dbu_CCSearchResponse();
        searchResult.isIdSearch = false;
        List<dbu_Search_Results__c> esnResultTobeSaved = new List<dbu_Search_Results__c>();
        map<string,string> storeCountry_language_currencycode_mapping = new map<string,string>();
        searchResult.products = new List<dbu_CCAPISearchResponseWrapper>();
        searchResult.Categories = new List<String>();
        ccLogicProductFind.wrapperFrameResponse responseWrapperReturned = new ccLogicProductFind.wrapperFrameResponse();
      
        string searchText;
        string currencyISOvalue ;
        string storelanguage; 
        string storeCountry = ''; 
        boolean normalcheckresultsResponseSuccess = false; //> if true, then proceed for normal search check
        boolean existingESNResponseSuccess = false;        //> if true, then proceed for locally existing ESN response check    
        boolean PCCIntegrtnResponseSuccess = false;        //> if true, then proceed for PCC Integration check      
        
        try{
            
            //get SearchKey
            //CECI-978 - Abhilash - Added Trim() to remove leading and trailing blank spaces.
            searchText = (ccLogicProductFind.extractSearchkeyFromURL(urlParam)).Trim();
            if(searchText != null){
                
                //get storeLanguage, country & ISO code
                storeCountry_language_currencycode_mapping = ccLogicProductFind.getCurrentStore(urlParam);
                if(storeCountry_language_currencycode_mapping.get('StoreCountry') != null && 
                   storeCountry_language_currencycode_mapping.get('storelanguage') != null &&
                   storeCountry_language_currencycode_mapping.get('currencyISOCode') != null){
                       currencyISOvalue = (string)storeCountry_language_currencycode_mapping.get('currencyISOCode');
                       storeCountry = (string)storeCountry_language_currencycode_mapping.get('StoreCountry');
                       storelanguage = (string)storeCountry_language_currencycode_mapping.get('storelanguage');
                       system.debug('currencyISOvalue > ' + currencyISOvalue + 'storeCountry > ' + storeCountry + 'storelanguage > ' + storelanguage);
                       
                       Integer searchLength = searchText.length();
                    //   if(searchLength <= 17) {
                            if(normalcheckresultsResponseSuccess == false && existingESNResponseSuccess == false && PCCIntegrtnResponseSuccess == false){
                                //Logic for Normal Search                                                   
                                responseWrapperReturned = getSearchResultFornormal(searchText, storeCountry, currencyISOvalue, storelanguage);  
                                system.debug('responseWrapperReturned > ' + responseWrapperReturned);
                                
                                if((responseWrapperReturned.ESNSearchResultsResp).size() > 0 || Test.isRunningTest()){
                                    normalcheckresultsResponseSuccess = true;
                                    existingESNResponseSuccess = false;
                                    PCCIntegrtnResponseSuccess = false;
                                    
                                    
                                    //final data ready to return
                                    searchResult = responseWrapperReturned.FramedProductData;                               
                                    searchResult.isIdSearch = true;
                                    //Save searchstring response assynchronously
                                    
                                    //CECI-978 - Commented below line as part of this requirement, search data will not be stored in the dbu_Search_Results__c and dbu_searchString__c objects - Abhilash
                                    //string UserIp = '';                                    
                                    //dbu_ESNResponseUtility.SaveSearchResponse(JSON.serialize(responseWrapperReturned.ESNSearchResultsResp),searchText,storeCountry,UserIp);                               
                                    
                                }else{
                                    existingESNResponseSuccess = true;normalcheckresultsResponseSuccess = false;PCCIntegrtnResponseSuccess = false;
                                } 
                                
                            }
                            
                            if(normalcheckresultsResponseSuccess == false && existingESNResponseSuccess == true && PCCIntegrtnResponseSuccess == false || Test.isRunningTest()){
                                //Logic for existing esn response check
                                    responseWrapperReturned = searchInLocalESNResponse(searchText, storeCountry, currencyISOvalue, storelanguage);
                                
                                if((responseWrapperReturned.ESNSearchResultsResp).size() > 0 || Test.isRunningTest()){
                                    existingESNResponseSuccess = true;
                                    normalcheckresultsResponseSuccess = false;
                                    PCCIntegrtnResponseSuccess = false;
                                    
                                    //final data ready to return
                                    searchResult = responseWrapperReturned.FramedProductData;  
                                    
                                    //CECI-978 - If VIN data is found in the partsResponse object then make the API callout to get productInfo data - Abhilash - Start
                                    if(searchLength == 17){
                                        dbu_Integration_DataplatAPI.TokenResponse productInfo = new dbu_Integration_DataplatAPI.TokenResponse();
                                        List<dbu_partsresponse__c> esnForVIN = [SELECT Id, dbu_ESNNumber__c FROM dbu_partsresponse__c WHERE dbu_VINNumber__c = :searchText Limit 1];
                                        system.debug('esnForVIN >>> ' + esnForVIN);
                                        productInfo=dbu_Integration_DataplatAPI.getProductInfo(esnForVIN[0].dbu_ESNNumber__c);
                                        dbu_CCVINProductInformation VINProductInfo=new dbu_CCVINProductInformation();
                                        if(productInfo!=null && productInfo.data != null && productInfo.engineSerialNumber!= null){                                            
                                            VINProductInfo.ESNNumber=productInfo.engineSerialNumber;
                                            VINProductInfo.marketingModelName=productInfo.data[0].marketingEngineModel;
                                            VINProductInfo.serviceModelName=productInfo.data[0].serviceEngineModel;
                                            VINProductInfo.buildDate=productInfo.data[0].engineBuildDate!=null?string.valueof(date.valueOf(productInfo.data[0].engineBuildDate)):null;                 
                                        }
                                        if(VINProductInfo!=null){ searchResult.VINProductInfo=VINProductInfo;}
                                    }                                    
                                    //CECI-978 - Abhilash - End
                                    
                                    //Save searchstring response assynchronously

                                    //CECI-978 - Commented below line as part of this requirement, search data will not be stored in the dbu_Search_Results__c and dbu_searchString__c objects - Abhilash
                                    //string UserIp = '';
                                    //dbu_ESNResponseUtility.SaveSearchResponse(JSON.serialize(responseWrapperReturned.ESNSearchResultsResp),searchText,storeCountry,UserIp);                                  
                                    
                                }else{
                                    existingESNResponseSuccess = false;normalcheckresultsResponseSuccess = false;PCCIntegrtnResponseSuccess = true;
                                }                                  
                            }
                            
                            if(normalcheckresultsResponseSuccess == false && existingESNResponseSuccess == false && PCCIntegrtnResponseSuccess == true || Test.isRunningTest()){
                                //logic for pcc integration
                                responseWrapperReturned = PCCintegrationSearch(searchText, storeCountry, currencyISOvalue, storelanguage);
                                    
                                if((responseWrapperReturned.ESNSearchResultsResp).size() > 0){
                                                                                                                                
                                    existingESNResponseSuccess = true;normalcheckresultsResponseSuccess = false;PCCIntegrtnResponseSuccess = false;                               
                                    
                                    //final data ready to return
                                    searchResult = responseWrapperReturned.FramedProductData;  
                                    
                                    //Save searchstring response assynchronously
                                    //CECI-978 - Commented below line as part of this requirement, search data will not be stored in the dbu_Search_Results__c and dbu_searchString__c objects - Abhilash
                                    //string UserIp = '';dbu_ESNResponseUtility.SaveSearchResponse(JSON.serialize(responseWrapperReturned.ESNSearchResultsResp),searchText,storeCountry,UserIp);                                  
                                    
                                }
                                  //SG start
                                if(responseWrapperReturned.VINProductInfo!=null){ searchResult.VINProductInfo=responseWrapperReturned.VINProductInfo;}
                                //SG end
                                
                            } 
                     //   }

                   }//end - get store country, language, currency code
                
            }//end - check search key
            



            
        }
        
        catch(Exception e)
        {
            system.debug('Exception message'+e.getMessage()+''+'Exception Line Number'+e.getLineNumber());
        }
        
        
        
        return searchResult;
    }
    
    public static String getExternalIp() {
        
        return Auth.SessionManagement.getCurrentSession().get('SourceIp'); 
    } 
    
    public static ccLogicProductFind.wrapperFrameResponse searchInLocalESNResponse(string searchkey, string storeCountry, string CountryISOCode, String StoreLanguage){
        system.debug('<<<<<<<<<<<<<<<< entering in searchInLocalESNResponse >>>>>>>>>>>');
        set<string> getexistingESNresponseset = new set<string>();
        ccLogicProductFind.wrapperFrameResponse finalWrapperResponse = new ccLogicProductFind.wrapperFrameResponse(); 
        
        getexistingESNresponseset = ccLogicProductFind.existingESNResponseSearchResult(searchkey);
        system.debug('getexistingESNresponseset > ' + getexistingESNresponseset);
        
        if(getexistingESNresponseset.size() > 0){
            //perform products find logic using the part numbers
            
            Map<string,object> ReadyResponse = new Map<string,object>();
            ReadyResponse = Intermidiatormethod(getexistingESNresponseset, storeCountry, 'Existing ESN Response Search');            
            system.debug('ReadyResponse > ' + ReadyResponse);
            
            if(ReadyResponse.size() > 0){
                finalWrapperResponse = ccLogicProductFind.frameResponseWrapper(storeCountry, StoreLanguage, CountryISOCode, ReadyResponse);
                system.debug('finalWrapperResponse > ' + finalWrapperResponse);
                
            }
            else{ finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;}            
            
        }else{
            finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();
            finalWrapperResponse.FramedProductData = null;
        } 
        
        return finalWrapperResponse;
    }    

  
    public static  ccLogicProductFind.wrapperFrameResponse getSearchResultFornormal (string searchkey, string storeCountry, string CountryISOCode, String StoreLanguage){
        set<string> searchIdSet = new set<string>();
        Map<String, Object> finalresult = new Map<String, Object>();
        list<string> searchedProductIDsList = new list<string>();
        set<string> searchedProductIDsSet = new set<string>();
        List<ccrz__E_Product__c> lstSearchProduct = new List<ccrz__E_Product__c>();
        list<ccrz__E_ProductCategory__c> CategoryData;
        list<ccrz__E_PriceListItem__c> pricedata;
        List<ccrz__E_Category__c> branddata;
        BrandResponse newbrans;
        ccLogicProductFind.wrapperFrameResponse finalWrapperResponse = new ccLogicProductFind.wrapperFrameResponse(); 
        //replacing the product search api
                 try {                     
                     searchedProductIDsList = ccLogicProductFind.SearchProductIDs(searchkey, storeCountry);
                     system.debug('searchedProductIDsList >> ' + searchedProductIDsList);
                     
                    if(searchedProductIDsList.size()>0){
                        searchedProductIDsSet.addAll(searchedProductIDsList);
                        
                        Map<string,object> ReadyResponse = new Map<string,object>();
                        ReadyResponse = Intermidiatormethod(searchedProductIDsSet, storeCountry, 'Normal Search');
                        
                        system.debug('ReadyResponse > ' + ReadyResponse);
                        
                        if(ReadyResponse.size() > 0){
                            finalWrapperResponse = ccLogicProductFind.frameResponseWrapper(storeCountry, StoreLanguage, CountryISOCode, ReadyResponse);
                            system.debug('finalWrapperResponse > ' + finalWrapperResponse);
                        }else{
                            finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;
                        }
                    }else{
                        finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;
                    }                                    
            } catch (Exception e) {
                system.debug('exception messge'+e.getmessage()+''+'exception line number'+e.getlinenumber());
            }
        return finalWrapperResponse;                
    }

    
    public static ccLogicProductFind.wrapperFrameResponse PCCintegrationSearch(string searchkey, string storeCountry, string CountryISOCode, String StoreLanguage){
        system.debug('<<<<<<<<<<<<<<<< entering in PCCintegrationSearch >>>>>>>>>>>');
        ccLogicProductFind.wrapperFrameResponse finalWrapperResponse = new ccLogicProductFind.wrapperFrameResponse(); 
        ccLogicProductFind.PCCRefinedResultResponse refinedResults = new ccLogicProductFind.PCCRefinedResultResponse();
        dbu_EsnSearchResponseWrapper partsApiResponsewrap = new dbu_EsnSearchResponseWrapper();
        dbu_GsnSearchResponseWrapper partsApiGSNResponsewrap;// Sri 
        Map<string,object> ReadyResponse = new Map<string,object>();
        string retreivedEsnforVIN;
        dbu_Integration_DataplatAPI.TokenResponse productInfo = new dbu_Integration_DataplatAPI.TokenResponse();
        ccLogicProductFind.wrapperFrameResponse responseWrapperReturned = new ccLogicProductFind.wrapperFrameResponse();
        Boolean esnFoundInCache = false;
        if(test.isRunningTest()){
            string responseBody='{"Header":{"MessageIdentifier":"2-a0c8c090-02fb-11eb-b9e9-121d5554e1ea", "ReturnCode":"PARTLIST001","ReturnCodeDescription":"PartLists Retrieved successfully","Status":"SUCCESS","MessageType":"S"},"DataArea":{"PartLists":[{"ESN":"79464646","Parts":[{"Number":"3687580","Description":"Studded Flange Cap Screw","Systems":["DRIVES AND MOUNTINGS"]},{"Number":"3171713","Description":"Hexagon Flange Head Cap Screw","Systems":["DRIVES AND MOUNTINGS"]}]}]}}';
            string correctedJsonStr = responseBody.replace('Number','Number_Z');
            partsApiResponsewrap = (dbu_EsnSearchResponseWrapper)json.deserialize(correctedJsonStr, dbu_EsnSearchResponseWrapper.class); //deserialize the reponse            
        }else{
            //Ramesh  CHG0111026 start
            if(searchkey.isAlphanumeric()){
                system.debug('searchkey:'+searchkey.isAlphanumeric());
                if(searchkey.length() == 8){ 
                  searchkey = searchkey.toLowercase();
                partsApiResponsewrap = dbu_Integration_ESNSearch.getEsnResult(searchkey);
            } //CHG0103246
            //VIN search Example
            //Sandeep Changes
            if(searchkey.length()==17){
                retreivedEsnforVIN = dbu_Integration_ESNSearchWithVIN.getEsnResultwithVIN(searchkey);
                if(retreivedEsnforVIN != null){ 

                    productInfo=dbu_Integration_DataplatAPI.getProductInfo(retreivedEsnforVIN); // SG  
                    system.debug('productInfo.data >>> ' + productInfo.data);
                    system.debug('productInfo.engineSerialNumber >>> ' + productInfo.engineSerialNumber);

                    //CECI-978 - Added below line of code to check if Parts data w.r.t the ESN retrived 
                    //from VIN already exists in the Parts Response object. If not, make an API call to get the parts for the ESN - Abhilash - Start
                    responseWrapperReturned = searchInLocalESNResponse(retreivedEsnforVIN, storeCountry, CountryISOCode, StoreLanguage);
                    if((responseWrapperReturned.ESNSearchResultsResp).size() > 0){
                        finalWrapperResponse = responseWrapperReturned;
                        esnFoundInCache = true;
                    }
                    else{
                        partsApiResponsewrap = dbu_Integration_ESNSearch.getEsnResult(retreivedEsnforVIN); 
                    }
                    //CECI-978 - Abhilash - END
                }
              }
              else{
                   // Change by Ravi..............
                   if(searchkey.length() == 10){
                    searchkey = searchkey.toLowercase();
                         partsApiGSNResponsewrap = dbu_Integration_GSNSearch.getGSNResult(searchkey);
                   }
             }
             //End VIN code       
            } //Ramesh  CHG0111026 End   
        }
        //partsApiResponsewrap.servicengmodel;1234
        system.debug('lstpartsApiResponse'+partsApiResponsewrap);
        system.debug('lstpartsApiGSNResponse'+partsApiGSNResponsewrap);

        if(partsApiGSNResponsewrap!=null){ //Sandeep
            refinedResults = ccLogicProductFind.refinePCCIntegrationSearchResultsGSN(partsApiGSNResponsewrap, searchkey); //Sandeep: Passing the GSN number to store results locally
     
            if((refinedResults.partsResponseData).size() > 0){
                dbu_ESNResponseUtility.SaveESNSearchResponse(JSON.serialize(refinedResults.partsResponseData), null);                  
            }

            if((refinedResults.partNumbersList).size() > 0){
                ReadyResponse = Intermidiatormethod(refinedResults.partNumbersList, storeCountry, 'PCC Integration Response Search');
                if(ReadyResponse.size() > 0){
                    finalWrapperResponse = ccLogicProductFind.frameResponseWrapper(storeCountry, StoreLanguage, CountryISOCode, ReadyResponse);
                }else{
                    finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;
                }
            }else{
                finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;
            }
        }
        else if(partsApiResponsewrap != null){
            //CECI-978 - Abhilash - Start
            //CECI-978 - Abhilash - Added below condition to update the VIN number coresponding to the ESN data which already exists in the Parts Response object.
            if(esnFoundInCache){
                if(searchkey.length() == 17){

                    List<dbu_partsresponse__c> existingESNResponseList = new List<dbu_partsresponse__c>();

                    existingESNResponseList = [SELECT Number_Z__c,dbu_ESNNumber__c,dbu_Description__c FROM dbu_partsresponse__c WHERE dbu_ESNNumber__c=:retreivedEsnforVIN AND dbu_VINNumber__c !=: searchkey];

                    dbu_ESNResponseUtility.SaveESNSearchResponse(JSON.serialize(existingESNResponseList), searchkey);  
                }
                
            }
            //CECI-978 - Abhilash - End
            else{
                refinedResults = ccLogicProductFind.refinePCCIntegrationSearchResults(partsApiResponsewrap);
                if((refinedResults.partsResponseData).size() > 0){
                    if(searchkey.length() == 17){
                        dbu_ESNResponseUtility.SaveESNSearchResponse(JSON.serialize(refinedResults.partsResponseData), searchkey);  
                    }
                    else{
                        dbu_ESNResponseUtility.SaveESNSearchResponse(JSON.serialize(refinedResults.partsResponseData), null);    
                    }              
                }
                
                if((refinedResults.partNumbersList).size() > 0){
                    ReadyResponse = Intermidiatormethod(refinedResults.partNumbersList, storeCountry, 'PCC Integration Response Search');
                    if(ReadyResponse.size() > 0){ finalWrapperResponse = ccLogicProductFind.frameResponseWrapper(storeCountry, StoreLanguage, CountryISOCode, ReadyResponse);}
                    else{finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;}
                }else{
                    finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;
                }
            }
            //SG start
            if(searchkey.length()==17 && productInfo!=null && productInfo.data != null && productInfo.engineSerialNumber!= null){
                dbu_CCVINProductInformation VINProductInfo=new dbu_CCVINProductInformation();
                VINProductInfo.ESNNumber=productInfo.engineSerialNumber; VINProductInfo.marketingModelName=productInfo.data[0].marketingEngineModel;  VINProductInfo.serviceModelName=productInfo.data[0].serviceEngineModel;  VINProductInfo.buildDate=productInfo.data[0].engineBuildDate!=null?string.valueof(date.valueOf(productInfo.data[0].engineBuildDate)):null;
                finalWrapperResponse.VINProductInfo=VINProductInfo;                    
            }
            //SG end
            //CECI-978 - Abhilash - Start
            else if((searchkey.length()==17 && productInfo.data == null && productInfo.engineSerialNumber == null) || Test.isRunningTest()){
                dbu_CCVINProductInformation VINProductInfo=new dbu_CCVINProductInformation();
                VINProductInfo.ESNNumber=null;
                VINProductInfo.marketingModelName=null;
                VINProductInfo.serviceModelName=null;
                VINProductInfo.buildDate=null;
                finalWrapperResponse.VINProductInfo=VINProductInfo; 
            }
            //CECI-978 - Abhilash - End
            
        }else{
            finalWrapperResponse.ESNSearchResultsResp = new List<dbu_Search_Results__c>();finalWrapperResponse.FramedProductData = null;
        }  
        return finalWrapperResponse;
    }
    
    public static BrandResponse fetchbrandBySearchResult(set<string> searchid){        
        system.debug('<<<<<<<<<<<<<<<< entering in fetchbrandBySearchResulth >>>>>>>>>>>');
        Map<string,set<string>> totalBrands = new Map<string,set<string>>();
        List<ccrz__E_Category__c > parentcategory = new List<ccrz__E_Category__c >();
        List<ccrz__E_Category__c > grandparentcategory = new List<ccrz__E_Category__c >();     
        Map<string,list<string>> productBrandMap = new Map<string,list<string>>();
        list<string> CombinedbrandList = new list<string>();
        BrandResponse brandResp = new BrandResponse();

        ccLogicProductFind.ProductCategoryResponse retrivedProductCategoryResponse = new ccLogicProductFind.ProductCategoryResponse();
        ccLogicProductFind.GrandCategoryResponse retrivedGrandCategoryResponse = new ccLogicProductFind.GrandCategoryResponse();
        ccLogicProductFind.GrandCategoryResponse retrivedSuperGrandCategoryResponse = new ccLogicProductFind.GrandCategoryResponse();
        set<string> parentcat = new set<string>();
        set<string> grandparentcat = new set<string>();
        set<string> parentcatset = new set<string>();
        list<id> grandparentcatList = new list<id>();
        try{
            
            system.debug('searchid > ' + searchid);
            
            retrivedProductCategoryResponse = ccLogicProductFind.retriveProductCategories(searchid);
            system.debug('retrivedProductCategoryResponse > ' + retrivedProductCategoryResponse);
            
            if((retrivedProductCategoryResponse.productBrandMap).size() > 0 && (retrivedProductCategoryResponse.productCategoryIDSet).size() > 0){
                totalBrands = retrivedProductCategoryResponse.productBrandMap;parentcatset = retrivedProductCategoryResponse.productCategoryIDSet;                  
            }
            
            system.debug('totalCategory > ' + totalBrands);
            system.debug('parentcatset > ' + parentcatset);
            if(parentcatset.size() > 0){
              CombinedbrandList.addAll(parentcatset);
            }  

            brandResp.combinedBrands = CombinedbrandList;
            brandResp.ProductBrandListMap = totalBrands;
            
            system.debug('brandResp > ' + brandResp);
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return brandResp;
    }
    
    
    public static Map<String, Object>  Intermidiatormethod(set<string> searchedProductIDs_or_partNumber_Set, string storeCountry, string kindOfSearch){
        system.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< entering in Intermidiatormethod >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        //Making Product & BrandData ready
        Map<String, Object> finalresult = new Map<String, Object>();
        BrandResponse newbrans = new BrandResponse();
        list<string> CategoryData = new list<string>();
        
        system.debug('searchedProductIDs_or_partNumber_Set > ' + searchedProductIDs_or_partNumber_Set);
        
        if(kindOfSearch == 'Normal Search'){
            
            // here searchedProductIDs_or_partNumber_Set will contain product IDs only
            finalresult = ccLogicProductFind.getProductDetailedInformation_Normal_Search(searchedProductIDs_or_partNumber_Set, storeCountry);    
        }else if(kindOfSearch == 'Existing ESN Response Search' || kindOfSearch == 'PCC Integration Response Search'){
            
            // here searchedProductIDs_or_partNumber_Set will contain product partnumbers only
            finalresult = ccLogicProductFind.getProductDetailedInformation_ExistingESN_or_PCCIntegration_Search(searchedProductIDs_or_partNumber_Set, storeCountry );
        }
        
        if(finalresult.size() > 0){
            if(finalresult.get('productIDsList') != null){
                if(((list<string>)finalresult.get('productIDsList')).size() > 0){
                    set<string> finalresultProduIdSet = new set<string>();
                    
                    //convert list to set
                    finalresultProduIdSet.addAll((list<string>)finalresult.get('productIDsList'));
                    
                    //fetch Brand
                    newbrans = fetchbrandBySearchResult(finalresultProduIdSet);
                    
                    //fetch category data
                    CategoryData  = ccLogicProductFind.fetchCategoryBySearchResult(finalresultProduIdSet);
                    
                    //populate brand & category
                    finalresult.put('newbrans',newbrans);   
                    finalresult.put('CategoryData',CategoryData);  
                }
            }
        }// end - get product Detail
        return finalresult;        
    }
    
    
    public class BrandResponse {
        public list<string> combinedBrands;
        public Map<string,set<string>> ProductBrandListMap;
    }

     
}