public with sharing class DatasetRecordInfoController {
    @AuraEnabled(Cacheable=true)
    public static List<String> getRecordInfo(String datasetOrFamilyName) {
        List<String> recordInfo = new List<String>();

        List<Data_Set__c> cDatasetList = [
            SELECT ID
            FROM Data_Set__c
            WHERE NAME = :datasetOrFamilyName
        ];
        if (cDatasetList.size() > 0) {
            recordInfo.add(cDatasetList[0].ID);
            recordInfo.add('Data_Set__c');
            return recordInfo;
        }

        // List<Product_Family__c> cProductFamilyList = [
        //     SELECT ID
        //     FROM Product_Family__c
        //     WHERE NAME = :productOrFamilyName
        // ];
        // if (cProductFamilyList.size() > 0) {
        //     recordInfo.add(cProductFamilyList[0].ID);
        //     recordInfo.add('Product_Family__c');
        //     return recordInfo;
        // }
        return null;
    }
}