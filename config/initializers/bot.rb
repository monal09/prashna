require 'programr'

brains = Dir.glob("lib/timepass/*")

TIMEPASS = ProgramR::Facade.new
TIMEPASS.learn(brains)