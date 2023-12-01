FROM ruby:3.2.2-alpine3.18 as jekyll                # Alpine linux running ruby latest as user jekyll

RUN apk add --no-cache build-base gcc bash cmake git  # Install some liux binaries.

# install both bundler 1.x and 2.x
RUN gem install bundler -v "~>1.0" && gem install bundler jekyll  #  Why 2 bundler versions?

EXPOSE 4000                               # Is there a default port?  taandard port?

WORKDIR /site                             # Output directory.

ENTRYPOINT [ "jekyll" ]                   # Run this upon execution of container.

CMD [ "--help" ]                          # Append this to that command.


FROM jekyll as jekyll-serve               # Install jekyll

COPY docker-entrypoint.sh /usr/local/bin/ # This script is run whe docker process starts.

# on every container start, check if Gemfile exists and warn if it's missing
ENTRYPOINT [ "docker-entrypoint.sh" ]

# test jekyll serve via bundle call
CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]
