require "sequel"

module Waldorfcamp
  class Photo < Sequel::Model
    dataset_module do
      def newest
        reverse(:uploaded_at)
      end

      def tagged_with(tags)
        where(tags: /#{tags.join("|")}/i)
      end
    end
  end
end
