# encoding: utf-8

module Screenshot
  class Image
    attr_accessor :path

    def initialize path = nil
      @path = path
    end

    def upload service
      if name = Services.constants.find { |s| "#{s}".downcase == "#{service}".downcase }
        service = Services.const_get(name).new self
        service.upload
      end
    end
  end
end
