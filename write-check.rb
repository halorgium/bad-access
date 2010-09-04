#!/usr/bin/env ruby

require 'find'
require 'fileutils'

class Badness
  def initialize
    File.open("tmp/bad", "w") do |f|
      f.puts "Starting..."
    end
  end

  def add(type, path)
    File.open("tmp/badcount", "w") do |f|
      report(f)
    end
    File.open("tmp/bad", "a") do |f|
      f.puts [type, path].inspect
    end
    them << [type, path]
  end

  def report(io = $stdout)
    io.puts "Bad: #{them.size}"
    io.puts "Prefixed: #{grouped_prefixed.size}"

    grouped_prefixed.map do |prefix,matches|
      io.puts "%s: %d" % [prefix, matches.size]
    end

    io.puts "-" * 80
  end

  def grouped_prefixed
    prefixed.group_by do |(type,path)|
      path
    end
  end

  def prefixed
    them.map do |type,path|
      prefix = path.split("/")[0..3].join("/")
      [type, prefix]
    end
  end

  def invalid?(path)
    !File.socket?(path) && !File.owned?(path) && File.writable?(path)
  end

  def them
    @them ||= []
  end
end

bad = Badness.new
Find.find("/") do |path|
  if FileTest.directory?(path)
    case path
    when ENV["HOME"], "/dev", "/Volumes/Backup"
      Find.prune
    when "/Volumes", "/.Trashes", "/Library/Caches",
         "/tmp", "/private/tmp", "/private/var/tmp", "/private/var/db/lockdown",
         "/Users/Shared", "/Users/Shared/SC Info",
         %r(\A/Users/\w+/Public/Drop Box\Z)
      next
    else
      pieces = path.split("/")
      if pieces.size < 4
        puts "visiting #{path}"
      end

      if bad.invalid?(path)
        bad.add(:dir, path)
      end

      next
    end
  else
    case path
    when %r(\A/private/var/db/lockdown/[0-9a-f]+\.plist\Z)
      next
    else
      if bad.invalid?(path)
        bad.add(:file, path)
      end
    end
  end
end

bad.report

puts "Completed"
