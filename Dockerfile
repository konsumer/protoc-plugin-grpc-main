
# this container will generate all the go source, then run it

FROM konsumer/nodegoproto

VOLUME /output

COPY . /usr/app
WORKDIR /usr/app

RUN npm install

ENTRYPOINT ["/usr/app/build_gateway.sh"]
