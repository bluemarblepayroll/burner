# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    # Arbitrarily set value
    class Set < Job
      attr_reader :value

      def initialize(name:, value: nil)
        super(name: name)

        @value = value

        freeze
      end

      def perform(_output, payload, _params)
        payload.value = value

        nil
      end
    end
  end
end
