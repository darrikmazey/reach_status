
require 'task_list'

class StatusApplication
	attr_accessor :status_file, :task_list

	def initialize
		@status_file = File.expand_path("~/.status")
		@task_list = TaskList.load_from_file(@status_file)
	end

	def quit
		@task_list.save_to_file(@status_file)
	end

	def do_action(action, args = [])
		if !self.respond_to? action.to_sym
			puts "unknown action: #{action}"
			return false
		end
		return self.send action.to_sym, args
	end

	def test(args = [])
		puts "test(#{args.join(', ')})"
	end

	def list(args = [])
		puts @task_list.to_list
	end
	alias :l :list

	def print(args = [])
		puts @task_list.to_status
		begin
			File.popen("xclip", 'w') { |f|
				f.write @task_list.to_status
			}
		rescue
		end
	end
	alias :p :print

	def start(args = [])
		task_num = 0
		task_num = args.shift.to_i if args.size > 0
		if @task_list.count <= task_num
			puts "unknown task: #{task_num}"
			self.list
		end
		@task_list[task_num].start!
	end
	alias :s :start

	def finish(args = [])
		task_num = 0
		task_num = args.shift.to_i if args.size > 0
		if @task_list.count <= task_num
			puts "unknown task: #{task_num}"
			self.list
		end
		@task_list[task_num].finish!
	end
	alias :f :finish

	def unstart(args = [])
		task_num = 0
		task_num = args.shift.to_i if args.size > 0
		if @task_list.count <= task_num
			puts "unknown task: #{task_num}"
			self.list
		end
		@task_list[task_num].unstart!
	end
	alias :u :unstart

	def new(args = [])
		desc = args.join(' ')
		t = Task.new
		t.description = desc
		@task_list << t
	end
	alias :n :new

	def delete(args = [])
		task_num = 0
		task_num = args.shift.to_i if args.size > 0
		if @task_list.count <= task_num
			puts "unknown task: #{task_num}"
			self.list
		end
		@task_list.remove(task_num)
	end
	alias :d :delete
end
