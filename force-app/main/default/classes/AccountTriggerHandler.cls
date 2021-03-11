public class AccountTriggerHandler {
    private boolean isExecuting = false;
    private integer size = 0;
    private List<Account> trgOld;
    private List<Account> trgNew;
    private static final String API_KEY = EmailParameters__c.getinstance(UserInfo.getProfileId()).API_KEY__c;
    private static final String API_URL = EmailParameters__c.getinstance(UserInfo.getProfileId()).API_URL__c;
    private static final String SENDER_EMAIL = EmailParameters__c.getinstance(UserInfo.getProfileId()).SENDER_EMAIL__c;
    private static final String TemplateId = EmailParameters__c.getinstance(UserInfo.getProfileId()).Template_ID__c;

    public AccountTriggerHandler(boolean isExecuting, integer size, list<Account> trgOld, List<Account> trgNew) {
        this.isExecuting = isExecuting;
        this.size = size;
        this.trgOld = trgOld;
        this.trgNew = trgNew;    
    }

    public void OnBeforeInsert()
    {
        // BeforeInsert Placeholder
    }
    public void OnAfterInsert()
    {
        If(!System.isBatch()){ // Dont enter the block if code is running in batch context
            for (Account a : trgNew) {
                if (a.name.contains('Bank') & a.Account_Email__c != null) { // If account Name matches Bank, send welcome email
                    sendemail(a.Account_Email__c);
            }
        }
        }
    }
    public void OnAfterUpdate()
    {
        // AfterUpdate Placeholder
    }
    public void OnBeforeUpdate()
    {
       // BeforeUpdate Placeholder
    }

    @future(callout=true)
    public static void sendemail(String to_address) {
        try {
            System.debug(TemplateId);
            EmailTemplate e = [select id, name, Subject, HtmlValue from EmailTemplate where id = :TemplateId];
            String sBody = 'from=' + SENDER_EMAIL  + '&to=' + to_address + ' &subject=' + e.Subject + '&html=' + e.HtmlValue;
            Blob headerValue = Blob.valueOf('api'+ ':' + API_KEY);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', authorizationHeader);
            req.setBody(sBody);
            req.setHeader('Content-Length', string.valueOf(sBody.length()));
            req.setEndPoint(API_URL);
            req.setMethod('POST');
            req.setBody(sBody);
            System.debug('email req: ' + req);
            if ( !Test.isRunningTest() ){
                HttpResponse res = new Http().send(req);
            }
        }
        catch (AsyncException e) {
            System.debug('There is an issue with asynchronous operation' + e);
        }
        catch (CalloutException e) {
            System.debug('There is an issue with the callout' + e);
        }
        catch (Exception e) {
            System.debug('There is an issue with the callout' + e);
        } 
    }
}