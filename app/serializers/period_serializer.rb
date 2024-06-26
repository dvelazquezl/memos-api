class PeriodSerializer < ActiveModel::Serializer
  attributes :id,
             :start_date,
             :end_date,
             :header_url,
             :header_width,
             :header_height,
             :footer_url,
             :footer_width,
             :footer_height
end
