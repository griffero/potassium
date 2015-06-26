recipe = ARGV.first

# Consider all marked as true
def selected?(key, val = nil); true; end

run_action(:recipe_loading) do
  eval_file "recipes/asks/#{recipe}.rb" rescue Exception
  eval_file "recipes/#{recipe}.rb"
end


run_action(:gem_install) do
  build_gemfile
  run "bundle install"
end

get(:callbacks).each do |name, cbs|

  puts "Processing #{name} callbacks"
  cbs.each do |event, cb|
    cb.each {|callback| instance_exec(&callback) }
  end

end
