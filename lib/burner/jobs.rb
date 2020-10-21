# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'library'

module Burner
  # Main library of jobs.  This file contains all the basic/default jobs.  All other consumer
  # libraries/applications can register their own, for example:
  #   Burner::Jobs.register('your_class', YourClass)
  class Jobs
    acts_as_hashable_factory

    register 'collection/arrays_to_objects', Library::Collection::ArraysToObjects
    register 'collection/graph',             Library::Collection::Graph
    register 'collection/objects_to_arrays', Library::Collection::ObjectsToArrays
    register 'collection/shift',             Library::Collection::Shift
    register 'collection/transform',         Library::Collection::Transform
    register 'collection/unpivot',           Library::Collection::Unpivot
    register 'collection/values',            Library::Collection::Values
    register 'deserialize/csv',              Library::Deserialize::Csv
    register 'deserialize/json',             Library::Deserialize::Json
    register 'deserialize/yaml',             Library::Deserialize::Yaml
    register 'dummy', '',                    Library::Dummy
    register 'echo',                         Library::Echo
    register 'io/exist',                     Library::IO::Exist
    register 'io/read',                      Library::IO::Read
    register 'io/write',                     Library::IO::Write
    register 'serialize/csv',                Library::Serialize::Csv
    register 'serialize/json',               Library::Serialize::Json
    register 'serialize/yaml',               Library::Serialize::Yaml
    register 'set_value',                    Library::SetValue
    register 'sleep',                        Library::Sleep
  end
end
