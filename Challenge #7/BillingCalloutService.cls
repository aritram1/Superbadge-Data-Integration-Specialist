public class BillingCalloutService {
    public static final String BILLING_SERVICE_CREDENTIAL_NAME = 'BillingServiceCredential';
    static final ServiceCredentials__c credential = ServiceCredentials__c.getInstance(BILLING_SERVICE_CREDENTIAL_NAME);
    
    public static void callBillingService(List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap){
        List<Project__c> projectsToSync = new List<Project__c>();
        
        for(Project__c project : newProjects){
            Project__c oldProject = oldProjectsMap.get(project.Id);
            if(project.Status__c == 'Billable' && project.Status__c != oldProject.Status__c){
                projectsToSync.add(project);
            }
        }
        
        if(projectsToSync.size() > 0){
            makeCallout(JSON.serialize(projectsToSync)); 
        }      
    }
    
    @future(callout = true)
    static void makeCallout(String serializedProjects){
        List<Project__c> projects = (List<Project__c>)JSON.deserialize(serializedProjects, List<Project__c>.class);
        List<Project__c> projectsToUpdate = new List<Project__c>();
        
        for(Project__c project : projects){
            BillingServiceProxy.InvoicesPortSoap11 invoicePort = new BillingServiceProxy.InvoicesPortSoap11();
            BillingServiceProxy.project extProject = setAndGetExternalProject(project);
            String response = invoicePort.billProject(extProject);
            
            if(response == 'OK'){
                project.Status__c = 'Billed';
                projectsToUpdate.add(project);
            }
        }
        
        if(projectsToUpdate.size() > 0){
            update projectsToUpdate;
        }
    }
    
    static BillingServiceProxy.project setAndGetExternalProject(Project__c project){
        BillingServiceProxy.project extProject = new BillingServiceProxy.project();
        extProject.projectid = project.ProjectRef__c;
        extProject.billAmount = project.Billable_Amount__c;
        extProject.username = credential.Username__c;
        extProject.password = credential.Password__c;
        
        return extProject;
    }
}
