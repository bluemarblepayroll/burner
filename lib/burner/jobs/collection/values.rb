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
      # Take an array of objects and call #values on each object.
      # If include_keys is true (it is false by default), then call #keys on the first
      # object and inject that as a "header" object.
      # Expected Payload#value input: array of objects.
      # Payload#value output: An array of arrays.
      class Values < Job
        attr_reader :include_keys

        def initialize(name:, include_keys: false)
          super(name: name)

          @include_keys = include_keys || false

          freeze
        end

        def perform(_output, payload)
          keys   = include_keys ? [keys(payload.value&.first)] : []
          values = (payload.value || []).map { |object| values(object) }

          payload.value = keys + values

          nil
        end

        private

        def keys(object)
          object.respond_to?(:keys) ? object.keys : []
        end

        def values(object)
          object.respond_to?(:values) ? object.values : []
        end
      end
    end
  end
end
