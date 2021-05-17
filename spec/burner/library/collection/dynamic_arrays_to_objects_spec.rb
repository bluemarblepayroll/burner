# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::DynamicArraysToObjects do
  let(:arrays) do
    [
      %w[1 captain kangaroo i should not be in the results],
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

  let(:keys)          { %w[id first last] }
  let(:string_out)    { StringIO.new }
  let(:output)        { Burner::Output.new(outs: [string_out]) }
  let(:register)      { 'register_a' }
  let(:keys_register) { 'headers' }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        register => arrays,
        keys_register => keys
      }
    )
  end

  subject { described_class.make(keys_register: keys_register, register: register) }

  describe '#perform' do
    before { subject.perform(output, payload) }

    it 'returns objects as hashes not arrays' do
      expect(payload[register]).to eq(objects)
    end

    it 'outputs how many objects will be filtered' do
      expect(string_out.string).to include('Dynamically mapping 2 array(s)')
    end

    it 'outputs keys to use as a filter' do
      expect(string_out.string).to include(keys.join(', '))
    end
  end
end
