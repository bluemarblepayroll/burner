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
      #
      # Expected Payload[register] input: nothing.
      # Payload[register] output: contents of the specified file.
      class Read < Base
        attr_reader :binary

        def initialize(name:, path:, binary: false, disk: {}, register: DEFAULT_REGISTER)
          super(disk: disk, name: name, path: path, register: register)

          @binary = binary || false

          freeze
        end

        def perform(output, payload)
          compiled_path = job_string_template(path, output, payload)

          output.detail("Reading: #{compiled_path}")

          payload[register] = disk.read(compiled_path, binary: binary)
        end
      end
    end
  end
end
