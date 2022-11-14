/************************************************************
Name:  IAM_Mule_oAuth_Access_Token_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is class for IAM_Mule_oAuth_Access_Token class.This class is used for generating 
Access Token for Mule Services    2                     
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2020        INITIAL DEVELOPMENT          
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
Private Class IAM_Mule_oAuth_Access_Token_Test{

    Static TestMethod void testMethod1(){
        IAM_TestData.createIntegrationDetails('IAM_Mule_oAuth');
        IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
    }
}