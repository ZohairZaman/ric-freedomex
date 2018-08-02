FROM ruby:2.5.0

MAINTAINER larry@blockverse.io

# By default image is built using RAILS_ENV=production.
# You may want to customize it:
#
#   --build-arg RAILS_ENV=development
#
# See https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
#
ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV} APP_HOME=/home/app
ENV MINIMUM_MEMBER_LEVEL_FOR_DEPOSIT=0 
ENV MINIMUM_MEMBER_LEVEL_FOR_WITHDRAW=0
ENV VAULT_TOKEN=e6df055e-deb5-76a1-6aff-e84d001a35f7
ENV VAULT_ADDR=http://35.227.110.5:8200
ENV SENDER_EMAIL=noreply@blockverse.io
ENV PEATIO_PUBLIC_KEY=LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF0QnBuLzJKdHgrMmpaTnNSVVRySwplVXlWQUFOR0l0WjlFZ3ZPR3VGNTZTR2wwZlRvbTh6Q2Zaak82a0FtT0pGcjcvRkUvbUJtby8wNnJvc3FqMzA0CnRRZUNSaitrOE5kbk5EcUNaZzc4TjlaWmJNYmJqRjdzMmRVNDBoL3A4NVJVOEY1aExZZDFHQmZDeE9kcGFJMGMKaWFBS3dGTHdKSGRrdUxkanZyWGE1aXl2UGdCUlR1b2k5TTd2cFh5RUtQNmlXbk95anRML1E3eDhlYTExOFhGRAorYTZCaVlrZTVkaEd3NThUNTFSblZuQjdQd2x2R0NYd3lxTlhjSUFMNERHaHd2cnJIZVAybmt5UFRwbDkvUys1Cm1xZ0Q5dkdrM00yNWczY0FzblBOeW1uTV BicHJaV0tWeUlrU0N3YXpQOW9HSWhzdmtHS0Z1bkw1ZUxhQ0hmWlYKZlFJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0tCg==
ENV RSA_PRIVATE_KEY=LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBdEJwbi8ySnR4KzJqWk5zUlVUcktlVXlWQUFOR0l0WjlFZ3ZPR3VGNTZTR2wwZlRvCm04ekNmWmpPNmtBbU9KRnI3L0ZFL21CbW8vMDZyb3NxajMwNHRRZUNSaitrOE5kbk5EcUNaZzc4TjlaWmJNYmIKakY3czJkVTQwaC9wODVSVThGNWhMWWQxR0JmQ3hPZHBhSTBjaWFBS3dGTHdKSGRrdUxkanZyWGE1aXl2UGdCUgpUdW9pOU03dnBYeUVLUDZpV25PeWp0TC9RN3g4ZWExMThYRkQrYTZCaVlrZTVkaEd3NThUNTFSblZuQjdQd2x2CkdDWHd5cU5YY0lBTDRER2h3dnJySGVQMm5reVBUcGw5L1MrNW1xZ0Q5dkdrM00yNWczY0FzblBOeW1uTVBicHIKWldLVnlJa1NDd2F6UDlvR0loc3ZrR0tGdW5MNWVMYUNIZlpWZlFJREFRQUJBb0lCQUdzaDZncjRPZVZiYm41bgo4WDBvUTVpei9VM3NwS1BFZ3RGaFJGQ3BIeU9XYUZUa0lobkxTMFg2eDlxQUhqdzRCTVROK0FSNHc1VjQ1SmMvCklTb0ppdG5raFpIVCtnRnBvSEpvKzNoS0lhMzFTMnh4UGRmWi8zbjBZOEJhUzRnaERBV1BucTYrak9Dd0FhT3YKSS95Vk5BeUpydHVJZW1DMnhLczhLNUVlREFBdVJQcng2VFAwVDZOdVVjdUROYWlJZTFucCtpVW5NOXAxNTJKVQprMTd3YS9DK3lxOVp6d2pGV05XaHRORkdvblRQS0M5UDgweVBBYUEvQ3dGVGl5elg2QU9KeEs2MjRHeU40OC9OCjg5UnNOSFFtT0orOFRBRkx3WXJqK1p3c2piTG81RWlaV0JkaFNRRDFVUjViN1psSlJNUkxtVVlVenE4S0syeE4KOGNVbStBRUNnWUVBMXI2V0pyZnRFVmFMOUFuSkpaR081b2l0amg5MmJ2MW5kdWQzc213dHdvWGpnbTVrblVJQgpIUVo0eENLQUFZR1hwcmxWOXVsTGtGbWZUMXBUSVlZai9IdXZKcTlydkt2M3lmN2Q0S0JnajVzd1laU1M0d2NVCjAxR0loS3FOSS91bkF1RzgzamVVRlRTZjc2Uk1JeGpVemlZWlQyc0NVbmg0T3RhTGJBR1Nja0VDZ1lFQTFyUWQKTFNBZW5WeUFoTkRpbHhnTmhYdXdEUjJPaEdRYmlYdkFlRGM1cWErY2xneXFpRDROZVJsSFBBeUVOTEJ1R1oxeQpHWHlKUm93RGx3ZTg3MlI4eHNYVzdlNDF1VGNCTDZmNm9jLzIzOUVxdnNRb0pqNXN3aHpoc0dnYWdKL043ZHhtClo5SitMTGZhNzd2b0NDakM3dDlmcWxiN0Y4SEtQVUJYSDNFU0hEMENnWUE3ODBrSDFpRWd6Z0NVU0ljWExlT3YKQ0VrcmZDMGNIekpiUjVOckJEaGlMZTZ0NHhQRHMwR01VTm8ySjB1RklDQ3VNdCtFNXV4cGlCdXBrNVhScmhrdAp5M25DV3diQXpXR0h5dGMyZG85K2g5eWg0VkNBZ09HWGZST1h0ZVZoUGtnSnpldGtQaS9oRzZmcXh2dGFjUHczCjhQcnY2UGZrL2l6U2dFSzhERlJPQVFLQmdBZmhBalVXdWFqaXJTQ3luYTRYeHQ5QUk3ekhlZVJuM0E3V2lNQ2cKbmpBWTdyRWU4OThlRDlhQzAvZGpLakxZeXFHTUFwVG0yZzdKc3BRSFI2cXRVRnJuQmJVamlic3JScExlSWpkdgo3MHBWWGJFMGQ1aTNyN3dMM1VoZythQUF2VWplVHErK3JMeXRYbzV2b2RzeXk3eUNXL3RmUjhXZWFmS0hldXIvCmRqK3RBb0dBQ1hXcTVIV0FJdkNSYk9UODRMNnZpZWVUbUxkWW9xdE84Mmw3ZlkxTmYvdE92NkpST202dy9HR3EKZkxJWktPR2cxdjg4cnFHQjB4MmJ0aEhWaDZuR1RaOW10Uk81b3Vid2pieitkS2dDc21WbEpNL1hXUGZxN1BKZAphY2hHQjV5QS85RUU5MFlLNFJ1eE5zdFduL0Q4Z253Rk54K1pMNTlSR0lpMXcwZERaNjQ9Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
ENV MINIMUM_MEMBER_LEVEL_FOR_DEPOSIT=0
ENV MINIMUM_MEMBER_LEVEL_FOR_WITHDRAW=0
ENV MINIMUM_MEMBER_LEVEL_FOR_TRADING=0
ENV SENDER_NAME=Blockverse
ENV APP_NAME=Blockverse
ENV BARONG_URL_HOST=http://127.0.0.1:3030
ENV URL_HOST=http://127.0.0.1

