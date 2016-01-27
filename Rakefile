require 'rake/clean'
require 'rake/testtask'
require 'rubygems'
require 'rubygems/package_task'

spec = eval(File.read('ludoc.gemspec'))

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

Gem::PackageTask.new(spec) do |pkg|
end

task :install do
  sh "rake gem"
  sh "sudo gem uninstall ludoc"
  sh "sudo gem install pkg/ludoc-#{Ludoc::VERSION}.gem"
  sh "rake clobber"
end
