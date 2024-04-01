trigger ContactTrigger on Contact (after update) {
    Set<Id> contactIds = new Set<Id>();
    for (Contact updatedContact : Trigger.new) {
        contactIds.add(updatedContact.Id);
    }
    ContactTriggerHandler.handleAfterUpdate(contactIds);
}
