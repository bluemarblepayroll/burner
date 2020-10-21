# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    # Arbitrarily set value
    #
    # Expected Payload#value input: anything.
    # Payload#value output: whatever value was specified in this job.
    class SetValue < Job
      attr_reader :value

      def initialize(name:, value: nil)
        super(name: name)

        @value = value

        freeze
      end

      def perform(_output, payload)
        payload.value = value

        nil
      end
    end
  end
end
