python3 -m http.server --bind `hostname -I | awk '{print $1}'`
