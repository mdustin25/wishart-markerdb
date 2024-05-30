class PanelMeasurements < ActiveRecord::Base
  belongs_to :panel
  belongs_to :measurement
end
