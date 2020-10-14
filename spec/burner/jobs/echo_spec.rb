# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Jobs::Echo do
  let(:message)    { 'Hello, {name}!' }
  let(:params)     { { name: 'McBoaty' } }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }

  subject { described_class.make(name: 'test', message: message) }

  describe '#perform' do
    it 'outputs templated message' do
      subject.perform(output, nil, params)

      expect(string_out.read).to include('Hello, McBoaty!')
    end
  end
end
