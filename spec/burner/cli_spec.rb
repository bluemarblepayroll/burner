# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Cli do
  let(:args) do
    [
      File.join('spec', 'fixtures', 'pipeline.yaml'),
      'param1=abc',
      'param2=def'
    ]
  end

  subject { described_class.new(args) }

  describe '#initialize' do
    it 'reads and loads yaml' do
      expect(subject.pipeline.steps.length).to eq(2)
      expect(subject.pipeline.steps.map(&:name)).to eq(%w[nothing bedtime])
    end
  end

  describe '#execute' do
    it 'calls Pipeline#execute' do
      argument_params = { 'param3' => 'ghi' }
      output          = Burner::Output.new
      payload         = Burner::Payload.new
      params          = subject.params

      expected_args = {
        output: output,
        params: params.merge(argument_params),
        payload: payload
      }

      expect(subject.pipeline).to receive(:execute).with(expected_args)

      subject.execute(output: output, params: argument_params, payload: payload)
    end
  end
end
