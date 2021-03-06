require_relative '../lib/cab_call'

describe CabCall do
  it "considers instances to be equal when both floor and direction are equal" do
    cc1 = CabCall.new(floor: 1, direction: :up)
    cc2 = CabCall.new(floor: 1, direction: :up)
    cc3 = CabCall.new(floor: 2, direction: :up)
    cc4 = CabCall.new(floor: 1, direction: :down)
    expect(cc1).to eq(cc2)
    expect(cc1).not_to eq(cc3)
    expect(cc1).not_to eq(cc4)
    expect(cc2).not_to eq(cc3)
    expect(cc2).not_to eq(cc4)
    expect(cc3).not_to eq(cc4)
  end
end
