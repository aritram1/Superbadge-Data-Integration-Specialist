trigger ProjectTrigger on Project__c (after update) {
    
    for (Project__c p : Trigger.new) {
        
        if (p.status__c == 'Billable' && Trigger.oldMap.get(p.id).status__c != 'Billable') {
            
            BillingCalloutService.callBillingService(Trigger.new,Trigger.oldMap);
            
        }
        
    }        
    
}
