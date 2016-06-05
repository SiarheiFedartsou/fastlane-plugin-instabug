module Fastlane
  module Actions
    class InstabugAction < Action
      def self.run(params)
        api_token = params[:api_token]
        if params[:dsym_path]
          dsym_path = params[:dsym_path]
          UI.user_error! "Provided dSYM doesn't exists" unless File.exist?(dsym_path)
          dsym_zip_path = ZipAction.run(path: dsym_path).shellescape
        elsif params[:dsym_zip_path]
          UI.user_error! "Provided dSYM.zip doesn't exists" unless File.exist?(params[:dsym_zip_path])
          dsym_zip_path = params[:dsym_zip_path].shellescape
        elsif Actions.lane_context[SharedValues::DSYM_ZIP_PATH]
          dsym_zip_path = Actions.lane_context[SharedValues::DSYM_ZIP_PATH].shellescape
        else
          UI.user_error! 'Cannot find dSYM'
        end

        endpoint = 'https://api.instabug.com/api/ios/v1/dsym'

        command =  "curl #{endpoint} --write-out %{http_code} --silent --output /dev/null -F dsym=@\"#{dsym_zip_path}\" -F token=\"#{api_token}\""

        UI.verbose command

        return command if Helper.test?

        result = Actions.sh(command)
        if result == 200
          UI.success 'dSYM is successfully uploaded to Instabug 🤖'
        else
          UI.error 'Something went wrong during Instabug dSYM upload'
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
                                         # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_path,
                                       env_name: 'FL_INSTABUG_DSYM_PATH',
                                       description: 'Path to *.dSYM file',
                                       conflicting_options: [:dsym_zip_path],
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :dsym_zip_path,
                                       env_name: 'FL_INSTABUG_DSYM_ZIP_PATH',
                                       description: 'Path to *.dSYM.zip file',
                                       conflicting_options: [:dsym_path],
                                       is_string: true,
                                       optional: true)
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
