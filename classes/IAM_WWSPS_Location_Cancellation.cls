/*1) Engines, 2) Power Generation, 3) Turbochargers, and 4) Filtration. 5) ALL*/

public class IAM_WWSPS_Location_Cancellation {
    
    Public Static String cancelLocation(IAM_WWSPS_Location_Parser.locationInfo location){
        String returnString='';
        
           
        //Checking Business Unit field to identityfy which action need to be performed.
        //Either EBU channel of Distribution process
        //PSBU Channel of Distribution process
        //All Location Process.
        
        //querying Account record to pass it in respective methods.
        List<Account> acntToCancel=IAM_WWSPS_Utility.getWWSPSLocationAccountDetails(location.SPcode);
        
        if(!acntToCancel.isEmpty()){
            if(location.Buss_entity_name.equalsIgnoreCase('Engines')){
                //follow Engine Business Process.
                returnString=engineBusinessCancellation(acntToCancel[0]);
            }else if(location.Buss_entity_name.equalsIgnoreCase('Power Generation')){
                //follow Power Gen Process.
                System.debug('Entered power gen cancellation');
                returnString=powerGenCancellation(acntToCancel[0]);
            }else if(location.Buss_entity_name.equalsIgnoreCase('Turbochargers')){
                //for Turbo Chargers
                returnString=turboChargerCancellation(acntToCancel[0]);
                
            }else if(location.Buss_entity_name.equalsIgnoreCase('Filtration')){
                //filtration
                  returnString=filtrationCancellation(acntToCancel[0]); 
            }else if(location.Buss_entity_name.equalsIgnoreCase('All')){
                //follow entire location Cancellation
                returnString=cancelEntireLocation(acntToCancel[0]);
            }
        }else{
            returnString='Location not present in IAM';
        }
        return returnString;
    } 
    
    //Method for Turbo cancellation
    Public Static String turboChargerCancellation(Account acnt){
      //since we do not have any specific  Subscriptions we just need to make sure
      //we need to empty filtration COD field on Account.
      return cancelAccount('Turbochargers',acnt);
        
    }
    
    //Method for Turbo cancellation
    Public Static String filtrationCancellation(Account acnt){
      //since we do not have any specific  Subscriptions we just need to make sure
      //we need to empty filtration COD field on Account.
      return cancelAccount('Filtration',acnt);
        
    }
    
    
    
    //Method for power gen cancellation
    Public Static String powerGenCancellation(Account acnt){
        String returnValue='';
        
        //get all the subscriptions with Name as QuickServe Online PGBU.
        List<IAM_Application__c> appsPGBU=IAM_WWSPS_Utility.getAccountFeatureAndAccess(acnt.id,'QuickServe Online CPG');
        system.debug('Printing app records returned'+appsPGBU);
        if(!appsPGBU.isEmpty()){
            //if apps not empty then change the status of the records to InActive.
            //if we change account access features status, User access will get inactive and Contact gets updated and 
            //user permission set will be removed and user will get updated.
           String valueFromDeactivate=IAM_WWSPS_Utility.changeStatusToInactive(appsPGBU);
            //Once account access and features gets deactivated we also need to make sure that COD value on the account to be removed.
            
            if(valueFromDeactivate.containsIgnoreCase('Records Inactivated')){
                //calling method to update the account.
                returnValue=cancelAccount('Power Generation',acnt);
            }
        }else{
            //Since no PGBU subscriptions are  Present.
            returnValue=cancelAccount('Power Generation',acnt);
        }        
        return returnValue;
    }

    
    Public Static String engineBusinessCancellation(Account acnt){
        String returnValue='';
        
        //get all the subscriptions with Name as QuickServe Online EBU.
        List<IAM_Application__c> appsEBU=IAM_WWSPS_Utility.getAccountFeatureAndAccess(acnt.id,'QuickServe Online EBU');
        system.debug('Printing app records returned'+appsEBU);
        if(!appsEBU.isEmpty()){
            
            String valueFromDeactivate=IAM_WWSPS_Utility.changeStatusToInactive(appsEBU);
            //Once account access and features gets deactivated we also need to make sure that COD value on the account to be removed.
            
            if(valueFromDeactivate.containsIgnoreCase('Records Inactivated')){
                returnValue=cancelAccount('Engines',acnt);
            }   
        }else{
              returnValue=cancelAccount('Engines',acnt);
        }
        System.debug('Retrun value from EBU cancellation Method'+returnValue);
        return returnValue;
    }
    

