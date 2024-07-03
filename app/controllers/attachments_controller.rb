class AttachmentsController < ApplicationController
  def bulk
    Attachment.transaction do
      attachment_data = attachment_params[:urls].map do |url|
        {
          url:, memo_id: attachment_params[:memo_id], user_id: attachment_params[:user_id]
        }
      end
      attachment_data.each do |attachment|
        att = Attachment.new(attachment)
        raise ActiveRecord::RecordInvalid, att unless att.valid?
      end

      Attachment.upsert_all(attachment_data)
    end
    render status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

  def attachment_params
    params.permit(:memo_id, :user_id, urls: [])
  end
end
