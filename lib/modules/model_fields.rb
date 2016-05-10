module Mayak

  module ModelFields

    def prepare_slug_private_method
"  def prepare_slug
    self.slug = UrlStringPreparator.slug self.slug, self.title
  end
  "
    end

    def slug_before_metod
      "before_validation :prepare_slug
      "
    end
  end

end
