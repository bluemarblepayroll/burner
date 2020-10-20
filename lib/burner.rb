# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'acts_as_hashable'
require 'benchmark'
require 'csv'
require 'forwardable'
require 'hashematics'
require 'json'
require 'objectable'
require 'realize'
require 'securerandom'
require 'singleton'
require 'stringento'
require 'time'
require 'yaml'

# Common/Shared
require_relative 'burner/modeling'

# Main Entrypoint(s)
require_relative 'burner/cli'
