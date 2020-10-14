# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'job'
require_relative 'jobs/deserialize/json'
require_relative 'jobs/deserialize/yaml'
require_relative 'jobs/dummy'
require_relative 'jobs/echo'
require_relative 'jobs/io/exist'
require_relative 'jobs/io/read'
require_relative 'jobs/io/write'
require_relative 'jobs/serialize/json'
require_relative 'jobs/serialize/yaml'
require_relative 'jobs/set'
require_relative 'jobs/sleep'

module Burner
  # Main library of jobs.  This file contains all the basic/default jobs.  All other consumer
  # libraries/applications can register their own, for example:
  #   Burner::Jobs.register('your_class', YourClass)
  class Jobs
    acts_as_hashable_factory

    register 'deserialize/json', Deserialize::Json
    register 'deserialize/yaml', Deserialize::Yaml
    register 'dummy', '',        Dummy
    register 'echo',             Echo
    register 'io/exist',         IO::Exist
    register 'io/read',          IO::Read
    register 'io/write',         IO::Write
    register 'serialize/json',   Serialize::Json
    register 'serialize/yaml',   Serialize::Yaml
    register 'set',              Set
    register 'sleep',            Sleep
  end
end
