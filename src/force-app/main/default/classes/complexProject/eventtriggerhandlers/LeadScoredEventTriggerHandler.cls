public class LeadScoredEventTriggerHandler {
    public static void handleAfterInsert(List<LeadScoredEvent__e> platformEvents) {
        List<Lead> leadsToUpdate = new List<Lead>();
        List<LeadAssignedEvent__e> leadAssignedEvents = new List<LeadAssignedEvent__e>();

        List<User> salesReps = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 3]; // Example: Get Sales Reps -  Adapt to your org!
        if (salesReps.isEmpty()) {
            System.debug('No Sales Reps found for routing!'); // Handle case if no Sales Reps are found
            return;
        }
        Integer repIndex = 0; // Simple Round-Robin assignment for POC

        for (LeadScoredEvent__e event : platformEvents) {
            Lead lead = [SELECT Id, LeadSource FROM Lead WHERE Id = :event.LeadId__c FOR UPDATE]; // FOR UPDATE for concurrency control

            // Simple Routing Logic based on Lead Source (POC example - expand in real app)
            Id assignedRepId = salesReps[repIndex].Id;
            if (lead.LeadSource == 'Web') {
                assignedRepId = salesReps[0].Id; // Always assign Web leads to first rep for POC demo
            } else {
                assignedRepId = salesReps[repIndex].Id; // Round-robin for other sources
                repIndex = Math.Mod((repIndex + 1), salesReps.size()); // Cycle through Sales Reps
            }

            lead.Assigned_Sales_Rep__c = assignedRepId;
            lead.Routing_Status__c = 'Routed'; 
            leadsToUpdate.add(lead);

            LeadAssignedEvent__e assignedEvent = new LeadAssignedEvent__e(LeadId__c = lead.Id, AssignedUserId__c = assignedRepId);
            leadAssignedEvents.add(assignedEvent);
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate; // Update Leads with assigned Sales Rep

             List<Database.SaveResult> eventResults = EventBus.publish(leadAssignedEvents);
            for (Database.SaveResult sr : eventResults) {
                if (!sr.isSuccess()) {
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('Platform Event Publish Error (LeadAssignedEvent): ' + err.getMessage() + ' - Lead ID: ' + sr.getId());
                    }
                }
            }
        }
    }
}