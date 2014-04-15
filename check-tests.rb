#!/bin/env ruby
# encoding: utf-8

CORRECT_ANSWERS_FILE = "correct.txt"

def extract_answers(file)
  answers = []
  while(line = file.gets)
    line.strip
    number_answer = line.split(' ')
    answers[number_answer.first.to_i] =  number_answer.last
  end

  return answers
end

def get_test_points(test_answers, correct_answers)
	question = 1
	points = 0
	while(question < correct_answers.count)
		answer_points = (question >= 20 && question <= 25) ? 2 : 1
		points += answer_points if correct_answers[question] == test_answers[question]
		question = question.next
	end

	return points
end

unless File.exist?(CORRECT_ANSWERS_FILE)
  puts "please create the correct.txt file"
  exit
end

correct = File.new(CORRECT_ANSWERS_FILE, "r")
correct_answers = extract_answers(correct)
tests = Dir["./*.txt"]
tests.reject! {|test| test == "./#{CORRECT_ANSWERS_FILE}"}

results = {}

tests.each do |test|
	test_file = File.new(test, "r")
	test_answers = extract_answers(test_file)
	points = get_test_points(test_answers, correct_answers)
	results.merge!({ test.gsub('./', '').downcase => points })
	test_file.close
end
results.sort.map do |name, points|
	puts "#{name} - #{points}"
end

