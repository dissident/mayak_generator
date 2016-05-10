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

    def insert_slug(file)

    end

  end
end
