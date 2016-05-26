CONSTANTS =  YAML.load_file('./config/constants.yml')[Rails.env]
REGEXP = {}
REGEXP[:email_validator] = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
