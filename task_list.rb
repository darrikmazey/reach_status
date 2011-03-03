
require 'task'

class TaskList

	def initialize
		@tasks = Array.new
	end

	def self.load_from_file(status_file)
		if File.exists?(status_file)
			tl = nil
			File.open(status_file, 'r') { |f|
				tl = YAML.load(f.read)
			}
			return tl
		end
		return TaskList.new
	end

	def save_to_file(status_file)
		File.open(status_file, 'w') { |f|
			f.puts YAML.dump(self)
		}
	end

	def <<(t)
		if t.class == Task
			@tasks << t unless @tasks.include? t
		end
	end

	def [](i)
		return(@tasks[i])
	end

	def to_list
		i = -1
		@tasks.map { |t| i += 1; "#{i} : #{t}" }.join("\n")
	end

	def to_status
		lines = []
		user = `whoami`.chomp
		now = DateTime.now
		last_monday = now - (now.wday - 1)
		lines << "#status ##{user} ##{last_monday.strftime('%Y%m%d')} @Chris"
		lines << "  #{user.capitalize}:"

		@finished = @tasks.select { |t| t.finished? and t.finished_at > last_monday }
		if @finished.size > 0
			lines << "    Finished:"
			@finished.each do |t|
				lines << "      - #{t.description}"
			end
		end
		@current = @tasks.select { |t| t.started? and !t.finished? }
		if @current.size > 0
			lines << "    Current:"
			@current.each do |t|
				lines << "      - #{t.description}"
			end
		end
		@on_deck = @tasks.select { |t| !t.started? and !t.finished? }
		if @on_deck.size > 0
			lines << "    On Deck:"
			@on_deck.each do |t|
				lines << "      - #{t.description}"
			end
		end
		lines.join("\n")
	end

	def count
		@tasks.count
	end

	def remove(i)
		@tasks.delete_at(i)
	end
end
