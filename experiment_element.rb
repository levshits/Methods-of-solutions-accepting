require 'tk'
class Experiment_element
  attr_accessor 'x', 'y'
  def initialize(x_max, y_max)
    @x = rand x_max
    @y = rand y_max
  end
  def get_distance(element)
    Math.sqrt((@x-element.x)**2+(@y-element.y)**2)
  end
end
class Cluster < Experiment_element
  attr_accessor 'x', 'y', 'index', 'cluster_members'
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
    true
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
  def find_the_farthest_element
    max_distance = 0
    max_element_index = 0
    (0...@cluster_members.size).each{|index|
      temp = self.get_distance(cluster_members[index])
      if temp > max_distance
        max_distance = temp
        max_element_index = @cluster_members_index[index]
      end}
    [max_distance,max_element_index]
  end
  def clear
    unless @cluster_members.empty?
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
  def draw_elements(canvas)
    color_list = %w(red blue green yellow cyan black azure purple deeppink bisque)
    (0...@clusters.size).each{|i| @clusters[i].draw_elements(canvas, color_list[i])}
  end
  def dispetch_elements(canvas)
    is_ready = false
    until is_ready
      (0...@clusters.size).each { |i| @clusters[i].clear }
      canvas.delete('all')
      self.sort_elements
      self.draw_elements(canvas)
      is_ready = true
      (0...@clusters.size).each { |i|
        is_ready = @clusters[i].is_central_element? && is_ready }
    end
  end
  def randomly_choose_clusters(clusters_count)
    @clusters = Array.new()
    index_array = Array.new
    (0...clusters_count).each{ |_|
      index = rand @list_elements.size
      while index_array.include? index
        index = rand @list_elements.size
      end
      index_array.push(index)
      @clusters.push Cluster.new(@list_elements[index], index)
    }
  end
  def choose_clusters_by_maximin(canvas)
    @clusters = Array.new
    index = rand @list_elements.size
    @clusters.push Cluster.new(@list_elements[index], index)
    is_search_end = false
    until is_search_end
      self.sort_elements
      max_elements = [0, 0]
      (0...@clusters.size).each { |i| temp = @clusters[i].find_the_farthest_element
      if temp[0]> max_elements[0]
        max_elements[1] = temp[1]
        max_elements[0] = temp[0]
      end }
      sum_distance = 0
      if @clusters.size>1
        (0...@clusters.size).each { |i| sum_distance += @clusters[i].get_distance(@clusters[i-1]) }
      end
      is_search_end = true
      sum_distance/=@clusters.size
      p @clusters.size
      if @clusters.size>1
        sum_distance/=2
      end
      p sum_distance
      p max_elements
      if sum_distance < max_elements[0]
        @clusters.push Cluster.new(@list_elements[max_elements[1]], max_elements[1])
        (0...@clusters.size).each { |i| @clusters[i].clear }
        is_search_end = false
      end
    end
    self.draw_elements(canvas)
    Tk.update_idletasks()
    sleep(3)
    self.dispetch_elements(canvas)
  end

  def sort_elements
    max_distance = Math.sqrt(@x_max**2+@y_max**2)
    (0...@list_elements.size).each{|index| distance = max_distance
    min_distance_index = 0
    (0...@clusters.size).each{|head_index| temp = @clusters[head_index].get_distance(@list_elements[index])
    if temp < distance
      distance = temp
      min_distance_index =head_index
    end}
    @clusters[min_distance_index].add_member @list_elements[index], index}
  end
  def k_middle(clusters_count,canvas)
    self.randomly_choose_clusters(clusters_count)
    self.dispetch_elements(canvas)
  end

end