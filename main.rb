require 'tk'
require_relative 'experiment_element'


def enter_button_click(elements_count, heads_count)
  p elements_count
  p heads_count
end
main_window = TkRoot.new { title "Methodology of solutions accepting"
  minsize(600,500)
  padx 10
  pady 10
}
dataframe = TkFrame.new {
  pack('side' => 'top')
  padx 10
  pady 10
  width main_window.width
}

canvasframe = TkFrame.new {
  pack('side' => 'top')
  padx 10
  pady 10
  width main_window.width
  background 'green'
}

TkLabel.new(dataframe){text "Elements count"; pack('side'=>'left')}
elements_count = TkSpinbox.new(dataframe) do
  to 5000
  from 100
  increment 100
  state 'readonly'
  pack 'side'=>'left'
end
TkLabel.new(dataframe){text "Heads count"; pack('side'=>'left')}
heads_count = TkSpinbox.new(dataframe) do
  to 20
  from 1
  increment 1
  state 'readonly'
  pack 'side'=>'left'
end
  canvas = TkCanvas.new(canvasframe) {background 'red';  place('height' => 500, 'width' => 50); grid}
  TkcLine.new( canvas, 0,0,500,1500)
enter_button = TkButton.new(dataframe){text "Enter"; pack; command proc{enter_button_click elements_count.get, heads_count.get}}
TkRoot.mainloop