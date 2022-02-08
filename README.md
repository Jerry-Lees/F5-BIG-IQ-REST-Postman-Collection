# F5 BIG-IQ REST Postman Collection Introduction

A postman collection to perform common BIG-IQ tasks for managing BIG-IP devices via REST

------------

## ***Warning***

This is not for the faint at heart, care must be taken to issue commands in the proper order and watching the results as you progress. Remember, this is a framework for interfacing with the REST API of BIG-IQ. This operates at a very low level and has it's inherent risks of human error.

------------

## Installation

Download the file in the repository and import into your postman installation.

Alternatively, you could link the repository to your local collection by following the tutorial below at postman's site:

https://learning.postman.com/docs/getting-started/importing-and-exporting-data/#importing-via-github-repositories

------------

## Getting Started

Just like building a configuration in TMSH or TM GUI, everything builds on either creating or selecting particular configuration items.
For example, to create a pool, you would need a monitor and pool members consisting of Nodes that have been created and the port to send traffic to. This is all done by issueing queries to the REST API and then storing the needed configuration items' information into the environment variables that are used in later calls to create, modify, or delete objects.

Set the following REQUIRED variables initially:

-BIGIQ_Mgmt

    This is the IP address of the BIG-IQ Configuration manager device that you wish to place changes to BIG-IP configurations via REST.

-UserName

    This is the administrative username to use when making REST calls.

-Password

    This is the password to the administrative account. USE CAUTION: This is stored in clear text, guard this file closely once populated. Unfortunately, Postman doesn't have a feature to prompt the user for information interactively-- despite a feature request being open since 2013.

-SearchDeviceAddress
    This is the management address of the BIG-IP you wish to make changes to, note that some calls will populate the variables related to this as well. While not technically *required*, it is recommended to populate this and run the "Get Device by address" request to ensure the correct BIG-IP is selected.

        https://github.com/postmanlabs/postman-app-support/issues/285

Optionally, once setup above, you may want to set the following variables and pre-populate some information by running some initial calls to the REST API:

-SearchVirtualName

    This is the variable that contains the name of a virtual you wish to search for. Note: it is best to put the exact virtual name in the variable since a substring could return multiple matches and thus possibly cause unexpected behavior

    Note, once populated, you can run the ***Get Virtual Information From Name*** and ***Get remaining Virtual Information*** Requests to populate required information about the virtual server.

## Getting started

To get familiar with the variables in the environment and to test your setup, follow the following get started tasks below.

### Troubleshooting

1. Always check the pre-requisits for the request that had an error and ensure that the appropriate environment variables have correct values

2. Most requests run multiple requests in the javascript in the tests and/or pre-request scripts section of the request, both in the script itself and at the collection level.

#### Specific errors

##### *FAILURE!* BIG-IQ Management address is empty! Please set it in the environment variables to avoid future errors

This is due to the "BIGIQ_Mgmt" variable not being populated in the environment. This is the most common issue with a new installation or when the environment has been cleared. Also, check the other variables related to login as well. There are messsage prompts telling the user what variables are empty in the console log as well.

##### *FAILURE!* BIG-IQ Management user is empty! Please set it in the environment variables to avoid future errors

This is due to the "UserName" variable not being populated in the environment. This is the most common issue with a new installation or when the environment has been cleared. Also, check the other variables related to login as well. There are messsage prompts telling the user what variables are empty in the console log as well.

##### *FAILURE!* BIG-IQ Management password is empty! Please set it in the environment variables to avoid future errors

This is due to the "Password" variable not being populated in the environment. This is the most common issue with a new installation or when the environment has been cleared. Also, check the other variables related to login as well. There are messsage prompts telling the user what variables are empty in the console log as well.

##### Error: [object Object]

This is due, most likely, to a environment variable not being set or a login failing becasue information for login such as credentials or the BIG-IQ address not being populated. In general, look at the console logs for the previous request that was made and check that requests "response body" to see if any errors occured.

#### Error: runtime:extensions~request: request url is empty

This is likely due to leading or trailing whitespace in a user entered parameter, or an other typo, thus causing a search to fail to return any results.

#### "message": "Get document for key: cm/adc-core/working-config/ltm/xxxxx/yyyyy/$filter=name eq '**' returned nothing"

Double check that the value for an environment variable recently entered was put in the "Current Value" column, not the "Initial Value Column".

### Initial test requests

#### READ THIS FIRST

Run this section *ONLY* against a test environment. This mini-guide will take you through modifying the configuration of a virtual server. *DO NOT* use this in a production environment or for a virtual that has impact.

Once the above variables are populted for your environment, you can run "Gather information to start/Get Virtual Information from name" by populating the following variable:

-SearchVirtualName
    This is the virtual server you wish to search for. This would be typically used to populate variables and/or to get the configuration for a virtual server you wish to modify.

After running this, take a look at the environment variables. You should find that a great deal of information is populated about the virtual server its pool, pool's monitor, and the device it is configured on.

Next, run "Gather information to start/Get remaining Virtual Information" and look at the variables again. You should see that more information is populated about the pool.

Next, change the IP Address in "VirtualDestinationAddress" to an unused IP address, 1.1.1.1 should work fine. Also change the description in "VirtualDescription" and the Name of the virtual server in "VirtualName".

Run the "Create Virtual Server from Environment Variables" request and review the created virtual in the BIG-IQ interface.

Next, update the information stored in the environment to reflect the new virtual server by placing the name of teh virtual you created into "SearchVirtualName" and run "NEW-cloudops_3-11430_2_vs". Run "Get Remaining Virtual Information" as well, if you modified/changed pool information.

Finally, create a deployment for the virtual server by runnning the "Create Virtual Deployment without deploy" request. When successful, look at the deployment and ensure there are no unexpected conflicts. Deploy from the GUI. (Note: You CAN deploy from REST, this is not implemented in early releases of this collection on purpose to add a layer of protection.)

You could also modify the virtual server configuration by changing the values, the description or Destination address for example after the running of "Gather information to start/Get remaining Virtual Information" and then running the "Modify Specific Virtual" request followed by a deployment like above.

## Getting to work

The collection preforms many common tasks such as:

### Device Tasks

The most important part of orchestration with BIG-IQ is to tell BIG-IQ what device it is going to create, Read, update, or Delete configiration for. Environment variables for this get popuolated by running the "Gather information to start/Get Device by address" request with the "SearchDeviceAddress" environemnt variable set to the address of the BIG-IP.

When Successful, this will populate the following variables:

DeviceID - Which is the device ID/GUID used as references and in the URI to device specific REST calls.

DeviceSelfLink - Which is the URL used inside the JSON document sent in the request body of REST calls. this should ALWAYS be to the hostname 'localhost'

DeviceSelfURI - Which is the URL used inside the URI for a call to the BIG-IQ REST REST API. This should ALWAYS be to the address of the BIG-IQ device and NOT the hostname 'localhost'.

NewDeviceLink - This is the variable that will be used in REST calls to create new objects and shoudl be the same (initially) as the "DeviceSelfLink"

(In addition some login variables that every requests updates are updated:

AuthToken - This is the token sent back by the REST API and used (and updated) in every call to authenticate the request.

AuthTokenTimeoutTime - This is the time that the token will time out. In BIG-IQ REST this is not updateable like in BIG-IP REST. It is currently not used but could be helpful in troubleshooting. The time is a number representing UTC time.

### Monitor Tasks

more to be added

### Node Tasks

more to be added

### Pool Tasks

more to be added

### Profile Tasks

more to be added

### Virtual Server Tasks

more to be added

### Deployment Tasks

more to be added
