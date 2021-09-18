# frozen_string_literal: true

require 'rails_helper'

class Validatable
  include ActiveModel::Validations
  attr_accessor :date

  validates :date, future_date: true
end

describe FutureDateValidator do
  subject { Validatable.new }

  # quando a data é anterior à data atual
  context 'when date is before current date' do
    before { subject.date = 1.day.ago }

    # eve ser inválido
    it 'should be invalid' do
      expect(subject.valid?).to be_falsey
    end

    # adiciona um erro no modelo
    it 'adds an error on model' do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  # quando a data e igual a data atual
  context 'when date is iqual current date' do
    before { subject.date = Time.zone.now }

    # hould be invalid
    it 'should be invalid' do
      expect(subject.valid?).to be_falsey
    end

    # adiciona um erro no modelo
    it 'adds an error on model' do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  # quando a data e maior que a data atual
  context 'when date is greater than current date' do
    before { subject.date = Time.zone.now + 1.day }

    # deve ser valido
    it 'should be valid' do
      expect(subject.valid?).to be_truthy
    end
  end
end
