#!/usr/bin/env bash

bundle exec rake jetty:clean
bundle exec rake sufia:jetty:config
bundle exec rake jetty:start
