public class CSS_WWSPSCertificationInfo {
       public static string receiveToken(){
      
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        string endPoint;
        string client_id;
        string client_secret;
        if(!Test.isRunningTest()){
            CSS_Integration_Details__c recIntDetails = new CSS_Integration_Details__c();
            recIntDetails = CSS_getConnnectionDetails.getConnection('OAGOAuth');
            endPoint = recIntDetails.End_Point__c; 
            client_id = recIntDetails.Username__c;   
            client_secret = recIntDetails.Passcode__c;
        }
        else{
            endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            client_id = 'bcccb3b1-e95b-464a-8589-b7ed6876793d';
            client_secret = 'adca726b-0c5e-4bde-ab8b-2b44a91c2d22';
        }
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
       
        HttpResponse res = http.send(req);
        
        string jSONRequestBody = res.getBody();
        CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
        string accessToken = wo1.access_token;
        System.debug('BODY: '+res.getBody());  
        System.debug('Status: '+res.getStatus());
        System.debug('Status Code: '+res.getStatusCode());
        return accessToken;
           
    }
    @future(Callout=true) // Sai:11/15/2016 : Added the future callout parameter as this is being called from scheduler.
    public static void processWWSPS(){
        List<Account> listAcc = new List<Account>();

         if(!Test.isRunningTest()){
                     listAcc=[select id,name,CSS_DBCode__c, CSS_DistributorCode__c, CSS_DealerCode__c, Location__c
                                from Account where Type IN ('Distributor Account','Dealer Account')];
        }
        else
        {
           		 	listAcc=[select id,name,CSS_DBCode__c, CSS_DistributorCode__c, CSS_DealerCode__c, Location__c
                                from Account where Type IN ('Distributor Account','Dealer Account') Limit 1]; 
        }
        
        system.debug('listAcc' + listAcc);
        if (listAcc.size()>0){
            generateWWSPSReq(listAcc);    
        }
        
    }
    
