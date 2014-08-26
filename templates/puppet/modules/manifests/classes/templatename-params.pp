# File::      <tt><%= config[:name] %>-params.pp</tt>
# Author::    <%= ENV['GIT_AUTHOR_NAME'] %> (<%= ENV['GIT_AUTHOR_MAIL'] %>)
# Copyright:: Copyright (c) <%= Time.now.year %> <%= config[:author] %>
# License::   <%= config[:license] %>
#
# ------------------------------------------------------------------------------
# = Class: <%= config[:name] %>::params
#
# In this class are defined as variables values that are used in other
# <%= config[:name] %> classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class <%= config[:name] %>::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of <%= config[:name] %>
    $ensure = $<%= config[:name] %>_ensure ? {
        ''      => 'present',
        default => "${<%= config[:name] %>_ensure}"
    }

    # The Protocol used. Used by monitor and firewall class. Default is 'tcp'
    $protocol = $<%= config[:name] %>_protocol ? {
        ''      => 'tcp',
        default => "${<%= config[:name] %>_protocol}",
    }
    # The port number. Used by monitor and firewall class. The default is 22.
    $port = $<%= config[:name] %>_port ? {
        ''      => 22,
        default => "${<%= config[:name] %>_port}",
    }
    # example of an array variable
    $array_variable = $<%= config[:name] %>_array_variable ? {
        ''      => [],
        default => $<%= config[:name] %>_array_variable,
    }


    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # <%= config[:name] %> packages
    $packagename = $::operatingsystem ? {
        default => '<%= config[:name] %>',
    }
    # $extra_packages = $::operatingsystem ? {
    #     /(?i-mx:ubuntu|debian)/        => [],
    #     /(?i-mx:centos|fedora|redhat)/ => [],
    #     default => []
    # }

    # Log directory
    $logdir = $::operatingsystem ? {
        default => '/var/log/<%= config[:name] %>'
    }
    $logdir_mode = $::operatingsystem ? {
        default => '750',
    }
    $logdir_owner = $::operatingsystem ? {
        default => 'root',
    }
    $logdir_group = $::operatingsystem ? {
        default => 'adm',
    }

    # PID for daemons
    # $piddir = $::operatingsystem ? {
    #     default => "/var/run/<%= config[:name] %>",
    # }
    # $piddir_mode = $::operatingsystem ? {
    #     default => '750',
    # }
    # $piddir_owner = $::operatingsystem ? {
    #     default => '<%= config[:name] %>',
    # }
    # $piddir_group = $::operatingsystem ? {
    #     default => 'adm',
    # }
    # $pidfile = $::operatingsystem ? {
    #     default => '/var/run/<%= config[:name] %>/<%= config[:name] %>.pid'
    # }

    # <%= config[:name] %> associated services
    $servicename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => '<%= config[:name] %>',
        default                 => '<%= config[:name] %>'
    }
    # used for pattern in a service ressource
    $processname = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => '<%= config[:name] %>',
        default                 => '<%= config[:name] %>'
    }
    $hasstatus = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => false,
        /(?i-mx:centos|fedora|redhat)/ => true,
        default => true,
    }
    $hasrestart = $::operatingsystem ? {
        default => true,
    }

    # Configuration directory & file
    # $configdir = $::operatingsystem ? {
    #     default => "/etc/<%= config[:name] %>",
    # }
    # $configdir_mode = $::operatingsystem ? {
    #     default => '0755',
    # }
    # $configdir_owner = $::operatingsystem ? {
    #     default => 'root',
    # }
    # $configdir_group = $::operatingsystem ? {
    #     default => 'root',
    # }

    $configfile = $::operatingsystem ? {
        default => '/etc/<%= config[:name] %>.conf',
    }
    $configfile_init = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => '/etc/default/<%= config[:name] %>',
        default                 => '/etc/sysconfig/<%= config[:name] %>'
    }
    $configfile_mode = $::operatingsystem ? {
        default => '0600',
    }
    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }
    $configfile_group = $::operatingsystem ? {
        default => 'root',
    }


}

