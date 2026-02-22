# frozen_string_literal: true

class DropzoneInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options.delete(:class)

    max_files = options.fetch(:max_files) { single_attachment? ? 1 : nil }
    param_name = single_attachment? ? "#{object_name}[#{attribute_name}]" : "#{object_name}[#{attribute_name}][]"

    data_attrs = {
      controller: "dropzone",
      dropzone_url_value: "/rails/active_storage/direct_uploads",
      dropzone_param_name_value: param_name,
      dropzone_max_files_value: max_files,
      dropzone_max_filesize_value: options.fetch(:max_filesize, 256),
      dropzone_accepted_files_value: options[:accepted_files],
      dropzone_add_remove_links_value: options.fetch(:add_remove_links, true),
      dropzone_message_value: I18n.t("simple_form.dropzone.message"),
      dropzone_hint_value: I18n.t("simple_form.dropzone.hint"),
      dropzone_existing_files_value: existing_files
    }.compact

    template.content_tag(:div, "", class: "dropzone", data: data_attrs)
  end

  private

  def single_attachment?
    @single_attachment ||= begin
      reflection = object.class.reflect_on_attachment(attribute_name)
      reflection&.macro == :has_one_attached
    end
  end

  def existing_files
    raw = object.send(attribute_name)

    return [] unless raw.attached?

    if single_attachment?

      [attachment_data(raw)]
    else

      raw.map { |att| attachment_data(att) }
    end
  end

  def attachment_data(attachment)
    {
      name: attachment.filename.to_s,
      size: attachment.byte_size,
      signed_id: attachment.blob.signed_id,
      url: attachment.content_type&.start_with?("image/") ? template.url_for(attachment) : nil
    }.compact
  end
end
