require 'tk'
class Experiment_element
  attr_accessor :x,:y
  def initialize(x_max, y_max)
    @x = rand x_max
    @y = rand y_max
  end
  def get_distance(element)
    return Math.sqrt((@x-element.x)**2+(@y-element.y)**2)
  end
end
class Cluster < Experiment_element
  attr_accessor :x, :y, :index,:cluster_members
  def initialize(element, index)
    @x = element.x
    @y = element.y
    @index = index
    @posibly_index = index
    @cluster_members = Array.new
    @cluster_members_index = Array.new
  end
  def is_central_element?
    min_distance = 10000
    (0...@cluster_members.size).each {|i|
      sum = 0

      (0...@cluster_members.size).each {
        |j|
        sum+=@cluster_members[i].get_distance(@cluster_members[j])
      }
      sum/=@cluster_members.size
      if min_distance>sum
        min_distance = sum
        @posibly_index = i
      end
    }
    if @index!=@cluster_members_index[@posibly_index]
      @index = @cluster_members_index[@posibly_index]
      @x = @cluster_members[@posibly_index].x
      @y = @cluster_members[@posibly_index].y
      return false
    end
    return true
  end
  def add_member(element, index)
    @cluster_members.push element
    @cluster_members_index.push index
  end
  def draw_elements(canvas, color)
    (0...@cluster_members.size).each{|index|
    TkcArc.new(canvas,@cluster_members[index].x-4,@cluster_members[index].y-4,
               @cluster_members[index].x+4,@cluster_members[index].y+4,'fill'=>color)}
    TkcOval.new(canvas,@x-4,@y-4,@x+4,@y+4, 'fill'=>'red')
  end
  def clear
    if !@cluster_members.empty?
      @cluster_members.clear
      @cluster_members_index.clear
    end
  end
end
class Experiment
  @list_elements
  def initialize(elements_count,x_max, y_max)
    @list_elements = Array[elements_count]
    @classified_elements = Array.new(@list_elements.size,-1)
    (0...elements_count).each {|i|@list_elements[i]=Experiment_element.new(x_max,y_max)}
    @x_max = x_max
    @y_max = y_max
  end
  def randomly_choose_clusters(clusters_count)
    @clusters = Array.new()
    index_array = Array.new
    (0...clusters_count).each{ |i|
      index = rand @list_elements.size
      while(index_array.include? index)
        index = rand @list_elements.size
      end
      index_array.push(index)
      @clusters.push Cluster.new(@list_elements[index], index)
    }
  end
  def draw_elements(canvas)
    color_list = ['red','blue','green','yellow','cyan','black','azure','purple','deeppink','bisque']
    (0...@clusters.size).each{|i| @clusters[i].draw_elements(canvas, color_list[i])}
  end
  def sort_elements
    max_distance = Math.sqrt(@x_max**2+@y_max**2)
    (0...@list_elements.size).each{|index| distance = max_distance
    min_distance_index = -1
    (0...@clusters.size).each{|head_index| temp = @clusters[head_index].get_distance(@list_elements[index])
    p temp
    if temp < distance
      distance = temp
      min_distance_index =head_index
    end}
    @clusters[min_distance_index].add_member @list_elements[index], index}
  end
  def k_middle(clusters_count,canvas)
    self.randomly_choose_clusters(clusters_count)
    is_ready = false
    while(!is_ready)
      (0...@clusters.size).each{|i| @clusters[i].clear}
      canvas.delete('all')
      self.sort_elements
      self.draw_elements(canvas)
      is_ready = true
      (0...@clusters.size).each{|i|
        is_ready = @clusters[i].is_central_element? && is_ready}
    end
  end
end