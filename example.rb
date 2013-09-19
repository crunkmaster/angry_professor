#!/usr/bin/env ruby

require 'fileutils'

# get all the submission archives
archives = Dir.glob("*.tar")
inputs = Array.new
c_failure = Array.new
successful = Array.new

for item in ARGV
  inputs.push(item)
end

command = "./a.out"

puts "what's the file name?"
assignment_name = gets.chomp()

puts archives

for archive in archives
  system("tar xf #{archive}")
  username = archive[0..-5]
  username = username + ".c"
  File.rename(assignment_name, username)

  c_output = `gcc -ansi -Werror -pedantic #{username}`
  c_result = $?.success?

  if c_result != 0
    c_failure.push(username[0..-3])
    next
  end

  for input in inputs
    command = command + " " + input
  end

  r_output = `#{command}`
  puts r_output
  puts "does this look correct?"
  if gets.chomp() == 'y'
    # save it to a file of good programs
   
      
end

print "these are the failures: #{c_failure}\n"

## for every archive
## untar archive, rename file to username.c
## compile username.c to a.out
## test output from a.out with answer from solutions

# grab all inputs from ARGV

for input in inputs
  print "input: #{input}\n"
end

puts "archives: #{archives}"

# get expected output from a solutions file
expected_output = File.new("solution", "r")
