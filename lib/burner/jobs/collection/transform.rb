# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'transform/attribute'
require_relative 'transform/attribute_renderer'

module Burner
  class Jobs
    module Collection
      # Iterate over all objects and return a new set of transformed objects.
      # Expected Payload#value input: array of objects.
      # Payload#value output: An array of objects.
      class Transform < Job
        BLANK = ''

        attr_reader :attribute_renderers,
                    :exclusive,
                    :resolver

        def initialize(name:, attributes: [], exclusive: false, separator: BLANK)
          super(name: name)

          @resolver  = Objectable.resolver(separator: separator)
          @exclusive = exclusive || false

          @attribute_renderers = Attribute.array(attributes)
                                          .map { |a| AttributeRenderer.new(a, resolver) }

          freeze
        end

        def perform(output, payload)
          payload.value = (payload.value || []).map { |row| transform(row, payload.time) }

          attr_count = attribute_renderers.length
          row_count  = payload.value.length

          output.detail("Transformed #{attr_count} attributes(s) for #{row_count} row(s)")

          nil
        end

        private

        def transform(row, time)
          outgoing_row = exclusive ? {} : row

          attribute_renderers.each_with_object(outgoing_row) do |attribute_renderer, memo|
            value = attribute_renderer.transform(row, time)

            resolver.set(memo, attribute_renderer.key, value)
          end
        end
      end
    end
  end
end
