# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Jobs::Deserialize::Json do
  let(:value)      { '{"name":"Captain Jack Sparrow"}' }
  let(:params)     { {} }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new(value: value) }

  subject { described_class.make(name: 'test') }

  describe '#perform' do
    it 'serializes and sets value' do
      subject.perform(output, payload, params)

      expected = { 'name' => 'Captain Jack Sparrow' }

      expect(payload.value).to eq(expected)
    end
  end
end
