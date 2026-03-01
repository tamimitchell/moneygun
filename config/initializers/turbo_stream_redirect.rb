# frozen_string_literal: true

# Custom turbo stream action to replace turbo_power's redirect_to.
# Generates: <turbo-stream action="redirect_to" target="url"></turbo-stream>
# The JS counterpart is in app/javascript/application.js.
module TurboStreamRedirect
  def redirect_to(url)
    turbo_stream_action_tag(:redirect_to, target: url)
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamRedirect)
