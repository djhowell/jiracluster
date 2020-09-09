#!/bin/bash
PLAYBOOK_DIR=/var/tmp/playbook.$$
WORKING_DIR=$PWD

echo "PLAYBOOK DIR: ${PLAYBOOK_DIR}"
echo "WORKING DIR: ${WORKING_DIR}"
mkdir -p $PLAYBOOK_DIR

cd $PLAYBOOK_DIR
git clone -b azure_deployments https://bitbucket.org/atlassian/dc-deployments-automation.git dc-deployments-automation
zip -r ansible.zip dc-deployments-automation -x '*.git*'

cd $WORKING_DIR
for product in crowd
do
  printf "Copying playbook zip for product: $product\n"
  pwd
  cp $PLAYBOOK_DIR/ansible.zip ../$product/scripts/
done