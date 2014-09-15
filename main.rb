require 'tk'
require 'tkextlib/tile'
require_relative 'experiment_element'

def mousebutton_click(canvas, x_max, y_max)
  canvas.delete('all')
  experiment = Experiment.new(100,x_max,y_max)
  experiment.k_middle(3,canvas)
end

main_window = TkRoot.new {title  "Methodology of solutions accepting"; minsize(500,400)}
canvas = TkCanvas.new(main_window) {background 'white'}
canvas.pack('fill'=>'both', 'expand'=>'yes')
canvas.bind( "1", proc{mousebutton_click(canvas, TkWinfo.width(canvas), TkWinfo.height(canvas))})
TkRoot.mainloop