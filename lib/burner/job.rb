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
  # implement #perform(output, payload) and then you can register it for use using
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

    # There are only a few requirements to be considered a valid Burner Job:
    #   1. The class responds to #name
    #   2. The class responds to #perform(output, payload)
    #   3. Optional: The class responds to #halt?.  If it returns true then the pipeline will
    #      stop processing after #perform returns.
    #
    # The #perform method takes in two arguments: output (an instance of Burner::Output)
    # and payload (an instance of Burner::Payload).  Jobs can leverage output to emit
    # information to the pipeline's log(s).  The payload is utilized to pass data from job to job,
    # with its most important attribute being #value.  The value attribute is mutable
    # per the individual job's context (meaning of it is unknown without understanding a job's
    # input and output value of #value.).  Therefore #value can mean anything and it is up to the
    # engineers to clearly document the assumptions of its use.
    #
    # Returning false will short-circuit the pipeline right after the job method exits.
    # Returning anything else besides false just means "continue".
    def perform(output, _payload)
      output.detail("#perform not implemented for: #{self.class.name}")

      nil
    end

    # Set halt to true by calling #halt.  This will indicate to the pipeline to stop all
    # subsequent processing.
    def halt?
      @halt || false
    end

    protected

    def job_string_template(expression, output, payload)
      templatable_params = payload.params.merge(__id: output.id, __value: payload.value)

      StringTemplate.instance.evaluate(expression, templatable_params)
    end

    def halt
      @halt = true
    end
  end
end
