#!/bin/bash
echo "Procompile all resources..."
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
cd /local/public
if [ -f bower.json ]; then 
  bower --allow-root install
fi
cd /local
if [ -d resources/jade ]; then
  pug -E twig -P -o craft/templates resources/jade
fi
if [ -f resources/sass/styles.sass ]; then
  sass resources/sass/styles.sass public/css/styles.css
fi
if [ -f resources/scss/styles.scss ]; then
  sass resources/scss/styles.scss public/css/styles.css
fi
if [ -f public/css/styles.css ]; then
  postcss --use autoprefixer -o public/css/styles.css public/css/styles.css
fi
if [ -d /local/resources/js ]; then
  cd /local/resources/js
  for i in *.js; do uglifyjs ${i} --compress --mangle --output ../../public/js/${i}; done
  cd /local
fi
if [ -d /local/resources/twig ]; then
  rsync -r /local/resources/twig/ /local/craft/templates/
fi
if [ -d /local/resources/css ]; then
  rsync -r /local/resources/css/ /local/public/css/
fi
