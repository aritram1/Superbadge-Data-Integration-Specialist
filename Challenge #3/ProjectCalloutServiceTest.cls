@isTest
private class ProjectCalloutServiceTest {
  
    @testSetup
    static void setup(){
        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = ProjectCalloutService.PROJECT_SERVICE_TOKEN_NAME;
        token.Token__c = 'TestToken';
        insert token;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Test Opp';
        opp.Type = 'New Project';
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        opp.Amount = 100000;
        insert opp;
    }
    
    @isTest
    static void testPMSCalloutFailure(){
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp'];
        for(Opportunity opp : opportunities){
            opp.StageName = 'Closed Won';
        }
    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        update opportunities;
        Test.stopTest();
        
        opportunities = [SELECT StageName FROM Opportunity WHERE Name = 'Test Opp'];
        System.assertEquals('Resubmit Project', opportunities[0].StageName);
    }
    
    @isTest
    static void testPMSCalloutSuccess(){
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp'];
        for(Opportunity opp : opportunities){
            opp.StageName = 'Closed Won';
        }
    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        update opportunities;
        Test.stopTest();
        
        opportunities = [SELECT StageName FROM Opportunity WHERE Name = 'Test Opp'];
        System.assertEquals('Submitted Project', opportunities[0].StageName);
    }
}
