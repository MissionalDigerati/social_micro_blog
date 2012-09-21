Social Micro Blog
=================

A blogging engine powered by your social media.  The blog displays posts from your favorite social media in a blog style.  All social network data is pulled in by triggering a Rake task as a cron job, so you do not need to worry about the speed of the website.  There is no content management in this software.  The content is managed purely from your social network sites.

Current Social Network Support
------------------------------

* Twitter

Setup
-----

You will first need to add your credentials to the `config/services.yml` file.
```
services:
  twitter:
    consumer_key:
    consumer_secret: 
    oauth_token: 
    oauth_token_secret: 
accounts:
  jpulos:
    provider: twitter
    username: jpulos
    name: Johnathan Pulos
    pull_total: 20
```

Once the settings are set,  you can run the following rake task to seed your database:

```
rake social_media:update
```

After you have the data,  you will want to setup a cron job to run that rake task every 30 minutes, or whatever time fits your habits.

Extending Social Network Access
-------------------------------

If you would like to add additional social network sites,  you can create a file in `app/services/` directory called {social network}\_service.rb, and the class should be called {social network}Service.  Look at the TwitterService class for an example.  Your class requires 2 methods:

* **setup** - The method for setting up your class.  You will be passed an object called _context_, which has the following attributes:
	* **credentials** - the social network credentials set in the `config/services.yml`.
	* **image\_format** - a string prepared for the sprint\_f method to setup the html for an image.  You will send it one argument,  the url of the image.
	* **video\_service\_format** - a string prepared for the sprint_f method to setup the html for a flash video player.  You will send it one argument,  the url of the flash video.
* **latest** - The method should return an array of all the posts from the social media according to the passed arguments.  The arguments are:
	* **account** - the social network account set in the `config/services.yml` file.
	* **max** - the max number of post to pull based on the settings in the `config/services.yml` file.

You will also need to setup your YAML `config/services.yml` file with the correct service credentials and account information.  Lastly,  open `lib/tasks/social_media.rake` and add the following after all the other require statements with the correct new file name:

`require_relative "../../app/services/{your new file}.rb"`

Development
-----------

Questions or problems? Please post them on the [issue tracker](https://github.com/MissionalDigerati/vts_web_interface/issues). You can contribute changes by forking the project and submitting a pull request.

This script is created by Johnathan Pulos and is under the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0-standalone.html).