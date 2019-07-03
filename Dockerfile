FROM ruby:2.6.3

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential libpq-dev

RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y postgresql-client

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