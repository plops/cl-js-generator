# create/fill node_modules directory with
# npm install

#--minify 
    
esbuild \
    --bundle \
    --sourcemap \
    --target=chrome101 \
    --outfile=out.js \
    main.js
