# encoding: utf-8

require 'tmpdir'
require 'singleton'

require 'screenshot/image'
require 'screenshot/manager'

module Screenshot
  class << Version = [0,1]
    def to_s; join ',' end
  end

  def self.capture
    Manager.instance.capture_image
  end
end
