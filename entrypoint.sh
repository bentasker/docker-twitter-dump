#!/bin/sh
#
#

username=$1

twitter-dump auth
twitter-dump search -q "(from:${username})" -o "/output/${username}.json"

