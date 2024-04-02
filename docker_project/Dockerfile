FROM python:3-alpine

WORKDIR /srv/app

COPY requirements.txt /srv/app/
RUN \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 python3 -m pip install -r requirements.txt --no-cache-dir && \
 apk --purge del .build-deps

COPY app/ /srv/app/

ENTRYPOINT [ "python3" ]
CMD [ "web.py" ]
#ENTRYPOINT [ "/bin/sh" ]

# Определяем переменную окружения для указания настройки Flask
#ENV FLASK_APP=web.py

# Запускаем приложение Flask при старте контейнера
#CMD ["flask", "run", "--host=0.0.0.0"]