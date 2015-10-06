## Development on Docker
[ ![Codeship Status for trekdemo/streamflow2](https://codeship.com/projects/7f8641c0-49d8-0133-1577-26ca0ee25698/status?branch=master)](https://codeship.com/projects/105740)

The application can be runned over a docker environment. In order to do that, you'll have to download docker-toolbox.

### Setup docker

Download docker toolbox from brew cask:
```shell
brew cask install dockertoolbox
```

Create a new VM with it:
```shell
docker-machine create --driver virtualbox default
```

Start the newly created VM
```shell
docker-machine start default
```

Whe opening a new terminal window, set docker's environment variables:
```shell
eval "$(docker-machine env default)"
```

Build the whole Docker environment
```shell
cd /to/your/application/folder
docker-compose build web
docker-compose build
```

### Useful commands

* start the application: `docker-compose up`
* install new gems after modifiing the Gemfile: `docker-compose run web bundle install`
* start a rails console: `docker-compose run web bundle exec rails c`
* run the test suite: `docker-compose run web bundle exec rspec`