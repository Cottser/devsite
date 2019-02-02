# devsite

Quickly set up a local copy of a Drupal site. Geared towards a basic naming convention:

Your VirtualHost of `example.localhost` will have a database `example_localhost`.

You don't have to use localhost as the TLD. Any non-alphanumeric characters in your VirtualHost will be replaced by underscores to create the database name.

## Usage

`devsite example.localhost`

Run from within a Drupal site.

devsite will attempt to:

1. Copy `settings.php` into place if it doesn't exist or ensure `settings.local.php` is included from an existing `settings.php`
2. Copy `settings.local.php` into place if it doesn't exist
3. Write basic `drushrc.php` with site URI
4. Create the `example_localhost` database (more details on this in the Setup section)
5. Write your database name to `settings.local.php`

## Setup

Create settings templates for the Drupal versions you work with in `~/Sites/default_files/drupal8` (example path for Drupal 8).

Each Drupal version folder must contain:

- `settings.php` (which includes `settings.local.php` at the bottom)
- `settings-local-include.php` which only contains the `settings.local.php` include snippet
- `settings.local.php` which acts as your local settings template and for database setup to work must include the following:

```
$databases['default']['default'] = [
  'driver' => 'mysql',
  'database' => '_dev',
  'username' => 'root',
  'password' => 'root',
  'host' => 'localhost',
  'prefix' => '',
];
```

Short array syntax is optional, but the `_dev` database name is important as that will be replaced and credentials should be valid if you want database creation to work.

## Compatibility and known issues

- Has been tested with Drupal 6, Drupal 7, and Drupal 8
- Mostly tested on macOS. Should be compatible with other OSes, if you run into problems file an issue
- Support for multisite is shaky at best

## Future development ideas

- Provide example settings templates in this project
- Make the settings template path configurable (currently hardcoded to `~/Sites/default_files`)
- Add fallback behaviour for when there are no settings templates found (copy default.settings.php instead of using a settings.php template, for instance)
- Additionally adopt .env for storing site URI and database credentials
- Add more checks and validation, for example for the argument passed to the script
- Generally make more flexible/configurable so that parts can be turned on and off
- Consider porting to a drush command or similar
