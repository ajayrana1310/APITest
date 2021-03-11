@IsTest
public with sharing class AccountTriggerHandlerTest {
    @isTest
     static void testInsert(){
        Account acc = new Account(name = 'Test Bank', Account_Email__c = 'rana.ajay1310@gmail.com');
        List<Account> listacc = new List<Account>();
        Test.startTest();
        insert acc;
        listacc = [select id from account];
        Test.stopTest();
        System.assertEquals(listacc.size(),1);
    }
    @isTest(SeeAllData=true)
    static void testSendEmail(){
        Test.startTest();
        AccountTriggerHandler.sendemail('rana.ajay1310@gmail.com');
        Test.stopTest();    
    }
}