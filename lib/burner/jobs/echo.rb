# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    # Output a simple message to the output.
    class Echo < Job
      attr_reader :message

      def initialize(name:, message: '')
        super(name: name)

        @message = message.to_s

        freeze
      end

      def perform(output, _payload, params)
        compiled_message = eval_string_template(message, params)

        output.detail(compiled_message)

        nil
      end
    end
  end
end
