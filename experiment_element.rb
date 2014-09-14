class Experiment_element
  attr_accessor :x,:y
  def initialize(x_max, y_max)
    @x = rand x_max
    @y = rand y_max
  end
end