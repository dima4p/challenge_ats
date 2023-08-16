class String
  def to_bool
    return false if blank? || self =~ /^(false|f|no|off|0)$/i
    return true if self =~ /^(true|t|yes|on|1)$/i
    return to_d.to_bool if self =~ /^(-|\+)?[0-9]+(\.[0-9]+)?$/
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

class Symbol
  def to_bool
    to_s.to_bool
  end
end

class FalseClass
  def to_bool
    self
  end
end

class TrueClass
  def to_bool
    self
  end
end

class Numeric
  def to_bool
    not self == 0
  end
end

class Object
  def to_bool
    present?
  end
end
