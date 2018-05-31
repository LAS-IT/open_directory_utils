module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CleanCheck

    def assert(&block)
      raise ArgumentError unless block.call
    end

    def check_uid(attribs)
      attribs[:uid] = attribs[:uid]&.strip
      assert{not attribs[:uid].eql? ''}
      assert{not attribs[:uid].include? ' '}
      # user_attrs = {}
      # attribs.each{ |k,v| user_attrs[k] = v.to_s.strip }
      # return user_attrs
      rescue NoMethodError, ArgumentError => error
        raise ArgumentError, "uid invalid"
    end

    def tidy_attribs(attribs)
      user_attrs = {}
      attribs.each{ |k,v| user_attrs[k] = v.to_s.strip }
      return user_attrs
    end

  end
end
