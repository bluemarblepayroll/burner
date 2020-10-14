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
      # Write value to disk.
      class Write < Base
        def perform(output, payload, params)
          compiled_path = compile_path(params)

          ensure_directory_exists(output, compiled_path)

          output.detail("Writing: #{compiled_path}")

          File.open(compiled_path, mode) { |io| io.write(payload.value) }

          nil
        end

        private

        def ensure_directory_exists(output, compiled_path)
          dirname = File.dirname(compiled_path)

          return if File.exist?(dirname)

          output.detail("Outer directory does not exist, creating: #{dirname}")

          FileUtils.mkdir_p(dirname)

          nil
        end
      end
    end
  end
end
