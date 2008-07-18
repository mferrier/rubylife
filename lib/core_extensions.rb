class String
  def snippet(len=100)
    return self.dup unless len < self.length
    last_space = self[0..len].rindex(' ') || len
    self[0..(last_space-1)] + "..."
  end
end

class Array
  def random
    self[Kernel.rand(length)]
  end
  
  def random!
    self.delete_at(Kernel.rand(length))
  end
  
  # def count(obj = nil, &block)
  #   puts obj.inspect
  #   puts block.inspect
  #   if obj.nil?
  #     self.size
  #   elsif obj
  #     self.select{|i| i == obj}.size
  #   elsif block_given?
  #     collect{|e| yield e}
  #   end
  # end
end

class Numeric
  def at_least(x)
    self < x ? x : self
  end
  
  def at_most(x)
    self > x ? x : self
  end
end

class Object
  def in?(enumerable)
    enumerable.include? self
  end

  def not
    Not.new(self)
  end

  class Not
    private *instance_methods.select {|m| m !~ /(^__|^\W|^binding$)/ }

    def initialize(subject)
      @subject = subject
    end

    def method_missing(sym, *args, &blk)
      !@subject.send(sym,*args,&blk)
    end
  end
end