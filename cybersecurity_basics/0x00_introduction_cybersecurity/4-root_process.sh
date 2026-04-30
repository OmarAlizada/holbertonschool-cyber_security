#!/bin/bash
ps -u "$1" -F | grep -v ' 0      0 '
