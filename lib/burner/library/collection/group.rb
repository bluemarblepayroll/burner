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
      # Take a register's value (an array of objects) and group the objects by the specified keys.
      # It essentially creates a hash from an array. This is useful for creating a O(1) lookup
      # which can then be used in conjunction with the Coalesce Job for another array of data.
      # It is worth noting that the resulting hashes values are singular objects and not an array
      # like Ruby's Enumerable#group_by method.
      #
      # If the insensitive option is set as true then each key's value will be coerced as
      # a lowercase string.  This can help provide two types of insensitivity: case and type
      # insensitivity.  This may be appropriate in some places but not others.  If any other
      # value coercion is needed then another option would be to first transform the records
      # before grouping them.
      #
      # An example of this specific job:
      #
      # input: [{ id: 1, code: 'a' }, { id: 2, code: 'b' }]
      # keys: [:code]
      # output: { ['a'] => { id: 1, code: 'a' }, ['b'] => { id: 2, code: 'b' } }
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: hash.
      class Group < JobWithRegister
        include Util::Keyable

        attr_reader :insensitive, :keys, :resolver

        def initialize(
          insensitive: false,
          keys: [],
          name: '',
          register: DEFAULT_REGISTER,
          separator: ''
        )
          super(name: name, register: register)

          @insensitive = insensitive || false
          @keys        = Array(keys)
          @resolver    = Objectable.resolver(separator: separator.to_s)

          raise ArgumentError, 'at least one key is required' if @keys.empty?

          freeze
        end

        def perform(output, payload)
          payload[register] = array(payload[register])
          count             = payload[register].length

          output.detail("Grouping based on key(s): #{keys} for #{count} records(s)")

          grouped_records = payload[register].each_with_object({}) do |record, memo|
            key       = make_key(record, keys, resolver, insensitive)
            memo[key] = record
          end

          payload[register] = grouped_records
        end
      end
    end
  end
end
