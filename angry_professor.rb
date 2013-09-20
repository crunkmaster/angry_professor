#!/usr/bin/ruby

require 'fileutils'

# get all the submission archives
archives = Dir.glob("*.tar")

inputs = Array.new
c_failure = Array.new
r_failure = Array.new 
successful = Array.new

command = "./a.out"

for item in ARGV
  inputs.push(item)
end

ARGV.clear

puts "what is the file name?"
assignment_name = gets.chomp()

puts archives

for archive in archives

  system("tar xf #{archive}")
  username = archive[0..-5]
  username = username + ".c"
  File.rename(assignment_name, username)

  puts username[0..-3] 

  c_output = `gcc -Wall -ansi -pedantic #{username}`
  c_result = $?.success?
  
  puts c_result

  if c_result == false 
    c_failure.push(username[0..-3])
    
    puts "%d " % c_result
    print "!!!ERROR WITH COMPOLATION!!!\n "

    next
  end

  for input in inputs
    command = command + " " + input
  end

  r_output = `#{command}`
  
  if r_output.include? "Right turn" or r_output.include? "Right Turn" 
    successful.push(username[0..-3])
    puts "In the bag"
    next
  end    
  
  
  puts r_output + "\nCorrect?"
  
  if gets.chomp() != 'y'
  
    r_failure.push(username[0..-3]) ;
    next
   
  end 
  
  successful.push(username[0..-3])
    
end

print "These are the compile-time failures: #{c_failure}\n"

print "These are the run-time failures: #{r_failure}\n"

print "These are the successes: #{successful}\n"

