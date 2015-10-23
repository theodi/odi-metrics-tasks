# ODI Metrics Tasks

[![Build Status](http://img.shields.io/travis/theodi/odi-metrics-tasks.svg)](https://travis-ci.org/theodi/odi-metrics-tasks)
[![Dependency Status](http://img.shields.io/gemnasium/theodi/odi-metrics-tasks.svg)](https://gemnasium.com/theodi/odi-metrics-tasks)
[![Coverage Status](http://img.shields.io/coveralls/theodi/odi-metrics-tasks.svg)](https://coveralls.io/r/theodi/odi-metrics-tasks)
[![Code Climate](http://img.shields.io/codeclimate/github/theodi/odi-metrics-tasks.svg)](https://codeclimate.com/github/theodi/odi-metrics-tasks)
[![Gem Version](http://img.shields.io/gem/v/odi-metrics-tasks.svg)](https://rubygems.org/gems/odi-metrics-tasks)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://theodi.mit-license.org)
[![Badges](http://img.shields.io/:badges-7/7-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)

Setup
-----

Add to gemfile:

    gem 'odi-metrics-tasks'

And require if necessary:

    require 'odi-metrics-tasks'

Configuration is loaded from environment variables. See the environment section below for the list of which variables must be set.

License
-------

This code is open source under the MIT license. See the LICENSE.md file for 
full details.

Architecture
------------

This repository consists of a whole bunch of glue scripts which connect various other systems. They should all have the following features:

* Implemented as [resque jobs](https://github.com/defunkt/resque#section_Jobs).
* Minimal; each job should be as small as possible, spawing other jobs rather than executing big bits of code.
* Idempotent; they should be able to run many times with the same arguments and not cause problems.
* Testable; minimal jobs are very easy to test. This is generally done with cucumber features.

We use [VCR](https://github.com/vcr/vcr) to mock away any HTTP requests during tests.

Environment
-----------

The following environment variables should be set in order to use this gem.

 * METRICS_API_USERNAME
 * METRICS_API_PASSWORD
 * METRICS_API_BASE_URL
 * HUBOT_USER_LIST
 * AIRBRAKE_API_KEY
 * GITHUB_ORGANISATION
 * GITHUB_OAUTH_TOKEN
 * GAPPS_CLIENT_ID
 * GAPPS_CLIENT_SECRET
 * GAPPS_REFRESH_TOKEN
 * CAPSULECRM_ACCOUNT_NAME
 * CAPSULECRM_API_TOKEN
 * PRECISEMEDIA_FEED_URL
 * TRELLO_DEV_KEY
 * TRELLO_MEMBER_KEY