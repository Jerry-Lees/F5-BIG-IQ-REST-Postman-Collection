#!/bin/bash

Variables=$(grep '\"key\": \"' F5-BIG-IQ-REST-Postman-Environment.json |awk '{print $2}'|sed 's/\"//g'|sed 's/,//g')
echo "Variable use counts"
for Variable in $Variables
do
UseCount=$(grep $Variable F5-BIG-IQ-REST-Postman-Collection.json|wc -l);
if ! [[ $UseCount -eq 0 ]]
then 
	echo "$Variable : $UseCount";
else 
	echo "**** $Variable is used no where! ****"

fi;
done