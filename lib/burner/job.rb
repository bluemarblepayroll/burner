# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'string_template'

module Burner
  # Abstract base class for all job subclasses.  The only public method a subclass needs to
  # implement #perform(params, payload, reporter) and then you can register it for use using
  # the Burner::Jobs factory class method #register.  An example of a registration:
  #   Burner::Jobs.register('your_class', YourClass)
  class Job
    include Util::Arrayable
    acts_as_hashable

    attr_reader :name

    def initialize(name:)
      raise ArgumentError, 'name is required' if name.to_s.empty?

      @name = name.to_s
    end

    protected

    def job_string_template(expression, output, payload)
      templatable_params = payload.params.merge(__id: output.id, __value: payload.value)

      StringTemplate.instance.evaluate(expression, templatable_params)
    end
  end
end
