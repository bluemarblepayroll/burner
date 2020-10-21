# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Burner
  module Library
    module IO
      # Read value from disk.
      class Read < Base
        attr_reader :binary

        def initialize(name:, path:, binary: false)
          super(name: name, path: path)

          @binary = binary || false

          freeze
        end

        def perform(output, payload)
          compiled_path = job_string_template(path, output, payload)

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
