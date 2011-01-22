#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift File.dirname(__FILE__) + '/../library'
require 'screenshot'
require 'screenshot/services'

if image = Screenshot.capture
  begin
    if url = image.upload(:metabox)
      puts "The screenshot has been uploaded to #{url}"
    end
  rescue Screenshot::Services::UploadError
    puts "Could not upload image: #{$!.message}"
  end
end
