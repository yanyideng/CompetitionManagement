FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

RUN mkdir /CompetitionManagement

WORKDIR /CompetitionManagement

ADD Gemfile /CompetitionManagement/Gemfile
ADD Gemfile.lock /CompetitionManagement/Gemfile.lock

RUN bundle install

ADD . /CompetitionManagement

COPY docker-entrypoint.sh /usr/local/bin

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /

ENTRYPOINT ["docker-entrypoint.sh"]