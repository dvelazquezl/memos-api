class AttachmentsController < ApplicationController
  def bulk
    memo_id = attachment_params[:memo_id]
    files = attachment_params[:files]

    attachments = files.map do |file|
      Attachment.new(
        url: file[:url],
        memo_id:,
        file_name: file[:file_name],
        user_id: @current_user.id
      )
    end

    Attachment.transaction do
      if attachments.all?(&:save)
        render json: attachments, status: :created
      else
        render json: attachments.map(&:errors), status: :unprocessable_entity
      end
    end
  end

  def delete
    attachment = Attachment.find(params[:id])

    if attachment.destroy
      render status: :no_content
    else
      render json: { errors: attachment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def attachment_params
    params.permit(:memo_id, files: [:url, :file_name])
  end
end
