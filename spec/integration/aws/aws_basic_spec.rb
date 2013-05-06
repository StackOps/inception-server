require File.expand_path("../../../spec_helper", __FILE__)
require File.expand_path("../../../support/aws/aws_helpers", __FILE__)

require "active_support/core_ext/hash/keys"

describe "AWS deployment using gems and publish stemcells" do
  include FileUtils
  include AwsHelpers

  attr_reader :bosh_name

  before { prepare_aws("basic", aws_region) }
  after { destroy_test_constructs(bosh_name) unless keep_after_test? }

  def aws_region
    ENV['AWS_REGION'] || "us-west-2"
  end

  xit "creates an EC2 inception/microbosh with the associated resources" do
    create_manifest

    manifest_file = home_file(".bosh_inception", "manifest.yml")
    File.should be_exists(manifest_file)

    cmd.deploy

    inception_vms = servers_with_sg("#{bosh_name}-inception-vm")
    inception_vms.size.should == 1
  end

end