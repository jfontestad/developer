({
    Import_Tableau_MD : function(component, event, helper) {
         var rid = component.get("v.recordId");
        alert('CLICK OK to start Metadata Sync for Tablueau Server Id:'+rid);
        var action= component.get("c.call_Tab_API");
        action.setParams({recid: rid});
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var retBI = response.getReturnValue();
                alert(state+" : Tableu Metadata Synced successfully");
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                 if (errors[0] && errors[0].message) {
                        alert("Error message: " +
                                 errors[0].message);
                    }

            }
             else {
                    alert("Unknown error");
                }
             $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
       
    }
})