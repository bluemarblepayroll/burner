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
      # Convert an array of arrays to an array of objects.  The difference between this
      # job and ArraysToObjects is that this one does not take in mappings and instead
      # will use another register for a list of keys.
      #
      # Expected Payload[register] input: array of arrays.
      # Payload[register] output: An array of hashes.
      class DynamicArraysToObjects < JobWithRegister
        BLANK = ''

        attr_reader :keys_register,
                    :resolver

        def initialize(
          keys_register:,
          name: '',
          register: DEFAULT_REGISTER,
          separator: BLANK
        )
          super(name: name, register: register)

          @keys_register = keys_register.to_s
          @resolver      = Objectable.resolver(separator: separator)

          freeze
        end

        def perform(output, payload)
          objects = array(payload[register])
          count   = objects.length
          keys    = array(payload[keys_register])

          output.detail("Dynamically mapping #{count} array(s) to key(s): #{keys.join(', ')}")

          payload[register] = objects.map { |object| transform(object, keys) }
        end

        private

        def transform(object, keys)
          object.each_with_object({}).with_index do |(value, memo), index|
            next if index >= keys.length

            key = keys[index]

            resolver.set(memo, key, value)
          end
        end
      end
    end
  end
end
