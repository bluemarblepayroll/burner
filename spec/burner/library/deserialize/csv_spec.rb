# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Deserialize::Csv do
  let(:value)      { "id,first,last\n1,captain,kangaroo\n2,twisted,sister\n" }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new(value: value) }
  let(:skip_first) { 0 }

  subject { described_class.make(name: 'test') }

  describe '#perform' do
    it 'de-serializes and sets value' do
      subject.perform(output, payload)

      expected = [
        %w[id first last],
        %w[1 captain kangaroo],
        %w[2 twisted sister]
      ]

      expect(payload.value).to eq(expected)
    end
  end
end
