PWD=$(pwd)

up: env fanout
	docker-compose up -d --scale httpbin=3

fanout:
	/bin/sh ./fanout.sh

env:
	echo "DIR=$$PWD" > .env

down: clean
	docker-compose down

clean:
	mv ./config.yml.bak ./config.yml
