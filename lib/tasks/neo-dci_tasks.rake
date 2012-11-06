namespace :"neo-dci" do
  desc "standard tasks for a new application"
  task :setup => [:"build:context", :"build:role"] do
    # nothing for its own
  end

  namespace :build do
    def copy_from_share(path)
      templates = File.expand_path("../share/", __FILE__)
      rails     = Rails.root.to_s
      sh "mkdir -p #{rails}/#{File.dirname path}"
      cp "#{templates}/#{path}", "#{rails}/#{path}"
    end

    desc "build application base role"
    task :role do
      copy_from_share "app/roles/role.rb"
    end

    desc "build application base context"
    task :context do
      copy_from_share "app/contexts/context.rb"
    end
  end
end
