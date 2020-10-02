#!/bin/bash
DEPLOY_DIR=/var/tmp/azure.$$
RELEASE_DATE=$(date '+%d-%b-%Y %H:%M:00')
BRANCH=${1:-master}

echo "DEPLOY DIR: ${DEPLOY_DIR}"
mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR
git clone git@bitbucket.org:atlassian/atlassian-azure-deployment.git
git clone -b azure_deployments https://bitbucket.org/atlassian/dc-deployments-automation.git

# From https://hello.atlassian.net/wiki/spaces/DCD/pages/374021731/Azure+Marketplace+Update+Offering
cd atlassian-azure-deployment
git checkout ${BRANCH}
find . -name mainTemplate.json | xargs -L1 sed -i .bak 's_https://bitbucket.org/atlassian/atlassian-azure-deployment/raw/master/[a-z]*/_[deployment().properties.templateLink.uri]_g'
find . -name createUiDefinition.json | xargs -L1 sed -i .bak "s/MARKETPLACE_RELEASE_DATE/${RELEASE_DATE}/"

for product in crowd
do
  cd  $DEPLOY_DIR
  zip -r $DEPLOY_DIR/atlassian-azure-deployment/$product/scripts/ansible.zip dc-deployments-automation -x '*.git*'
	PRODUCT_ZIP=/tmp/$product.$(date +%Y%m%d%H%M).zip
	printf "Creating zip for product: $product at $PRODUCT_ZIP\n"
	cd $DEPLOY_DIR/atlassian-azure-deployment/$product
	zip -qr $PRODUCT_ZIP createUiDefinition.json mainTemplate.json nestedtemplates scripts templates
done

rm -fr $DEPLOY_DIR

