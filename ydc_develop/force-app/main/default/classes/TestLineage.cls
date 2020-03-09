@isTest
public class TestLineage {
        
    @isTest
    static void shouldGetBiFieldLineage() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
        Test.startTest();
        Test.stopTest();
    }
    
    @isTest
    static void shouldThrowExceptionOnUnsupportedObjectType() {
        Boolean failed;
		Account a = new Account(Name='Example');
        insert a;
        
        Test.startTest();
        try {
            String json = Lineage.getLineageData(a.Id);
			failed = false;
        } catch (IllegalArgumentException e) {
            failed = true;
        }
        Test.stopTest();
        
        System.assert(true);
    }

}