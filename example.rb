#!/usr/bin/env ruby

require 'fileutils'

# get all the submission archives
archives = Dir.glob("*.tar")
inputs = Array.new
c_failure = Array.new

puts "what's the file name?"
assignment_name = gets.chomp()

puts archives

for archive in archives
  system("tar xf #{archive}")
  username = archive[0..-5]
  username = username + ".c"
  File.rename(assignment_name, username)

  output = `gcc -ansi -Werror -pedantic #{username}`
  result = $?.success?

  if result != 0
    c_failure.push(username[0..-3])
  end
end

print "these are the failures: #{c_failure}\n"

## for every archive
## untar archive, rename file to username.c
## compile username.c to a.out
## test output from a.out with answer from solutions

# grab all inputs from ARGV
for item in ARGV
  inputs.push(item)
end

for input in inputs
  print "input: #{input}\n"
end

puts "archives: #{archives}"

# get expected output from a solutions file
expected_output = File.new("solution", "r")
