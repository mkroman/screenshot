# encoding: utf-8

module Screenshot
  class Manager
    include Singleton

    Executables = {
         OS_X: { screencapture: "%s" },
        Linux: { scrot: "-bs %s", import: "%s" },
      Windows: {},
      Unknown: { scrot: "-bs %s", import: "%s" }
    }

    def initialize
      @platform = determine_platform
    end

    def capture_image
      if command = suitable_command
        executable, path = command

        puts "Taking a screenshot with #{executable} …"

        if %x{#{executable}}
          puts "Captured image to #{path} …"

          Image.new path
        else
          puts "Execution failed …"
        end
      else
        puts "Could \e[1m*not*\e[0m find a suitable executable for your platform."
      end
    end

  private

    def suitable_command
      Executables[@platform].each do |executable, arguments|
        each_environment_path do |path|
             file = File.join path, executable.to_s
            image = temporary_file
          command = [file, arguments].join(' ') % image

          return command, image if File.exists? file
        end
      end
      
      nil
    end

    def temporary_file
      path = File.join Dir.tmpdir, rand(36 ** 12).to_s(36) + ".png"

      while File.exists? path
        path = File.join Dir.tmpdir, rand(36 ** 12).to_s(36) + ".png"
      end

      path
    end

    def each_environment_path
      ENV['PATH'].split(':').each { |path| yield path }
    end

    def determine_platform
      if RUBY_PLATFORM.downcase.include? "darwin"
        :OS_X
      elsif RUBY_PLATFORM.downcase.include? "mswin"
        :Windows
      elsif RUBY_PLATFORM.downcase.include? "linux"
        :Linux
      else
        :Unknown
      end
    end
  end
end