    public static void generateWWSPSReq(list<Account> listAcc){
        string cInfoRequest = '';
        string jSONResponseBody = '';
        try{
            string accessToken=receiveToken();
            String DistributorCode = '';
            String sCode;
            for(Account acc: listAcc){
                sCode='';
                if (acc.Location__c !='') {
                    sCode = acc.Location__c.substring(acc.Location__c.indexOf('-')+1,acc.Location__c.length());
                    DistributorCode = DistributorCode + '\"' + sCode + '\"' + ','; 
                }
            } 
            DistributorCode = DistributorCode.substringBeforeLast(',');
            string sBusinessUnit = '1';
            
            HttpRequest req = new HttpRequest();
            if(!Test.isRunningTest()){
                CSS_Integration_Details__c recIntDetails = new CSS_Integration_Details__c();
                recIntDetails = CSS_getConnnectionDetails.getConnection('WWSPS');
                req.setEndpoint(recIntDetails.End_Point__c);
            }
            else{
                req.setEndpoint('https://services-dev.cummins.com/css/getproductcertifications');
            }
            
            system.debug('accessToken' + accessToken);
            req.setTimeout(10000); // Sai:11/14/2016 Added for 74076.
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            //Request Creation :
            cInfoRequest= '{"Header":{"Sender":{"MessageID": "unique message ID at SF","SenderID": "SF","ServiceName": "ServiceRequest"},"Target":{"TargetID":"WWSPS"}},';
            cInfoRequest= cInfoRequest + '"DataArea":  { "DistributorCode": ['+DistributorCode+'], "BusinessUnit": "' + sBusinessUnit +'"}  } ';

            System.debug('The cInfoRequest is***'+ cInfoRequest );
            req.setBody(cInfoRequest);
            req.setMethod('POST');
            
            Http http = new Http(); 
            
            HTTPResponse res = http.send(req);
            jSONResponseBody = res.getBody();
            system.debug('Response=' + jSONResponseBody);
            if(jSONResponseBody.contains('ERROR')){
                System.debug('Incorrect json format');
                System.debug('BODY: '+res.getBody());
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                css_utility.LogOutIntError(cInfoRequest, 'CSS Error:' + res.getStatusCode(),jSONResponseBody,'WWSPS');
            } else if(jSONResponseBody.contains('DEVELOPMENT MESSAGE')) {
                css_utility.LogOutIntError(cInfoRequest, 'CSS Error:' + 'External Token Error',jSONResponseBody,'WWSPS');
            } else {
                // Success
                System.debug('BODY: '+res.getBody());
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                system.debug('*********9123#######');
                //parsing the json response :-
                jSONResponseBody = jSONResponseBody.replace(',{"ServiceModel":"DUMMY"}', '');
                //jSONResponseBody = jSONResponseBody.replace('{"ProductCertifications":{', '{"ProductCertifications":[{');
                //jSONResponseBody = jSONResponseBody.replace('}},"Header":', '}]},"Header":');
                system.debug('After Replace Function=' + jSONResponseBody);
                CSS_JSON2ApexWWSPS obj = CSS_JSON2ApexWWSPS.parse(jSONResponseBody);
                system.debug('obj*****>>'+obj);
                //Upserting the data to the CSS_Accreditation__c from the parsed Json response 
                upsertWWSPSResp(Obj);
            }
        }
        catch(exception e){
            system.debug('error*******'+e.getMessage());
            css_utility.LogOutIntError(cInfoRequest, 'CSS Error:' + e.getMessage(),jSONResponseBody,'WWSPS');
        }
       
    }
    public static void  upsertWWSPSResp(CSS_JSON2ApexWWSPS prsdObj){
        //list to store the Service Provider code 
        list<string> lstSPCode = new list<string>();
        //list to store service model name 
        list<string> lstServiceModelName = new list<string>();
        //adding all code from the parsed response to the list 
        String sCodeFrmJSON = '';
        for(integer i=0 ;i<prsdObj.DataArea.ProductCertifications.size();i++){
            sCodeFrmJSON = string.valueOf(prsdObj.DataArea.ProductCertifications[i].DistributorCode);
            while (sCodeFrmJSON.length()<5) { sCodeFrmJSON = '0' + sCodeFrmJSON; }
            lstSPCode.add(sCodeFrmJSON);
            for(CSS_JSON2ApexWWSPS.ProductDetails prod : prsdObj.DataArea.ProductCertifications[i].ProductDetails ){
                lstServiceModelName.add(prod.ServiceModel);
            }
        }
        system.debug('lstSPCode ## ' + lstSPCode);
        //query accounts to update the respose values 
        list<Account> lstAccounts=[SELECT WWSPS_Cert_Expiry_Date__c,WWSPS_Profile_Status__c,CSS_DistributorCode__c,
                                   CSS_DBCode__c,CSS_DealerCode__c,WR_WWSPS_Cert_Date__c,WR_Certfication_Flag__c FROM Account
                                   WHERE Type IN ('Distributor Account','Dealer Account')
                                   AND (CSS_DBCode__c IN :lstSPCode OR CSS_DealerCode__c IN :lstSPCode)];
        system.debug('lstAccounts ## ' + lstAccounts);
        map<string,Id> mapCodeToAccount =new map<string,Id>();
        //populating map<Code,Account Record>
        for(Account acc : lstAccounts){
            if (acc.CSS_DBCode__c != '' && acc.CSS_DBCode__c != null){
                mapCodeToAccount.put(acc.CSS_DBCode__c, acc.Id);
            }
            if (acc.CSS_DealerCode__c != '' && acc.CSS_DealerCode__c != null){
                mapCodeToAccount.put(acc.CSS_DealerCode__c, acc.Id);
            }
        }
        system.debug('mapCodeToAccount ## ' + mapCodeToAccount);
        //List to update the Account 
        list<Account> lstUpsertAccount = new list<Account>();
        //populating the response data for the Account
        for(CSS_JSON2ApexWWSPS.ProductCertifications data : prsdObj.DataArea.ProductCertifications){
            Account accnt = new Account();
			sCodeFrmJSON = string.valueOf(data.DistributorCode);
            while (sCodeFrmJSON.length()<5) { sCodeFrmJSON = '0' + sCodeFrmJSON; }
            //system.debug('string.valueOf(data.DistributorCode) ## ' + sCodeFrmJSON);
            accnt.Id = mapCodeToAccount.get(sCodeFrmJSON);
            if(data.CertificationExpiryDate==null || data.CertificationExpiryDate==''){
            }else{
            Date dt = Date.valueOf(data.CertificationExpiryDate);
                accnt.WWSPS_Cert_Expiry_Date__c=dt;
            }
            Date certDt;
            if(data.CerificationDate==null || data.CerificationDate==''){
            }
            else{
            certDt = Date.valueOf(data.CerificationDate);
            accnt.WR_WWSPS_Cert_Date__c = certDt;    
            }
            accnt.WWSPS_Profile_Status__c =data.ProfileStatus;
            if(data.CerificationFlag!=null){
            accnt.WR_Certfication_Flag__c = data.CerificationFlag;
            }
            //system.debug('accnt=' + accnt);
            lstUpsertAccount.add(accnt);
        }
        
        Set<Account> mysetAcc = new Set<Account>();
        List<Account> resultAcc = new List<Account>();
        mysetAcc.addAll(lstUpsertAccount);
        resultAcc.addAll(mysetAcc);
        // Create the CSS_Accreditation__c records for Upsert
        String accId;
        list<CSS_Accreditation__c> lstUpsertAccred =new list<CSS_Accreditation__c>();
        Map<String,List<String>> mapAccredQualProgIds = new Map<String,List<String>>();
        for(integer i=0 ;i<prsdObj.DataArea.ProductCertifications.size();i++){
            //system.debug('1****>>');
            sCodeFrmJSON = string.valueOf(prsdObj.DataArea.ProductCertifications[i].DistributorCode);
            while (sCodeFrmJSON.length()<5) { sCodeFrmJSON = '0' + sCodeFrmJSON; }
            accId = mapCodeToAccount.get(sCodeFrmJSON);
            for(CSS_JSON2ApexWWSPS.ProductDetails prod : prsdObj.DataArea.ProductCertifications[i].ProductDetails ){
                //system.debug('2****>>');
                if(prod.ServiceModel != '' && accId !='' ){
                    //system.debug('3****>>');                    
                    CSS_Accreditation__c accredt =new CSS_Accreditation__c();
                    accredt.Name=prod.ServiceModel + '-'+ accId;
                    accredt.Service_Model_Name__c = prod.ServiceModel;
                    accredt.Account__c=accId;
                    accredt.Certification_Status__c = prod.ProductCertificationStatus;
                    //system.debug ('Name ## ' + accredt.Name);
                    //system.debug ('Service_Model_Name__c ## ' + accredt.Service_Model_Name__c);
                    //system.debug ('Account__c ## ' + accredt.Account__c);
                    //system.debug ('Certification_Status__c ## ' + accredt.Certification_Status__c);
                    if (accredt.Service_Model_Name__c !='DUMMY') {
                        //system.debug ('prod.TechIDs.TechID ## ' +prod.TechIDs.TechID);
                        if (prod.TechIDs != null &&!prod.TechIDs.TechID.isEmpty()) {
                            mapAccredQualProgIds.put(prod.ServiceModel + '-'+ accId, prod.TechIDs.TechID);
                            accredt.QUAL_PROG_ID__c= getCommaSpratedSTR(prod.TechIDs.TechID);
                        }
                    }
                    //system.debug ('QUAL_PROG_ID__c ## ' +accredt.QUAL_PROG_ID__c);
                    if (accredt.Service_Model_Name__c !='DUMMY') {
                        lstUpsertAccred.add(accredt);
                    }
                    //system.debug ('after  lstUpsertAccred add');
                }
            }
        }
        //system.debug ('lstUpsertAccred ## ' +lstUpsertAccred);
        //Update Account
        if(!resultAcc.isEmpty()){
            update resultAcc;
        } 
        //Upsert CSS_Accreditation__c
        if (!lstUpsertAccred.isEmpty()) {
            Map<String,CSS_Accreditation__c> mapUniqAccred = new Map<String,CSS_Accreditation__c>();

            Integer intRecCnt;
            for (CSS_Accreditation__c recDupAccred1: lstUpsertAccred) {
				mapUniqAccred.put(recDupAccred1.Name, recDupAccred1);
            }
            upsert mapUniqAccred.values() Name;
            system.debug('mapUniqAccred: '+mapUniqAccred);
            Map<String,CSS_AccredUser__c> mapUniqAccredUser = new Map<String,CSS_AccredUser__c>();
            for(String accredName:mapUniqAccred.keySet()){
                if(!mapAccredQualProgIds.isEmpty() && mapAccredQualProgIds.containsKey(accredName)){
                    for(String QualProgId:mapAccredQualProgIds.get(accredName)){
                        If(QualProgId != null && QualProgId != 'DUMMY') {
                            CSS_Accreditation__c accred = mapUniqAccred.get(accredName);
                            CSS_AccredUser__c accredUser = new CSS_AccredUser__c();
                            accredUser.Accreditation__c = accred.Id;                        
                            accredUser.Qual_Prog_Id__c = QualProgId;
                            accredUser.Name = 'Accred User'+' '+accred.Id+' '+QualProgId;
                            mapUniqAccredUser.put(accredUser.Name,accredUser);
                        }
                    }
                }
            }
            
            upsert mapUniqAccredUser.values() Name;
            system.debug('mapUniqAccredUser: '+mapUniqAccredUser);
        }
    }
    //method to concatenate string with comma separated if list of string is provided 
    public static string getCommaSpratedSTR(list<string> lstString){
        String finalStr = '';
        for(String str : lstString){
            finalStr = finalStr + str + ',' ; 
            
        } 
        finalStr = finalStr.substringBeforeLast(',');
        finalStr = finalStr.replace('DUMMY,','');
        finalStr = finalStr.replace(',DUMMY','');
		finalStr = finalStr.replace('DUMMY','');
        return finalStr;
    }
    
     
}