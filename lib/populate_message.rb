require 'erb'

class TemplateRenderer
  def initialize(language, template_name)
    @language = language
    @template_name = template_name
  end

  def render_template(template_name)
    raw_template = File.read(File.dirname(__FILE__) + "/../templates/#{@language}/#{template_name}.erb")

    erb_renderer = ERB.new(raw_template)
    return erb_renderer.result(binding)
  end

  def get_value(value)
    @values ||= {}
    @values[value] ||= begin
      case value
      when 'guest_name'
        prompt("What is the guests name?")
      when 'checkout_date'
        prompt("What is the checkout date?")
      when 'location'
        location_template_path = "locations/#{prompt("What location is it?")}"
        render_template(location_template_path)
      end
    end
  end

  def prompt(question)
    print "\n#{question} "
    return STDIN.gets.strip
  end

  def render
    render_template(@template_name)
  end
end

renderer = TemplateRenderer.new('english', 'greeting_message')

puts renderer.render

# values = get_email_options(language, template_name)
# values = {:guest_name => "George", :checkout_date => "Sept 14th, #{Time.now.year}"}
