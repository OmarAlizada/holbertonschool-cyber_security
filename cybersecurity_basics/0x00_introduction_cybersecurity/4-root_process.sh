#!/bin/bash
ps -u "$1" -F | grep -vE 'VSZ|RSS' | grep -v ' 0 +0 '
