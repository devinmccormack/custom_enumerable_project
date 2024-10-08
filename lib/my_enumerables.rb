module Enumerable
  def my_each_with_index
    # Return an enumerator if no block is given
    return to_enum(:my_each_with_index) unless block_given?

    # Use an index counter to yield each element and its index
    index = 0
    for element in self
      yield(element, index)
      index += 1
    end

    # Return the original enumerable
    self
  end

  # Define my_all?
  def my_all?
    # Return true if the block is not given and all elements are truthy
    if !block_given?
      my_each { |element| return false unless element }
      return true
    end

    # Iterate over each element and yield it to the block
    my_each do |element|
      # If the block returns false for any element, return false
      return false unless yield(element)
    end

    # If all elements passed the block condition, return true
    true
  end

  # Define my_any?
  def my_any?
    # Check if the block is given; if not, check truthiness of elements
    if !block_given?
      my_each { |element| return true if element }
      return false
    end

    # Iterate over each element and yield it to the block
    my_each do |element|
      # Return true if any element satisfies the block's condition
      return true if yield(element)
    end

    # If no elements meet the condition, return false
    false
  end

  # Define my_none?
  def my_none?
    # Check if the block is given; if not, check truthiness of elements
    if !block_given?
      my_each { |element| return false if element }
      return true
    end

    # Iterate over each element and yield it to the block
    my_each do |element|
      # Return false if any element satisfies the block's condition
      return false if yield(element)
    end

    # If no elements meet the condition, return true
    true
  end

  # Define my_count
  def my_count
    # If a block is given, count elements that satisfy the condition
    if block_given?
      count = 0
      my_each { |element| count += 1 if yield(element) }
      return count
    end

    # If no block is given, return the size of the enumerable
    size
  end

  # Define my_map
  def my_map
    result = []
    
    if block_given?
      my_each do |element|
        result << yield(element)
      end
    elsif !block_given? && Proc === Proc.new
      my_each do |element|
        result << Proc.new.call(element)
      end
    end
    
    result
  end

  # Define my_inject
  def my_inject(initial = nil, sym = nil)
    # If the initial value is a symbol, shift it to sym
    if initial.is_a?(Symbol) || initial.is_a?(String)
      sym = initial
      initial = nil
    end

    # If sym is given, convert it to a proc
    if sym
      my_each { |element| initial = initial ? initial.send(sym, element) : element }
    else
      # Otherwise, use the block provided
      my_each { |element| initial = initial ? yield(initial, element) : element }
    end

    initial
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    # Return an enumerator if no block is given
    return to_enum(:my_each) unless block_given?

    # Iterate over each element and yield to the block
    for element in self
      yield(element)
    end

    # Return the original array
    self
  end
end
