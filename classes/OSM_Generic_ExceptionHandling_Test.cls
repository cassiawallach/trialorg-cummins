@isTest
public class OSM_Generic_ExceptionHandling_Test {

    static testMethod void OSM_Generic_ExceptionHandling(){
        
        OSM_Generic_ExceptionHandling excpObj = new OSM_Generic_ExceptionHandling();
        excpObj.errorMessage = 'unexpected Response';
        excpObj.exceptionFlag = true;
    }
}