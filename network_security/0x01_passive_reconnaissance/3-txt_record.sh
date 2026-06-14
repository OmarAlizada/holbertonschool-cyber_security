#!/bin/bash
nslookup -type=txt "$1" | grep "text ="
