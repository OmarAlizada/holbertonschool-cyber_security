#!/bin/bash
bc <<< "obase=2; $1" | xargs printf "%08d\n"
