/************************************************************
Name:  IAM_Reclaim_LDAP_CallOut_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex Class to make call to ldap to Authenticate user.Added Authorization Token                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020    Made Changes to the class for Mule API Conversion     
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_Reclaim_LDAP_CallOut_Test{

    static testMethod Void testMethod1(){
     IAM_TestData.createIntegrationDetails('IAM_LDAP_Authenticate_Mule');   
     IAM_Reclaim_LDAP_CallOut.authentication('oh611@gmail.com','Cummins1');
    
    }
    
    
     static testMethod Void testMethod2(){
    IAM_TestData.createIntegrationDetails('IAM_LDAP_Authenticate_Mule');
     IAM_Reclaim_LDAP_CallOut.authentication('','');
    
    }
 }