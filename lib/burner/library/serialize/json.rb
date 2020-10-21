# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Serialize
      # Treat value like a Ruby object and serialize it using JSON.
      class Json < Job
        def perform(_output, payload)
          payload.value = payload.value.to_json

          nil
        end
      end
    end
  end
end
