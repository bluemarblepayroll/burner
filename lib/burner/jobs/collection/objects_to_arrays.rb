# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    module Collection
      # Convert an array of objects to an array of arrays.  You can leverage the separator
      # option to support key paths and nested objects.
      # Expected Payload#value input: array of hashes.
      # Payload#value output: An array of arrays.
      class ObjectsToArrays < Job
        attr_reader :mappings

        # If you wish to support nested objects you can pass in a string to use as a
        # key path separator.  For example: if you would like to recognize dot-notation for
        # nested hashes then set separator to '.'.
        def initialize(name:, mappings: [], separator: '')
          super(name: name)

          @mappings = Modeling::KeyIndexMapping.array(mappings)
          @resolver = Objectable.resolver(separator: separator.to_s)

          freeze
        end

        def perform(_output, payload)
          payload.value = (payload.value || []).map { |object| key_to_index_map(object) }

          nil
        end

        private

        attr_reader :resolver

        def key_to_index_map(object)
          mappings.each_with_object(prototype_array) do |mapping, memo|
            memo[mapping.index] = resolver.get(object, mapping.key)
          end
        end

        def prototype_array
          Array.new(mappings.length)
        end
      end
    end
  end
end