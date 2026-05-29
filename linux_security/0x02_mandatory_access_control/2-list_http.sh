#!/bin/bash
semanage port -l | grep -E "http|pegasus"
