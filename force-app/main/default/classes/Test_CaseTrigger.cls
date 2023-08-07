@isTest
public class Test_CaseTrigger {
    @testSetup
    public static void testCaseInsertion() {
        
        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Description = 'Test Desc';
        testCase.Type = 'Problem';
        
        Case testCaseII = new Case();
        testCaseII.Subject = 'Test Case2';
        testCaseII.Description = 'Test Desc2';
        testCaseII.Type = 'Other';
        
        //Test.startTest();
        insert testCase;
        insert testCaseII;
        testCaseII.Type = 'Problem';
        update testCaseII;
        //Test.stopTest();
        
    }
    
    @isTest
    public static void testmeathod(){
        List<Case> caseList = [SELECT Id , Description , Subject, type, Nonconformance__c, Nonconformance__r.QMS_Reference_Number__c, CaseNumber from Case WHERE Type = 'Electrical'];
        Test.startTest();
        for(Case cs : caseList){
            if(cs.Type == 'Problem'){
                system.assertEquals(cs.Nonconformance__r.QMS_Reference_Number__c, cs.CaseNumber);
            }
        }
        Test.stopTest();
    }
}