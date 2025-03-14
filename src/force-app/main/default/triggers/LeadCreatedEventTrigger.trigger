trigger LeadCreatedEventTrigger on Lead (after insert) {
    if (Trigger.isInsert && Trigger.isAfter) {
        LeadCreatedEventTriggerHandler.handleAfterInsert(Trigger.new);
    }
}