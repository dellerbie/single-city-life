# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Text field input boxes
  def text_field_for(form, 
                     field,
                     size=HTML_TEXT_FIELD_SIZE,
                     maxlength=DB_STRING_MAX_LENGTH,
                     required=false)
    cssClass = required ? "required" : "";
    label = content_tag("label", "#{field.humanize}:", :for => field, :class => cssClass)
    form_field = form.text_field field, :size => size, :maxlength => maxlength
    content_tag("div", "#{label} #{form_field}", :class => "formRow")
  end
  
  # Textarea inputs
  def text_area_field_for(form,
                          field,
                          rows=TEXT_ROWS,
                          cols=TEXT_COLS)
    label = content_tag("label", "#{field.humanize}:", :for => field)
    form_field = form.text_area field, :rows => rows, :cols => cols
    content_tag("div", "#{label} #{form_field}", :class => "formRow")
  end
  
  # Select boxes
  def select_field_for(form,
                       field,
                       items,
                       prompt="Please select",
                       required=false)
    cssClass = required ? "required" : "";
    label = content_tag("label", "#{field.humanize}:", :for => field, :class => cssClass)
    form_field = form.select field, items, { :prompt => prompt }
    content_tag("div", "#{label} #{form_field}", :class => "formRow")
  end
end
