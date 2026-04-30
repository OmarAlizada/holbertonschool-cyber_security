#!/bin/bash
ps -u "$1" -nhF | grep -vE ' +0 +0 '
