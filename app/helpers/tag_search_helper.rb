module TagSearchHelper

    def tag_cloud(tags, classes)
      return [] if tags.empty?

      max_count = tags.sort_by(&:count).last.count.to_f

      tags.each do |tag|
        index = ((tag.count / max_count) * (classes.size - 1)).round
        yield tag, classes[index]
      end
    end

    def order_tag(search, options = {}, html_options = {})
      if !options[:as]
        id = options[:by].to_s.downcase == "id"
        options[:as] = id ? options[:by].to_s.upcase : options[:by].to_s.humanize
      end
      options[:ascend_scope] ||= "#{options[:by]} asc"
      options[:descend_scope] ||= "#{options[:by]} desc"
      ascending = search.to_s == options[:ascend_scope]
      new_scope = ascending ? options[:descend_scope] : options[:ascend_scope]
      selected = [options[:ascend_scope], options[:descend_scope]].include?(search.to_s)
      if selected
        css_classes = html_options[:class] ? html_options[:class].split(" ") : []
        if ascending
          options[:as] = "&#9650;&nbsp;#{options[:as]}"
          css_classes << "ascending"
        else
          options[:as] = "&#9660;&nbsp;#{options[:as]}"
          css_classes << "descending"
        end
        html_options[:class] = css_classes.join(" ")
      end
      url_options = {
        :order => new_scope
      }.deep_merge(options[:params] || {})
      options[:as] = raw(options[:as]) if defined?(RailsXss)
      
      link_to options[:as], url_for(url_options), html_options
    end

end
