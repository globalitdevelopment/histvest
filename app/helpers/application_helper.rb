module ApplicationHelper
	def full_title(page_title)
		base_title = "Historiske Vestfold"
		if page_title.empty?
			base_title
		else
			"#{page_title} - #{base_title}"
		end
	end

	def icon(name, opts = {})
    image_tag "#{name}.png", opts
	end

	# Used for nested forms. Calls the method in application.js
	def link_to_remove_fields(name, f)
		f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => "btn")
	end
  
	def link_to_add_fields(name, f, association)
		new_object = f.object.class.reflect_on_association(association).klass.new
		fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
		  render(association.to_s.singularize + "_fields", :f => builder)
		end
		link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => "btn")
	end
	
  def latest_news
    latest_news = []
    latest_news
  end

  def first_word(str)
  	arr = str.split(/\s+/)
  	arr[0]
  end

  def trailing_words(str)
  	arr = str.split(/\s+/)
  	arr.shift
  	arr.join(' ')
  end

  def touch?
  	request.subdomains.first.to_s[0,5] == "touch"
  end

end
