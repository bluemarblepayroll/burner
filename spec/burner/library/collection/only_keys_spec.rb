# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::OnlyKeys do
  let(:string_out)    { StringIO.new }
  let(:output)        { Burner::Output.new(outs: [string_out]) }
  let(:register)      { 'register1' }
  let(:keys_register) { 'headers' }

  let(:records) do
    [
      { id: 1, first: 'bozo', last: 'clown' },
      { id: 2, first: 'frank', last: 'rizzo' },
    ]
  end

  let(:keys) { %i[id last] }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        register => records,
        keys_register => keys
      }
    )
  end

  subject do
    described_class.make(
      register: register,
      keys_register: keys_register
    )
  end

  describe '#perform' do
    it 'copies value in register' do
      subject.perform(output, payload)

      expected = [
        { id: 1, last: 'clown' },
        { id: 2, last: 'rizzo' },
      ]

      expect(payload[register]).to eq(expected)
    end
  end
end
