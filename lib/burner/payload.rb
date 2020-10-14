# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  # The input for all Job#perform methods.  The main notion of this object is its "value"
  # attribute.  This is dynamic and weak on purpose and is subject to whatever the Job#perform
  # methods decides it is.  This definitely adds an order-of-magnitude complexity to this whole
  # library and lifecycle, but I am not sure there is any other way around it: trying to build
  # a generic, open-ended object pipeline to serve almost any use case.
  class Payload
    attr_accessor :value

    attr_reader :context

    def initialize(context: {}, value: nil)
      @context = context || {}
      @value   = value
    end
  end
end
