# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Jobs
    # Do nothing.
    class Dummy < Job
      def perform(_output, _payload, _params)
        nil
      end
    end
  end
end