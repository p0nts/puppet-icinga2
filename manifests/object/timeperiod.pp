# == Defined type: icinga2::object::timeperiod
#
#  This is a defined type for Icinga 2 host objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/object-types#objecttype-timeperiod
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::timeperiod (
  $object_name                   = $name,
  $templates                     = ['legacy-timeperiod'],
  $timeperiod_display_name       = undef,
  $methods                       = undef,
  $ranges                        = {},
  $target_dir                    = '/etc/icinga2/objects/timeperiods',
  $target_file_name              = "${name}.conf",
  $target_file_ensure            = file,
  $target_file_owner             = $::icinga2::config_owner,
  $target_file_group             = $::icinga2::config_group,
  $target_file_mode              = $::icinga2::config_mode,
  $refresh_icinga2_service       = true
) {

  validate_string($object_name)
  validate_array($templates)
  validate_string($timeperiod_display_name)
  if $methods {
    validate_string($methods)
  }
  validate_hash($ranges)
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')
  validate_bool($refresh_icinga2_service)

  #If the refresh_icinga2_service parameter is set to true...
  if $refresh_icinga2_service == true {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object/timeperiod.conf.erb'),
      #...notify the Icinga 2 daemon so it can restart and pick up changes made to this config file...
      notify  => Class['::icinga2::service'],
    }

  }
  #...otherwise, use the same file resource but without a notify => parameter:
  else {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object/timeperiod.conf.erb'),
    }

  }

}
