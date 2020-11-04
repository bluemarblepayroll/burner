# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Burner
  module Modeling
    class Validations
      # Check if a value is present.  If it is blank (null or empty) then it is invalid.
      class Present < Base
        acts_as_hashable

        def valid?(object_value, resolver)
          !resolver.get(object_value, key).to_s.empty?
        end

        private

        def default_message
          'is required'
        end
      end
    end
  end
end
