public class CallTableauSyncAPI {
    @auraEnabled
    public static BI__c call_Tab_API(id recid){
        BI__c BIServer = [select id,name, site__c, username__c, type__c, port__c, host_name__c, password__c 
                          from BI__c where id = :recid];
        system.debug('Inside Server Controller:'+BIServer);
        try{
      //  TableauMetadataSync sync=new TableauMetadataSync(BIServer.Username__c,BIServer.Password__c,BIServer.Host_Name__c,BIServer.Site__c,recid);
        //sync.sync();
        } catch(exception e){
            throw new AuraHandledException('Error:'+e);
        }
        
        return BIServer;
    }

}