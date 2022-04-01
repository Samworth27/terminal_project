# # normal code
# folder = File.basename(__FILE__, ".*")
# Dir.glob(File.expand_path("../#{folder}/*.rb", __FILE__)).each do |file|
#   require_relative "#{folder}/#{File.basename(file)}"
# end


# # one liner code
# Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}