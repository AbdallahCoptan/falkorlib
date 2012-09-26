##############################################################################
# Rakefile - Configuration file for rake (http://rake.rubyforge.org/)
# Time-stamp: <Wed 2012-09-26 17:06 svarrette>
#
# Copyright (c) 2012 Sebastien Varrette <Sebastien.Varrette@uni.lu>
# .             http://varrette.gforge.uni.lu
#                       ____       _         __ _ _
#                      |  _ \ __ _| | _____ / _(_) | ___
#                      | |_) / _` | |/ / _ \ |_| | |/ _ \
#                      |  _ < (_| |   <  __/  _| | |  __/
#                      |_| \_\__,_|_|\_\___|_| |_|_|\___|
#
# Use 'rake -T' to list the available actions
#
# Resources:
# * http://www.stuartellis.eu/articles/rake/
##############################################################################
# We run tests by default
task :default => :test

#
# Install all tasks found in tasks folder
#
# See .rake files there for complete documentation.
#
RAKE_TASKS_TO_LOAD = [
                      'debug_mail.rake',
                      'gem.rake',
                      'spec_test.rake',
                      'unit_test.rake',
                      'yard.rake'
                     ] 

Dir["tasks/*.rake"].each do |taskfile|
	next unless RAKE_TASKS_TO_LOAD.include?(taskfile.gsub(/.*tasks\//, ''))
	load taskfile
end
