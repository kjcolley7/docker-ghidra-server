FROM openjdk:11-jdk

# Install necessary packages: wget, unzip, and ed (used by ghidraSvr script)
RUN apt-get update && apt-get install -y wget unzip ed && rm -rf /var/lib/apt/lists/*

# Download Ghidra, verify checksum, extract to /ghidra, delete zip
WORKDIR /tmp
RUN wget -q https://ghidra-sre.org/ghidra_9.1.1_PUBLIC_20191218.zip -O ghidra.zip && \
	echo 'b0d40a4497c66011084e4a639d61ac76da4b4c5cabd62ab63adadb7293b0e506 ghidra.zip' | sha256sum -c
RUN unzip -q ghidra.zip && mv ghidra_9.1.1_PUBLIC /ghidra && rm ghidra.zip

# Setup directory structure
RUN mkdir /repos
WORKDIR /repos
WORKDIR /ghidra

# Create unprivileged ghidra user and give it full access to contents of /ghidra and /repos
RUN groupadd -r ghidra && useradd --no-log-init -r -g ghidra -d /ghidra -s /bin/bash ghidra && \
	chown -R ghidra:ghidra /ghidra && \
	chown root:ghidra /ghidra && \
	chmod g+w /ghidra && \
	chown root:ghidra /repos && \
	chmod g+w /repos

# Set the repositories dir to /repos, the account name to ghidra, and add
# the -u parameter, which means users are prompted for their usernames.
RUN sed -i \
	-e 's/^ghidra\.repositories\.dir=.*$/ghidra.repositories.dir=\/repos/g' \
	-e 's/^wrapper\.app\.parameter\.2=/wrapper.app.parameter.4=/g' \
	-e 's/^wrapper\.app\.parameter\.1=-a0$/wrapper.app.parameter.2=-a0/g' \
	server/server.conf && \
	echo 'wrapper.app.account=ghidra' >> server/server.conf && \
	echo 'wrapper.app.parameter.3=-u' >> server/server.conf && \
	echo 'wrapper.app.parameter.1=-ip0.0.0.0' >> server/server.conf
	# -e 's/^wrapper\.console\.loglevel=INFO$/wrapper.console.loglevel=DEBUG/g' \
	# -e 's/^#wrapper\.debug=.*$/wrapper.debug=true/g' \
	# -e 's/^wrapper\.logfile\.loglevel=.*$/wrapper.logfile.loglevel=DEBUG/g' \

# Switch to unprivileged ghidra user for running the Ghidra server
USER ghidra

# Allow option of mounting /repos as a volume so that the repos can live outside of the container
VOLUME /repos

# These ports are exposed by Ghidra server
EXPOSE 13100 13101 13102

# Actually start Ghidra server
CMD ["/ghidra/server/ghidraSvr", "console"]
