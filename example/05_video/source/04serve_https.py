#!/usr/bin/python3
import http.server
from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl

print("opening server at https://localhost:4443")
httpd = HTTPServer(('localhost', 4443), http.server.SimpleHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket, 
                                keyfile="key.pem", 
                                certfile='cert.pem',
                                ssl_version=ssl.PROTOCOL_TLS,
                                server_side=True)

httpd.serve_forever()
