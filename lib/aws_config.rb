require 'aws-sdk'

class AwsConfig
  config = YAML.load_file('./config/aws.yml')
end
