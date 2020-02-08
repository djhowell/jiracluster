#!/bin/bash
DEPLOY_DIR=/var/tmp/azure.$$

echo "DEPLOY DIR: ${DEPLOY_DIR}"
mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR
git clone git@bitbucket.org:atlassian/atlassian-azure-deployment.git

# From https://hello.atlassian.net/wiki/spaces/DCD/pages/374021731/Azure+Marketplace+Update+Offering
cd atlassian-azure-deployment
find . -name mainTemplate.json | xargs -L1 sed -i bak 's_https://bitbucket.org/atlassian/atlassian-azure-deployment/raw/master/[a-z]*/_[deployment().properties.templateLink.uri]_g'

for product in jira confluence bitbucket
do
	PRODUCT_ZIP=/tmp/$product.$(date +%Y%m%d%H%M).zip
	printf "Creating zip for product: $product at $PRODUCT_ZIP\n"

	cd $DEPLOY_DIR/atlassian-azure-deployment/$product
	zip -qr $PRODUCT_ZIP createUiDefinition.json mainTemplate.json nestedtemplates scripts templates
done

rm -fr $DEPLOY_DIR

