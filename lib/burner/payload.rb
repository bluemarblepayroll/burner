# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'written_file'

module Burner
  # The input for all Job#perform methods.  The main notion of this object is its "value"
  # attribute.  This is dynamic and weak on purpose and is subject to whatever the Job#perform
  # methods decides it is.  This definitely adds an order-of-magnitude complexity to this whole
  # library and lifecycle, but I am not sure there is any other way around it: trying to build
  # a generic, open-ended object pipeline to serve almost any use case.
  class Payload
    attr_accessor :value

    attr_reader :context, :written_files

    def initialize(context: {}, value: nil, written_files: [])
      @context       = context || {}
      @value         = value
      @written_files = written_files || []
    end

    def add_written_file(written_file)
      tap { written_files << WrittenFile.make(written_file) }
    end
  end
end
