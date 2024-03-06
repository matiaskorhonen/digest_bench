#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"

require_relative "lib/digest_benchmark"

require "csv"
require "date"

bench = DigestBenchmark.perform

CSV.open("simple_#{Date.today.iso8601}.csv", "wb") do |csv|
  csv << ["label", "user", "system", "total", "real"]
  bench.each do |result|
    csv << [result.label, result.utime, result.stime, result.total, result.real]
  end
end
