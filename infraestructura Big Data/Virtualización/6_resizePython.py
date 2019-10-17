from keystoneauth1 import session
from keystoneclient.auth.identity import v3
from novaclient import client
#from glanceclient import clientG
#import novaclient.v1_1.client as client
import os
import time
import glanceclient
from time import sleep

##https://docs.openstack.org/python-novaclient/latest/
print "###################INICIO"


USER_ID='a1360bf519494bd69b4ef9b660306a58'
PASSWORD='databig'
PROJECT_ID='864f9b4399be412895025f682c221902'

auth = v3.Password(auth_url='http://192.168.98.160/identity/v3',user_id=USER_ID,password=PASSWORD,project_id=PROJECT_ID)
sess = session.Session(auth=auth)
sess = session.Session(auth=auth)
nova = client.Client("2", session=sess)

##https://docs.openstack.org/python-glanceclient/latest/reference/apiv2.html
glance = glanceclient.Client("2", session=sess)

##https://docs.openstack.org/python-novaclient/pike/reference/api/v2/flavors.html

print "FLAVORS----------------------------"
flavors= nova.flavors.list()
for flavor in flavors:
    print dir(flavor)
    print "name=",flavor.name,"id=",flavor.id
   
print "______________________________________"

##https://docs.openstack.org/python-novaclient/pike/reference/api/index.html
print "IMAGES----------------------------"
images= glance.images.list()
for image in images:
    print "name=",image.name,"id=",image.id
print "*******************************************"


SERVER_ID='732ac972-8873-49c3-8b29-251490ca1b7b'
FLAVOR_ID='8b2739f7-245d-4c53-84e2-6db1dd485642'
FLAVOR_ID='222'

##DEBERIA HABER CONTROL DE ERROES SOBRE PARAMETROS

instance = nova.servers.get(SERVER_ID)
print 'Resizing!'
nova.servers.resize(SERVER_ID,FLAVOR_ID)
##https://docs.openstack.org/python-novaclient/3.3.3/ref/v2/servers.html
print instance.status
while instance.status != "VERIFY_RESIZE":
    instance = nova.servers.get(SERVER_ID)
    time.sleep(10)
    print instance.status
    
print instance.status
nova.servers.confirm_resize(SERVER_ID)
print 'Resized!'



