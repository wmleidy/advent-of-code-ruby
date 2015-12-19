class Node
	attr_accessor :value, :next

	def initialize(value = nil)
		@value = value
		@next = nil
	end
end

class Stack
	def initialize
		@top = nil
	end

	def push(value)
		node = Node.new(value)
		node.next = @top
		@top = node
		self
	end

	def pop
		value = @top.value
		@top = @top.next
		value
	end

	def peek
		@top.value
	end

	def empty?
		@top.nil?
	end
end

class Queue
	def initialize
		@first = nil
		@last = nil
	end

	def enqueue(value)
		node = Node.new(value)
		if self.empty?
			@first = node
			@last = node
		else
			@last.next = node
			@last = @last.next		
		end
		self
	end

	def dequeue
		value = @first.value
		@first = @first.next
		value
	end

	def front
		@first.value
	end

	def back
		@last.value
	end

	def empty?
		@first.nil?
	end
end