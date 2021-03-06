#!/usr/bin/ruby
#########################################
# bootstrap_spec.rb
# @author Sebastien Varrette <Sebastien.Varrette@uni.lu>
# Time-stamp: <Thu 2016-11-03 21:38 svarrette>
#
# @description Check the Bootstrapping operations
#
# Copyright (c) 2013 Sebastien Varrette <Sebastien.Varrette@uni.lu>
# .             http://varrette.gforge.uni.lu
##############################################################################

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe FalkorLib::Bootstrap do

  include FalkorLib::Common

  dir = Dir.mktmpdir

  before :all do
    $stdout.sync = true
    #FalkorLib.config[:no_interaction] = true
  end

  after :all do
    FileUtils.remove_entry_secure dir
    #FalkorLib.config[:no_interaction] = false
  end

  context 'helper functions' do
    it "#select_forge - none" do
      expect(STDIN).to receive(:gets).and_return('1')
      t = FalkorLib::Bootstrap.select_forge()
      expect(t).to eq(:none)
    end

    it "#select_forge -- default to github" do
      expect(STDIN).to receive(:gets).and_return('')
      t = FalkorLib::Bootstrap.select_forge(:github)
      expect(t).to eq(:github)
    end

    FalkorLib::Config::Bootstrap::DEFAULTS[:licenses].keys.each do |lic|
      it "#select_licence -- default to #{lic}" do
        expect(STDIN).to receive(:gets).and_return('')
        t = FalkorLib::Bootstrap.select_licence(lic)
        expect(t).to eq(lic)
      end
    end

    ### Badges
    it "#get_badge " do
      subject = 'licence'
      status  = 'GPL-2.0'
      t = FalkorLib::Bootstrap.get_badge(subject, status)
      expect(t).to match(/#{subject}/)
      expect(t).to match(/#{status.sub(/-/, '--')}/)
    end
  end # context

  ############################################
  #context 'bootstrap/base' do
    # it "#trash " do
    #   FalkorLib.config[:no_interaction] = true
    #   FalkorLib::Bootstrap.trash(dir)
    #   default_trashdir = File.join(dir, FalkorLib.config[:templates][:trashdir])
    #   t = File.directory?( default_trashdir )
    #   expect(t).to be true
    #   t = File.exist?(File.join(default_trashdir, '.gitignore'))
    #   expect(t).to be true
    # end

    # it "#trash -- with non standard trash dir (dir = '#{dir}')" do
    #   trash = '.trashtoto'
    #   FalkorLib::Bootstrap.trash(dir, trash)
    #   trashdir = File.join(dir, trash)
    #   t = File.directory?( trashdir )
    #   expect(t).to be true
    #   t = File.exist?(File.join(trashdir, '.gitignore'))
    #   expect(t).to be true
    # end

    # it "#versionfile" do
    #   f = File.join(dir, 'VERSION')
    #   FalkorLib::Bootstrap.versionfile(dir)
    #   t = File.exist?(f)
    #   expect(t).to be true
    #   content = `cat #{f}`.chomp
    #   expect(content).to eq('0.0.0')
    # end

    # it "#versionfile -- non standard file and version" do
    #   opts = {
    #     :file    => 'version.txt',
    #     :version => '1.2.3'
    #   }
    #   f = File.join(dir, opts[:file])
    #   FalkorLib::Bootstrap.versionfile(dir, opts)
    #   t = File.exist?(f)
    #   expect(t).to be true
    #   content = `cat #{f}`.chomp
    #   expect(content).to eq(opts[:version])
    # end





  # end


  # ############################################
  # context 'boostrap repo' do
  #     it '#repo' do
  #         FalkorLib.config[:no_interaction] = true
  #         FalkorLib::Bootstrap.repo(dir, { :no_interaction => true, :git_flow => false })
  #         FalkorLib.config[:no_interaction] = false
  #     end
  # end

  # ############################################
  # context 'boostrap motd' do
  #     it "#motd" do
  #         motdfile = File.join(dir, 'motd1')
  #         FalkorLib::Bootstrap.motd(dir, { :file => "#{motdfile}", :no_interaction => true })
  #         t = File.exists?(motdfile)
  #         expect(t).to be true
  #     end
  # end

end
