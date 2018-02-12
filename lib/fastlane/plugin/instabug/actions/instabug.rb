module Fastlane
  module Actions
    class InstabugAction < Action
      def self.run(params)
        api_token = params[:api_token]

        if params[:dsym_path].end_with?('.zip')
          dsym_zip_path = params[:dsym_path].shellescape
        else
          dsym_path = params[:dsym_path]
          dsym_zip_path = ZipAction.run(path: dsym_path).shellescape
        end

        endpoint = 'https://api.instabug.com/api/sdk/v3/symbols_files'

        command =  "curl #{endpoint} --write-out %{http_code} --silent --output /dev/null -F dsym=@\"#{dsym_zip_path}\" -F application_token=\"#{api_token}\""

        UI.verbose command

        return command if Helper.test?

        result = Actions.sh(command)
        if result == "200"
          UI.success 'dSYM is successfully uploaded to Instabug 🤖'
        else
          UI.error "Something went wrong during Instabug dSYM upload. Status code is #{result}"
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Instabug dSYM uploading'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: 'FL_INSTABUG_API_TOKEN', # The name of the environment variable
                                       description: 'API Token for Instabug', # a short description of this parameter
                                       verify_block: proc do |value|
                                         UI.user_error!("No API token for InstabugAction given, pass using `api_token: 'token'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_path,
                                       env_name: 'FL_INSTABUG_DSYM_PATH',
                                       description: 'Path to *.dSYM file',
                                       default_value: Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH],
                                       is_string: true,
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("dSYM file doesn't exists") unless File.exist?(value)
                                       end)
        ]
      end

      def self.authors
        ['SiarheiFedartsou']
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
