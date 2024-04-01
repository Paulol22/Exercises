public with sharing class ContactTriggerHandler {
    public static void handleAfterUpdate(Set<Id> contactIds) {
        // Check CRUD permission for the Contact object
        if (!Schema.sObjectType.Contact.isUpdateable() || !Schema.sObjectType.Contact.isAccessible()) {
            // Handle insufficient permissions
            throw new InsufficientPermissionsException('Insufficient permissions to update Contact records.');
        }
        
        // Perform SOQL query to retrieve Contact records
        List<Contact> updatedContacts = [SELECT Id, AccountId, Phone, IsPrimaryContact__c FROM Contact WHERE Id IN :contactIds];

        // Check CRUD permission for the Account object
        if (!Schema.sObjectType.Account.isUpdateable() || !Schema.sObjectType.Account.isAccessible()) {
            // Handle insufficient permissions
            throw new InsufficientPermissionsException('Insufficient permissions to update Account records.');
        }

        // Perform DML operation to update Account records
        List<Account> accountsToUpdate = new List<Account>();
        for (Contact updatedContact : updatedContacts) {
            // Update Account records based on Contact changes
            // Example logic...
            Account acc = new Account(Id = updatedContact.AccountId, Phone = updatedContact.Phone);
            accountsToUpdate.add(acc);
        }

        try {
            update accountsToUpdate;
        } catch (Exception e) {
            // Handle DML errors if necessary
        }
    }
}
