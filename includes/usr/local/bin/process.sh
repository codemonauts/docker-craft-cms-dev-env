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
  /usr/local/bin/sass /local/resources/sass/styles.sass /local/public/css/styles.css
  /usr/local/bin/postcss --use autoprefixer -o /local/public/css/styles.css /local/public/css/styles.css
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
echo "finished!"
