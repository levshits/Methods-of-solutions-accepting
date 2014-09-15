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
class Experiment
  @list_elements
  def initialize(elements_count,x_max, y_max)
    @list_elements = Array[elements_count]
    @classified_elements = Array.new(@list_elements.size,-1)
    (0...elements_count).each {|i|@list_elements[i]=Experiment_element.new(x_max,y_max)}
  end
  def draw_elements(canvas)
    color_list = ['red','blue','green','yellow','cyan','black','azure','purple','deeppink','bisque']
    (0...@class_heads.size).each{|i| TkcOval.new(canvas,@class_heads[i].x-4,@class_heads[i].y-4,
                                                 @class_heads[i].x+4,@class_heads[i].y+4, 'fill'=>'red')}
    (0...@list_elements.size).each{|i| TkcArc.new(canvas,@list_elements[i].x-4,@list_elements[i].y-4,
                                                  @list_elements[i].x+4,@list_elements[i].y+4, 'fill'=> color_list[@classified_elements[i]+1])}
  end
  def k_middle(head_count,canvas, x_max,y_max)
    @class_heads = Array.new
    index_array = Array.new
    (0...head_count).each{ |i|
      index = rand @list_elements.size
      p "index " +index.to_s
      while(index_array.include? index)
        index = rand @list_elements.size
      end
      p index_array
      index_array.push(index)
      p index
      @class_heads.push @list_elements[index]
      p index
    }
    max_distance = Math.sqrt(x_max**2+y_max**2)
    print max_distance
    (0...@list_elements.size).each{|index| distance = max_distance
    (0...head_count).each{|head_index| temp = @class_heads[head_index].get_distance(@list_elements[index])
                                        p temp
                                        if temp < distance
                                          distance = temp
                                          @classified_elements[index] = head_index
                                        end}
                                        p "min "+distance.to_s}
      is_not_ready = true
      self.draw_elements(canvas)
      while(is_not_ready)
        is_not_ready = false
        distance_from_each = Array.new(@list_elements.size){Array.new(2,0)}
        (0...@list_elements.size).each{|i|
          (i...@list_elements.size).each{|j|
          if @classified_elements[i]==@classified_elements[j]
            temp = @list_elements[i].get_distance(@list_elements[j])
            distance_from_each[i][0] +=temp
            distance_from_each[j][0] +=temp
            distance_from_each[i][1] +=1
            distance_from_each[j][1] +=1
          end}}
        print "OK"
        print index_array
        min_distance = Array.new(index_array.size,0)
        (0...index_array.size).each{|index|
          min_distance[index]=distance_from_each[index_array[index]][0]/distance_from_each[index_array[index]][1]
        }
        (0...@list_elements.size).each{|index|
        if (distance_from_each[index][0]/distance_from_each[index][1]) < (min_distance[@classified_elements[index]])
          is_not_ready =true
          min_distance = distance_from_each[index][0]/distance_from_each[index][1]
          index_array[@classified_elements[index]]=index
        end}
      end

  end

end