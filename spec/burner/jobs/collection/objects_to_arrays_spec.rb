# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Jobs::Collection::ObjectsToArrays do
  let(:arrays) do
    [
      %w[1 captain kangaroo],
      %w[2 twisted sister]
    ]
  end

  let(:objects) do
    [
      {
        'first' => 'captain',
        'id' => '1',
        'last' => 'kangaroo'
      },
      {
        'first' => 'twisted',
        'id' => '2',
        'last' => 'sister'
      }
    ]
  end

  let(:mappings) do
    [
      { index: 0, key: 'id' },
      { index: 1, key: 'first' },
      { index: 2, key: 'last' }
    ]
  end

  let(:params)     { {} }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload) { Burner::Payload.new(value: objects) }

  subject { described_class.make(name: 'test', mappings: mappings) }

  describe '#perform' do
    it 'returns mapped array' do
      subject.perform(output, payload, params)

      expect(payload.value).to eq(arrays)
    end
  end
end
