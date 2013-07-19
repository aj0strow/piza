require 'spec_helper'

describe Piza do
  it 'should provide unique names' do
    name = Piza.unique_name
    expect(Piza.unique_name).not_to eq(name)
  end
end