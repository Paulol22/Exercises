public class ContactTriggerHandler implements Queueable {
    private List<Contact> primaryContacts;

    public ContactTriggerHandler(List<Contact> primaryContacts) {
        this.primaryContacts = primaryContacts;
    }

    public void execute(QueueableContext context) {
        // Maparea Id-urilor de conturi la numerele de telefon ale contactelor primare
        Map<Id, String> accountToPhoneMap = new Map<Id, String>();
        for (Contact con : primaryContacts) {
            accountToPhoneMap.put(con.AccountId, con.Phone);
        }

        // Obținerea tuturor contactelor care sunt legate de aceleași conturi ca și contactele primare
        List<Contact> contactsToUpdate = [SELECT Id, AccountId, Phone FROM Contact
                                           WHERE AccountId IN :accountToPhoneMap.keySet()
                                           AND Id NOT IN :primaryContacts];

        // Actualizarea numărului de telefon
        for (Contact con : contactsToUpdate) {
            con.Phone = accountToPhoneMap.get(con.AccountId);
        }

        // Actualizare asincronă cu allOrNothing setat la false
        // pentru a preveni inversarea tuturor actualizărilor în cazul în care una dintre ele eșuează
        Database.update(contactsToUpdate, false);
    }
}
