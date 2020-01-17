# A compatible delegation that works on Ruby 2.6, 2.7 and Ruby 3:
#
#    ruby2_keywords def foo(*args, &block)
#      target(*args, &block)
#    end
#
# Ruby <= 2.6 does not handle the new delegation style correctly, so the old-style delegation
# must be used.
#
# `ruby2_keywords` allows you to run the old style even in Ruby 2.7 and 3.0.
#
# More informations:
# https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/
#
# Discussion about adding `ruby2_keywords` semantics by default in 2.7.1:
# https://bugs.ruby-lang.org/issues/16463
#
#
# We need to remove this method if we no longer support Ruby versions < 2.7.
#
module Kernel
  def ruby2_keywords(*)
  end if RUBY_VERSION < "2.7"
end
