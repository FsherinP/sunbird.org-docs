---
title: Build and Deploy
page_title: Build and Deploy
description: Build and Deploy
published: true
allowSearch: true
keywords: Upgrade, Sunbird 3.8.0
---

## Overview

This page details out the jobs required to be run as part of the upgrade from Sunbird release 3.7.0 to release 3.8.0. Use the following table to understand the jobs that need to be executed in order to successfully complete the upgrade. 

### Variables

|Variable Name|Service Name|Comments|
|-------------|------------|--------|
|sunbird_portal_offline_supported_languages|Player Service|This variable should be removed from private <code>Core/common.yml</code> if defined|
|adminutil_refresh_token_secret_key        |Adminutils    |- Go to http://KEYCLOAK_IP:8080/auth/admin/master/console/#/realms/sunbird/keys<br> - Get this secret value from DB, by loging into the keycloak 7 postgres DB and run the query: `SELECT value FROM component_config CC INNER JOIN component C ON(CC.component_id = C.id) WHERE C.realm_id = 'sunbird' and provider_id = 'hmac-generated' AND CC.name = 'secret';`<br> - [More details with pictures are here](https://project-sunbird.atlassian.net/wiki/spaces/DevOps/pages/2281734145/Keycloak+Upgrade+from+3.2.0+to+7.0.1)<br> - This was done as part of release-3.7.0 hotfix|

### Build and Deploy

|Service to be Build|Build Tag|Service to Deploy|Deploy Tag|Comments|
|-------------------|---------|-----------------|----------|--------|
|Build/KnowledgePlatform/FlinkJobs|release-3.8.0_RC4|Deploy/KnowledgePlatform/FlinkJobs|release-3.8.0||
|||Deploy/KnowledgePlatform/KafkaSetup|release-3.8.0||
|Build/KnowledgePlatform/KnowledgePlatform|release-3.8.0_RC9|Deploy/KnowledgePlatform/Learning|release-3.8.0||
|||Deploy/KnowledgePlatform/LoggingFileBeatsVM|release-3.8.0||
|Build/KnowledgePlatform/Yarn|release-3.8.0_RC9|Deploy/KnowledgePlatform/Yarn|release-3.8.0||
|||Provision/AnalyticsSpark|release-3.8.0||
|Build/DataPipeline/AnalyticsCore|release-3.8.0_RC1|Deploy/DataPipeline/AnalyticsCore|release-3.8.0||
|||Deploy/DataPipeline/AnalyticsFetchLogs|release-3.8.0||
|Build/DataPipeline/CoreDataProducts|release-3.8.0_RC1|Deploy/DataPipeline/CoreDataProducts|release-3.8.0||
|Build/DataPipeline/ETLJobs|release-3.8.0_RC4|Deploy/DataPipeline/ETLJobs| release-3.8.0||
|Build/DataPipeline/ETLUserCacheIndexer|release-3.8.0_RC4|Deploy/DataPipeline/ETLUserCacheIndexer|release-3.8.0||
|Build/DataPipeline/EdDataProducts|release-3.8.0_RC5|Deploy/DataPipeline/EdDataProducts|release-3.8.0||
|Build/DataPipeline/FlinkPipelineJobs|release-3.8.0_RC4|Deploy/DataPipeline/FlinkPipelineJobs|release-3.8.0||
|Build/Core/AdminUtils|release-3.7.0_RC1|Deploy/Kubernetes/AdminUtils|release-3.8.0||
|Build/Core/Assessment|release-3.8.0_RC2|Deploy/Kubernetes/Assessment|release-3.8.0||
|Build/Core/Bot|release-3.8.0_RC1|Deploy/Kubernetes/Bot|release-3.8.0||
|Build/Core/Content|release-3.8.0_RC3|Deploy/Kubernetes/Content|release-3.8.0||
|Build/Core/DiscussionsMW|release-3.8.0_RC2|Deploy/Kubernetes/DiscussionsMW|release-3.8.0||
|Build/Core/Groups|release-3.7.0_RC5|Deploy/Kubernetes/Groups|release-3.8.0||
|Build/Core/Keycloak|release-3.8.0_RC1|Deploy/Kubernetes/Keycloak|release-3.8.0||
|Build/Core/KnowledgeMW|release-3.8.0_RC3|Deploy/Kubernetes/KnowledgeMW|release-3.8.0||
|Build/Core/Learner|release-3.8.0_RC9|Deploy/Kubernetes/Learner|release-3.8.0||
|Build/Core/Lms|release-3.8.0_RC5|Deploy/Kubernetes/Lms|release-3.8.0||
|||Deploy/Kubernetes/LoggingFileBeatsVM|release-3.8.0||
|||Deploy/Kubernetes/Monitoring|release-3.8.0||
|Build/Core/Nodebb|release-3.7.0_RC6|Deploy/Kubernetes/Nodebb|release-3.8.0||
|||Deploy/Kubernetes/OnboardAPIs|release-3.8.0||
|Build/Core/Player|release-3.8.0_RC9|Deploy/Kubernetes/Player|release-3.8.0||
|Build/Core/Router|release-3.8.0_RC1|Deploy/Kubernetes/Router|release-3.8.0||
|Build/Core/Taxonomy|release-3.6.0_RC3|Deploy/Kubernetes/Taxonomy|release-3.8.0||
|||Deploy/Kubernetes/UploadSchemas|release-3.8.0||
|Build/Core/Cassandra|release-3.8.0_RC1|Deploy/Kubernetes/Cassandra|release-3.8.0||

### Manual Configurations

| Manual Step | Instruction |
| -------------------- | -------------------- |
| Update jenkins job | Refer [PR1](https://github.com/project-sunbird/sunbird-devops/pull/2322) [PR2](https://github.com/project-sunbird/sunbird-devops/pull/2407) |
| ES Re-indexing | [Run this before deploing learner service](https://project-sunbird.atlassian.net/wiki/spaces/UM/pages/2346156058/SC-2190+ES+scaling+-+reindexing+Org+index) |
| Delete old user index | `curl --location --request DELETE 'localhost:9200/user?pretty'` |
| Delete old org index | `curl --location --request DELETE 'localhost:9200/org?pretty'` |
| User and Org Sync | [Confluence Link](https://project-sunbird.atlassian.net/wiki/spaces/UM/pages/2437480455/SC-2190+sync+tool+for+learner-service) |
| Delete all content and collection entry from KnowledgePlatform redis cache | - <code>redis-cli --scan --pattern do_* &#124; xargs redis-cli del</code><br> - <code>redis-cli --scan --pattern hierarchy_do_* &#124; xargs redis-cli del</code><br> |
| Update the forms | Jira Links - [SB-23481](https://project-sunbird.atlassian.net/browse/SB-23481) [SB-23627](https://project-sunbird.atlassian.net/browse/SB-23627) [SB-23671](https://project-sunbird.atlassian.net/browse/SB-23671) [SB-23859](https://project-sunbird.atlassian.net/browse/SB-23859) [SB-22505](https://project-sunbird.atlassian.net/browse/SB-22505) |
| Run cateogory definition update api | [Confluence Link](https://project-sunbird.atlassian.net/wiki/spaces/SingleSource/pages/2364964876/Course+primaryCategory+Config) |
| Run neo4j cypher script | [Script Link](https://github.com/project-sunbird/sunbird-learning-platform/blob/release-3.8.0/docs/cypher-scripts/release-3.8.0.cypher) |
