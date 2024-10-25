module Ac
  module Database
    def self.request_model_exists?
      model = "Request".safe_constantize
      model.present? && model < ActiveRecord::Base && "Extractor".safe_constantize
    end

    def self.save_request response, class_name: "Ac"
      return unless request_model_exists?
      res = Extractor::ResponseWithJson.from_response response
      ::Request.create!({
        extractor_class: class_name,
        base_url: res.request.base_url,
        request_options: res.request.options,
        request_original_options: res.request.original_options,
        response_options: res.parsed_options,
        request_cache_key: res.request.cache_key
      })
    end
  end
end
