require 'helper'

class RoleTest < NeoDCICase
  module Human
    extend Neo::DCI::Role

    def live!
      :live
    end
  end

  module CryBaby
    extend Neo::DCI::Role
    include Human

    def self.assignable_to?(user, emo=false)
      emo || user.gender == :female
    end

    def cry!
      :me_a_river
    end
  end

  module EmoCore
    extend Neo::DCI::Role

    def self.role_assigned(user, *args)
      user.role_as(CryBaby, *args)
    end

    def growl!
      :breee
    end
  end

  User = Struct.new(:gender) do
    include Neo::DCI::Data
  end

  let(:male) { User.new(:male) }
  let(:emo) { User.new(:male) }
  let(:female) { User.new(:female) }

  context :usage do
    test "all humans can live" do
      male.role_as Human
      female.role_as Human
      assert_equal :live, male.live!
      assert_equal :live, female.live!
    end

    test "female can cry!" do
      female.role_as CryBaby
      assert_equal :me_a_river, female.cry!
    end

    test "emo can cry!" do
      emo.role_as CryBaby, true
      assert_equal :me_a_river, emo.cry!
    end

    test "boys don't cry!" do
      e = assert_raises Neo::DCI::Role::NotAssignable do
        male.role_as CryBaby
      end
      assert_equal CryBaby, e.role
      assert_equal male, e.object
    end

    test "emo cores can cry! and growl!" do
      emo.role_as EmoCore, true
      assert_equal :me_a_river, emo.cry!
      assert_equal :breee, emo.growl!
    end
  end

  context :role_as do
    test "returns object itself" do
      actual = female.role_as CryBaby
      assert_same female, actual
    end
  end
end
