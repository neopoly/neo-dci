module Neo
  module DCI
    module Data
      # Enhances an object with the Role +role+.
      def role_as(role, *params)
        if role.assignable_to?(self, *params)
          extend role
          role.role_assigned(self, *params)
          self
        else
          raise Neo::DCI::Role::NotAssignable.new role, self, params
        end
      end
    end
  end
end
