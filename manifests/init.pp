# See README.md for details.
class accounts(
  $groups_membership        = undef,
  $ssh_keys                 = {},
  $users                    = {},
  $usergroups               = {},
  $accounts                 = {},
  $start_uid                = undef,
  $start_gid                = undef,
  $purge_ssh_keys           = false,
  $ssh_authorized_key_title = '%{ssh_key}-on-%{account}',
  $shell                    = undef,
  $managehome               = true,
  $forcelocal               = true,
) {
  include ::accounts::config

  # create any groups found in the usergroups hash
  group {
    keys($usergroups):
      ensure => present,
  }

  create_resources(accounts::account, $accounts)

  # Remove users marked as absent
  $absent_users = keys(absents($users))
  user { $absent_users:
    ensure     => absent,
    forcelocal => $forcelocal,
  }
}
