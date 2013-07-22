require 'spec_helper'

describe Piza do
  it 'should provide unique names' do
    expect(Piza.unique_name).not_to eq(Piza.unique_name)
  end
end