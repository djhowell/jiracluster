False Positive Issues 
The Azure Resource Manager Template Toolkit (arm-ttk) is used to analyse & test the templates, it generates some false positive issues which can be ignored:

| Template | Issue | Notes |
|----------|-------|-------|
| azuredeploy-alerts.json        | IDs Should Be Derived From ResourceIDs Property:      "Id" must use one of the following expressions for  an resourceId property      |   Ids and are using require the WebTestGeolocation location ID as per the docs & examples    |