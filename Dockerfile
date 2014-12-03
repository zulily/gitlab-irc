FROM dockerfile/ruby

RUN gem install sinatra

ADD gitlab-irc.rb /gitlab-irc.rb

ENTRYPOINT ["ruby", "/gitlab-irc.rb"]
