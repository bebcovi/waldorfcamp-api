require "sequel"

module Waldorfcamp
  class Photo < Sequel::Model
    dataset_module do
      def newest
        order{uploaded_at.desc}
      end

      def tagged_with(tags)
        where(tags: /#{tags.join("|")}/i)
      end
    end
  end
end
