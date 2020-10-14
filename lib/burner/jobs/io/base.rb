# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    module IO
      # Common configuration/code for all IO Job subclasses.
      class Base < Job
        attr_reader :binary, :path

        def initialize(name:, path:, binary: false)
          super(name: name)

          raise ArgumentError, 'path is required' if path.to_s.empty?

          @path   = path.to_s
          @binary = binary || false

          freeze
        end

        private

        def compile_path(params)
          eval_string_template(path, params)
        end

        def mode
          binary ? 'wb' : 'w'
        end
      end
    end
  end
end
