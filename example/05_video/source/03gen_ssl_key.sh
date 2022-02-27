openssl req -x509 \
	-newkey rsa:2048 \
	-nodes -keyout key.pem \
	-out cert.pem \
	-days 365 \
	-subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"
