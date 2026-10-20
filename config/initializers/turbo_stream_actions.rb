ActiveSupport.on_load(:turbo_streams_tag_builder) do
  def redirect(url, frame: nil)
    turbo_stream_action_tag(:redirect, url: url, frame: frame)
  end

  def reset_form(target)
    turbo_stream_action_tag(:reset_form, target: target)
  end

  def scroll_to(target)
    turbo_stream_action_tag(:scroll_to, target: target)
  end
end
