@isTest
public class TestDataFactory {
    
    public static Database__c createDatabase(String name) {
        Database__c obj = new Database__c();
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static Schema__c createSchema(Database__c db, String name) {
        Schema__c obj = new Schema__c();
        obj.Database__c = db.Id;
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static Table__c createTable(Schema__c sch, String name) {
        Table__c obj = new Table__c();
        obj.Schema__c = sch.Id;
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static Column__c createColumn(Table__c tbl, String name) {
        Column__c obj = new Column__c();
        obj.Table__c = tbl.Id;
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static BiProject__c createBiProject(String name) {
        BiProject__c obj = new BiProject__c();
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static BiWorkbook__c createBiWorkbook(BiProject__c p, String name) {
        BiWorkbook__c obj = new BiWorkbook__c();
        obj.BiProject__c = p.Id;
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static BiView__c createBiView(BiWorkbook__c wb, String name) {
        BiView__c obj = new BiView__c();
        obj.BiWorkbook__c = wb.Id;
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static BiField__c createBiField(BiView__c v, String name) {
        BiField__c obj = new BiField__c();
        obj.BI_View__c = v.Id;
        obj.Name = name;
        insert obj;
        return obj;
    }
    
    public static BiField_Column__c createBiFieldColumn(Column__c c, BiField__c f) {
        BiField_Column__c obj = new BiField_Column__c();
        obj.Column__c = c.Id;
        obj.BI_Field__c = f.Id;
        insert obj;
        return obj;
    }
     public static BiField_Column__c createColumnBifield( BiField__c f, Column__c c) {
        BiField_Column__c obj = new BiField_Column__c();
        obj.Column__c = c.Id;
        obj.BI_Field__c = f.Id;
        insert obj;
        return obj;
    }
    public static Term__c createTerm(String name) {
        Term__c obj = new Term__c();
        obj.Name = name;
        insert obj;
        return obj;
    }
    public static Data_Quality_Rules__c createDataQualityRule(String name) {
        Data_Quality_Rules__c obj = new Data_Quality_Rules__c();
        obj.Name = name;
        insert obj;
        return obj;
    }
    public static Data_Element__c createDataElement(String name) {
        Data_Element__c obj = new Data_Element__c();
        obj.Name = name;
        insert obj;
        return obj;
    }
    public static File_System__c createFileSystem(String name) {
        File_System__c obj = new File_System__c();
        obj.Name = name;
        insert obj;
        return obj;
    }
    public static Folder__c createFolder(File_System__c filesystem,String name) {
        Folder__c obj = new Folder__c();
        obj.Name = name;
        obj.File_System__c=filesystem.Id;
        insert obj;
        return obj;
    }
    public static File__c createFile(File_System__c filesystem,Folder__c folder,String name) {
        File__c obj = new File__c();
        obj.Name = name;
        obj.File_System__c =filesystem.Id;
        obj.Folder__c=folder.Id;
        insert obj;
        return obj;
    }
    public static Field__c createField(File__c file, String name) {
        Field__c obj = new Field__c();
        obj.Name = name;
        obj.File__c=file.Id;
        insert obj;
        return obj;
    }
    public static Community__c createCommunity(String name) {
        Community__c obj = new Community__c();
        obj.Name = name;
        insert obj;
        return obj;
    }
     public static Glossary__c createGlossary(Community__c community, String name) {
        Glossary__c obj = new Glossary__c();
        obj.Name = name;
        obj.Community__c=community.Id;
        insert obj;
        return obj;
    }
     public static Term__c createTerm(Glossary__c glossary, String name) {
        Term__c obj = new Term__c();
        obj.Name = name;
        obj.Glossary__c=glossary.Id;
        insert obj;
        return obj;
    }
    public static Term_Column__c createColumnTerm(Column__c c, Term__c f) {
        Term_Column__c obj = new Term_Column__c();
        obj.Column__c = c.Id;
        obj.Term__c = f.Id;
        insert obj;
        return obj;
    }

}