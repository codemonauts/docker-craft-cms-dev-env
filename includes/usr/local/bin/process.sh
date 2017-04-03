#!/bin/bash
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
cd /local
FILE=${1}
BASENAME=`basename ${FILE}`
echo -n "Processing ${FILE} ... "
# JS
if [[ ${FILE} =~ \.js$ ]]; then
  /usr/local/bin/uglifyjs ${FILE} --compress --mangle --output /local/public/js/${BASENAME}
fi
# CSS
if [[ ${FILE} =~ \.sass$ ]]; then
  if [ -f /local/resources/compass/config.rb ]; then
    cd /local/resources/compass
    /usr/local/bin/compass compile
  else
    cd /local/resources/sass
    for sass in *.sass; do
      filename="${sass%.*}"
      /usr/local/bin/sass /local/resources/sass/${sass} /local/public/css/${filename}.css
      /usr/local/bin/postcss --use autoprefixer -o /local/public/css/${filename}.css /local/public/css/${filename}.css
    done
  fi
fi
if [[ ${FILE} =~ \.scss$ ]]; then
  if [ -f /local/resources/compass/config.rb ]; then
    cd /local/resources/compass
    /usr/local/bin/compass compile
  else
    cd /local/resources/scss
    for scss in *.scss; do
      filename="${scss%.*}"
      /usr/local/bin/sass /local/resources/scss/${scss} /local/public/css/${filename}.css
      /usr/local/bin/postcss --use autoprefixer -o /local/public/css/${filename}.css /local/public/css/${filename}.css
    done
  fi
fi
# JADE
if [[ ${FILE} =~ \.jade$ ]]; then
  /usr/local/bin/pug -E twig -P -s ${FILE}
  TWIG=${FILE//\.jade/\.twig}
  TWIG_BASENAME=`basename ${TWIG}`
  TWIG_SOURCE=`dirname ${TWIG}`
  TWIG_DEST=${TWIG_SOURCE//resources\/jade/craft\/templates}
  if [ ! -d ${TWIG_DEST} ]; then
    mkdir -p ${TWIG_DEST}
  fi
  mv ${TWIG} ${TWIG_DEST}/${TWIG_BASENAME}
fi
# TWIG
if [[ ${FILE} =~ \/twig\/ ]]; then
  rsync -r /local/resources/twig/ /local/craft/templates/
fi
# CSS
if [[ ${FILE} =~ \/css\/ ]]; then
  rsync -r /local/resources/css/ /local/public/css/
fi
# JS Vendor
if [[ ${FILE} =~ \/vendor\/ ]]; then
  rsync -r /local/resources/vendor/ /local/public/vendor/
fi
echo "finished!"