    //Common method to pass Bu and then call cancellation account method.
    Public Static String cancelAccount(String BusinessUnit,Account acnt){
        String returnValue='';
        String valueFromAccountUpdate=IAM_WWSPS_Utility.updateAccount(acnt,BusinessUnit,'Cancelled');
        if(valueFromAccountUpdate.equalsIgnoreCase('Records Inactivated')){
            returnValue='Location Cancelled for '+BusinessUnit;
        }
        System.debug('Return value from cancel Account method'+returnValue);
       return returnValue; 
    }    
    
    /*Below Method is used to Cancel the Entire location.
     * Get all applications,Check if there is DA,RLS applications.
     * If above applications are present then change the type of the location.
     * get the uniwue number for customer, appened it with C-. since we have Process builder 
     *it should take care.Also change the account owner to IAM default and record type to IAM. 
     *if above applications are not present then update the record type,owner so no one sees the applications
    */
    Public Static String cancelEntireLocation(Account acnt){
        String returnValue='';
        List<IAM_Application__c> appsToCancel=new List<IAM_Application__c>();
        List<IAM_Application__c> appsToBeActive= new List<IAM_Application__c>();
        //get all Subscriptions and Inactivate them.
        List<IAM_Application__c> appsALL=IAM_WWSPS_Utility.getAccountFeatureAndAccess(acnt.id,'All');
        system.debug('Printing app records returned'+appsALL);
        if(!appsALL.isEmpty()){
            
            //Loop through apps and check if above apps are present.
            Map<id,IAM_Application__c> allAppsMap=new Map<id,IAM_Application__c>();
            List<String> appNames= new List<String>();
            for(IAM_Application__c app:appsAll){
                allAppsMap.put(app.id,app);
                appNames.add(app.IAM_Application_Name__c);   
            }
            System.debug('Application Names to deactivate'+appNames);
            System.debug('Application Names to deactivate Map'+allAppsMap);
            
            List<String> appsNotToCancel= System.Label.IAM_Apps_Not_To_Cancel.Split(';');
            System.debug('Printing apps not to deactivate'+appsNotToCancel);
            
            //comparing all the app names to seperate which apps need to be deactivated.
            for(id ids:allAppsMap.KeySet()){
                if(!appsNotToCancel.Contains(allAppsMap.get(ids).IAM_Application_Name__c)){
                    //add to list which should be cancelled.
                    appsToCancel.add(allAppsMap.get(ids));
                }else{
                    appsToBeActive.add(allAppsMap.get(ids));
                }
            }
            
            System.debug('Printing apps  to deactivate'+appsToCancel);
            System.debug('Printing apps to be active '+appsToBeActive);
            if(!appsToBeActive.isEmpty()){
                //Since Free apps are there just make the necessary changes.Do not move user.
                
                //check if paid apps are presnt and cancel them.
                if(!appsToCancel.isEmpty()){
                    //calling apps method to cancel the apps.
                    String valueFromDeactivate=IAM_WWSPS_Utility.changeStatusToInactive(appsToCancel);
                    System.debug('Checking if apps To Canel got deactivated or not'+valueFromDeactivate);
                }
                
                //calling account method to make necessary changes
                returnValue=cancelAccount('All',acnt);
                   
            }else{
                //Since there are no DA and RLS apps.Cancell the entire account and move user to Default location.
                String valueFromDeactivate=IAM_WWSPS_Utility.changeStatusToInactive(appsALL);
                if(valueFromDeactivate.containsIgnoreCase('Records Inactivated')){
                    returnValue=IAM_WWSPS_Utility.cancelEntireLocation(acnt);
                 }                  
            }           
        }else{
            //update the account status,owner empty fields and change the record type as well and Move any users to the default location.
            returnValue=IAM_WWSPS_Utility.cancelEntireLocation(acnt);
        }
        return returnValue;
    }
}