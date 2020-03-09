public class TableauMetadataSync {
    
    Private  String username;
    private   string password;
    private   string url;
    private  String site;
    private String serverId;
    private TableauAPI tableauAPI;
    public TableauMetadataSync(String username,String password,string url,string site,String serverId){
        this.username=username;
        this.password=password;
        this.url=url;
        this.site=site;
        this.serverId=serverId;
        tableauAPI= new TableauAPI(username,password,url,site);
    }
   
    public  void sync(){
        List<BI_Site__c> bisites = new List<BI_Site__c>();
        List<BiWorkbook__c> biworkbooks = new List<BiWorkbook__c>();
        List<BI_Dashboard__c> bidashboards = new List<BI_Dashboard__c>();
        Set<BI_Sheet__c> bisheets = new Set<BI_Sheet__c>();
        Set<BiProject__c> biprojects= new Set<BiProject__c>();
        List<BI_Dashboard_Sheet__c> bidashboardsheets= new List<BI_Dashboard_Sheet__c>();
        Set<BiField__c> bifields = new Set<BiField__c>();
        List<BI_Sheet_Field__c> bisheetfields = new List<BI_Sheet_Field__c>();
        
        
        getBISites(bisites);
        getBIWorkbooks(biprojects,biworkbooks);
        getBIDashboards(bidashboards);
        getBISheets(bisheets,bidashboardsheets);
        getBISheetFields(bifields,bisheetfields);
        
        upsert bisites External_ID__c;
        upsert new List<BiProject__c>(biprojects) External_ID__c;
        upsert biworkbooks External_ID__c;
        upsert bidashboards External_ID__c;
        upsert new List<BI_Sheet__c>(bisheets) External_ID__c;
        upsert bidashboardsheets Unique_Key__c;
        upsert new List<BiField__c>(bifields) External_ID__c;
        upsert bisheetfields Unique_Key__c;
    }
    
    public void getBISites(List<BI_Site__c> bisites){
        List<Site> sites=tableauAPI.getTableauSites();
        for(Site site:sites){
            BI_Site__c bisite = new BI_Site__c(Name=site.Name,
                                               External_ID__c=site.luid,
                                               External_URL__c=url +'/#/site/'+site.Name+'/home',
                                               BI_Server__c=serverId);
            bisites.add(bisite);
        }
    }
    
    public void getBIWorkbooks(Set<BiProject__c> biprojects,List<BiWorkbook__c> biworkbooks){
        List<Workbook> workbooks=tableauAPI.getWorkbooks();
        for(Workbook workbook:workbooks){
            BiProject__c biproject=new BiProject__c(Name=workbook.projectName,
                                                    External_ID__c=workbook.projectVizportalUrlId,
                                                    BI_Site__r=new BI_Site__c(External_ID__c=workbook.site.luid),
                                                    External_URL__c=url +'/#/site/'+workbook.site.name+'/projects/'+workbook.projectVizportalUrlId);
            biprojects.add(biproject);
            BiWorkbook__c biworkbook= new BiWorkbook__c(Name=workbook.name,
                                                        External_ID__c=workbook.luid,
                                                        BiProject__r= new BiProject__c(External_ID__c=workbook.projectVizportalUrlId),
                                                        External_URL__c=url +'/#/site/'+workbook.site.name+'/workbooks/'+workbook.vizportalUrlId);
            biworkbooks.add(biworkbook);
        }
    }
    
    public void getBIDashboards(List<BI_Dashboard__c> bidashboards){
        List<Dashboard> dashboards= tableauAPI.getDashboards();
        for(Dashboard dashboard:dashboards){
            system.debug('Dashbaords name'+dashboard.name);
            String thumbnail=tableauAPI.getThumbnail(dashboard.workbook.site.luid,dashboard.workbook.luid,dashboard.luid);
            BI_Dashboard__c bidashboard= new BI_Dashboard__c(Name=dashboard.name,
                                                             External_ID__c=dashboard.luid,
                                                             Thumbnail__c=thumbnail,
                                                             BI_Workbook__r=new BiWorkbook__c(External_ID__c=dashboard.workbook.luid));
            bidashboards.add(bidashboard);
        }
    }
    
    public void getBISheets(Set<BI_Sheet__c> bisheets,List<BI_Dashboard_Sheet__c> bidashboardsheets){
        List<Sheet> sheets= tableauAPI.getSheets();
        for(Sheet sheet:sheets){
            String thumbnail;
            if(sheet.luid!=''){
                thumbnail =tableauAPI.getThumbnail(sheet.workbook.site.luid,sheet.workbook.luid,sheet.luid);
            }else{
                thumbnail='preview is not available';
            }
            List<Dashboard> containedInDashboards=sheet.containedInDashboards;
            if(containedInDashboards.size() != 0){
                for(Dashboard dashboard:containedInDashboards){
                    BI_Sheet__c bisheet= new BI_Sheet__c(Name=sheet.name,
                                                         Thumbnail__c=thumbnail,
                                                         External_ID__c=(sheet.luid=='')?sheet.id:sheet.luid,
                                                         Workbook__r=new BiWorkbook__c(External_ID__c=dashboard.workbook.luid));
                    bisheets.add(bisheet);
                    BI_Dashboard_Sheet__c bidashboardsheet = new BI_Dashboard_Sheet__c(Unique_Key__c=((sheet.luid=='')?sheet.id:sheet.luid)+dashboard.luid,
                                                                                       BI_Dashboard__r= new BI_Dashboard__c(External_ID__c=dashboard.luid),
                                                                                       BI_Sheet__r = new BI_Sheet__c(External_ID__c=(sheet.luid=='')?sheet.id:sheet.luid));
                    bidashboardsheets.add(bidashboardsheet);
                }}else{
                    BI_Sheet__c bisheet= new BI_Sheet__c(Name=sheet.name,
                                                         Thumbnail__c=thumbnail,
                                                         External_ID__c=(sheet.luid=='')?sheet.id:sheet.luid,
                                                         Workbook__r=new BiWorkbook__c(External_ID__c=sheet.workbook.luid)); 
                    bisheets.add(bisheet);
                }
        }
    }
    
    public void getBISheetFields(Set<BiField__c> bifields,List<BI_Sheet_Field__c> bisheetfields){
        List<SheetField> sheetfields= tableauAPI.getFields();
        for(SheetField sheet:sheetfields){
            for(SheetField.Field field:sheet.sheetFieldInstances){
                BI_Sheet_Field__c bisheetfield= new BI_Sheet_Field__c(Unique_Key__c=field.id+((sheet.luid=='')?sheet.id:sheet.luid),
                                                                      BI_Field__r= new BiField__c(External_ID__c=field.id),
                                                                      BI_Sheet__r=new BI_Sheet__c(External_ID__c=(sheet.luid=='')?sheet.id:sheet.luid));
                bisheetfields.add(bisheetfield);
                BiField__c bifield= new BiField__c(Name=field.name,
                                                   External_ID__c=field.id,
                                                   Type__c=field.typename);
                bifields.add(bifield);
            }}
    }
}