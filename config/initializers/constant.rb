REGEXP = {}
REGEXP[:email_validator] = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
TIME_TO_EXPIRY = 6
CONSTANTS =  YAML.load_file(Rails.root.join('config', 'constants.yml'))[Rails.env]
