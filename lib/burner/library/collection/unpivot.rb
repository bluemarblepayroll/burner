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
      # Take an array of objects and un-pivot groups of keys into rows.
      # Under the hood it uses HashMath's Unpivot class:
      # https://github.com/bluemarblepayroll/hash_math
      #
      # Expected Payload#value input: array of objects.
      # Payload#value output: An array of objects.
      class Unpivot < Job
        attr_reader :unpivot

        def initialize(name:, pivot_set: HashMath::Unpivot::PivotSet.new)
          super(name: name)

          @unpivot = HashMath::Unpivot.new(pivot_set)

          freeze
        end

        def perform(output, payload)
          pivot_count   = unpivot.pivot_set.pivots.length
          key_count     = unpivot.pivot_set.pivots.map { |p| p.keys.length }.sum
          payload.value = array(payload.value)
          object_count  = payload.value.length || 0

          message = "#{pivot_count} Pivots, Key(s): #{key_count} key(s), #{object_count} objects(s)"

          output.detail(message)

          payload.value = payload.value.flat_map { |object| unpivot.expand(object) }

          nil
        end
      end
    end
  end
end
