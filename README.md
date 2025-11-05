# CranialToMe

A Rails application for managing patient data, tasks, and research workflows. This project includes a centralized database for demographics, tasks, and common data elements (CDEs).

## Setup for Terminal(Mac)
1. Clone repo
- git clone https://github.com/yourusername/CranialToMeDemo.git
- cd CranialToMeDemo
2. Install Dependencies
- brew install rbenv
- rbenv install 2.7.2 (Takes a few minutes)
- export PATH="$HOME/.rbenv/bin:$PATH"
- eval "$(rbenv init - zsh)"
- rbenv rehash
- rbenv global 2.7.2
- gem install bundler:2.4.22 (Takes a few minutes)
- bundle install
3. Database Seeding/startup:
- rails db:setup
- rails s
4. Update Database:
- git pull
