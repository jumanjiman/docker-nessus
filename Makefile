UNIQUE_MAC ?= 02:42:ac:11:00:01
NESSUS_PORT ?= 8834

nessus :
	if [[ $$(docker images |grep nessus-unlicensed-data|wc -l ) -ne 1 ]]; then \
		echo "** You have not created a nessus-unlicensed-data image yet." ; \
		echo "** Run 'make unlicensed to create it." ; \
		exit 255 ; \
	fi

	if [[ $$(docker images |grep -v nessus-unlicensed-data|grep nessus |grep licensed|wc -l ) -ne 1 ]]; then \
		echo "** You have not created a licensed nessus image yet." ; \
		echo "** Run 'make licensed to create it." ; \
		exit 255 ; \
	fi

	docker run -d --name nessus-licensed -p $(NESSUS_PORT):8834 --mac-address $(UNIQUE_MAC) --volumes-from nessus-unlicensed-data nessus:licensed
	@echo "Nessus is running at https://127.0.0.1:$(NESSUS_PORT)"

stop :
	docker kill $$(docker ps|grep 'nessus:licensed')
	@echo "Nessus stopped"


clean_unlic :
	(docker ps -a |grep nessus | awk '{ print $$1 }'| xargs docker kill) || true
	(docker ps -a |grep nessus | awk '{ print $$1 }'| xargs docker rm) || true
	docker rm /nessus-unlicensed || true

unlicensed : clean_unlic
	set -x
	docker pull sometheycallme/docker-nessus
	docker create --name nessus-unlicensed sometheycallme/docker-nessus:latest true
	cd nessus-data
	docker cp $$(docker ps -a|grep nessus-unlicensed|awk '{ print $$1'}):/opt/nessus/sbin .
	docker cp $$(docker ps -a|grep nessus-unlicensed|awk '{ print $$1'}):/opt/nessus/var  .
	docker cp $$(docker ps -a|grep nessus-unlicensed|awk '{ print $$1'}):/opt/nessus/etc  .
	docker rm $$(docker ps -a|grep nessus-unlicensed|awk '{ print $$1'})
	docker build -t nessus-unlicensed-data .
	docker create --name nessus-unlicensed-data nessus-unlicensed-data true
	docker run -d --name nessus-unlicensed -p $(NESSUS_PORT):8834 --mac-address $(UNIQUE_MAC) --volumes-from nessus-unlicensed-data sometheycallme/docker-nessus
	@echo "Go to https://127.0.0.1:$(NESSUS_PORT) to confiugre, register and update nessus"
	@echo "You can get an activation code from https://www.tenable.com/products/nessus/nessus-plugins/obtain-an-activation-code"
	@echo "When you are done, run 'make licensed' to continue"

clean_lic :
	docker rmi nessus:licensed || true

licensed : clean_lic
	if [[ $$(docker ps|grep nessus-unlicensed|wc -l ) -ne 1 ]] ; then \
		echo "** You don't have a running docker-unlicensed container."; \
		echo "** Run 'make unlicensed' first to create one"; \
		exit 255; \
	fi
	docker stop $$(docker ps|grep nessus-unlicensed|awk '{ print $$1 }')
	@echo "Committing changes, this may take a while"
	docker commit $$(docker ps -a|grep nessus-unlicensed|grep -v nessus-unlicensed-data|awk '{ print $$1 }') nessus:licensed
