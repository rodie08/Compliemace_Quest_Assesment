/*
Class Name :-NonconformanceHandler
Developer name : Rohit Rawat
Date : &/8/23
Description : - Class will craete/update the Case Record
*/
public class NonconformanceHandler {
    public static boolean stoprecursion = false;
    public static void updateCaseRelatedNonconformance(List<SQX_Nonconformance__c> nonconformanceList){
        try{
            Set<String> listOfCaseNumber = new Set<String>();
            List<Case> updateCaseList = new List<Case>();
            Map<String,SQX_Nonconformance__c> caseNumberVsNonconformanceMap = new  Map<String,SQX_Nonconformance__c>();
            Set<String> casesToUpdate =new Set <String>(); 
            
            for(SQX_Nonconformance__c ncInstance : nonconformanceList){
                if(ncInstance.QMS_Reference_Number__c != null){
                    listOfCaseNumber.add(ncInstance.QMS_Reference_Number__c);  
                }
                if(!caseNumberVsNonconformanceMap.containsKey(ncInstance.QMS_Reference_Number__c)){
                    caseNumberVsNonconformanceMap.put(ncInstance.QMS_Reference_Number__c, ncInstance);
                }
            }
           // system.debug('calss caseNumberVsNonconformanceMap>>>> ' + caseNumberVsNonconformanceMap);
            //system.debug(' calss listOfCaseNumber>>>> ' + listOfCaseNumber);
            if(!listOfCaseNumber.isEmpty()){
                for(case caseObj : [SELECT Id , CaseNumber from Case WHERE CaseNumber IN : listOfCaseNumber AND  Stop_Recursion__c = false]){
                    caseObj.Nonconformance__c = caseNumberVsNonconformanceMap.get(caseObj.CaseNumber).Id;
                    caseObj.Stop_Recursion__c=true;
                    NonconformanceHandler.updateCase(JSON.serialize(caseObj));
                }  
            }
        }catch(Exception exp){
            system.debug(' calss Error:::: '+ exp.getMessage()+' line ::: '+exp.getLineNumber());
        }
    }
    @future
    public static void updateCase(String caseIds){
        try{
            Case caseObj =(Case)JSON.deserialize(caseIds,Case.class);
           // system.debug('caseObj::::'+caseObj);
            if( caseObj !=null){
                Database.UPDATE(caseObj);
            }
        }catch(Exception exp){
            system.debug('  Error:::: '+ exp.getMessage()+' line ::: '+exp.getLineNumber());
        }
    }
}