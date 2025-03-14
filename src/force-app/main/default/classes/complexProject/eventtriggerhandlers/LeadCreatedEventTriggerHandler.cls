public class LeadCreatedEventTriggerHandler {
    public static void handleAfterInsert(List<Lead> newLeads) {
        List<Database.SaveResult> eventResults = new List<Database.SaveResult>();
        List<LeadCreatedEvent__e> leadCreatedEvents = new List<LeadCreatedEvent__e>();

        for (Lead lead : newLeads) {
            LeadCreatedEvent__e event = new LeadCreatedEvent__e(LeadId__c = lead.Id);
            leadCreatedEvents.add(event);
        }

        if (!leadCreatedEvents.isEmpty()) {
            eventResults = EventBus.publish(leadCreatedEvents);
        }

        // Handle event publishing results (for logging/error handling in real app)
        for (Database.SaveResult sr : eventResults) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    System.debug('Platform Event Publish Error: ' + err.getMessage() + ' - Lead ID: ' + sr.getId());
                    // Add more robust error handling/logging in a production scenario
                }
            }
        }
    }
}