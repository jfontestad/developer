@isTest
public class TestTraceability {
    
    @isTest
    static void shouldGetDatabaseTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(db.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetSchemaTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(sch.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetTableTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(tbl.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetColumnTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        Community__c community=TestDataFactory.createCommunity('Community');
        Glossary__c glossary=TestDataFactory.createGlossary(community,'Glossary');
        Term__c term=TestDataFactory.createTerm(glossary,'Term');
        Term_Column__c fc = TestDataFactory.createColumnTerm(col, term);
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(col.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
 
    @isTest
    static void shouldGetBiProjectTraceability() {
		BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(p.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetBiWorkbookTraceability() {
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(wb.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetBiViewTraceability() {
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(v.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetBiFieldTraceability() {
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(f.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
     @isTest
    static void shouldGetFileSystemTraceability() {
        File_System__c fs = TestDataFactory.createFileSystem('File System');
		Folder__c folder = TestDataFactory.createFolder(fs, 'Folder');
		File__c file = TestDataFactory.createFile(fs,folder, 'File');
		Field__c field = TestDataFactory.createField(file, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(fs.Id);
        Test.stopTest();
        
        System.assert(json != null);
    } 
    
         @isTest
    static void shouldGetFolderTraceability() {
        File_System__c fs = TestDataFactory.createFileSystem('File System');
		Folder__c folder = TestDataFactory.createFolder(fs, 'Folder');
		File__c file = TestDataFactory.createFile(fs,folder, 'File');
		Field__c field = TestDataFactory.createField(file, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(folder.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
   
          @isTest
    static void shouldGetFileTraceability() {
        File_System__c fs = TestDataFactory.createFileSystem('File System');
		Folder__c folder = TestDataFactory.createFolder(fs, 'Folder');
		File__c file = TestDataFactory.createFile(fs,folder, 'File');
		Field__c field = TestDataFactory.createField(file, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(file.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
 
             @isTest
    static void shouldGetFieldTraceability() {
        File_System__c fs = TestDataFactory.createFileSystem('File System');
		Folder__c folder = TestDataFactory.createFolder(fs, 'Folder');
		File__c file = TestDataFactory.createFile(fs,folder, 'File');
		Field__c field = TestDataFactory.createField(file, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(field.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }

             @isTest
    static void shouldGetDataQualityRuleTraceability() {
        Data_Quality_Rules__c dqr = TestDataFactory.createDataQualityRule('Data Quality Rule');
        Test.startTest();
    	String json = Traceability.getTraceabilityData(dqr.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
     @isTest
    static void shouldGetTermTraceability() {
       Community__c community=TestDataFactory.createCommunity('Community');
        Glossary__c glossary=TestDataFactory.createGlossary(community,'Glossary');
        Term__c term=TestDataFactory.createTerm(glossary,'Term');
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        Term_Column__c fc = TestDataFactory.createColumnTerm(col, term);
        Test.startTest();
    	String json = Traceability.getTraceabilityData(term.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    @isTest
    static void shouldThrowExceptionOnUnsupportedObjectType() {
        Boolean failed;
		Account a = new Account(Name='Example');
        insert a;
        
        Test.startTest();
        try {
            String json = Traceability.getTraceabilityData(a.Id);
			failed = false;
        } catch (IllegalArgumentException e) {
            failed = true;
        }
        Test.stopTest();
        
        System.assert(true);
    }
    
}