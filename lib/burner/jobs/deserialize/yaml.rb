# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    module Deserialize
      # Take a YAML string and deserialize into object(s).
      class Yaml < Job
        attr_reader :safe

        def initialize(name:, safe: true)
          super(name: name)

          @safe = safe

          freeze
        end

        # The YAML cop was disabled because the consumer may want to actually load unsafe
        # YAML, which can load pretty much any type of class instead of putting the loader
        # in a sandbox.  By default, though, we will try and drive them towards using it
        # in the safer alternative.
        # rubocop:disable Security/YAMLLoad
        def perform(output, payload, _params)
          output.detail('Warning: loading YAML not using safe_load.') unless safe

          payload.value = safe ? YAML.safe_load(payload.value) : YAML.load(payload.value)

          nil
        end
        # rubocop:enable Security/YAMLLoad
      end
    end
  end
end
