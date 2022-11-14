@isTest
public class FSL_SPTechCertificationSchedular_Test
{
    static testMethod void FSL_SPTechCertificationSchedular_Test()
    {
        Test.startTest();
        FSL_SPTechCertificationSchedular spTechCertSch = new FSL_SPTechCertificationSchedular();
        string spTechCertCExp = '0 0 23 * * ?';
        system.schedule('FSL SP TechCert Info Scheduler', spTechCertCExp, spTechCertSch); 
        Test.stoptest();
    }
}