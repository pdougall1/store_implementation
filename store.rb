require 'spec_helper'

class Store

  def initialize(data: {})
    @data = data
  end

  def read(path)
    recurse_hash(path, @data)
  end

  def write(path, value)
    recurse_hash(path, @data) { |hash, key|
      hash[key] = value
    }
  end

  def recurse_hash(path, hash, &block)
    key = path.shift
    return hash unless key

    unless hash.keys.include?(key)
      raise ArgumentError.new("Data did not incldue a segment in the path : #{key}")
    end

    if path.empty?
      if block
        block.call(hash, key)
      else
        return hash[key] 
      end
    end
    
    recurse_hash(path, hash[key], &block)
  end
end