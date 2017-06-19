#!/bin/bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

echo "Precompile all resources..."
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
if [ -d resources/pug ]; then
  pug -E twig -P -o craft/templates resources/pug
fi
if [ -f /local/resources/compass/config.rb ]; then
  cd /local/resources/compass
  compass compile
else
  if [ -d /local/resources/sass ]; then
    cd /local/resources/sass
    for sass in *.sass; do
      filename="${sass%.*}"
      sass /local/resources/sass/${sass} /local/public/css/${filename}.css
      postcss --use autoprefixer -o /local/public/css/${filename}.css /local/public/css/${filename}.css
    done
  fi
  if [ -d /local/resources/scss ]; then
    cd /local/resources/scss
    for scss in *.scss; do
      filename="${scss%.*}"
      sass /local/resources/scss/${scss} /local/public/css/${filename}.css
      postcss --use autoprefixer -o /local/public/css/${filename}.css /local/public/css/${filename}.css
    done
  fi
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
if [ -d /local/resources/vendor ]; then
  rsync -r /local/resources/vendor/ /local/public/vendor/
fi
