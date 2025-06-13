module Docsplit
  class StructureExtractor    
    def extract(pdfs, opts = {})
      extract_options opts
      FileUtils.mkdir_p @output unless File.exist?(@output)
      [pdfs].flatten.each { |pdf| extract_structure(pdf) }
    end

    private

    def extract_structure(pdf)
      @pdf_name = File.basename(pdf, File.extname(pdf))
      struct_txt = File.join(@output, "#{@pdf_name}_struct.txt")
      run "pdfinfo -struct-text #{ESCAPE[pdf]} > #{ESCAPE[struct_txt]} 2>&1"
    end

    def extract_options(opts)
      @output  = opts[:output] || '.'
    end

    # Run an external process and raise an exception if it fails
    def run(command)
      result = `#{command}`
      raise ExtractionFailed, result if $? != 0
      result
    end
  end
end
