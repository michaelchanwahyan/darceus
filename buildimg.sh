#!/bin/sh
docker build -t darceus:latest ./
docker rmi   -f $(docker images -f "dangling=true" -q)
