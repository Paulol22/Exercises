trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact con : Trigger.new) {

        if (con.IsPrimaryContact__c == true) {
            List<Contact> existingPrimaryContacts = [
                SELECT Id FROM Contact
                WHERE AccountId = :con.AccountId
                AND IsPrimaryContact__c = true
                AND Id != :con.Id
                LIMIT 1
            ];

            if (!existingPrimaryContacts.isEmpty()) {
                con.addError('A primary contact already exist.');
            }
        }
    }
}