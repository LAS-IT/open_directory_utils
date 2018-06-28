require 'spec_helper'

RSpec.describe OpenDirectoryUtils::Version do
  it "has a version number" do
    expect(OpenDirectoryUtils::Version::VERSION).not_to be nil
  end
  it "has correct version number" do
<<<<<<< HEAD
    expect(OpenDirectoryUtils::Version::VERSION).to eq '0.1.6'
=======
    expect(OpenDirectoryUtils::Version::VERSION).to eq '0.1.9'
>>>>>>> 12e169c3a50dc44006258b7f1e8bdda043094b3a
  end
end
