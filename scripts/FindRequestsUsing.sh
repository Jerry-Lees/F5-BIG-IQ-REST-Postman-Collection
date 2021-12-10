#!/bin/bash
SearchTerm=$1
echo "Requests using $SearchTerm"
grep -B200 $SearchTerm F5-BIG-IQ-REST-Postman-Collection.json|grep '\"name\"'|cut -d' ' -f 2-|sed 's/\"//g'|sed 's/,//g'

