# take a user name and a hash of user groups
# find which groups that user is a member of
# also expand any users listed with an @ symbol
# at the start of the user name - this will be a
# ref to a group

module Puppet::Parser::Functions
  newfunction(:user_is_group_member, :type => :rvalue, :doc => <<-EOS
      Returns an array of groups a user is a member of
    EOS
  ) do |args|
    raise(Puppet::ArgumentError, "user_is_group_member(): Wrong number of arguments given") if args.size != 2
    raise(Puppet::ArgumentError, "user_is_group_member(): First parameter must be a string") if args[0].class != String
    raise(Puppet::ArgumentError, "user_is_group_member(): Second parameter must be a hash") if args[1].class != Hash

    user = args[0]
    usergroups = args[1]
    groups = []

    usergroups.each do |groupname, properties|
      if properties.class == Hash and properties.has_key?('members')
        if properties['members'].include? user
          groups << groupname
        end
        properties['members'].each do |member|
          if member.start_with?('@')
            group_member = member.tr('@','')
            if usergroups[group_member]['members'].include? user
              groups << groupname
            end
          end
        end
      end
    end
    #Puppet.notice("user #{user} has groups: " + groups.to_s)
    groups
  end
end
