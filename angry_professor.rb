#!/usr/bin/ruby

require 'fileutils'

archives   = Dir.glob("*.tar") # get all the submission archives
command    = "./a.out"
c_failure  = []
r_failure  = []
outputs    = []
successful = []

if File.exist?( "output" )
  fin = File.open( "output","r" )
  output = fin.read()
else
  output = []
end

for arg in ARGV
  command = command + " " + arg
end

ARGV.clear

puts "What is the file name?"
assignment_name = gets.chomp()

puts "input?"
input = gets.chomp() 

for archive in archives

  system("tar xf #{archive}")
  username = archive[0..-5]
  File.rename(assignment_name + ".c", username + ".c" )
 
  puts username 
   
  c_output = `gcc -Werror -ansi -pedantic #{username}.c`
  c_result = $?.success?
  
  if c_result == false 
    c_failure.push(username)
    print "!!!ERROR WITH COMPOLATION!!!\n "
    next
  end

  puts command

#  r_output = `#{command} < #{input}`
   r_output = `echo #{input} | #{command}`
  puts r_output + "\nCorrect?"

  if r_output.upcase.include?( "#{output}" ) 
    successful.push(username)
    puts "In the bag"
    next
  end    
  
#  if gets.chomp() != 'y'
  r_failure.push(username)
  next
  #end 
  
  successful.push(username)
end

system( "rm -f a.out" )

# output to file
logfile = File.new( "result", "w")
logfile.write( "Total numer of submissions: #{archives.size}.\n" )

#logfile.write( "Total numer of submissions on time: #{submission_number}.\n" )

logfile.write("\nAll lists are listed alphabetically by last name.\n\nCompile-time failures: #{c_failure.size}\n")
for failure in c_failure.sort_by { |failure| failure[1..-1] }
  logfile.write("#{failure}, \n")
end

logfile.write("\nRun-time failures: #{r_failure.size}\n")
for failure in r_failure.sort_by { |failure| failure[1..-1] }
  logfile.write("#{failure}, \n")
end

logfile.write("\nSuccesses: #{successful.size}\n")
for success in successful.sort_by { |success| success[1..-1] }
  logfile.write("#{success}, \n")
end
