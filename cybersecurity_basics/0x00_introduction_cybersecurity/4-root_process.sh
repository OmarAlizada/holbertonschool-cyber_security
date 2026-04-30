#!/bin/bash
ps -u "$1" -nhF | grep -v ' 0 '
