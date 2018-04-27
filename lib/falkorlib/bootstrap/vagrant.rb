# -*- encoding: utf-8 -*-
################################################################################
# Time-stamp: <Fri 2018-04-27 13:57 svarrette>
################################################################################
# Interface for Bootstrapping MkDocs
#

require "falkorlib"
require "falkorlib/common"
require "falkorlib/bootstrap"

require 'erb' # required for module generation
require 'artii'
require 'facter'

include FalkorLib::Common

module FalkorLib
  module Bootstrap #:nodoc:

    module_function

    ###### vagrant ######
    # Initialize Vagrant in the current directory
    # Supported options:
    #  * :force       [boolean] force overwritting
    ##
    def vagrant(dir = Dir.pwd, options = {})
      info "Initialize Vagrant (see https://www.vagrantup.com/)"
      path = normalized_path(dir)
      use_git = FalkorLib::Git.init?(path)
      rootdir = (use_git) ? FalkorLib::Git.rootdir(path) : path
      templatedir = File.join( FalkorLib.templates, 'vagrant')
      config = FalkorLib::Config::Bootstrap::DEFAULTS[:vagrant].clone
      if options[:os]
        config[:os] = options[:os]
      else
        config[:os] = select_from(config[:boxes].keys,
                    "Select OS to configure within your vagrant boxes by default",
                    (config[:boxes].keys.find_index(config[:os]) + 1))
      end
      [ :ram, :vcpus, :domain, :range ].each do |k|
        config[k.to_sym] = ask("\tDefault #{k.capitalize}:", config[k.to_sym])
      end
      puts config.to_yaml
      FalkorLib::GitFlow.start('feature', 'vagrant', rootdir) if (use_git && FalkorLib::GitFlow.init?(rootdir))
      init_from_template(templatedir, rootdir, config,
                         :no_interaction => true,
                         :no_commit => true)
      # Dir.chdir( File.join(rootdir, 'docs')) do
      #   run %(ln -s README.md index.md )
      #   run %(ln -s README.md contributing/index.md )
      #   run %(ln -s README.md setup/index.md )
      # end
      #exit_status.to_i
    end # vagrant

  end # module Bootstrap
end # module FalkorLib