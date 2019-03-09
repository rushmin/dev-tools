# WSO2 Dev Tools

This repo contains a set of script which help developers to troubleshoor WSO2 products.

The tools are ...

#### 1) find-source.sh - Locates the source location of a given JAR file.

**Story**

As a developer I need to find the exact source code (repo/tag) of a JAR file inside a WSO2 product to troubleshoot issues.

Most of the JAR files shipped with WSO2 products are released using the [Maven release plugin](http://maven.apache.org/maven-release/maven-release-plugin/). This makes sure the POM file of the JAR file contains the SCM information. The script constructs the source repo URL with the SCM information in the POM files. The search extends to the parent POM files when needed.

**Usage**
find-source.sh `<jar-file-location`>

**Example**
```
$ find-source.sh repository/components/plugins/org.wso2.carbon.identity.oidc.dcr_6.0.14.jar
XPath set is empty
DEBUG : Couldn't find SCM information in the pom file of the JAR. Trying the parent pom.
DEBUG : POM URL : https://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/carbon/identity/inbound/auth/oauth2/identity-inbound-auth-oauth/6.0.14/identity-inbound-auth-oauth-6.0.14.pom

Source Location - https://github.com/wso2-extensions/identity-inbound-auth-oauth/tree/v6.0.14
```

#### 2) find-update.sh - Lists the WUM updates which contains the given JAR file.

**Story**
As a developer I need to find the latest WUM update which contains a given jar file to see the latest fixes which the JAR file contains.

**Usage**
find-update.sh `<update-location`> `<jar-name`> [product-home]

**Arguements**

-- update-location
Location where the update archive files reside. e.g. ~/.wum3/updates/wilkes/4.4.0/

-- jar-name
JAR file name to be looked-up for

-- product-home (optional)
Home directory of the WSO2 product. When this argument is present the searched updates will be filtered against the updates in the product.

**Sample**

```
$ find-update.sh ~/.wum3/updates/wilkes/4.4.0/ org.wso2.carbon.identity.oauth_5.3.4.jar .
FOUND - /Users/rushmin/.wum3/updates/wilkes/4.4.0//WSO2-CARBON-UPDATE-4.4.0-0866.zip
FOUND - /Users/rushmin/.wum3/updates/wilkes/4.4.0//WSO2-CARBON-UPDATE-4.4.0-0928.zip
FOUND - /Users/rushmin/.wum3/updates/wilkes/4.4.0//WSO2-CARBON-UPDATE-4.4.0-0981.zip
FOUND - /Users/rushmin/.wum3/updates/wilkes/4.4.0//WSO2-CARBON-UPDATE-4.4.0-1091.zip
DEBUG : Filtered - /Users/rushmin/.wum3/updates/wilkes/4.4.0//WSO2-CARBON-UPDATE-4.4.0-1133.zip
```

#### 3) load-test-runner.sh - A wrapper to Jmeter which helps to organize the tests results when it comes to more than one rest rounds

**Story**

As a developer I need to store the results of a load test in a trackable way along with a snapshot of the script which was used to run the test.

**Usage**
run-load-test.sh `<label`> `<script-file`> `<properties-file`> `<reports-root-directory`>

**Example**
```
$ load-test-runner.sh "is-530-with-fix" "client-credentials-grant/client-credential.jmx" "client-credentials-grant/is530-load-test.properties" "../reports"

Started : 'is-530-with-fix (client-credentials-grant/client-credential.jmx)' with the properties 'client-credentials-grant/is530-load-test.properties'

Reports are stored in  ../reports/1552114625
```
