class Array
  
  def first?(obj)
    index(obj) == 0
  end

  def last?(obj)
    index(obj) == count-1
  end

  def move_to_front(obj)
    delete(obj)
    insert(0, obj)
  end

  def move_to_back(obj)
    delete(obj)
    push(obj)
  end

  def move_forward(obj)
    unless first?(obj)
      i = index(obj) - 1
      delete(obj)
      insert(i, obj)
    end
  end

  def move_back(obj)
    unless last?(obj)
      i = index(obj) + 1
      delete(obj)
      insert(i, obj)
    end
  end

end
