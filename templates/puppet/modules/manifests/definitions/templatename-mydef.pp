# File::      <tt><%= config[:name] %>-mydef.pp</tt>
# Author::    <%= ENV['GIT_AUTHOR_NAME'] %> (<%= ENV['GIT_AUTHOR_MAIL'] %>)
# Copyright:: Copyright (c) <%= Time.now.year %> <%= config[:author] %>
# License::   <%= config[:license] %>
#
# ------------------------------------------------------------------------------
# = Defines: <%= config[:name] %>::mydef
#
# <%= config[:summary] %>
#
# == Pre-requisites
#
# * The class '<%= config[:name] %>' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*content*]
#  Specify the contents of the mydef entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the mydef entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#  In neither the 'source' or 'content' parameter is specified, then the
#  following parameters can be used to set the console entry.
#
# == Sample usage:
#
#     include "<%= config[:name] %>"
#
# You can then add a mydef specification as follows:
#
#      <%= config[:name] %>::mydef {
#
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define <%= config[:name] %>::mydef(
    $ensure         = 'present',
    $content        = '',
    $source         = ''
)
{
    include <%= config[:name] %>::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("<%= config[:name] %>::mydef 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($<%= config[:name] %>::ensure != $ensure) {
        if ($<%= config[:name] %>::ensure != 'present') {
            fail("Cannot configure a <%= config[:name] %> '${basename}' as <%= config[:name] %>::ensure is NOT set to present (but ${<%= config[:name] %>::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    $real_content = $content ? {
        '' => $source ? {
            ''      => template('<%= config[:name] %>/<%= config[:name] %>_entry.erb'),
            default => ''
        },
        default => $content
    }
    $real_source = $source ? {
        '' => '',
        default => $content ? {
            ''      => $source,
            default => ''
        }
    }

    # concat::fragment { "${<%= config[:name] %>::params::configfile}_${basename}":
    #     target  => "${<%= config[:name] %>::params::configfile}",
    #     ensure  => "${ensure}",
    #     content => $real_content,
    #     source  => $real_source,
    #     order   => '50',
    # }

    # case $ensure {
    #     present: {

    #     }
    #     absent: {

    #     }
    #     disabled: {

    #     }
    #     default: { err ( "Unknown ensure value: '${ensure}'" ) }
    # }

}


