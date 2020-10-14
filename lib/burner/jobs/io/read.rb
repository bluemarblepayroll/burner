# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Burner
  class Jobs
    module IO
      # Read value from disk.
      class Read < Base
        def perform(output, payload, params)
          compiled_path = compile_path(params)

          output.detail("Reading: #{compiled_path}")

          payload.value = File.open(compiled_path, mode, &:read)

          nil
        end

        private

        def mode
          binary ? 'rb' : 'r'
        end
      end
    end
  end
end
