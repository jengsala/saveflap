module ApplicationHelper

  ALERT_MAPPING = {
    success: 'alert-success',
    error:   'alert-danger',
    alert:   'alert-danger',
    warning: 'alert-warning',
    info:    'alert-info',
    notice:  'alert-info'
  }.freeze


  def options_for_spinner_button(label = t('text.save_in_progress'))
    { class: 'btn btn-outline btn-primary', data: { disable_with: spinner_icon(label) } }
  end


  def spinner_icon(label, icon = 'fa-spinner')
    "<i class='fa #{icon} fa-spin'></i> #{label}"
  end


  def render_flashes
    messages = []
    flash.each do |key, value|
      css = ALERT_MAPPING[key.to_sym]
      content = value + button_close
      messages << content_tag(:div, content.html_safe, class: "alert #{css} fade in", role: 'alert')
    end

    messages = messages.map { |m| content_tag(:li, m) }
    messages = messages.join('').html_safe
    content_tag(:ul, messages, class: 'list-unstyled')
  end


  def button_close
    content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
      content_tag(:span, '&times;'.html_safe, 'aria-hidden' => 'true') +
      content_tag(:span, 'Close', class: 'sr-only')
    end
  end

end
