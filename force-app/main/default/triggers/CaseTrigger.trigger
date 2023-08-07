trigger CaseTrigger on Case (before update,After insert) {
    switch on Trigger.OperationType{
        when After_INSERT{
            CaseHandler.createNonconformanceForCase(trigger.new);
        }
        when BEFORE_UPDATE{
            system.debug('BEFORE_UPDATE ');
            for(Case caseObj : Trigger.new){
                if(caseObj.Stop_Recursion__c == false)
                    CaseHandler.checkPriorNonconformanceRecord(trigger.new);  
            }
        }
    }
}