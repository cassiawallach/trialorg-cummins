/*
 * Block comments with details of changes
 */
@isTest
public class CG_BL_Intake_Test
{
    @testsetup
    static void testdata()
    {
        Account acc = new Account();
           acc.name='Gopal';
           acc.CSS_DistributorCode__c='56270';
           acc.IAM_Service_Provider_Code__c='56270';
           acc.IAM_Service_Provider_Code__c = '56270';
           acc.Type = 'Customer';
           acc.IAM_Service_Provider_Code__c = '56270';
           acc.CMI_Account_Status__c = 'Active';
          
            insert acc; 
        css_jobeventTemporary__c JT = new css_jobeventTemporary__c();
        JT.attribute1__C = 'ApplicationCodes';
        JT.Reason__c = '{"DataArea":{"Details":[{"Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"120","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"130","MarineFlag":"N","DefaultUom":""},{"Description":"BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"200","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"210","MarineFlag":"N","DefaultUom":""},{"Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"220","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"300","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"400","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"410","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"420","MarineFlag":"N","DefaultUom":""},{"Description":"INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"500","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"600","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"605","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"610","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"620","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"625","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"645","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"650","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"655","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"665","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"700","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"710","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"720","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"800","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"810","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (OTHER THAN STANDBY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"820","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"830","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"840","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"900","MarineFlag":"N","DefaultUom":""},{"Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"910","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"920","MarineFlag":"N","DefaultUom":""},{"Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"930","MarineFlag":"N","DefaultUom":""},{"Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"940","MarineFlag":"N","DefaultUom":""},{"Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"950","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"960","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"10","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"11","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"12","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"13","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"20","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"21","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"22","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"23","MarineFlag":"N","DefaultUom":""},{"Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"30","MarineFlag":"N","DefaultUom":""},{"Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"31","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"40","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"41","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"42","MarineFlag":"N","DefaultUom":""},{"Description":"0INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"50","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"51","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"60","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"61","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"62","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"63","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"64","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"65","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"66","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"70","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"71","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"72","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"80","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"81","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"82","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"83","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"84","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"90","MarineFlag":"N","DefaultUom":""},{"Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"91","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"92","MarineFlag":"N","DefaultUom":""},{"Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"93","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"94","MarineFlag":"N","DefaultUom":""},{"Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"95","MarineFlag":"N","DefaultUom":""},{"Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"96","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"100","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"110","MarineFlag":"N","DefaultUom":""},{"Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"230","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"310","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"510","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"635","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"660","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"FORD GRAY AUTO","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"140","MarineFlag":"N","DefaultUom":""},{"Description":"FORD GRAY BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"240","MarineFlag":"N","DefaultUom":""},{"Description":"ISC-SERIES","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"150","MarineFlag":"N","DefaultUom":""},{"Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"621","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"651","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"656","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"661","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"320","MarineFlag":"N","DefaultUom":""},{"Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"890","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"670","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"675","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"680","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"685","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"690","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"695","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"891","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"520","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR (WORLDWIDE HHP LEAN-BURN GAS)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"850","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"250","MarineFlag":"N","DefaultUom":""},{"Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"699","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"662","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"663","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"530","MarineFlag":"N","DefaultUom":"Hours"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
insert JT;
        
        
    }
    static  testMethod void CG_BL_Intake_TestMethod1() {
        
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
    Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.startTest();
        CG_BL_Intake BLIntake = new CG_BL_Intake();
        CSS_CountryStateValues__c countryval = new CSS_CountryStateValues__c();
        countryval.CountryName__c = 'India';
        countryval.CountryCode__c = 'India';
        countryval.StateCode__c = 'AS';
        countryval.StateName__c = 'Assam';
        countryval.Name = 'Test';
        insert countryval;
        //Added new methods
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Guidanz').getRecordTypeId();
        
         Account acc = new Account();
           acc.name='Ridhima1';
           acc.CSS_DistributorCode__c='56270';
           acc.IAM_Service_Provider_Code__c='999';
           acc.CMI_Account_Status__c = 'Active';
           acc.RecordTypeId =recordTypeId;
           acc.Type = 'Customer';
           insert acc;
        
        system.debug('acc '+acc);
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        css_jobeventTemporary__c JT = new css_jobeventTemporary__c();
        JT.attribute1__C = 'ApplicationCodes';
        JT.Reason__c = '{"DataArea":{"Details":[{"Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"120","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"130","MarineFlag":"N","DefaultUom":""},{"Description":"BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"200","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"210","MarineFlag":"N","DefaultUom":""},{"Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"220","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"300","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"400","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"410","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"420","MarineFlag":"N","DefaultUom":""},{"Description":"INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"500","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"600","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"605","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"610","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"620","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"625","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"645","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"650","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"655","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"665","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"700","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"710","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"720","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"800","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"810","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (OTHER THAN STANDBY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"820","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"830","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"840","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"900","MarineFlag":"N","DefaultUom":""},{"Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"910","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"920","MarineFlag":"N","DefaultUom":""},{"Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"930","MarineFlag":"N","DefaultUom":""},{"Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"940","MarineFlag":"N","DefaultUom":""},{"Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"950","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"960","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"10","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"11","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"12","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"13","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"20","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"21","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"22","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"23","MarineFlag":"N","DefaultUom":""},{"Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"30","MarineFlag":"N","DefaultUom":""},{"Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"31","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"40","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"41","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"42","MarineFlag":"N","DefaultUom":""},{"Description":"0INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"50","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"51","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"60","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"61","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"62","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"63","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"64","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"65","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"66","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"70","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"71","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"72","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"80","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"81","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"82","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"83","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"84","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"90","MarineFlag":"N","DefaultUom":""},{"Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"91","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"92","MarineFlag":"N","DefaultUom":""},{"Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"93","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"94","MarineFlag":"N","DefaultUom":""},{"Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"95","MarineFlag":"N","DefaultUom":""},{"Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"96","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"100","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"110","MarineFlag":"N","DefaultUom":""},{"Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"230","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"310","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"510","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"635","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"660","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"FORD GRAY AUTO","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"140","MarineFlag":"N","DefaultUom":""},{"Description":"FORD GRAY BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"240","MarineFlag":"N","DefaultUom":""},{"Description":"ISC-SERIES","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"150","MarineFlag":"N","DefaultUom":""},{"Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"621","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"651","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"656","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"661","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"320","MarineFlag":"N","DefaultUom":""},{"Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"890","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"670","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"675","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"680","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"685","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"690","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"695","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"891","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"520","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR (WORLDWIDE HHP LEAN-BURN GAS)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"850","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"250","MarineFlag":"N","DefaultUom":""},{"Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"699","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"662","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"663","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"530","MarineFlag":"N","DefaultUom":"Hours"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
insert JT;
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56270');
            insert u;
      CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'TestKal';
       JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Ridhima test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = 'abc';
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      JO.Shop_Work_Order__c = '120';
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      Jo.Assigned_To__c = u.id;
      Jo.esn__c = '79464646';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
      Jo.OwnerId = u.Id;
       // JO.GetEngineDataPlateQSOL = null;
      JO.Notes__c = 'notessss';
      insert(JO);
       
         system.debug('------Testing---' +JO);
         list<CSS_UserLocation__c> lstuloc = new list<CSS_UserLocation__c>();
    system.runAs(u){
               CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        insert userLocation;
        
        lstuloc.add(userLocation);
        CG_BL_Intake.selectedLocation(lstuloc);
        List<SelectOption> lstOpt = BLIntake.fetchLocationName(lstuloc);
        user usr=css_utility.getUserAttributes(Userinfo.getUserId());
        system.debug('user '+usr);
        Map<string,String> MapCertStat = CG_BL_Intake.getCertificationStatus(JO.Service_Model__c);
    }
        CG_BL_Intake.cancel(JO,JO);
        
        List<css_solution_component__c> solCompCTTP = new List<css_solution_component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c = 'Approved';
            solComp.Complete_Indicator__c = True;
            solcomp.Multiple_Times__c = True;
       // solcomp.GetEngineDataPlateQSOL = '';
        insert solComp;
        solCompCTTP.add(solComp);
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
            ctt.Type__c = 'ATC';
            ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt.Doc_Num__c = 'ATCF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
            ctt.Reviewed__c = false;
            ctt.Job_Order__c = JO.Id;
            ctt.ESN__c = JO.ESN__c;
        ctt.cu_language__C = 'fr';
            insert ctt;
  
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Type__c = 'CAM';
            ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt1.Doc_Num__c = 'CF0051000';
            ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt1.Performed__c = false;
            ctt1.Performed_Review__c = true;
            ctt1.Reviewed__c = false;
            ctt1.Job_Order__c = JO.Id;
            ctt1.ESN__c = JO.ESN__c;
        ctt1.cu_language__C = 'fr';
            insert ctt1;

        system.debug('---ctttest--' +ctt1);
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
            ctt2.Type__c = 'TRP';
            ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt2.Doc_Num__c = 'TF0051000';
            ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt2.Performed__c = false;
            ctt2.Performed_Review__c = true;
            ctt2.Reviewed__c = false;
            ctt2.Job_Order__c = JO.Id;
            ctt2.ESN__c = JO.ESN__c;
        ctt2.cu_language__C = 'fr';
        insert ctt2;
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
            ctt3.Type__c = 'TSB';
            ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt3.Doc_Num__c = 'TF0051000';
            ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt3.Performed__c = false;
            ctt3.Performed_Review__c = true;
            ctt3.Reviewed__c = false;
            ctt3.Job_Order__c = JO.Id;
            ctt3.ESN__c = JO.ESN__c;
        insert ctt3;
        lstQSOLDocs.add(ctt3);
        lstQSOLDocs.add(ctt);
        lstQSOLDocs.add(ctt1);
        lstQSOLDocs.add(ctt2);
        lstCAM.add(ctt1);
        lstCAM.add(ctt2);
        lstCAM.add(ctt3);
        lstTRP.add(ctt2);
        lstATC.add(ctt);
        
        CG_BL_Intake.fetchUserLocation(JO.id, 'creatorLocation');
        lstuloc = CG_BL_intake.fetchMultiLocation();
                
        List<SelectOption> lstoptsub = CG_BL_Intake.getSubType(JO.id, '03520-04892');
        List<SelectOption> lstunit = CG_BL_Intake.getUnitType(JO.id, 'creatorLocation');
        List<SelectOption> lstOpt1 = BLIntake.getCountry();
        List<SelectOption> lstApp = CG_BL_Intake.getApplication();
        List<SelectOption> lstStates = BLIntake.getStates('India'); 
        Date mdate = CG_BL_Intake.parseQSOLDate('04 05 2017');
        CSS_TestData.createAccountLanguage(true);
        CSS_TestData.createIntegrationDetails(true);
 
      // Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        List<List<CSS_CampTsbTrp__c>> lstQDocs = CG_BL_Intake.getQSOLDocs(JO.id, JO.esn__c,'en');
       // Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        
        List<List<CSS_CampTsbTrp__c>> lstCamp = CG_BL_Intake.getCampaigns(JO.esn__c, JO.Service_Model__c,JO.Failure_Date__c, 'en',JO.id);
        List<List<CSS_CampTsbTrp__c>> lstSQDocs = CG_BL_Intake.getSiebelQSOLCampaigns(JO.id, JO.esn__c,'en',JO.Service_Model__c,JO.Failure_Date__c);
        List<List<CSS_CampTsbTrp__c>> llstQLinks = CG_BL_Intake.addQSOLLinksToSiebelData(JO.id,solCompCTTP,lstCAM,lstTRP,lstATC);
        List<css_solution_component__c> lstquery = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);    
        //List<List<CSS_CampTsbTrp__c>> lstSQDocs1 = CG_BL_Intake.getTSBsTemp_Existing(JO.id, JO.esn__c,'en');
        //List<List<CSS_CampTsbTrp__c>> lstSQDocs2 = CG_BL_Intake.getQSOLDocs_Existing(JO.id, JO.esn__c,'en');
        CSS_WPR_SBL_ApplicationResJSON AppCodes = CG_BL_Intake.getApplicationCodesWrapper();
        CG_OP_OAGWrapper BMSCustD = CG_BL_Intake.fetchBMSCustomerDetails(JO.Customer_Name__c,'TestCode','TestLocation');
        CG_OP_OAGWrapper BMSAcc = CG_BL_Intake.createBMSAccount(JO.Customer_Name__c,'','','','','8888888888','Toronto','Ontario','MB4','','','ca','en','','');
        
