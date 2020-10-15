# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'jobs'
require_relative 'output'
require_relative 'payload'
require_relative 'step'

module Burner
  # The root package.  A Pipeline contains the job configurations along with the steps.  The steps
  # referens jobs and tell you the order of the jobs to run.
  class Pipeline
    acts_as_hashable

    class JobNotFoundError < StandardError; end

    attr_reader :steps

    def initialize(jobs: [], steps: [])
      jobs_by_name = Jobs.array(jobs).map { |job| [job.name, job] }.to_h

      @steps = Array(steps).map do |step_name|
        job = jobs_by_name[step_name.to_s]

        raise JobNotFoundError, "#{step_name} was not declared as a job" unless job

        Step.new(job)
      end
    end

    # The main entry-point for kicking off a pipeline.
    def execute(output: Output.new, params: {}, payload: Payload.new)
      output.write("Pipeline started with #{steps.length} step(s)")

      output_params(params, output)
      output.ruler

      time_in_seconds = Benchmark.measure do
        steps.each do |step|
          return_value = step.perform(output, payload, params)

          if return_value.is_a?(FalseClass)
            output.detail('Job returned false, ending pipeline.')
            break
          end
        end
      end.real.round(3)

      output.ruler
      output.write("Pipeline ended, took #{time_in_seconds} second(s) to complete")

      payload
    end

    private

    def output_params(params, output)
      if params.keys.any?
        output.write('Parameters:')
      else
        output.write('No parameters passed in.')
      end

      params.each { |key, value| output.detail("#{key}: #{value}") }
    end
  end
end
