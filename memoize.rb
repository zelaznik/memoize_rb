module Memoize
  def memoize(&block)

    yield

    cls0 = Class.new
    cls = Class.new &block

    class_names = cls.public_methods(false) - cls0.public_methods(false)
    instance_names = cls.instance_methods(false)

    instance_names.each do |name|
      orig = instance_method(name)

      cache = Hash.new do |h,k|
        scope, *args = k
        h[k] = orig.bind(scope).call(*args)
      end

      define_method(name) { |*args| cache[[self] + args] }
    end

    class_names.each do |method_name|
      orig = public_method(method_name).unbind
      cache = Hash.new do |h,k|
        scope, *args = k
        h[k] = orig.bind(scope).call(*args)
      end

      define_singleton_method(method_name) { |*args| cache[[self] + args] }
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
    def self.cls_name
      puts "Calling Foo.cls_name"
      name
    end
  end
end