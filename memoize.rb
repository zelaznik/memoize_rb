module Memoize
  def memoize(&block)
    yield
    cls = Class.new &block

    cls.instance_methods(false).each do |name|
      orig = instance_method(name)

      cache = Hash.new do |h,k|
        scope, *args = k
        h[k] = orig.bind(scope).call(*args)
      end

      define_method(name) { |*args| cache[[self] + args] }
    end
  end
end

class Foo
  extend Memoize

  memoize do
    def fib(n)
      (n < 2) ? n : fib(n-1) + fib(n-2)
    end
    def fact(n)
      (n < 1) ? 1 : n * fact(n-1)
    end
  end
end