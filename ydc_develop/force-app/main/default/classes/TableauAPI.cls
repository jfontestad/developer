public class TableauAPI {  
    private String username;
    private string password;
    private string url;
    private String site;
    public TableauAPI(String username, String password, String url, String site){
        this.username=username;
        this.password=password;
        this.site=site;
        this.url=url;
    }
    public  string getToken(){
        string token;        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+'/api/3.6/auth/signin');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        String body='{ "credentials": { "name": "'+username+'","password": "'+password+'","site": {"contentUrl": "'+site+'"}}}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            // System.debug(response.getBody());
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> tokenMap = (Map<String, Object>) result.get('credentials');
            token= (String) tokenMap.get('token');
            
        }
        return token;
    }
    
    public List<Site> getTableauSites(){
        List<Site> site = new List<Site>();
        String getSitesQuery='"{tableauSites { id luid name uri } }"';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+'/api/metadata/graphql');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        request.setHeader('X-Tableau-Auth', getToken());
        String body='{"query":'+ getSitesQuery	+'}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
            String result = response.getBody();
            JSONParser parser = JSON.createParser(result);
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken()==JSONToken.START_ARRAY && parser.getCurrentName()=='tableauSites'){
                    site=(List<Site>)parser.readValueAs(Site[].class);
                    return site;
                }}}
        return site;
    }
    public List<Workbook> getWorkbooks(){
        List<Workbook> workbooks = new List<Workbook>();
        String getWorkbookQuery='"{workbooks{id luid name createdAt updatedAt description owner {id luid name username email} vizportalUrlId projectName projectVizportalUrlId site{id name luid uri}}}"';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+'/api/metadata/graphql');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        request.setHeader('X-Tableau-Auth', getToken());
        String body='{"query":'+ getWorkbookQuery	+'}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
            String result = response.getBody();
            JSONParser parser = JSON.createParser(result);
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken()==JSONToken.START_ARRAY && parser.getCurrentName()=='workbooks'){
                    workbooks=(List<Workbook>)parser.readValueAs(Workbook[].class);
                    return workbooks;
                }}}
        return workbooks;
    }
    public List<Dashboard> getDashboards(){
        List<Dashboard> dashboards = new List<Dashboard>();
        String getdashboardsQuery='"{dashboards{id luid name workbook{id luid name createdAt updatedAt description owner {id luid name username email} vizportalUrlId projectName projectVizportalUrlId site{id name luid uri}}}}"';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+'/api/metadata/graphql');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        request.setHeader('X-Tableau-Auth', getToken());
        String body='{"query":'+ getdashboardsQuery	+'}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
            String result = response.getBody();
            JSONParser parser = JSON.createParser(result);
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken()==JSONToken.START_ARRAY && parser.getCurrentName()=='dashboards'){
                    dashboards=(List<Dashboard>)parser.readValueAs(Dashboard[].class);
                    return dashboards;
                }}}
        return dashboards;
    }
    public List<Sheet> getSheets(){
        List<sheet> sheets = new List<Sheet>();
        String getSheetsQuery='"{sheets{id luid name path workbook{id luid name createdAt updatedAt description owner {id luid name username email} vizportalUrlId projectName projectVizportalUrlId site{id name luid uri}}containedInDashboards{id luid name workbook{id luid name createdAt updatedAt description owner {id luid name username email} vizportalUrlId projectName projectVizportalUrlId site{id name luid uri}}}}}"';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+'/api/metadata/graphql');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        request.setHeader('X-Tableau-Auth', getToken());
        String body='{"query":'+ getSheetsQuery	+'}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
            String result = response.getBody();
            JSONParser parser = JSON.createParser(result);
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken()==JSONToken.START_ARRAY && parser.getCurrentName()=='sheets'){
                    sheets=(List<Sheet>)parser.readValueAs(sheet[].class);
                    return sheets;
                }}}
        return sheets;
    }
    public List<SheetField> getFields(){
        List<SheetField> sheetfields = new List<SheetField>();
        String getSheetFieldQuery='"{sheets{id luid name sheetFieldInstances{description id name __typename}}}"';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+'/api/metadata/graphql');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Accept', 'application/json;charset=UTF-8');
        request.setHeader('X-Tableau-Auth', getToken());
        String body='{"query":'+ getSheetFieldQuery	+'}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
            String result = response.getBody();
            JSONParser parser = JSON.createParser(result);
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken()==JSONToken.START_ARRAY && parser.getCurrentName()=='sheets'){
                    sheetfields=(List<SheetField>)parser.readValueAs(SheetField[].class);
                    return sheetfields;
                }}}
        return sheetfields;
    }
    public  String getThumbnail(String siteId, String workbookId, String viewId){
        String result;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url+'/api/3.6/sites/'+siteId+'/workbooks/'+workbookId+
                            '/views/'+viewId+'/previewImage');
        request.setMethod('GET');
        request.setHeader('X-Tableau-Auth', getToken());
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
            result= 'Thumbnail not available';
        } else {
            // System.debug(response.getBody());
            system.debug('Able to XXXXXXX');
            Blob image = response.getBodyAsBlob();
            string stringForm = EncodingUtil.base64Encode(image);
            result='<img alt="User-added image" src="data:image/jpeg;base64,'+ stringForm+ '"></img>';
            
        } 
        return result;
    }
    
    
}