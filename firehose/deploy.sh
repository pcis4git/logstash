#!/bin/bash

export $(xargs < env.config)

export LOGSTASH_CONFIGMAP=${THOR_LOGSTASH_APP}-config
export PIPELINE_CONFIGMAP=${THOR_LOGSTASH_APP}-pipeline

kubectl delete configmap $THOR_LOGSTASH_APP -n $KNS
kubectl create configmap $THOR_LOGSTASH_APP -n $KNS \
  --from-literal=THOR_KAFKA_BROKER=$THOR_KAFKA_BROKER \
  --from-literal=THOR_KAFKA_TOPIC=$THOR_KAFKA_TOPIC \
  --from-literal=THOR_KAFKA_GROUP=$THOR_KAFKA_GROUP \
  --from-literal=THOR_DEBUG=$THOR_DEBUG  \
  --from-literal=THOR_ENV=$THOR_ENV

kubectl delete configmap ${LOGSTASH_CONFIGMAP} -n $KNS
kubectl create configmap ${LOGSTASH_CONFIGMAP} -n $KNS \
   --from-file=logstash.yml=./logstash.yml \
   --from-file=pipelines.yml=./pipelines.yml \
   --from-file=log4j2.properties=./log4j2.properties \
   --from-file=aws.cer.txt=./aws.cer.txt \
   --from-file=aws.pk.txt=./aws.pk.txt

kubectl delete configmap ${PIPELINE_CONFIGMAP} -n $KNS
kubectl create configmap ${PIPELINE_CONFIGMAP} -n $KNS \
   --from-file=pipeline.conf=./pipeline.conf \
   --from-file=filter.rb=./filter.rb 

export DEPLOY_DATE_TIME=`date +%Y%m%d_%H%M%S`

cat logstash.deployment.template.yml | sed "s/{{THOR_LOGSTASH_APP}}/$THOR_LOGSTASH_APP/g" | sed "s/{{DEPLOY_DATE_TIME}}/$DEPLOY_DATE_TIME/g" > logstash.deployment.yml
kubectl apply  -f  logstash.deployment.yml -n $KNS
# cat eventhub-logstash.yml


