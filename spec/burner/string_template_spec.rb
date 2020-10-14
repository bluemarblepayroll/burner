# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::StringTemplate do
  subject { described_class.instance }

  describe '#evaluate' do
    it 'formats with a hash' do
      expression = 'My name is {name}.'
      input      = { name: 'The Jolly Roger' }
      actual     = subject.evaluate(expression, input)
      expected   = 'My name is The Jolly Roger.'

      expect(actual).to eq(expected)
    end

    it 'formats with a nested hash using dot-notation' do
      expression = 'My first name is {name.first}.'
      input      = { name: { first: 'Jolly' } }
      actual     = subject.evaluate(expression, input)
      expected   = 'My first name is Jolly.'

      expect(actual).to eq(expected)
    end
  end
end
