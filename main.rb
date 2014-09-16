require 'tk'
require 'tkextlib/tile'
require_relative 'experiment_element'


def mousebutton_click(canvas, x_max, y_max )
  canvas.delete('all')
  p "Please choose algoritm"
  p "1. Algorithm k-means."
  p "2. Algorithm maximina."
  p "0. Exit."
  case gets.chomp.to_i
    when 0
      Tk.exit
    when 2
      p "Please enter count of elements"
      elements_count = gets.chomp.to_i
      experiment = Experiment.new(elements_count,x_max,y_max)
      experiment.choose_clusters_by_maximin(canvas)
    when 1
      p "Please enter count of elements"
      elements_count = gets.chomp.to_i
      p "Please enter count of classes"
      classes_count = gets.chomp.to_i
      experiment = Experiment.new(elements_count,x_max,y_max)
      experiment.k_middle(classes_count,canvas)
  end
  p "ready"
end

main_window = TkRoot.new {title  "Methodology of solutions accepting"; minsize(500,400)}
canvas = TkCanvas.new(main_window) {background 'white'}
canvas.pack('fill'=>'both', 'expand'=>'yes')
canvas.bind( "1", proc{mousebutton_click(canvas, TkWinfo.width(canvas), TkWinfo.height(canvas))})


TkRoot.mainloop