opt_out_usage

# Have an easy way to get the root of the project
def root_path
  Dir.pwd.sub(/.*\Kfastlane/, '').sub(/.*\Kandroid/, '').sub(/.*\Kios/, '').sub(/.*\K\/\//, '')
end

# Have an easy way to run flutter tasks on the root of the project
lane :sh_on_root do |options|
  Dir.chdir(root_path) { sh(options[:command]) }
end

# Tasks to be reused on each platform flow
lane :fetch_dependencies do
  sh_on_root(command: "flutter pub get --suppress-analytics")
end

# Tasks to be reused on each platform flow
lane :build_autogenerated_code do
  sh_on_root(command: "flutter pub run build_runner build --delete-conflicting-outputs")
end

# Tasks to be reused on each platform flow
lane :lint do
  sh_on_root(command: "flutter format --suppress-analytics --set-exit-if-changed -n lib/main.dart lib/src/ test/")
end

# Tasks to be reused on each platform flow
lane :test do |options|
  sh_on_root(command: "flutter test --no-pub --coverage --suppress-analytics")
end