trigger ProjectTrigger on Project__c (after update) {
    
    for (Project__c p : Trigger.new) {
        
        if (p.status__c == 'Billable' && Trigger.oldMap.get(p.id).status__c != 'Billable') {
            
            BillingCalloutService.callBillingService(Trigger.new,Trigger.oldMap);
            
        }
        
    }        
    
}

//ok so this code is terrible... the call out should happen only after the loop collect elements from the new list and old map that are valid but you get the point that the project trigger is missing and needs to be added
