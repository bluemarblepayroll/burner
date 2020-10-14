# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    module Serialize
      # Treat value like a Ruby object and serialize it using YAML.
      class Yaml < Job
        def perform(_output, payload, _params)
          payload.value = payload.value.to_yaml

          nil
        end
      end
    end
  end
end
