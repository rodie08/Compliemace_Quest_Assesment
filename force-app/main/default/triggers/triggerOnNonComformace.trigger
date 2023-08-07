trigger triggerOnNonComformace on SQX_Nonconformance__c (After insert) {
    switch on Trigger.OperationType{
        when AFTER_INSERT{
            if(!NonconformanceHandler.stoprecursion){
                NonconformanceHandler.stoprecursion=true;
                NonconformanceHandler.updateCaseRelatedNonconformance(trigger.new);   
            }
        }
    }
}