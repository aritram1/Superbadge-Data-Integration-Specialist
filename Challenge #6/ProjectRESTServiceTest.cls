@isTest
private class ProjectRESTServiceTest {
  
    @testSetup
    static void setup(){       
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
    static void testProjectRestServiceFailure(){
        //Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp'];
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = '/services/apexrest/project';
        
        RestContext.request = request;
        
        Test.startTest();
        String response = ProjectRESTService.postProjectData(
                            'Test Ref 123', 
                            'Test Project', 
                            'test opp id', 
                            Date.today(), 
                            Date.today().addDays(1), 
                            110000, 
                            'Running');
        Test.stopTest();
        
        System.assertEquals('Invalid id: test opp id', response);
    }
    
    @isTest
    static void testProjectRestServiceSuccess(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp'];
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = '/services/apexrest/project';
        
        RestContext.request = request;
        
        Test.startTest();
        String response = ProjectRESTService.postProjectData(
                            'Test Ref 123', 
                            'Test Project', 
                            opp.id, 
                            Date.today(), 
                            Date.today().addDays(1), 
                            110000, 
                            'Running');
        Test.stopTest();
        
        opp = [SELECT DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
        System.assertEquals('OK', response);
    }
    
}
