#!/bin/bash
ps -u $1 -F | grep ' 0     0 '
