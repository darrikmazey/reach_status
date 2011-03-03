
require 'yaml'
require 'date'

class Task
	attr_accessor :description

	def initialize(desc = nil)
		@description = desc
		@created_at = DateTime.now
		@started_at = nil
		@finished_at = nil
		@started = false
		@finished = false
	end
	
	def started_at
		@started_at.to_datetime
	end

	def finished_at
		@finished_at.to_datetime
	end

	def serialize
		YAML.dump(self)
	end

	def to_s
		"#{description} (#{status})"
	end

	def status
		if @finished
			return "finished : #{@finished_at.strftime('%Y-%m-%d %H:%M')}"
		elsif @started
			return "started : #{@started_at.strftime('%Y-%m-%d %H:%M')}"
		else
			return "pending"
		end
	end
	
	def finished?
		@finished
	end

	def started?
		@started
	end

	def pending?
		!@started && !@finished
	end

	def start!
		@started_at = DateTime.now
		@started = true
	end

	def finish!
		@finished_at = DateTime.now
		@finished = true
	end

	def restart!
		@finished_at = nil
		@finished = false
		start!
	end

	def unstart!
		@finished_at = nil
		@finished = false
		@started_at = nil
		@started = false
	end
end
