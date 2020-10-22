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
      # Convert an array of arrays to an array of objects.  Pass in an array of
      # Burner::Modeling::KeyIndexMapping instances or hashable configurations which specifies
      # the index-to-key mappings to use.
      #
      # Expected Payload#value input: array of arrays.
      # Payload#value output: An array of hashes.
      #
      # An example using a configuration-first pipeline:
      #
      #   config = {
      #     jobs: [
      #       {
      #         name: 'set',
      #         type: 'set_value',
      #         value: [
      #           [1, 'funky']
      #         ]
      #       },
      #       {
      #         name: 'map',
      #         type: 'collection/arrays_to_objects',
      #         mappings: [
      #           { index: 0, key: 'id' },
      #           { index: 1, key: 'name' }
      #         ]
      #       },
      #       {
      #         name: 'output',
      #         type: 'echo',
      #         message: 'value is currently: {__value}'
      #       },
      #
      #     ],
      #     steps: %w[set map output]
      #   }
      #
      #   Burner::Pipeline.make(config).execute
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
