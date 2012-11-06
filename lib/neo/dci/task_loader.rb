module Neo
  module DCI
    # Load rake tasks under lib/tasks
    class TaskLoader < ::Rails::Railtie
      rake_tasks do
        Dir[File.join(File.dirname(__FILE__),'../../tasks/**/*.rake')].each { |f| load f }
      end
    end
  end
end
