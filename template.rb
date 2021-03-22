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
  copy_file "config/application.rb", force: true
end

add_template_directory_to_source_path
use_custom_gemfile
disable_unwanted_generators
