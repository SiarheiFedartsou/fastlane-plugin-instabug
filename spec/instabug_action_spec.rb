require 'spec_helper'

describe Fastlane::Actions::InstabugAction do
  let (:test_path) { '/tmp/fastlane/tests/fastlane' }
  let (:fixtures_path) { './spec/fixtures/' }
  let (:dsym_file) { 'test.dSYM' }

  # Action parameters
  let (:dsym_file_path) { File.join(test_path, dsym_file) }

  before do
    FileUtils.mkdir_p(test_path)
    source = File.join(fixtures_path, dsym_file)
    destination = File.join(test_path, dsym_file)

    FileUtils.cp_r(source, destination)
  end

  describe '#run' do
    it 'should raise error if dSYM path is not provided' do
      error_msg = 'Cannot find dSYM'
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          instabug(api_token: 'token')
        end").runner.execute(:test)
      end.to raise_error(error_msg)
    end

    it 'should raise error if dSYM path and dSYM.zip path provided at the same time' do
      error_msg = "Unresolved conflict between options: 'dsym_path' and 'dsym_zip_path'"
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          instabug(api_token: 'token',
          dsym_path: '/path/to/dsym',
          dsym_zip_path: '/path/to/dsym.zip')
        end").runner.execute(:test)
      end.to raise_error(error_msg)
    end

    it 'should raise error if dSYM file does not exists' do
      error_msg = "Provided dSYM doesn't exists"
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          instabug(api_token: 'token',
          dsym_path: '/path/to/dsym')
        end").runner.execute(:test)
      end.to raise_error(error_msg)
    end

    it 'should raise error if dSYM.zip file does not exists' do
      error_msg = "Provided dSYM.zip doesn't exists"
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          instabug(api_token: 'token',
          dsym_zip_path: '/path/to/dsym')
        end").runner.execute(:test)
      end.to raise_error(error_msg)
    end

    it "shouldn't raise error if dSYM path is not provided explicitly, but SharedValues::DSYM_ZIP_PATH is provided" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          Actions.lane_context[SharedValues::DSYM_ZIP_PATH] = '#{dsym_file_path}'
          instabug(api_token: 'token')
        end").runner.execute(:test)
      end.not_to raise_error
    end

    it 'should use provided token for curl command' do
      result = Fastlane::FastFile.new.parse("lane :test do
        instabug(api_token: 'fake_token')
      end").runner.execute(:test)
      expect(result).to include('-F token="fake_token"')
    end

    it 'should make requests to Instabug dSYM endpoint' do
      result = Fastlane::FastFile.new.parse("lane :test do
        instabug(api_token: 'fake_token')
      end").runner.execute(:test)
      expect(result).to include('curl https://api.instabug.com/api/ios/v1/dsym')
    end
  end

  after do
    FileUtils.rm_r(test_path)
  end
end
