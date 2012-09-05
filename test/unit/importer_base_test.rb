require_relative '../test_helper'
require './lib/importers/base'

describe ImporterBase do
  before do
    @example_file = 'test/support/legacy_user_test.csv'
  end

  subject {ImporterBase}

  it 'is a thing' do
    subject.new(@example_file).must_be_instance_of ImporterBase
  end

  describe '#file_path' do
    it 'returns the file path' do
      subject.new(@example_file).file_path.must_equal @example_file
    end
  end

  describe '#csv' do
    it 'parses the file and returns a CSV object' do
      CSV.expects(:open).with(@example_file).returns(%w(foo bar))
      subject.new(@example_file).csv
    end
  end

  describe '#headers_hash_for_class' do
    it 'returns the correct symbol for the given hash' do
      module Foo;class Bar;end;end
      subject.new(@example_file).headers_hash_for_class(Foo).must_equal :foo_header_mapping
      subject.new(@example_file).headers_hash_for_class(Foo::Bar).must_equal :bar_header_mapping
    end
  end

  describe '#model_class' do
    it 'returns nil when not subclassed' do
      subject.new(@example_file).model_class('').must_equal nil
    end
  end

  describe '#associated_many_classes' do
    it 'returns an empty array when not subclassed' do
      subject.new(@example_file).associated_many_classes.must_equal []
    end
  end

  describe '#associated_single_classes' do
    it 'returns an empty array when not subclassed' do
      subject.new(@example_file).associated_single_classes.must_equal []
    end
  end
end
