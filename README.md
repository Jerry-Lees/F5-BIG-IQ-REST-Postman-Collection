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

### READ THIS FIRST

Run this section *ONLY* against a test environment. This mini-guide will take you through modifying the configuration of a virtual server. *DO NOT* use this example in a production environment or for a virtual that has impact until you feel you understand completely what is happening.

### Initial test requests

Once the above variables are populated for your environment, you can run "Gather information to start/Get Virtual Information from name" by populating the following variable:

-SearchVirtualName
    This is the virtual server you wish to search for. This would be typically used to populate variables and/or to get the configuration for a virtual server you wish to modify.

After running this, take a look at the environment variables. You should find that a great deal of information is populated about the virtual server its pool, pool's monitor, and the device it is configured on.

Next, run "Gather information to start/Get remaining Virtual Information" and look at the variables again. You should see that more information is populated about the pool.

Next, change the IP Address in "VirtualDestinationAddress" to an unused IP address, 1.1.1.1 should work fine. Also change the description in "VirtualDescription" and the Name of the virtual server in "VirtualName".

Run the "Create Virtual Server from Environment Variables" request and review the created virtual in the BIG-IQ interface.

Next, update the information stored in the environment to reflect the new virtual server by placing the name of teh virtual you created into "SearchVirtualName" and run "NEW-cloudops_3-11430_2_vs". Run "Get Remaining Virtual Information" as well, if you modified/changed pool information.

Finally, create a deployment for the virtual server by runnning the "Create Virtual Deployment without deploy" request. When successful, look at the deployment and ensure there are no unexpected conflicts. Deploy from the GUI. (Note: You CAN completely deploy from REST as well, this is not implemented in early releases of this collection on purpose to add a layer of protection.)

You could also modify the virtual server configuration by changing the values, the description or Destination address for example after the running of "Gather information to start/Get remaining Virtual Information" and then running the "Modify Specific Virtual" request followed by a deployment like above.

## Getting to work

The collection preforms many common tasks such as:

### Device Tasks

The most important part of orchestration with BIG-IQ is to tell BIG-IQ what device it is going to create, Read, update, or Delete configiration for. Environment variables for this get populated by running the "Device Info/Get Device by address" request with the "SearchDeviceAddress" environment variable set to the address of the BIG-IP. These variables here MUST be populated on all calls. Most calls in the collection that "GET" data will do this, however, to create configuration items it is nessisary that they be pre-populated for success.

When Successful, this will populate the following variables:

DeviceID - Which is the device ID/GUID used as references and in the URI to device specific REST calls.

DeviceSelfLink - Which is the URL used inside the JSON document sent in the request body of REST calls. this should ALWAYS be to the hostname 'localhost'

DeviceSelfURI - Which is the URL used inside the URI for a call to the BIG-IQ REST REST API. This should ALWAYS be to the address of the BIG-IQ device and NOT the hostname 'localhost'.

NewDeviceLink - This is the variable that will be used in REST calls to create new objects and should be the same (initially) as the "DeviceSelfLink"

In addition some login variables that every requests updates are updated:

AuthToken - This is the token sent back by the REST API and used (and updated) in every call to authenticate the request.

AuthTokenTimeoutTime - This is the time that the token will time out. In BIG-IQ REST this is not updateable like in BIG-IP REST. It is currently not used but could be helpful in troubleshooting. The time is a number representing UTC time.

### Monitor Tasks

The monitor tasks section of the collection retrieves, creates, and deletes monitor configuration items. These configuration items are used in pool references when associated with a pool. Only ONE monitor on a pool is supported at this time, the monitor in the environment variables will always be the monitor used on the pool when it is created. While this is something to be aware of, you can used this to change a monitor on a pool as well, by getting the pool into the environment, getting a new monitor, and then updating the pool.

#### "Get Monitor from Name" Request

