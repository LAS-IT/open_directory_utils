require 'spec_helper'

RSpec.describe OpenDirectoryUtils::Version do
  it "has a version number" do
    expect(OpenDirectoryUtils::Version::VERSION).not_to be nil
  end
  it "has correct version number" do
    expect(OpenDirectoryUtils::Version::VERSION).to be '0.1.0'
  end
end
