# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Compress
      # Iterates over an array of objects, extracts a path and data in each object, and
      # creates a zip file.  By default, if a path is blank then an ArgumentError will be raised.
      # If this is undesirable then you can set ignore_blank_path to true and the record will be
      # skipped.  You also have the option to supress blank files being added by configuring
      # ignore_blank_data as true.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: compressed binary zip file contents.
      class RowReader < JobWithRegister
        DEFAULT_DATA_KEY = 'data'
        DEFAULT_PATH_KEY = 'path'

        attr_reader :data_key,
                    :ignore_blank_data,
                    :ignore_blank_path,
                    :path_key,
                    :resolver

        def initialize(
          name:,
          data_key: DEFAULT_DATA_KEY,
          ignore_blank_data: false,
          ignore_blank_path: false,
          path_key: DEFAULT_PATH_KEY,
          register: DEFAULT_REGISTER,
          separator: ''
        )
          super(name: name, register: register)

          @data_key          = data_key.to_s
          @ignore_blank_data = ignore_blank_data || false
          @ignore_blank_path = ignore_blank_path || false
          @path_key          = path_key.to_s
          @resolver          = Objectable.resolver(separator: separator)

          freeze
        end

        def perform(output, payload)
          io = Zip::OutputStream.write_buffer do |zio|
            array(payload[register]).each.with_index(1) do |record, index|
              path = resolver.get(record, path_key)
              data = resolver.get(record, data_key)

              next if assert_and_skip_missing_path?(path, index, output)
              next if skip_missing_data?(data, index, output)

              path = strip_leading_separator(path)

              zio.put_next_entry(path)
              zio.write(data)
            end
          end

          payload[register] = io.string
        end

        private

        def strip_leading_separator(path)
          path.to_s.start_with?(File::SEPARATOR) ? path.to_s[1..-1] : path.to_s
        end

        def assert_and_skip_missing_path?(path, index, output)
          if ignore_blank_path && path.to_s.empty?
            output.detail("Skipping record #{index} because of blank path")
            true
          elsif path.to_s.empty?
            raise ArgumentError, "Record #{index} is missing a path at key: #{path_key}"
          end
        end

        def skip_missing_data?(data, index, output)
          return false unless ignore_blank_data && data.to_s.empty?

          output.detail("Skipping record #{index} because of blank data")
          true
        end
      end
    end
  end
end
