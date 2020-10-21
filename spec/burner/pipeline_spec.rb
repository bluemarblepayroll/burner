# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'csv'
require 'spec_helper'

class ParseCsv < Burner::Job
  def perform(_output, payload)
    payload.value = CSV.parse(payload.value, headers: true).map(&:to_h)

    nil
  end
end
Burner::Jobs.register('parse_csv', ParseCsv)

describe Burner::Pipeline do
  let(:params)     { { name: 'Funky' } }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new(params: params) }

  let(:jobs) do
    [
      { name: :nothing1 },
      { name: :nothing2 },
      { name: :nothing3 }
    ]
  end

  let(:steps) do
    %i[nothing1 nothing2 nothing3]
  end

  subject { described_class.make(jobs: jobs, steps: steps) }

  describe '#initialize' do
    it 'raises a DuplicateJobNameError if jobs have the same name' do
      jobs = [
        { name: :nothing1 },
        { name: :nothing2 },
        { name: :nothing3 },
        { name: :nothing3 }
      ]

      error_constant = Burner::Pipeline::DuplicateJobNameError
      expect { described_class.make(jobs: jobs) }.to raise_error(error_constant)
    end
  end

  context 'when a step does not correspond to a job' do
    let(:jobs) do
      [
        { name: :nothing }
      ]
    end

    let(:steps) do
      %i[nada]
    end

    it 'raises JobNotFoundError' do
      error = Burner::Pipeline::JobNotFoundError

      expect { described_class.make(jobs: jobs, steps: steps) }.to raise_error(error)
    end
  end

  describe '#execute' do
    it 'execute all steps' do
      subject.execute(output: output, payload: payload)

      expect(string_out.read).to include('::nothing1')
      expect(string_out.read).to include('::nothing2')
      expect(string_out.read).to include('::nothing3')
    end

    it 'outputs params' do
      subject.execute(output: output, payload: payload)

      expect(string_out.read).to include('Parameters:')
    end

    it 'does not output params' do
      subject.execute(output: output)

      expect(string_out.read).not_to include('Parameters:')
      expect(string_out.read).to     include('No parameters passed in.')
    end

    it 'short circuits when Job#perform returns false' do
      pipeline = {
        jobs: [
          { name: :nothing1 },
          {
            name: :check,
            type: 'io/exist',
            short_circuit: true,
            path: 'does_not_exist_123.t'
          },
          { name: :nothing2 }
        ],
        steps: %i[nothing1 check nothing2]
      }

      Burner::Pipeline.make(pipeline).execute(output: output, payload: payload)

      expect(string_out.read).not_to include('nothing2')
      expect(string_out.read).to     include('Job returned false, ending pipeline.')
    end
  end

  describe 'README examples' do
    specify 'json-to-yaml converter' do
      pipeline = {
        jobs: [
          {
            name: :read,
            type: 'io/read',
            path: '{input_file}'
          },
          {
            name: :output_id,
            type: :echo,
            message: 'The job id is: {__id}'
          },
          {
            name: :output_value,
            type: :echo,
            message: 'The current value is: {__value}'
          },
          {
            name: :parse,
            type: 'deserialize/json'
          },
          {
            name: :convert,
            type: 'serialize/yaml'
          },
          {
            name: :write,
            type: 'io/write',
            path: '{output_file}'
          }
        ],
        steps: %i[
          read
          output_id
          output_value
          parse
          convert
          output_value
          write
        ]
      }

      params = {
        input_file: File.join('spec', 'fixtures', 'input.json'),
        output_file: File.join(TEMP_DIR, "#{SecureRandom.uuid}.yaml")
      }

      payload = Burner::Payload.new(params: params)

      Burner::Pipeline.make(pipeline).execute(output: output, payload: payload)

      actual = File.open(params[:output_file], 'r', &:read)

      expect(actual).to eq("---\nname: Funky Chicken!\n")
    end

    specify 'adding csv parsing job' do
      pipeline = {
        jobs: [
          {
            name: :read,
            type: 'io/read',
            path: '{input_file}'
          },
          {
            name: :output_id,
            type: :echo,
            message: 'The job id is: {__id}'
          },
          {
            name: :output_value,
            type: :echo,
            message: 'The current value is: {__value}'
          },
          {
            name: :parse,
            type: :parse_csv
          },
          {
            name: :convert,
            type: 'serialize/yaml'
          },
          {
            name: :write,
            type: 'io/write',
            path: '{output_file}'
          }
        ],
        steps: %i[
          read
          output_id
          output_value
          parse
          convert
          output_value
          write
        ]
      }

      params = {
        input_file: File.join('spec', 'fixtures', 'cars.csv'),
        output_file: File.join(TEMP_DIR, "#{SecureRandom.uuid}.yaml")
      }

      payload = Burner::Payload.new(params: params)

      Burner::Pipeline.make(pipeline).execute(output: output, payload: payload)

      actual = File.open(params[:output_file], 'r', &:read)

      expected_yaml = <<~YAML
        ---
        - make: jeep
          model: wrangler
          year: '1991'
        - make: honda
          model: accord
          year: '2000'
      YAML

      expect(actual).to eq(expected_yaml)
    end
  end
end
