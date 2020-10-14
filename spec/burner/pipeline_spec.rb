# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Pipeline do
  let(:params)     { { name: 'Funky' } }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new }

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
      subject.execute(output: output, params: params, payload: payload)

      expect(string_out.read).to include('::nothing1')
      expect(string_out.read).to include('::nothing2')
      expect(string_out.read).to include('::nothing3')
    end

    it 'outputs params' do
      subject.execute(output: output, params: params, payload: payload)

      expect(string_out.read).to include('Parameters:')
    end

    it 'does not output params' do
      subject.execute(output: output, params: {}, payload: payload)

      expect(string_out.read).not_to include('Parameters:')
      expect(string_out.read).to     include('No parameters passed in.')
    end
  end
end
