trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    // Check if Disable_Trigger custom setting is checked
    if(Automation_Flags__c.getinstance(UserInfo.getProfileId()).Disable_Triggers__c != true) {
        AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size, Trigger.old, Trigger.new);
        if( Trigger.isInsert )
        {
            if(Trigger.isBefore)
            {
                handler.OnBeforeInsert();
            }
            else
            {
                handler.OnAfterInsert();
            }
        }
        else if ( Trigger.isUpdate )
        {
            if(Trigger.isBefore)
            {
                handler.OnBeforeUpdate();
            }
            else
            {
                handler.OnAfterUpdate();
            }
        }
    }
}