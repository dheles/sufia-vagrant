#!/usr/bin/env ruby

BRANCH="-b figaro"
RAILS_ENVIRONMENT="-e production"

REPO_ARGS = [RAILS_ENVIRONMENT, BRANCH].join(" ")
puts REPO_ARGS
