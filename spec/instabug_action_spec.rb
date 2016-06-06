require 'spec_helper'

describe Fastlane::Actions::InstabugAction do
  describe '#run' do
    it 'should raise error if dSYM file does not exists' do
      error_msg = "dSYM file doesn't exists"
      expect do
        result = Fastlane::FastFile.new.parse("lane :test do
          instabug(api_token: 'token',
          dsym_path: '/path/to/dsym')
        end").runner.execute(:test)
      end.to raise_error(error_msg)
    end

    it 'should use dSYM provided via DSYM_OUTPUT_PATH' do
      dsym_path = File.absolute_path('./spec/fixtures/test.dSYM.zip')
      result = Fastlane::FastFile.new.parse("lane :test do
        Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] = '#{dsym_path}'
        instabug(api_token: 'fake_token')
      end").runner.execute(:test)
      expect(result).to include("#{dsym_path}")
    end

    it 'should use dSYM provided via dsym_path option' do
      dsym_path = File.absolute_path('./spec/fixtures/test.dSYM.zip')
      result = Fastlane::FastFile.new.parse("lane :test do
        instabug(api_token: 'fake_token', dsym_path: '#{dsym_path}')
      end").runner.execute(:test)
      expect(result).to include("#{dsym_path}")
    end


    it 'should use provided token for curl command' do
      dsym_path = File.absolute_path('./spec/fixtures/test.dSYM.zip')
      result = Fastlane::FastFile.new.parse("lane :test do
        Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] = '#{dsym_path}'
        instabug(api_token: 'fake_token')
      end").runner.execute(:test)
      expect(result).to include('-F token="fake_token"')
    end

    it 'should make requests to Instabug dSYM endpoint' do
      dsym_path = File.absolute_path('./spec/fixtures/test.dSYM.zip')
      result = Fastlane::FastFile.new.parse("lane :test do
        Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] = '#{dsym_path}'
        instabug(api_token: 'fake_token')
      end").runner.execute(:test)
      expect(result).to include('curl https://api.instabug.com/api/ios/v1/dsym')
    end

    it 'should zip dSYM automatically if it is not zipped already' do
      dsym_path = File.absolute_path('./spec/fixtures/test.dSYM')
      result = Fastlane::FastFile.new.parse("lane :test do
        Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] = '#{dsym_path}'
        instabug(api_token: 'fake_token')
      end").runner.execute(:test)
      expect(result).to include('.zip')
    end
  end
end
