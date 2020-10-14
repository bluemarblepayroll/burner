# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Jobs::Dummy do
  subject { described_class.make(name: 'test') }

  describe '#perform' do
    it "does not change payload's value" do
      value   = 123
      payload = Burner::Payload.new(value: value)

      subject.perform(nil, payload, nil)

      expect(payload.value).to eq(value)
    end
  end
end
