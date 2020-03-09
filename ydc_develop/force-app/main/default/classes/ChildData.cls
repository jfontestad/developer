public class ChildData {
    public String name;
     public String parent;
     public String url;
     public String objectType; 
     public String relationshipName;
     public Id id;   
     public ChildData(String name,String parent,String url,String objectType,String relationshipName,Id id) {
     this.name = name;
     this.parent=parent;
     this.url=url;
     this.objectType=objectType;
     this.relationshipName=relationshipName;
     this.id=id;
     }
 }