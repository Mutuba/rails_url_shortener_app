RSpec.shared_examples "taggable" do
  it { is_expected.to have_many(:tags).dependent(:destroy) }
end