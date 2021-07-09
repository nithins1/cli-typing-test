require 'terminfo'
require 'colorize'

TIME_LIMIT = 1 # Seconds
CHARS_PER_WORD = 5
height, width = TermInfo.screen_size

puts "##### Typing Speed Test! #####".blue
puts "##### By: Nithin Singhal #####".blue
puts "### Press 'Enter' to start ###".blue
gets

words_list = Array.new
File.readlines('commonwords.txt', chomp: true).each do |word|
  words_list << word
end

mispelled_words = Array.new
correct_words_typed = 0
total_words_printed = 0
total_words_typed = 0
total_chars_typed = 0

t_start = Time.now
while (Time.now - t_start).to_i < TIME_LIMIT do
  line_length = 0
  line = ""
  print("  ")
  while true do
    word = words_list[rand(1000)] + " "
    # Prevent duplicate words from appearing in line
    while line.include? word do
      word = words_list[rand(1000)] + " "
    end

    # Stop adding words when line becomes too long
    if line_length + word.length >= width - 1
      break
    end

    line += word
    line_length += word.length
  end
  print (line + "\r").cyan
  print "> "
  input_line = gets.chomp
  puts

  total_chars_typed += input_line.length

  line = line.split(" ")
  input_line = input_line.split(" ")
  total_words_printed += line.length
  total_words_typed += input_line.length
  line.each do |word|
    if input_line.include? word
      correct_words_typed += 1
    else
      mispelled_words << word
    end
    #puts "Correct words typed: " + correct_words_typed.to_s
    #puts "Total words printed: " + total_words_printed.to_s
  end
end
t_end = Time.now
time_taken = (t_end - t_start).to_f
puts "Time taken: #{format("%.2f", time_taken)}s".green
print("Mispelled words:".red)
if mispelled_words.empty?
  puts " None!".green
else
  mispelled_words.each do |word|
    print (" " + word).red
  end
  puts
end

puts "Accuracy: #{format("%1.2f", (correct_words_typed.to_f / total_words_printed * 100))}%".blue
puts "Words Per Minute (WPM): #{format("%.2f", (total_chars_typed.to_f / CHARS_PER_WORD / (time_taken / 60)))}".blue
puts "Characters Per Second (CPS): #{format("%.2f", (total_chars_typed.to_f / time_taken))}".blue