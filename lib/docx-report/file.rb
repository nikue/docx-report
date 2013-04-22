module DOCXReport

  class File

    attr_accessor :tmp_dir, :path

    def initialize(template)

      raise "Template [#{template}] not found." unless ::File.exists? template

      @template = template
      @tmp_dir = ::File.join(Dir.tmpdir, random_filename(:prefix=>'odt_'))
      Dir.mkdir(@tmp_dir) unless ::File.exists? @tmp_dir
    end

    def create(dest)
      if dest
        FileUtils.cp(@template, dest)
        @path = "#{dest}/#{::File.basename(@template)}"
      else
        FileUtils.cp(@template, @tmp_dir)
        @path = "#{@tmp_dir}/#{::File.basename(@template)}"
      end
    end

    def update(*content_files, &block)

      content_files.each do |content_file|

        update_content_file(content_file) do |txt|

          yield txt

        end

      end

    end

    def remove
      FileUtils.rm_rf(@tmp_dir)
    end

    private

    def update_content_file(content_file, &block)

			zf = Zip::ZipFile.open(@path)

			buffer = Zip::ZipOutputStream.write_buffer do |out|
				zf.entries.each do |e|
					#Rails.logger.debug e.name + " - " + content_file
					if e.ftype == :directory
						out.put_next_entry(e.name)
					elsif e.name == "word/" + content_file
						txt = e.get_input_stream.read
						yield(txt)
						out.put_next_entry(e.name)
						out.write(txt)
					else
						out.put_next_entry(e.name)
						out.write e.get_input_stream.read
					end
				end
			end

			::File.open(@path, "wb") {|f| f.write(buffer.string) }

#     Zip::ZipFile.open(@path) do |z|
#
#        cont = "#{@tmp_dir}/#{content_file}"
#
#        z.extract("word/"+content_file, cont)
#
#        txt = ''
#
#        ::File.open(cont, "r") do |f|
#          txt = f.read
#        end
#
#        yield(txt)
#
#        ::File.open(cont, "w") do |f|
#           f.write(txt)
#        end
#
#        z.replace("word/"+content_file, cont)
#      end

    end

    def random_filename(opts={})
      opts = {:chars => ('0'..'9').to_a + ('A'..'F').to_a + ('a'..'f').to_a,
              :length => 24, :prefix => '', :suffix => '',
              :verify => true, :attempts => 10}.merge(opts)
      opts[:attempts].times do
        filename = ''
        opts[:length].times { filename << opts[:chars][rand(opts[:chars].size)] }
        filename = opts[:prefix] + filename + opts[:suffix]
        return filename unless opts[:verify] && ::File.exists?(filename)
      end
      nil
    end

  end

end
