from __future__ import print_function

import json
import logging
from simple_salesforce import Salesforce
from simple_salesforce import SFType
import boto3


log = logging.getLogger()
log.setLevel(logging.DEBUG)

def describe(sf):
    return (lambda obj: SFType(obj["name"], sf.session_id, sf.sf_instance, sf.sf_version, sf.proxies).describe())


def handler(event, context):
    log.debug("Received event {}".format(json.dumps(event)))
    sf = Salesforce(instance_url=event["instance_url"], session_id=event["session_id"])
    objs = sf.describe()["sobjects"]
    objects = map(describe(sf),objs)   
    client = boto3.client("dynamodb") 
    client.batch_write_item(RequestItems={'sobs-metadata-dev':map((lambda obj: {'PutRequest':{'Item':obj}}),objects)})

        
    return {}
