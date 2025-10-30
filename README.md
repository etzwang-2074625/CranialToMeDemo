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
1. Clone Repo:
- git clone https://github.com/yourusername/CranialToMe.git
- cd CranialToMe

2. Install Dependencies:
- bundle install

3. Database Startup/Seeding:
- rails db:create
- rails db:migrate
- rails db:seed

4. Start Server:
- rails s

**Important:** (If the server is not starting, run this before rails s)
- export PATH="$HOME/.rbenv/bin:$PATH"
- eval "$(rbenv init -)" 
- source ~/.zshrc