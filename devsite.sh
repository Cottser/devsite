#!/usr/bin/env bash

function devsite() {
  local DRUPAL_VERSION="$(drush php-eval 'echo drush_drupal_major_version();')"
  if [ ! $DRUPAL_VERSION ]; then
    echo "No Drupal installation found."
    return 1
  fi

  # Currently Drupal 6 and 7 are supported.
  if [ $DRUPAL_VERSION -lt 6 -o $DRUPAL_VERSION -gt 7 ]; then
    echo "Drupal $DRUPAL_VERSION is not supported."
    return 1
  fi

  local CONFIG_PATH="$(drush php-eval 'echo DRUPAL_ROOT . "/" . conf_path();')"

  # Check if CONFIG_PATH is writable. If it isn't, try to change it.
  if [ ! -w "$CONFIG_PATH" ]; then
    local CONFIG_READONLY=1
    chmod u+w "$CONFIG_PATH"
  fi

  # Confirm overwrite of existing settings.php file.
  CONFIRM='y'
  if [ -e "$CONFIG_PATH/settings.php" ]; then
    yesno "Overwrite existing settings.php file?"
  fi
  [ "$CONFIRM" == 'y' ] && cp -f ~/Sites/default_files/drupal$DRUPAL_VERSION/settings.php $CONFIG_PATH

  # Confirm overwrite of existing settings.local.php file.
  CONFIRM='y'
  if [ -e "$CONFIG_PATH/settings.local.php" ]; then
    yesno "Overwrite existing settings.local.php file?"
  fi
  [ "$CONFIRM" == 'y' ] && cp -f ~/Sites/default_files/drupal$DRUPAL_VERSION/settings.local.php $CONFIG_PATH

  # @todo Optionally write database name to settings.local.php if a database name
  #   is passed in. Or accept the format of 'mysite.dev' and change it to 'mysite_dev'.
  # @todo Create database if it doesn't exist.
  # @todo Add hosts file entry.
  # @todo Add VirtualHost entry.
  # @todo Restart Apache (ask for password up front)
  
  # Change the CONFIG_PATH directory back to the original permissions if applicable.
  [ $CONFIG_READONLY ] && chmod u-w "$CONFIG_PATH"
}
