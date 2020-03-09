public without sharing class TableauSyncAPISchedule implements Schedulable {	
    public void execute(SchedulableContext sc) {
        TableauSyncAPINew.tableauQueryAPI();
    }    
}