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
      # Check if a value is blank, if it is not blank then it is not valid.
      class Blank < Base
        acts_as_hashable

        def valid?(object, resolver)
          resolver.get(object, key).to_s.empty?
        end

        private

        def default_message
          'must be blank'
        end
      end
    end
  end
end
