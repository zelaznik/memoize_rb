require_relative 'memoize.rb'

class Bar
  class_eval do
    def fib(n)
      (n<2) ? n : fib(n-1) + fib(n-2)
    end
  end
end