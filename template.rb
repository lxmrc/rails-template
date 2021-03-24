# Add this directory to `source_paths` so that `copy_file` etc. work
# correctly. If this file was invoked remotely, use `git clone` to
# download them to a local temporary directory.
def add_template_directory_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/lxmrc/rails-template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

# Replace default Gemfile with custom version
def use_custom_gemfile
  copy_file "Gemfile", force: true
end

# Disable unwanted generators
def disable_unwanted_generators
  insert_into_file "config/application.rb", 
    after: "config.generators.system_tests = nil" do
      <<-RUBY
    \n
    config.generators do |g|
      g.stylesheets       false
      g.javascripts       false
      g.helper            false
      g.assets            false
      g.view_specs        false
      g.fixtures          false
      g.view_specs        false
      g.helper_specs      false
      g.routing_specs     false
      g.request_specs     false
      g.controller_specs  false
    end
      RUBY
    end
end

# Run `rails webpacker:install`
def add_webpacker
  rails_command "webpacker:install"
end

# Add Bootstrap and jQuery
def add_bootstrap_and_jquery
  run("yarn add bootstrap jquery popper.js")
  directory "app/javascript/css"
  copy_file "app/javascript/packs/application.js", force: true
  copy_file "config/webpack/environment.js", force: true
  copy_file "app/views/layouts/application.html.erb", force: true
end

add_template_directory_to_source_path
use_custom_gemfile
disable_unwanted_generators
add_webpacker
add_bootstrap_and_jquery
