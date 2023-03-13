trigger ProjectTrigger on Project__c (after update) {
    
    List<Project__c> relatedRecords = new List<Project__c> ();
    for (Project__c p : Trigger.new) {
        
        if (p.status__c == 'Billable' && Trigger.oldMap.get(p.id).status__c != 'Billable') {
            
            // The logic to include the eligible elements to a sepearete list
            relatedRecords.add(p);
            
        }
        
    }
    
    
    // Call the webservice finally with the list of records
    BillingCalloutService.callBillingService(relatedRecords);
    
    
}
