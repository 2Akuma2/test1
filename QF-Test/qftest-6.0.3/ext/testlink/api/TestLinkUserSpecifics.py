#modify those global settings according to your TestLink installation
#Normally you need to replace anything before .../lib/api/xmlrpc.php
#In newer versions the API is located in a separate v1 folder
#serverurl = "http://localhost/testlink-1.9.7/lib/api/xmlrpc.php"
serverurl = "http://localhost/testlink-1.9.7/lib/api/xmlrpc/v1/xmlrpc.php"

#development key, generated under 'My Settings' -> 'API interface'
#press 'Generate a new key' unless you can see a development key
devkey = "d965b4d883817689b94b3d08e9d8be17"

#comma separted list of custom fields in TestLink, which should be shown
#in exported test-case's comment
#custom_fields = ['REQ_FIELD']
custom_fields = []
