# Design Review Docu
I have create a Design Docu to address the Q&A aspects.
https://www.notion.so/Project-Conversation-Tracker-Design-Review-Document-1cd901f5e85380bc979aeac0dd74a7a6#1cd901f5e85380e1bdedcbb0dbc7b287

# Pre-requisite
- ruby 3.4.2
- rails 8.0.2

## Running the Project ( ideally a script would have been a better to run this setup)
- bundle install
- bundle exec rails db:setup
- bundle exec rspec
- rails s

## Heroku Link to web app
- https://project-conversation-app-8cf60172303c.herokuapp.com

## User Emails
- admin@staff.com | Pass1234
- staff@staff.com | Pass1234
- client@acme.com | Pass1234

## ✅ Role Permissions Summary

| Action                | Admin | Staff | Client |
|-----------------------|:-----:|:-----:|:------:|
| View Projects         | ✅    | ✅    | ✅     |
| Create/Update Project | ✅    | ✅    | ✅     |
| Change Status         | ✅    | ✅    | ❌     |
| Archive Project       | ✅    | ❌    | ❌     |
| Delete Project        | ✅    | ❌    | ❌     |
| Add Comments          | ✅    | ✅    | ✅     |

