trigger FleetTrigger on Fleet__c (before insert, before update) {
    if(Trigger.isInsert){
        FleetTriggerHandler.calculateResaleValue(trigger.new, null, true, false);
    }else if(Trigger.isUpdate){
        FleetTriggerHandler.calculateResaleValue(trigger.new, trigger.oldMap, false, true);
    }
}