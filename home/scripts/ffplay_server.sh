#!/bin/sh

killall ffplay
ffplay -nodisp rtp://0.0.0.0:1730
