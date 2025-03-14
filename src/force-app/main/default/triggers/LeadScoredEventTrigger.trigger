trigger LeadScoredEventTrigger on LeadScoredEvent__e (after insert) {
    if (Trigger.isInsert && Trigger.isAfter) {
        LeadScoredEventTriggerHandler.handleAfterInsert(Trigger.new);
    }
}