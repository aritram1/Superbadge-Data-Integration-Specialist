@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    
    @HttpPost
    global static String postProjectData(
    String projectRef,
    String projectName,
    String opportunityId,
    Date startDate,
    Date endDate,
    Double amount,
    String status){
        
        Savepoint sPoint = Database.setSavepoint();
        
        try{
            Project__c project = new Project__c();
            project.ProjectRef__c = projectRef;
            project.Name = projectName;
            project.Opportunity__c = opportunityId;
            project.Start_Date__c = startDate;
            project.End_Date__c = endDate;
            project.Billable_Amount__c = amount;
            project.Status__c = status;            
            upsert project;
            
            Opportunity opp = new Opportunity();
            opp.Id = opportunityId;
            opp.DeliveryInstallationStatus__c = 'In progress';
            update opp;
            
            return 'OK';
            
        }catch(Exception ex){
            Database.rollback(sPoint);
            return ex.getMessage();
        }      
    }
    
}
