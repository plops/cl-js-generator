# create/fill node_modules directory with
# npm install

esbuild \
    --bundle \
    --minify \
    --sourcemap \
    --target=chrome101 \
    --outfile=out.js \
    main.js
