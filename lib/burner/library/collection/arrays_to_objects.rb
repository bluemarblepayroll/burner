# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Collection
      # Convert an array of arrays to an array of objects.
      #
      # Expected Payload#value input: array of arrays.
      # Payload#value output: An array of hashes.
      class ArraysToObjects < Job
        attr_reader :mappings

        def initialize(name:, mappings: [])
          super(name: name)

          @mappings = Modeling::KeyIndexMapping.array(mappings)

          freeze
        end

        def perform(_output, payload)
          payload.value = array(payload.value).map { |array| index_to_key_map(array) }

          nil
        end

        private

        def index_to_key_map(array)
          mappings.each_with_object({}) do |mapping, memo|
            memo[mapping.key] = array[mapping.index]
          end
        end
      end
    end
  end
end