        Test.stopTest();
    
    }
     static  testMethod void CG_BL_Intake_TestMethod2() {
        Test.startTest();
   // Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
         Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
 Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
            insert u;
      CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'TestKal';
       JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Ridhima test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = 'abc';
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      //JO.Shop_s_Work_Order__c = 120;
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      Jo.Assigned_To__c = UserInfo.getUserId();
      Jo.esn__c = '79464646';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
      Jo.OwnerId = u.Id;
      JO.Notes__c = 'notessss';
      insert(JO);
         system.debug('------Testing---' +JO);
    
    
        
        List<css_solution_component__c> solCompCTTP = new List<css_solution_component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'TRP';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c = 'Approved';
            solComp.Complete_Indicator__c = True;
            solcomp.Multiple_Times__c = True;
        insert solComp;
        solCompCTTP.add(solComp);
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
            ctt.Type__c = 'TRP';
            ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt.Doc_Num__c = 'TF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
            ctt.Reviewed__c = false;
            ctt.Job_Order__c = JO.Id;
            ctt.ESN__c = JO.ESN__c;
            insert ctt;
  
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Type__c = 'ATC';
            ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt1.Doc_Num__c = 'ATCF0051000';
            ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt1.Performed__c = false;
            ctt1.Performed_Review__c = true;
            ctt1.Reviewed__c = false;
            ctt1.Job_Order__c = JO.Id;
            ctt1.ESN__c = JO.ESN__c;
            insert ctt1;

        system.debug('---ctttest--' +ctt1);
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
            ctt2.Type__c = 'CAM';
            ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt2.Doc_Num__c = 'CF0051000';
            ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt2.Performed__c = false;
            ctt2.Performed_Review__c = true;
            ctt2.Reviewed__c = false;
            ctt2.Job_Order__c = JO.Id;
            ctt2.ESN__c = JO.ESN__c;
        insert ctt2;
         CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
            ctt3.Type__c = 'TSB';
            ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt3.Doc_Num__c = 'TF0051000';
            ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt3.Performed__c = false;
            ctt3.Performed_Review__c = true;
            ctt3.Reviewed__c = false;
            ctt3.Job_Order__c = JO.Id;
            ctt3.ESN__c = JO.ESN__c;
        
        insert ctt3;
        
         Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Guidanz').getRecordTypeId();
        Id contactRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
                  .get('Guidanz').getRecordTypeId();
        
         account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '999';
            acc.RecordtypeId = recordTypeId;
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.firstname='test1';
        c.LastName='test1';
        c.RecordtypeId    =contactRecId;
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = '12345678';
        ass.vin__c = '1VHGH3W20C6708434';
        //ass.Make_Model__c = 'KENWORTHT';
        ass.Model__c='T680';
        ass.Service_Model__c='ISL G CM2180';
        //ass.Build_Date__c = Date.valueOf('8/30/2012');
        //ass.Warranty_Start_Date__c = Date.valueOf('8/30/2012');
        ass.Equipment_Configuration__c = 'EQ6862';
        ass.Engine_Family_Code__c = '10';
        ass.Customer_Code__c = '123';
        ass.Critical_Part_List_Number__c = '123';
        ass.MoveX_Phone_Number__c = '1234';
        ass.Unit_Number__c = '123';
        ass.Unit_Type__c = 'Engines';
        ass.Automotive_Application_Flag__c = 'N';
        //ass.ETO_Conversion_Date__c = Date.valueOf('8/30/2012');
        ass.Marine_Application_Flag__c = 'Y';
        ass.Engine_Bill_To_Code__c = '123';
        ass.Equipment_Id__c = 'EQ6862';
        ass.Customer_Name__c = 'Testing';
        ass.Make__c = 'KENWORTH';
        ass.Product_Application_Code__c = 'BB';
        ass.Access_Code__c = 'C';
        ass.Product_Application_Description__c = 'AUTOMOTIVE';
        ass.No_Warranty__c = true;
        ass.OEM_SP_Code__c = '1220';
        ass.Engine_Family_Name__c  = '10';
        ass.Design_Phase_Code__c = '10';
        ass.Paccar_Flag__c = true;
         ass.Type__c='Engines';
        //ass.Ship_Date__c = Date.valueOf('8/30/2012');
        ass.ETO_Old_PSN__c = '12345678';
        lstAsset.add(ass);
        insert lstAsset;
        
        lstQSOLDocs.add(ctt3);
        lstQSOLDocs.add(ctt);
        lstQSOLDocs.add(ctt1);
        lstQSOLDocs.add(ctt2);
         lstCAM.add(ctt2);
        lstTRP.add(ctt);
        lstATC.add(ctt1);
        CSS_TestData.createAccountLanguage(true);
        CSS_TestData.createIntegrationDetails(true);
        CG_BL_Intake.getQSOLDocs(JO.id, JO.esn__c,'en');
        CG_BL_Intake.getQSOLClaimsDocs(JO.id, JO.esn__c,'en');
          CG_BL_Intake.GetEngineDataPlateQSOL('12345678');
         CG_BL_Intake.GetEngineDataPlateQSOLREST('12345678');
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        List<List<CSS_CampTsbTrp__c>> lstCamp = CG_BL_Intake.getCampaigns(JO.esn__c, JO.Service_Model__c,JO.Failure_Date__c, 'en',JO.id);
        List<List<CSS_CampTsbTrp__c>> lstSQDocs = CG_BL_Intake.getSiebelQSOLCampaigns(JO.id, JO.esn__c,'en',JO.Service_Model__c,JO.Failure_Date__c);
        List<List<CSS_CampTsbTrp__c>> llstQLinks = CG_BL_Intake.addQSOLLinksToSiebelData(JO.id,solCompCTTP,lstCAM,lstTRP,lstATC);
        List<css_solution_component__c> lstquery = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);    
        
        
        Test.stopTest();
    }
    static  testMethod void CG_BL_Intake_TestMethod3() {
        Test.startTest();
     
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
 Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
            insert u;
                          Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Guidanz').getRecordTypeId();
               account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '999';
            acc.RecordtypeId = recordTypeId;
            acc.Region__c='US and Canada';
            insert acc;
      CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'TEST';
       JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Ridhima test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = 'abc';
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      //JO.Shop_s_Work_Order__c = 120;
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      Jo.Assigned_To__c = UserInfo.getUserId();
      Jo.esn__c = '79936452';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
      Jo.OwnerId = u.Id;
      JO.Notes__c = 'notessss';
      JO.Account__c=acc.Id;
      insert(JO);
         system.debug('------Testing---' +JO);
    
    
        
        List<css_solution_component__c> solCompCTTP = new List<css_solution_component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'ATC';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c = 'Approved';
            solComp.Complete_Indicator__c = True;
            solcomp.Multiple_Times__c = True;
        insert solComp;
        solCompCTTP.add(solComp);
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
            ctt.Type__c = 'ATC';
            ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt.Doc_Num__c = 'ATCF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
            ctt.Reviewed__c = false;
            ctt.Job_Order__c = JO.Id;
            ctt.ESN__c = JO.ESN__c;
            insert ctt;
  
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Type__c = 'CAM';
            ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt1.Doc_Num__c = 'CF0051000';
            ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt1.Performed__c = false;
            ctt1.Performed_Review__c = true;
            ctt1.Reviewed__c = false;
            ctt1.Job_Order__c = JO.Id;
            ctt1.ESN__c = JO.ESN__c;
            insert ctt1;

        system.debug('---ctttest--' +ctt1);
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
            ctt2.Type__c = 'TRP';
            ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt2.Doc_Num__c = 'TF0051000';
            ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt2.Performed__c = false;
            ctt2.Performed_Review__c = true;
            ctt2.Reviewed__c = false;
            ctt2.Job_Order__c = JO.Id;
            ctt2.ESN__c = JO.ESN__c;
        insert ctt2;
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
            ctt3.Type__c = 'TSB';
            ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt3.Doc_Num__c = 'TF0051000';
            ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt3.Performed__c = false;
            ctt3.Performed_Review__c = true;
            ctt3.Reviewed__c = false;
            ctt3.Job_Order__c = JO.Id;
            ctt3.ESN__c = JO.ESN__c;
        insert ctt3;
        lstQSOLDocs.add(ctt3);
        lstQSOLDocs.add(ctt);
        lstQSOLDocs.add(ctt1);
        lstQSOLDocs.add(ctt2);
        lstCAM.add(ctt1);
        lstTRP.add(ctt2);
        lstATC.add(ctt);
        CSS_TestData.createAccountLanguage(true);
            CSS_TestData.createIntegrationDetails(true);
 
    
        List<List<CSS_CampTsbTrp__c>> lstQDocs = CG_BL_Intake.getQSOLDocs(JO.id, JO.esn__c,'en');
        //Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        List<List<CSS_CampTsbTrp__c>> lstCamp = CG_BL_Intake.getCampaigns(JO.esn__c, JO.Service_Model__c,JO.Failure_Date__c, 'en',JO.id);
        List<List<CSS_CampTsbTrp__c>> lstSQDocs = CG_BL_Intake.getSiebelQSOLCampaigns(JO.id, JO.esn__c,'en',JO.Service_Model__c,JO.Failure_Date__c);
        List<List<CSS_CampTsbTrp__c>> llstQLinks = CG_BL_Intake.addQSOLLinksToSiebelData(JO.id,solCompCTTP,lstCAM,lstTRP,lstATC);
        List<css_solution_component__c> lstquery = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);    
        
        
        Test.stopTest();
    }
    static testmethod void testmethodQSOLDocs(){
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
            insert u;
      CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'TEST';
       JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Ridhima test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = 'abc';
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      //JO.Shop_s_Work_Order__c = 120;
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      Jo.Assigned_To__c = UserInfo.getUserId();
      Jo.esn__c = '79464646';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
      Jo.OwnerId = u.Id;
      JO.Notes__c = 'notessss';
      insert(JO);
        CSS_TestData.createAccountLanguage(true);
            CSS_TestData.createIntegrationDetails(true);
        
 Test.startTest();
    Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        List<List<CSS_CampTsbTrp__c>> lstQDocs = CG_BL_Intake.getQSOLDocs(JO.id, JO.esn__c,'en');
        
        Test.stopTest();
    }
    static testmethod void CG_BL_Intake_TestMethod5()
    {
         CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
                Date d = Date.Today();
       // System.debug('date');
                SerRec.DSID__c='12345';
                SerRec.DSID_Status__c='open';
                SerRec.ESN__c ='79464647';
                SerRec.Customer_Name__c='ABC';
                SerRec.Failure_Date__c =d;
                SerRec.Failure_Point__c=2.2;
                SerRec.Unit_Number__c='1234';
                SerRec.Service_Model__c='ESN';
                SerRec.Service_Model_N__c = 445566;
                SerRec.Make__c='test';
                SerRec.Model__c='test1';
                SerRec.VIN__c='1XKAD49X6CJ305490';
                SerRec.Customer_Name__c='ABC';
                SerRec.Warranty_Start_Date__c=d;
                SerRec.Failure_Point_Measure__c = 'MI'; 
                SerRec.Application__c='Automotive'; 
                SerRec.sub_Type__c='cedan';
                SerRec.INSITE_UpdateTimeStamp__c= system.today();
                 SerRec.INSITE_ESN_Choice__c='Not Selected';
                 
                 SerRec.DSID_Creation_Timestamp__c=system.today();
                 SerRec.DSID_WorkGroup__c='Wrkgrp';
                 SerRec.Equipment_ID__c='Equip';
                 SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
                 SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
                 SerRec.CSS_Job_Location_Code__c='56270-56255';
                  SerRec.PSN_Not_Available__c = true;
        
        insert SerRec;
       css_job_order__c jo1 = new  css_job_order__c();    
        CG_BL_Intake cg1 = new CG_BL_Intake();
        cg1.getCountry();
         CG_BL_Intake.cancel(SerRec,jo1);
        system.assert(SerRec.Shop_Work_Order__c==null);
    }
 
    static  testmethod void CG_BL_Intake_TestMethod15()
    {
        account acc = [select id,name,CSS_DistributorCode__c,IAM_Service_Provider_Code__c from account limit 1];
        css_jobeventTemporary__c JT=[select id,name,attribute1__C,Reason__c from css_jobeventTemporary__c limit 1];
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56270');
            insert u;
        system.runAs(u)
        {
            //Creating User Location and adding userlocation into list
            list<CSS_UserLocation__c> lstuloc = new list<CSS_UserLocation__c>();
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(name = 'abc',AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        insert userLocation;
        lstuloc.add(userLocation);
            //Creating Job Order
      CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'TestKal';
       JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Gopal test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = userLocation.name;
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      JO.Shop_Work_Order__c = '120';
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      Jo.Assigned_To__c = u.id;
      Jo.esn__c = '79464646';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
      Jo.OwnerId = u.Id;
      JO.Notes__c = 'notessss';
      insert(JO);
   CSS_Job_Order__c JO2 = [select id,name,Creator_Location__c,Customer_Code__c,Shop_Work_Order__c from css_job_order__c limit 1];
     
        css_job_order__c jo1 = new css_job_order__c();
        system.debug('SerRec'+JO2);
        system.assert(JO2.name!=null);
       system.assert(JO2.Creator_Location__c!=null);
        system.assert(JO2.Customer_Code__c!=null);
       system.assert(JO2.Shop_Work_Order__c!=null);
             
            //Inserting Integeration Detail for deletebms service
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'DeleteBMSJob';
        conDetails1.AuthEnv__c = 'OAGOAUTH';
        conDetails1.ApplicationName__c = 'DeleteBMSJob';
        conDetails1.End_Point__c = 'https://services-dev.cummins.com/csswarranty/bmsjobdeletion';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.Timeout__c = 120000;
        insert conDetails1;
            //Caling Cancel Method here
            test.startTest();
            
            CG_BL_Intake.cancel(JO2,JO);
            //Calling Close Service Job
            CG_BL_Intake.closeServiceJob(JO2);
            system.debug('CG_BL_Intake');
              test.stopTest();  
               }
    }
    static testmethod void mapSPData_test()
    {
       
        
         CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'Gopal';
       JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Gopal test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = 'abc12';
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      JO.Shop_Work_Order__c = '120';
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      //Jo.Assigned_To__c = u.id;
      Jo.esn__c = '79464646';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
     // Jo.OwnerId = u.Id;
      JO.Notes__c = 'notessss';
        jo.CSS_Channel_Of_Distribution__c='101';
        jo.CSS_Travel_Rate__c='12';
      insert(JO);
        List<CSS_UserLocation__c> userLocs = new List<CSS_UserLocation__c>();
        CSS_UserLocation__c accLoc = new CSS_UserLocation__c();
        accLoc.Location_Source__c = 'LDAP';
        accLoc.isPrimary__c = true;
        accLoc.isActive__c = true;
        accLoc.Location_code__c = '03520-28480';
        userLocs.add(accLoc);
        
        
        insert userLocs;
        
        
        
        css_job_order__c jo1 = new css_job_order__c();
        CG_BL_Intake.mapSPData(JO, JO1);
        CG_BL_Intake.FormatDate(System.today());  
        CG_BL_Intake.FormatDate(date.newinstance(2019, 1, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 2, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 3, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 4, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 5, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 6, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 7, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 8, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 9, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 10, 17));
        CG_BL_Intake.FormatDate(date.newinstance(2019, 11, 17));
        CG_BL_Intake.FormatDate(date.newinstance(20,12, 17));
       
        CG_BL_Intake.getModel('Test','Test','Test','Test');
        CG_BL_Intake.getMake('Test','Test','Test');
         Map<string,String> s =CG_BL_Intake.getCertificationStatus('Test',System.Today(),null,false,true,'String',System.Today());
        Map<string,String> s1 =CG_BL_Intake.getCertificationStatus('Test',System.Today(),'Tetsacc',true,false,'String',System.Today());
        Map<string,String> s11 =CG_BL_Intake.getCertificationStatus('Test',System.Today(),'Test',true,true,'String',System.Today());
        CG_BL_Intake.FetchAccountId('03520-2848');// Changed
        CG_BL_Intake.fetchSPData(JO,'Test','Test',System.Today(),'Test');
        CG_BL_Intake.getBMSCustomerCreditMsgs('Test','Test');
        
        CG_BL_Intake.getCertificationStatus(null);
         CG_BL_Intake.getBMSCustomerCreditMsgs(null,null);
         CG_BL_Intake.closeServiceJob(new CSS_Job_Order__c());
        CG_BL_Intake.closeServiceJob(null);
        CG_BL_Intake.fetchMultiLocation();
        CG_BL_Intake.mapSPData(null,null);
        CG_BL_Intake.parseQSOLDate(null);  
         CG_BL_Intake.FormatDate(null);
        CG_BL_Intake.getSubType(null, '03520-04892');  
        CG_BL_Intake.getUnitType(null, 'creatorLocation');
        CG_BL_Intake.getModel(null,null,null,null);
        CG_BL_Intake.GetEngineDataPlateQSOL('79464646');
        CG_BL_Intake.selectedLocation(userLocs);
        
        CG_BL_Intake take = new CG_BL_Intake();
        take.fetchLocationName(userLocs);
        take.getStates(null);
        
        CG_BL_Intake.fetchUserLocation(null,null);
    }
    static  testMethod void CG_BL_Intake_TestMethod1111() {
        
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
    Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_BL_Intake BLIntake = new CG_BL_Intake();
        CSS_CountryStateValues__c countryval = new CSS_CountryStateValues__c();
        countryval.CountryName__c = 'India';
        countryval.CountryCode__c = 'India';
        countryval.StateCode__c = 'TN';
        countryval.StateName__c = 'Telangana';
        countryval.Name = 'Test';
        insert countryval;
                
                Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Guidanz').getRecordTypeId();
                  
                
        Account acc = new Account();
       acc.name='Akanksha';
       acc.CSS_DistributorCode__c='56270';
       acc.CSS_DealerCode__c='999';
       acc.Type = 'Customer';
       acc.RecordTypeId = recordTypeId;
       acc.CSS_DBCode__c='33333';
       //acc.Region__c = 'US and Canada';
       //acc.CMI_Account_Status__c = 'Active';
       //acc.IAM_Service_Provider_Code__c = '56270';
        insert acc;
        
        List<CSS_Accreditation__c> lstaccrd = new list<CSS_Accreditation__c>();
    CSS_Accreditation__c accrd1 = new CSS_Accreditation__c();
    //accrd1.Account__c = testclaimsRec.Account__c;
    //accrd1.Service_Model_Name__c = testpsnNewRec.Service_Model__c;
    accrd1.Service_Level__c = 'akanksha';
    accrd1.StartDate__c = system.today();
    accrd1.EndDate__c = system.today()+30;
    insert accrd1;
    lstaccrd.add(accrd1);
        string location = [select id,location__c from account where id=:acc.id].location__c;
       // system.debug('location***'+location);
        css_jobeventTemporary__c JT = new css_jobeventTemporary__c();
        JT.attribute1__C = 'ApplicationCodes';
        JT.Reason__c = '{"DataArea":{"Details":[{"Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"120","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"130","MarineFlag":"N","DefaultUom":""},{"Description":"BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"200","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"210","MarineFlag":"N","DefaultUom":""},{"Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"220","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"300","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"400","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"410","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"420","MarineFlag":"N","DefaultUom":""},{"Description":"INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"500","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"600","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"605","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"610","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"620","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"625","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"645","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"650","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"655","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"665","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"700","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"710","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"720","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"800","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"810","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (OTHER THAN STANDBY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"820","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"830","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"840","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"900","MarineFlag":"N","DefaultUom":""},{"Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"910","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"920","MarineFlag":"N","DefaultUom":""},{"Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"930","MarineFlag":"N","DefaultUom":""},{"Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"940","MarineFlag":"N","DefaultUom":""},{"Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"950","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"960","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"10","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"11","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"12","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"13","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"20","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"21","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"22","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"23","MarineFlag":"N","DefaultUom":""},{"Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"30","MarineFlag":"N","DefaultUom":""},{"Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"31","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"40","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"41","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"42","MarineFlag":"N","DefaultUom":""},{"Description":"0INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"50","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"51","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"60","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"61","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"62","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"63","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"64","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"65","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"66","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"70","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"71","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"72","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"80","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"81","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"82","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"83","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"84","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"90","MarineFlag":"N","DefaultUom":""},{"Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"91","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"92","MarineFlag":"N","DefaultUom":""},{"Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"93","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"94","MarineFlag":"N","DefaultUom":""},{"Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"95","MarineFlag":"N","DefaultUom":""},{"Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"96","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"100","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"110","MarineFlag":"N","DefaultUom":""},{"Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"230","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"310","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"510","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"635","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"660","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"FORD GRAY AUTO","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"140","MarineFlag":"N","DefaultUom":""},{"Description":"FORD GRAY BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"240","MarineFlag":"N","DefaultUom":""},{"Description":"ISC-SERIES","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"150","MarineFlag":"N","DefaultUom":""},{"Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"621","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"651","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"656","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"661","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"320","MarineFlag":"N","DefaultUom":""},{"Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"890","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"670","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"675","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"680","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"685","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"690","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"695","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"891","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"520","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR (WORLDWIDE HHP LEAN-BURN GAS)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"850","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"250","MarineFlag":"N","DefaultUom":""},{"Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"699","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"662","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"663","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"530","MarineFlag":"N","DefaultUom":"Hours"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
insert JT;
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56270');
            insert u;
      CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'TestKal';
       JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Ridhima test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = 'abc';
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      JO.Shop_Work_Order__c = '120';
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      Jo.Assigned_To__c = u.id;
      //Jo.esn__c = '79464646';
      Jo.esn__c = '79936452';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
      Jo.OwnerId = u.Id;
      JO.Notes__c = 'notessss';
      insert(JO);
      
      CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
      intDetails.Name='GetCampaign';
      intDetails.ApplicationName__c= 'GetCampaign';
      intDetails.AuthEnv__c='OAGOAuth';
      intDetails.End_Point__c='https://services-stg.cummins.com/css/getcampaigndetails  ';
      intDetails.IsActive__c=true;
      intDetails.Method_Type__c='POST';
      intDetails.Passcode__c='455';
      intDetails.Timeout__c=120000;
      intDetails.Username__c='rkm2LC2Bc+MBU41DI07kdQBdDf8OLbIE9PjyN19GFKE=';
      intDetails.Key__c='lDPu+ZY9orXKAb395MSisA0bFXIZo0NzXIyhvLllnUc=';
      insert intDetails;
      
      CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
      intDetails1.Name='CSS_SBL_WarrantyDetailCoverage';
      intDetails1.ApplicationName__c= 'CSS_SBL_WarrantyDetailCoverage';
      intDetails1.AuthEnv__c='OAGOAuth';
      intDetails1.End_Point__c='https://services-stg.cummins.com/css/accodecoverage  ';
      intDetails1.IsActive__c=true;
      intDetails1.Method_Type__c='POST';
      intDetails1.Passcode__c='ck7yqg0ICK5h4J1Jb/5Yl7dJF2h66Ua3VuXqdkSGvcQ=';
      intDetails1.Timeout__c=120000;
      intDetails1.Username__c='6Qo/uCbht7NSk3RI6WG+VU8cWrncYqfuUCU7NXddjoU=';
      intDetails1.Key__c='9p/UUTNjKWbRjgSlxDx33+xMz5VDh9O979WxeZy71zw=';
      insert intDetails1;
      
      CSS_Integration_Details__c intDetails2 = new CSS_Integration_Details__c();
      intDetails2.Name='GetWattantyDocsforQsolREST';
      intDetails2.ApplicationName__c= 'GetWattantyDocsforQsolREST';
      intDetails2.AuthEnv__c='QsolToken';
      intDetails2.End_Point__c='https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?serialNumber=';
      intDetails2.IsActive__c=true;
      intDetails2.Method_Type__c='GET';
      intDetails2.Passcode__c='455';
      intDetails2.Timeout__c=120000;
      intDetails2.Username__c='rkm2LC2Bc+MBU41DI07kdQBdDf8OLbIE9PjyN19GFKE=';
      intDetails2.Key__c='lDPu+ZY9orXKAb395MSisA0bFXIZo0NzXIyhvLllnUc=';
      insert intDetails2;
      
       
         system.debug('------Testing---' +JO);
         list<CSS_UserLocation__c> lstuloc = new list<CSS_UserLocation__c>();
    system.runAs(u){
               CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        insert userLocation;
        
        lstuloc.add(userLocation);
        CG_BL_Intake.selectedLocation(lstuloc);
        List<SelectOption> lstOpt = BLIntake.fetchLocationName(lstuloc);
        user usr=css_utility.getUserAttributes(Userinfo.getUserId());
        Map<string,String> MapCertStat = CG_BL_Intake.getCertificationStatus(JO.Service_Model__c);
    }
        CG_BL_Intake.cancel(JO,JO);
        
        List<css_solution_component__c> solCompCTTP = new List<css_solution_component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c = 'Approved';
            solComp.Complete_Indicator__c = True;
            solcomp.Multiple_Times__c = True;
        insert solComp;
        solCompCTTP.add(solComp);
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
            ctt.Type__c = 'ATC';
            ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt.Doc_Num__c = 'ATCF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
            ctt.Reviewed__c = false;
            ctt.Job_Order__c = JO.Id;
            ctt.ESN__c = JO.ESN__c;
        ctt.cu_language__C = 'fr';
            insert ctt;
  
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Type__c = 'CAM';
            ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt1.Doc_Num__c = 'CF0051000';
            ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt1.Performed__c = false;
            ctt1.Performed_Review__c = true;
            ctt1.Reviewed__c = false;
            ctt1.Job_Order__c = JO.Id;
            ctt1.ESN__c = JO.ESN__c;
        ctt1.cu_language__C = 'fr';
            insert ctt1;

        system.debug('---ctttest--' +ctt1);
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
            ctt2.Type__c = 'TRP';
            ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt2.Doc_Num__c = 'TF0051000';
            ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt2.Performed__c = false;
            ctt2.Performed_Review__c = true;
            ctt2.Reviewed__c = false;
            ctt2.Job_Order__c = JO.Id;
            ctt2.ESN__c = JO.ESN__c;
        ctt2.cu_language__C = 'fr';
        insert ctt2;
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
            ctt3.Type__c = 'TSB';
            ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt3.Doc_Num__c = 'TF0051000';
            ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt3.Performed__c = false;
            ctt3.Performed_Review__c = true;
            ctt3.Reviewed__c = false;
            ctt3.Job_Order__c = JO.Id;
            ctt3.ESN__c = JO.ESN__c;
        insert ctt3;
        lstQSOLDocs.add(ctt3);
        lstQSOLDocs.add(ctt);
        lstQSOLDocs.add(ctt1);
        lstQSOLDocs.add(ctt2);
        lstCAM.add(ctt1);
        lstCAM.add(ctt2);
        lstCAM.add(ctt3);
        lstTRP.add(ctt2);
        lstATC.add(ctt);
        
        CG_BL_Intake.fetchUserLocation(JO.id, 'creatorLocation');
        lstuloc = CG_BL_intake.fetchMultiLocation();
                
        List<SelectOption> lstoptsub = CG_BL_Intake.getSubType(JO.id, 'creatorLocation');
        List<SelectOption> lstunit = CG_BL_Intake.getUnitType(JO.id, 'creatorLocation');
        List<SelectOption> lstOpt1 = BLIntake.getCountry();
        List<SelectOption> lstApp = CG_BL_Intake.getApplication();
        List<SelectOption> lstStates = BLIntake.getStates('India'); 
        Date mdate = CG_BL_Intake.parseQSOLDate('04 05 2017');
        CSS_TestData.createAccountLanguage(true);
            CSS_TestData.createIntegrationDetails(true);
 
//        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.startTest();
        List<List<CSS_CampTsbTrp__c>> lstQDocs = CG_BL_Intake.getQSOLDocs(JO.id, JO.esn__c,'en');
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        List<List<CSS_CampTsbTrp__c>> lstCamp = CG_BL_Intake.getCampaigns(JO.esn__c, JO.Service_Model__c,JO.Failure_Date__c, 'en',JO.id);
        List<List<CSS_CampTsbTrp__c>> lstSQDocs = CG_BL_Intake.getSiebelQSOLCampaigns(JO.id, JO.esn__c,'en',JO.Service_Model__c,JO.Failure_Date__c);
        List<List<CSS_CampTsbTrp__c>> llstQLinks = CG_BL_Intake.addQSOLLinksToSiebelData(JO.id,solCompCTTP,lstCAM,lstTRP,lstATC);
        List<css_solution_component__c> lstquery = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);    
        
        CSS_WPR_SBL_ApplicationResJSON AppCodes = CG_BL_Intake.getApplicationCodesWrapper();
        CG_OP_OAGWrapper BMSCustD = CG_BL_Intake.fetchBMSCustomerDetails(JO.Customer_Name__c,'TestCode','TestLocation');
        CG_OP_OAGWrapper BMSAcc = CG_BL_Intake.createBMSAccount(JO.Customer_Name__c,'','','','','8888888888','Toronto','Ontario','MB4','','','ca','en','','');
        Test.stopTest();
    
    }
    static testMethod void getCampaignsForUTMethod(){
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.name='Akanksha';
        acc.CSS_DistributorCode__c='56270';
        acc.CSS_DealerCode__c='999';
        acc.Type = 'Customer';
        acc.RecordTypeId = recordTypeId;
        acc.CSS_DBCode__c='33333';
        acc.Region__c = 'US and Canada';
       //acc.CMI_Account_Status__c = 'Active';
       //acc.IAM_Service_Provider_Code__c = '56270';
        insert acc; 
      CSS_Job_Order__c JO = new CSS_Job_Order__c();
      JO.Customer_Name__c = 'TestKal';
      JO.Application__c = 'Recreational Vehicle';
      JO.Model__c = 'Ridhima test 123';
      JO.Make__c = 'CSSTest';
      JO.Notes__c = 'CAMPCOMMENTS';
      JO.Failure_Point__c = 122;
      JO.Failure_Point_Measure__c = 'Miles';
      JO.VIN__c = '12345677890';
      JO.Failure_Date__c = date.today() - 20;
      JO.Warranty_Start_Date__c = date.today() - 365;
      JO.Location_Certification__c = 'abc';
      JO.jobLocation__c = 'abc';
      JO.Before_In_Service__c = True;
      //JO.lo = 10;
      JO.Shop_Work_Order__c = '120';
      JO.Status__c = 'Repair Complete';
      JO.Unit_Number__c = 'test123';
      //Jo.Assigned_To__c = u.id;
      //Jo.esn__c = '79464646';
      Jo.esn__c = '79936452';
      JO.Unit_Type__c = 'type';
      Jo.Country__c = 'United States';
      Jo.CSS_State__c = 'Indiana';
      Jo.City__c = 'Columbus';
      Jo.Customer_Code__c = '23456';
      Jo.Service_Model__c = 'Test one';
      //Jo.OwnerId = u.Id;
      JO.Notes__c = 'notessss';
      JO.Account__c=acc.id;
      insert(JO);
        CSS_Integration_Details__c intDetails = new CSS_Integration_Details__c();
      intDetails.Name='GetCampaign';
      intDetails.ApplicationName__c= 'GetCampaign';
      intDetails.AuthEnv__c='OAGOAuth';
      intDetails.End_Point__c='https://services-stg.cummins.com/css/getcampaigndetails  ';
      intDetails.IsActive__c=true;
      intDetails.Method_Type__c='POST';
      intDetails.Passcode__c='f7INxVstQKKEyQwME4rQaHQ/8NG47wKW5veyaeADGcQ=';
      intDetails.Timeout__c=120000;
      intDetails.Username__c='HF94wyQQXRzJNdlkcOwIKzG2QTe12k2A+/3y4zZxs+o=';
      intDetails.Key__c='YUyISxUmZiUoCjwKhz4J/kUbEcKF84UagJgkGbApdj8=';
      insert intDetails;
      
      CSS_Integration_Details__c intDetails1 = new CSS_Integration_Details__c();
      intDetails1.Name='CSS_SBL_WarrantyDetailCoverage';
      intDetails1.ApplicationName__c= 'CSS_SBL_WarrantyDetailCoverage';
      intDetails1.AuthEnv__c='OAGOAuth';
      intDetails1.End_Point__c='https://services-stg.cummins.com/css/accodecoverage  ';
      intDetails1.IsActive__c=true;
      intDetails1.Method_Type__c='POST';
      intDetails1.Passcode__c='ck7yqg0ICK5h4J1Jb/5Yl7dJF2h66Ua3VuXqdkSGvcQ=';
      intDetails1.Timeout__c=120000;
      intDetails1.Username__c='6Qo/uCbht7NSk3RI6WG+VU8cWrncYqfuUCU7NXddjoU=';
      intDetails1.Key__c='9p/UUTNjKWbRjgSlxDx33+xMz5VDh9O979WxeZy71zw=';
      insert intDetails1;
      
      CSS_Integration_Details__c intDetails2 = new CSS_Integration_Details__c();
      intDetails2.Name='GetWattantyDocsforQsolREST';
      intDetails2.ApplicationName__c= 'GetWattantyDocsforQsolREST';
      intDetails2.AuthEnv__c='QsolToken';
      intDetails2.End_Point__c='https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?serialNumber=';
      intDetails2.IsActive__c=true;
      intDetails2.Method_Type__c='GET';
      intDetails2.Passcode__c='kdrOWawZxSx0N0yJCIs1jsCYFfPVT2OLWA5SyMd4d1E=';
      intDetails2.Timeout__c=120000;
      intDetails2.Username__c='rkm2LC2Bc+MBU41DI07kdQBdDf8OLbIE9PjyN19GFKE=';
      intDetails2.Key__c='lDPu+ZY9orXKAb395MSisA0bFXIZo0NzXIyhvLllnUc=';
      insert intDetails2;
        Test.startTest();
        Date d = date.today();
        date d1 = date.parse('10/10/17');
        date d2 = date.parse('10/12/16');
       
        CG_BL_Intake.getCampaignsForUT('esn','sServiceModel',d,'qsolLanguage','region','mileage','mileageMeasure','applicationCode',d,'reconEngineFlag');
       // CSS_FN_SIEBEL.getWarrantyDetailCoverage('79464646','selectedLocation',d,'3','mileageMeasure','DC',d,'tempSysCode','tempCompcode','559','62','a1O3B0000007DQsUAM',true,'tempComponentId','','Second Call', 'reconEngineFlag', false,'TestJob');
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',d1,'failpoint','failmeasure','engappcode',d2,'syscode33445','comp123','f123','acc123','a1O3B0000007DQsUAM',true,'campNum','N','Second Call', '',false,null);
        Test.stopTest();
    }
    
   static testmethod void AssetCodeCoverage(){
       
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id contactRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '999';
            acc.RecordtypeId = recordTypeId;
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.firstname='test1';
        c.LastName='test1';
        c.RecordTypeId =contactRecId;
        insert c;
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = '12345678';
        ass.vin__c = '1VHGH3W20C6708434';
        //ass.Make_Model__c = 'KENWORTHT';
        ass.Model__c='T680';
        ass.Service_Model__c='ISL G CM2180';
        //ass.Build_Date__c = Date.valueOf('8/30/2012');
        //ass.Warranty_Start_Date__c = Date.valueOf('8/30/2012');
        ass.Equipment_Configuration__c = 'EQ6862';
        ass.Engine_Family_Code__c = '10';
        ass.Customer_Code__c = '123';
        ass.Critical_Part_List_Number__c = '123';
        ass.MoveX_Phone_Number__c = '1234';
        ass.Unit_Number__c = '123';
        ass.Unit_Type__c = 'Engines';
        ass.Automotive_Application_Flag__c = 'N';
        //ass.ETO_Conversion_Date__c = Date.valueOf('8/30/2012');
        ass.Marine_Application_Flag__c = 'Y';
        ass.Engine_Bill_To_Code__c = '123';
        ass.Equipment_Id__c = 'EQ6862';
        ass.Customer_Name__c = 'Testing';
        ass.Make__c = 'KENWORTH';
        ass.Product_Application_Code__c = 'BB';
        ass.Access_Code__c = 'C';
        ass.Product_Application_Description__c = 'AUTOMOTIVE';
        ass.No_Warranty__c = true;
        ass.OEM_SP_Code__c = '1220';
        ass.Engine_Family_Name__c  = '10';
        ass.Design_Phase_Code__c = '10';
        ass.Paccar_Flag__c = true;
         ass.Type__c='Engines';
        ass.Type_PSN__c = 'Engines-12345678';
        ass.ETO_Old_PSN__c = '12345678';
        
        insert ass;
        
        CG_BL_Intake.GetEngineDataPlateQSOL('12345678');
    }
}