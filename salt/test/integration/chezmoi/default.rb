# frozen_string_literal: true

describe file('/usr/local/bin/chezmoi') do
  it { should exist }
end

describe directory('/home/kitchen/.local/share/chezmoi/.git') do
  it { should exist }
end

describe bash('/usr/local/bin/chezmoi status') do
  its('stdout') { should eq '' }
  its('stdout') { should eq '' }
  its('exit_status') { should eq 0 }
end
