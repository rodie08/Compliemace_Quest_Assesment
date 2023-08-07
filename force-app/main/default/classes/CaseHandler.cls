/*
Class Name :-CaseHandler
Developer name : Rohit Rawat
Date : &/8/23
Description : - Claseed will craete/update the Case Record
*/

public class CaseHandler {
    public static boolean stoprecursion = false; //For stoprecursion  
    public static void createNonconformanceForCase(List<Case> caseList){
        try{
            List<SQX_Nonconformance__c> insertNonconformanceList = new List<SQX_Nonconformance__c>();
            List<Case> casesToUpdate = new List<Case>();
            Map<String,SQX_Nonconformance__c> caseNumberVSNonconformanceRecord = new  Map<String,SQX_Nonconformance__c>();
            
            system.debug('caseList::: '+caseList.size());
            for(Case caseObj : caseList){
                if(caseObj.Type == 'Problem'){
                    SQX_Nonconformance__c  newNonconformancRecord = new SQX_Nonconformance__c();
                    newNonconformancRecord.Description__c=caseObj.Description;
                    newNonconformancRecord.Priority__c=caseObj.Priority;
                    newNonconformancRecord.QMS_Reference_Number__c=caseObj.CaseNumber;
                    newNonconformancRecord.Title__c=caseObj.Subject;
                    insertNonconformanceList.add(newNonconformancRecord);  
                }
            }
            system.debug('insertNonconformanceList::: '+insertNonconformanceList); // inserting the SQX_Nonconformance__c
            if(!insertNonconformanceList.isEmpty() && insertNonconformanceList.size() > 0){
                Database.insert(insertNonconformanceList);
            }
        }catch(Exception exp){
            system.debug('Error:::: '+ exp.getMessage()+' line ::: '+exp.getLineNumber());
        }
    }
    
    
    // This Method used to update the Case Record
    public static void checkPriorNonconformanceRecord(List<Case> caseList){
        try{
            Set<String> caseNumberSet = new Set<String>();
            Map<String,SQX_Nonconformance__c> caseNumberVsNonconformanceMap = new Map<String,SQX_Nonconformance__c>(); // Map of Case number nad its SQX_Nonconformance__c recrd
            List<Case> storedNonconformanceRecord = new List<Case>();
            
            for(Case caseObj : caseList){
                if(caseObj.Type == 'Problem' && caseObj.Nonconformance__c == null  && caseObj.Stop_Recursion__c == false){
                    system.debug('inside ');
                    //caseObj.Stop_Recursion__c = true;
                    caseNumberSet.add(caseObj.CaseNumber); 
                    caseNumberVsNonconformanceMap.put(caseObj.CaseNumber,null);
                }
            }
            system.debug('caseNumberSet::: '+caseNumberSet);
            if(!caseNumberSet.isEmpty()){
                // Query all the SQX_Nonconformance__c withncase Number to check it case already have the SQX_Nonconformance__c record 
                for(SQX_Nonconformance__c nonObj : [SELECT Priority__c, QMS_Reference_Number__c ,Title__c  , Description__c FROM SQX_Nonconformance__c WHERE QMS_Reference_Number__c IN: caseNumberSet]){
                    if(nonObj !=null)
                        caseNumberVsNonconformanceMap.put(nonObj.QMS_Reference_Number__c,nonObj);
                }
            }
            system.debug('caseNumberVsNonconformanceMap::: '+caseNumberVsNonconformanceMap);
            if(!caseNumberVsNonconformanceMap.isEmpty() || caseNumberVsNonconformanceMap.size() > 0){
                for(Case caseObj : caseList){
                    if(caseNumberVsNonconformanceMap.containsKey(caseObj.CaseNumber) && caseNumberVsNonconformanceMap.get(caseObj.CaseNumber) == null){
                        storedNonconformanceRecord.add(caseObj);
                    }
                }
            }
            system.debug('storedNonconformanceRecord::: '+storedNonconformanceRecord);
            // Reusing  the createNonconformanceForCase method 
            CaseHandler.createNonconformanceForCase(storedNonconformanceRecord);            
        }catch(Exception exp){
            system.debug('Error:::: '+ exp.getMessage()+' line ::: '+exp.getLineNumber());
        }
    }
}