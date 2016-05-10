module Mayak

  module Inserter

    def has_private?(file)
      File.readlines(file).select { |string| string.strip == "private" }.size == 1
    end

    def has_validate_block?(file)
      File.readlines(file).select { |string| string.include?("validate") }.size > 0
    end

    def has_uploaders?(file)
      File.readlines(file).select { |string| string.include?("mount_uploader ") }.size > 0
    end

    def has_scopes?(file)
      File.readlines(file).select { |string| string.include?("scope ") }.size > 0
    end

    def has_acts_as?(file)
      File.readlines(file).select { |string| string.include?("acts_as_") }.size > 0
    end

    def has_method?(file, method)
      File.readlines(file).select { |string| string.include?("def #{method}") }.size > 0
    end

    def insert_private_method(file, method)
      if has_private?(file)
        insert_into_file_after file, method, "  private\n"
      else
        insert_into_file_before file, "  private\n", "end\n"
        insert_into_file_after file, method, "  private\n"
      end
    end

    def insert_filter(file, filter)

    end

    private

    def insert_into_file_after(filepath, insertion_text, condition)
      regexp = Regexp.new condition
      content = File.read(filepath).sub(regexp, "#{condition} \n#{insertion_text}")
      File.open(filepath, 'wb') { |file| file.write(content) }
    end

    def insert_into_file_before(filepath, insertion_text, condition)
      regexp = Regexp.new condition
      content = File.read(filepath).sub(regexp, "#{insertion_text} \n#{condition}")
      File.open(filepath, 'wb') { |file| file.write(content) }
    end

  end
end
