require 'spec_helper'

RSpec.describe OpenDirectoryUtils::Version do
  it "has a version number" do
    expect(OpenDirectoryUtils::Version::VERSION).not_to be nil
  end
  it "has correct version number" do
    expect(OpenDirectoryUtils::Version::VERSION).to eq '0.1.2'
  end
end
