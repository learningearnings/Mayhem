module ApplicationHelper
  # In the context of views, the current_person gets decoratred
  # NOTE: I'm not sure if this is confusing, since current_person will be different depending on the context (controller or view)
  # For now I think it makes sense, but we can rethink if it confuses anyone...
  def current_person
    if current_user && current_user.person
      PersonDecorator.decorate(current_user.person)
    end
  end

  def current_otu_code_categories
    @code_categories ||= current_person.otu_code_categories(current_school.id)
  end

  def active_if(visitor_type)
    # We don't set visitor_type for students, but we want the helper to be sensible
    visitor_type = '' if visitor_type == 'student'
    if params[:visitor_type].to_s == visitor_type
      'active'
    end
  end

  def current_school
    @current_school ||= School.find(session[:current_school_id])
  end

  def current_school_name
    school = nil
    if current_school
      school = current_school
    end
    if school.nil? && current_user
      school = current_user.person.schools.first
    end
    if school.nil? && request.subdomain
      school = School.find_by_store_subdomain(request.subdomain)
    end
    school.nil? ? "Unknown School" : school.name
  end

  def buck_link(buck)
    link_to 'Redeem Buck', "/bank/redeem_bucks", buck
  end

  def filter_widget
    render "shared/filter/filter_widget"
  end

  def image_processor
    ::Dragonfly[:images]
  end

  def store_type
    if request && request.subdomain == 'le'
      'lestore'
    else
      'schoolstore'
    end
  end

  def render_reward_highlights products
    render 'shared/rewards_highlights', products: products
  end

  def avatar_for(person, geometry='50x50#')
    avatar_img = if person && person.avatar.present?
                   person.avatar.image
                 else
                   default_avatar_path = Rails.root.join('app/assets/images/default_avatar.png').to_s
                   image_processor.fetch_file(default_avatar_path)
                 end
    image_tag(avatar_img.thumb(geometry).url)
  end

  def resized_image(image_file_url, geometry='50x50#')
    img = image_processor.fetch_url(image_file_url)
    image_tag(img.thumb(geometry).url)
  end

  def le_svg_tag source, options = {}
    if is_dragonfly_image?(source)
      url = source.url
    else
      url = source
    end
    options[:type] = "image/svg+xml" unless options[:type]
    if block_given?
      content_tag(:script,options,nil,false) do
        yield
      end
    else # source file passed in
      if browser_is?(:webkit) || browser_is?(:firefox)
        return image_tag(url, options)
      else
        content_tag(:script,options,nil,false) do
          source.data.html_safe
        end
      end
    end
  end

  def browser_is? query
    query = query.to_s.strip.downcase
    result = case query
    when /^ie(\d+)$/
      ua.index("msie #{$1}") && !ua.index('opera') && !ua.index('webtv')
    when 'ie'
      ua.match(/msie \d/) && !ua.index('opera') && !ua.index('webtv')
    when 'yahoobot'
      ua.index('yahoo! slurp')
    when 'mozilla'
      ua.index('gecko') || ua.index('mozilla')
    when 'webkit'
      ua.match(/webkit|iphone|ipad|ipod/)
    when 'safari'
      ua.index('safari') && !ua.index('chrome')
    when 'ios'
      ua.match(/iphone|ipad|ipod/)
    when /^robot(s?)$/
      ua.match(/googlebot|msnbot/) || browser_is?('yahoobot')
    when 'mobile'
      browser_is?('ios') || ua.match(/android|webos|mobile/)
    else
      ua.index(query)
    end
    not (result.nil? || result == false)
  end

  # Determine the version of webkit.
  # Useful for determing rendering capabilities
  # For instance, Mobile Webkit versions lower than 532 don't handle webfonts very well (intermittent crashing when using multiple faces/weights)
  def browser_webkit_version
    if browser_is? 'webkit'
      match = ua.match(%r{\bapplewebkit/([\d\.]+)\b})
      match[1].to_f if (match)
    end or 0
  end

  def browser_is_mobile?
    browser_is? 'mobile'
  end

  # Gather the user agent and store it for use.
  def ua
    @ua ||= begin
      request.env['HTTP_USER_AGENT'].downcase
    rescue
      ''
    end
  end

  def number_to_bucks number
    '%.02f' % number
  end

  def human_date date
    date.strftime("%B %d, %Y")
  end

  def is_dragonfly_image?(source)
    source.inspect =~ /Dragonfly Attachment/ # oh god oh god
  end

  def classroom_delete_confirmation_message
    reward_count = @classroom.classroom_product_links.count
    if reward_count == 0
      "Are you sure?"
    else
      "Are you sure? There are currently #{reward_count} reward(s) for this classroom."
    end
  end
end
