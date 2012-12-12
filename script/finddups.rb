#!/usr/bin/env ruby
#
#
require 'yaml'
require 'digest/md5'

def dir_signature image_dir
  info_string = ""
  orig_dir = Dir.getwd()
  Dir.chdir(image_dir)
  files = Dir.glob("*/*")
  files.sort!
  files.each do |f|
    info_string += File.basename(f) + ':'
    info = File::Stat.new(f)
    info_string += info.size.to_s + ':'
  end
  Dir.chdir(orig_dir)
  Digest::MD5.hexdigest(info_string)
end

path_to_glory = ['public','spree','products']
components_found = 0
iterations = 0
directories = {}
protected_files = {}
starting_point = working_point = Dir.getwd
while(components_found < path_to_glory.count || iterations > 100) do
  d = Dir.new('.')
  d.each do |f|
    next if f == '..' || f == '.'
    entries = nil
    if path_to_glory.include?(f) && File.directory?(f)
      Dir.chdir(f)
      components_found += 1
      break
    end
  end
end

if components_found == path_to_glory.count
  working_point = Dir.getwd
else
  exit
end
puts "Working in #{working_point}"

d = Dir.new(working_point)

d.each do |f|
  next if f == '..' || f == '.'
  if File.symlink?(f)
    protected_files[File.readlink(f)] = 1
  end
  this_signature = dir_signature f
  directories[this_signature] ||= []
  directories[this_signature] << f
end

directories.each_pair do |sig,dirs|
  dirs.sort!
  if dirs.count > 1
    puts "#{sig} has #{dirs.count}"
  end
  basedir = nil
  dirs.each_index do |i|
    if protected_files[dirs[i]]
      basedir = dirs[i]
      break
    end
  end
  dirs.compact
  basedir = dirs.shift if !basedir
  dirs.each do |d|
    next unless protected_files[d].nil?
    next if File.symlink?(d)
    File.rename(d, d + '.delete')
    File.symlink(basedir,d)
  end
end
