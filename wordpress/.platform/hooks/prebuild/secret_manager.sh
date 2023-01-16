#!/bin/bash

SECRETARN=$(/opt/elasticbeanstalk/bin/get-config environment -k SecretRDSARN)
REGION=$(/opt/elasticbeanstalk/bin/get-config environment -k Region)

aws secretsmanager get-secret-value --secret-id $SECRETARN --region $REGION | jq -r '.SecretString' > secret.json