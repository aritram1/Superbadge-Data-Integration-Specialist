@isTest
private class BillingCalloutServiceTest {
   
    @testSetup
    static void setup(){
        ServiceCredentials__c credential = new ServiceCredentials__c();
        credential.Name = BillingCalloutService.BILLING_SERVICE_CREDENTIAL_NAME;
        credential.Username__c = 'test username';
        credential.Password__c = 'test password';
        insert credential;
        
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
        
        Project__c project = new Project__c();
        project.Name = 'test project';
        project.ProjectRef__c = 'test project ref 123xyz';
        project.Billable_Amount__c = 100000;
        project.Status__c = 'Running';
        project.Opportunity__c =opp.Id;
        insert project;       
    }
    
    @isTest
    static void testBillingCalloutFailure(){
        List<Project__c> projects = [SELECT Id FROM Project__c WHERE Name = 'test project'];
        for(Project__c proj : projects){
            proj.Status__c = 'Running';
        }
    
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        update projects;
        Test.stopTest();
        
        projects = [SELECT Status__c FROM Project__c WHERE Name = 'test project'];
        System.assertEquals('Running', projects[0].Status__c);
    }
    
    @isTest
    static void testBillingCalloutSuccess(){
        List<Project__c> projects = [SELECT Id FROM Project__c WHERE Name = 'test project'];
        for(Project__c proj : projects){
            proj.Status__c = 'Billable';
        }
    
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        update projects;
        Test.stopTest();
        
        projects = [SELECT Status__c FROM Project__c WHERE Name = 'test project'];
        System.assertEquals('Billed', projects[0].Status__c);
    }
}
