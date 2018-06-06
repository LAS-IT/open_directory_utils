module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CleanCheck

    def assert(&block)
      raise ArgumentError unless block.call
    end

    def check_critical_attribute(attrib, key, value=nil)
      assert{not attrib[key].nil?}
      attrib[key] = attrib[key].to_s.strip
      assert{not attrib[key].eql? ''}
      assert{not attrib[key].include? ' '} if key.eql? :scope
      assert{not attrib[key].include? ' '} if [:uid, :username, :record_name].include? key
      rescue NoMethodError, ArgumentError => error
        message  = "#{key}: '#{attrib[key].inspect}' invalid"
        message += ", value_name: :#{value}"  unless value.nil?
        raise ArgumentError, message
    end

    def tidy_attribs(attribs)
      user_attrs = {}
      attribs.each{ |k,v| user_attrs[k] = v.to_s.strip }
      return user_attrs
    end

    def user_record_name_alternatives(attribs)
      attribs[:record_name] = nil
      attribs[:record_name] = attribs[:user_name]
      attribs[:record_name] = attribs[:record_name] || attribs[:short_name]
      attribs[:record_name] = attribs[:record_name] || attribs[:shortname]
      attribs[:record_name] = attribs[:record_name] || attribs[:username]
      attribs[:record_name] = attribs[:record_name] || attribs[:uid]
      return attribs
    end

  end
end
