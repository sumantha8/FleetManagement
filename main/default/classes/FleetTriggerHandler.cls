public class FleetTriggerHandler {
    
    Public static Final Id Bus_FleetRT = Schema.SObjectType.Fleet__c.getRecordTypeInfosByDeveloperName().get('Bus').getRecordTypeId();
    public static Map<String,Fleet_Resale_Calculation__c > defaultConfiguration = Fleet_Resale_Calculation__c.getall();
    
    public static void calculateResaleValue(List<Fleet__c> newFleet, Map<ID, Fleet__c> oldFleetMap, Boolean isInsertOrUndelete, Boolean isUpdate){
        if(newFleet != null && !newFleet.isEmpty()){
            for(Fleet__c fleet : newFleet){
                system.debug('new fleet-- 1 '+fleet);
                //system.debug('new fleet-- 1 '+oldFleetMap.get(fleet.Id));
                system.debug('new RT-- 1 '+fleet.RecordTypeId+'-'+Bus_FleetRT);
                //system.debug('new status-- 1 '+fleet.Current_status__c+'-'+oldFleetMap.get(fleet.Id).Current_status__c);
                //system.debug('new max cap-- 1 '+fleet.Maximum_Capacity__c+'-'+oldFleetMap.get(fleet.Id).Maximum_Capacity__c);
                //system.debug('new year-- 1 '+fleet.Year__c+'-'+oldFleetMap.get(fleet.Id).Year__c);
                if(fleet.RecordTypeId == Bus_FleetRT && fleet.Current_status__c == 'Ready For Use' && String.isNotBlank(fleet.Maximum_Capacity__c) && 
                   (oldFleetMap == null || (oldFleetMap != null && ((fleet.Current_status__c != oldFleetMap.get(fleet.Id).Current_status__c) || 
                                                                    (fleet.Maximum_Capacity__c != oldFleetMap.get(fleet.Id).Maximum_Capacity__c) ||
                                                                    (fleet.Year__c  != oldFleetMap.get(fleet.Id).Year__c ))))){
                                                                        system.debug('new fleet-- 2 '+fleet.Bus_ID__c);
                                                                        computeResaleValueForFleet(fleet);
                                                                    }
            }  
        }
    }
    
    public static void computeResaleValueForFleet(Fleet__c fleet){
        try{
            Decimal sellingPrice = defaultConfiguration.containsKey(fleet.Maximum_Capacity__c+'-Passenger') ? defaultConfiguration.get(fleet.Maximum_Capacity__c+'-Passenger').value__c : 100000;
            if(fleet.Year__c < (defaultConfiguration.containsKey('Fleet Historic Year') ? defaultConfiguration.get('Fleet Historic Year').Metrics__c : 1972)){
                string action = defaultConfiguration.containsKey('Fleet Historic Year') ? defaultConfiguration.get('Fleet Historic Year').Action__c  : 'Increase';
                if(action == 'Increase'){
                    sellingPrice += sellingPrice*(defaultConfiguration.containsKey('Fleet Historic Year') ? defaultConfiguration.get('Fleet Historic Year').value__c : 34)/100; 
                }else{
                    sellingPrice -= sellingPrice*(defaultConfiguration.containsKey('Fleet Historic Year') ? defaultConfiguration.get('Fleet Historic Year').value__c : 34)/100;
                }
            }
            
            if(fleet.Air_conditioned__c){
                string action = defaultConfiguration.containsKey('Air Conditioning') ? defaultConfiguration.get('Air Conditioning').Action__c  : 'Increase';
                if(action == 'Increase'){
                    sellingPrice += sellingPrice*(defaultConfiguration.containsKey('Air Conditioning') ? defaultConfiguration.get('Air Conditioning').value__c : 3)/100; 
                }else{
                    sellingPrice -= sellingPrice*(defaultConfiguration.containsKey('Air Conditioning') ? defaultConfiguration.get('Air Conditioning').value__c : 3)/100;
                }
            }
            if(fleet.Odometer_Reading__c > (defaultConfiguration.containsKey('Millaege') ? defaultConfiguration.get('Millaege').Metrics__c : 100000)){
                string action = defaultConfiguration.containsKey('Millaege') ? defaultConfiguration.get('Millaege').Action__c  : 'Reduce';
                Decimal milesOverReducedPrice = (fleet.Odometer_Reading__c - (defaultConfiguration.containsKey('Millaege') ? defaultConfiguration.get('Millaege').Metrics__c : 100000))*(defaultConfiguration.containsKey('Millaege') ? defaultConfiguration.get('Millaege').value__c : 0.10);
                if(action == 'Reduce'){
                    sellingPrice -= milesOverReducedPrice;
                }else{
                    sellingPrice += milesOverReducedPrice;
                }
            }
            fleet.Resale_Value__c = sellingPrice;
            system.debug('new fleet-- 3'+fleet.Resale_Value__c);
        }catch(Exception ex){
            system.debug('Exception Occurred in computeResaleValueForFleet for :'+fleet+' ::: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Fleet__c> getFleetInformation(){
        return [SELECT Id, Name, Air_conditioned__c, Bus_ID__c, Current_status__c, Maximum_Capacity__c, Number_of_wheels__c, Odometer_Reading__c, Resale_Value__c, Year__c,Image_URL__c FROM Fleet__c ORDER By LastModifiedDate DESC Limit 50 ];
    }
}