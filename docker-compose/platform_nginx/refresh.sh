#!/bin/bash
filename='image.txt'

docker-compose config | grep "image" | cut -f2- -d: | tr -d "[:blank:]" > $filename 

echo "Refresh"

while read p; do 
    docker pull $p
done < $filename

rm -rf $filename