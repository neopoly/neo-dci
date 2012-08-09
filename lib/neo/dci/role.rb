# A Role gives an object (e.g. an User) specific behaviour (or methods).
#
# == Example
#
#   module TeamMember
#     extend Neo::DCI::Role
#
#     def self.assignable_to?(user, team)
#       team.member?(user)
#     end
#
#     def leave_team!(team)
#       # ...
#     end
#   end
#
#   class User
#     include Neo::DCI::Data
#   end
#
#   team_member = team.members.first
#   team_member.role_as TeamMember
#   team_member.leave_team!(team)
#
#   non_member = User.find(1)
#   non_member.role_as TeamMember # => raises Role::NotAssignable
#
module Neo
  module DCI
    module Role
      # Decides if the role is assignable to +object+.
      #
      # The decision can determined by +object+ and +params+.
      #
      # Returns +true+ by default so every +object+ can have that role.
      def assignable_to?(object, *params)
        true
      end

      # Hook after a role has been assigned.
      #
      # Useful for extend the role with other roles.
      def role_assigned(object, *params)
      end

      class NotAssignable < StandardError
        attr_reader :role, :object, :params

        def initialize(role, object, params)
          super "Role #{role} not assignable to #{object} with params #{params.inspect}"
          @role   = role
          @object = object
          @params = params
        end
      end
    end
  end
end
