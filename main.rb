require_relative 'memoize.rb'

include Memoize

memoize debug: true do
  def fib(n)
    (n<2) ? n : fib(n-1) + fib(n-2)
  end
end

class Foo
  extend Memoize

  memoize debug: true do
    def foo_fib(n)
      (n<2) ? n : foo_fib(n-2) + foo_fib(n-1)
    end
  end
end

Foo.new.instance_eval do
  [5, 10, 30].each do |i|
    puts "foo_fib(#{i}): "
    puts "   #{foo_fib(i)}"
  end
end