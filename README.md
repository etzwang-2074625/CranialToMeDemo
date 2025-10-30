# CranialToMe

A Rails application for managing patient data, tasks, and research workflows. This project includes a centralized database for demographics, tasks, and common data elements (CDEs).

## Prerequisites

Make sure you have the following installed:

- Ruby `2.7.2`
- Rails `5.2.8`
- Node `23.11.0`

Check your versions:
- ruby -v
- rails -v
- node -v

## Setup for Terminal(Mac)
# Install Ruby 2.7.2 (rbenv or RVM)
rbenv install 2.7.2
rbenv global 2.7.2

# Install bundler
gem install bundler -v 2.4.22

# Clone repo
git clone <repo-url>
cd <repo-folder>

# Install dependencies
bundle install

# Install Node.js
sudo apt-get install -y nodejs npm # Linux
brew install node                 # macOS

# Set up database
bundle exec rails db:setup

# Run server
bundle exec rails s