# Allow customization of user ID and group ID (it's useful when you use Docker bind mounts)
ARG UID=1000
ARG GID=1000

# Set the TZ variable to avoid perpetual system calls to stat(/etc/localtime)
ENV TZ=UTC

 # Create group "app" and user "app".
RUN groupadd -r --gid ${GID} app \
 && useradd --system --create-home --home ${APP_HOME} --shell /sbin/nologin --no-log-init \
      --gid ${GID} --uid ${UID} app \
 # Install system dependencies.
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y \
      default-libmysqlclient-dev \
      chromedriver \
      nodejs \
      yarn

WORKDIR $APP_HOME

# Install dependencies defined in Gemfile.
COPY Gemfile Gemfile.lock $APP_HOME/
RUN mkdir -p /opt/vendor/bundle \
 && chown -R app:app /opt/vendor \
 && su app -s /bin/bash -c "bundle install --path /opt/vendor/bundle"

# Copy application sources.
COPY . $APP_HOME
# TODO: Use COPY --chown=app:app when Docker Hub will support it.
RUN chown -R app:app $APP_HOME

# Switch to application user.
USER app

# Initialize application configuration & assets.
RUN ./bin/init_config \
  && chmod +x ./bin/logger \
  && bundle exec rake tmp:create yarn:install assets:precompile

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000

# The main command to run when the container starts.
CMD ["bundle", "exec", "puma", "--config", "config/puma.rb","-b","0.0.0.0"]
