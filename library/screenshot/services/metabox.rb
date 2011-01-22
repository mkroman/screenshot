# encoding: utf-8

require 'curb'

module Screenshot
  class Services
    class Metabox
      attr_accessor :image

      ServiceURI = "http://metabox.it/"

      def initialize image
        @image = image
      end
      
      def upload
        response = Curl::Easy.new(ServiceURI) do |curl|
          curl.multipart_form_post = true
          curl.http_post Curl::PostField.file "file", @image.path
        end.body_str

        if response =~ /^Error: (.*)/
          raise Services::UploadError, $1
        else
          response[0..-2]
        end
      end
    end
  end
end
