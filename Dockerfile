FROM tiangolo/uwsgi-nginx:python2.7

ENV UWSGI_INI /askbotapp/uwsgi.ini 
ENV PYTHONUNBUFFERED 1

ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN mkdir /askbotapp
WORKDIR /askbotapp/

ADD uwsgi.ini /askbotapp/uwsgi.ini 

RUN askbot-setup --dir-name=. --db-engine=${ASKBOT_DATABASE_ENGINE:-2} \
    --db-name=${ASKBOT_DATABASE_NAME:-db.sqlite} \
    --db-user="${ASKBOT_DATABASE_USER}" \
    --db-password="${ASKBOT_DATABASE_PASSWORD}"

RUN sed "s/ROOT_URLCONF.*/ROOT_URLCONF = 'urls'/"  settings.py -i

RUN python manage.py migrate --noinput
RUN python manage.py collectstatic --noinput

