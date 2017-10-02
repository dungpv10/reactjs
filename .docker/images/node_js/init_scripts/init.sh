#!/bin/bash

cd /usr/src/app
npm install
pm2-docker process.yml