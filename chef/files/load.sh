#!/bin/bash
echo eb76b357-cb60-4dae-8d4f-be8f14a7b5ac | sudo docker login -u liveobjects --password-stdin
cd /code
sudo docker-compose up -d 