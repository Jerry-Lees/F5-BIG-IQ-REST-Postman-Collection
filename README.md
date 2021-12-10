# F5 BIG-IQ REST Postman Collection Introduction

A postman collection to perform common BIG-IQ tasks for managing BIG-IP devices via REST

------------

## ***Warning***

This is not for the faint at heart, care must be taken to issue commands in the proper order and watching the results as you progress. Remember, this is a framework for interfacing with the REST API of BIG-IQ. This operates at a very low level and has it's inherent risks of human error.

------------

## Installation

Download the file in the repository and import into your postman installation.

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

To get familiar with the variables in the environment and to test your setup, follow teh following get started tasks below.

### Initial test requests

*READ THIS FIRST*
Run this section *ONLY* against a test environment. This mini-guide will take you through modifying the configuration of a virtual server. *DO NOT* use this in a production environment or for a virtual that has impact.

Once the above variables are populted for your environment, you can run "Gather information to start/Get Virtual Information from name" by populating the following variable:

-SearchVirtualName
    This is the virtual server you wish to search for. This would be typically used to populate variables and/or to get teh configuration for a virtual server you wish to modify.

After running this, take a look at the environment variables. You should find that a great deal of information is populated about the virtual server its pool, pool's monitor, and the device it is configured on.

Next, run "Gather information to start/Get remaining Virtual Information" and look at the variables again. You should see that more information is populated about the pool.

(add more here)

## Getting to work

The collection preforms many common tasks such as:

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
