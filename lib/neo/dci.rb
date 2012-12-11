module Neo
  module DCI
  end
end
 
require 'neo/dci/version'
require 'neo/dci/data'
require 'neo/dci/role'
require 'neo/dci/context'
require 'neo/dci/context_result'

require 'neo/dci/task_loader' if defined?(::Rails::Railtie)