This request pulls a specific monitor based on it's "MonitorTypeName". The strings for "MonitorTypeName" are teh same as the ones used in a tmsh command. For example, "tmsh list ltm monitor http".
It also uses the "SearchMonitorName" variable which should be teh exact name of the monitor you are looking for. As with all Searches in this collection, it is best to use the EXACT name of the monitor you desire. Not doing so could return several monitors and the wrong monitor could be populated. For example, you have a two monitors; "Test-www.widgets.com" and "Prod-www.widgets.com". Using the SearchMonitorName of "www.widgets.com" would return 2 results. This can potentially lead to unpredictable results, even though there are checks for this scenario in the collection.

The inputs and outputs of the request are explained below:

Inputs:
    MonitorTypeName     - User Supplied value for the type of monitor being created
    SearchMonitorName   - The name of the monitor to find

Outputs:
    MonitorID           - The ID of the monitor created
    MonitorType         - The name for the type of monitor. (This is the 'kind' from the rest response body)
    MonitorTypeString   - Programmatically populated value, The string of the monitortype in a response or request body. Used in a section of it's own, unique to each monitor type. I.E. "monitorHttpReferences" for http monitors.
    MonitorTypeName     - Programmatically populated value, The string used to reference the type in a JSON document. This is teh same as a TMOS Command would use, "http" for a http monitor etc.
    MonitorSelfLink     - The link to the monitor for adding to JSON documents sent in the request body. (has "localhost" for the hostname in the URL.)
    MonitorSelfURI      - The link to the monitor used to make REST calls. (Has teh IP address of the BIG-IQ in the URL.)
    MonitorName         - The name of the moinitor.

#### "Create New Monitor from Environment Variables" Request

This request creates a monitor from the values in the environment variables mentioned below. After Creation, it populates other needed variables to be used in association with a pool later.

The inputs and outputs of the request are explained below:

Inputs:
    MonitorTypeName     - User Supplied value for the type of monitor being created.
    MonitorName         - The name of the new monitor.
    MonitorRecvString   - The Receive string for the monitor. (ensure that \r\n is entered as \\r\\n to escape the \, otherwise it won't work)
    MonitorSendString   - The Send strin for the monitor. (ensure that \r\n is entered as \\r\\n to escape the \, otherwise it won't work)

Outputs:
    MonitorID           - The ID of the monitor created
    MonitorSelfLink     - The link to the monitor for adding to JSON documents
    MonitorSelfURI      - The link to the monitor used in REST calls
    MonitorTypeString   - Programmatically populated value, The string of the path used to reference the type in a JSON document.
    MonitorTypeName     - Programmatically populated value, The string used to reference the type in a JSON document.

#### "Delete Monitor from Environment Variables" Request

This request deletes a pool for later deployment (and deletion) to the BIG-IP Configuration. This request also removes the values of all associated environment variables, so to create a pool, a subsequent get of a monitor would be required.

The inputs and outputs of the request are explained below:

Inputs:
    MonitorTypeName  - User Supplied value for the type of monitor being created, is programatically updated from monitor get calls in this collection as well.
    MonitorID           - The ID of the monitor deleted.
Outputs:
    MonitorID           - The ID of the monitor created, set to "".
    MonitorSelfLink     - The link to the monitor for adding to JSON documents, set to "".
    MonitorType         - The "kind" of monitor, set to "".
    MonitorSelfURI      - The link to the monitor used in REST calls, set to "".
    MonitorTypeString   - Programmatically populated value, The string of the path used to reference the type in a JSON document, set to "".
    MonitorTypeName     - Programmatically populated value, The string used to reference the type in a JSON document, set to "".

### Node Tasks

#### "" Request

The inputs and outputs of the request are explained below:

#### "" Request

The inputs and outputs of the request are explained below:

#### "" Request

The inputs and outputs of the request are explained below:

more to be added

### Pool Tasks

#### "" Request

The inputs and outputs of the request are explained below:

more to be added

### Profile Tasks

#### "" Request

The inputs and outputs of the request are explained below:

more to be added

### Virtual Server Tasks

#### "" Request

The inputs and outputs of the request are explained below:

more to be added

### Deployment Tasks

#### "" Request

The inputs and outputs of the request are explained below:

more to be added

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
