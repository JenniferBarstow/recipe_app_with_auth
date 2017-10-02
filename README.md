## Basic Recipe Application with Authentication ## 

**A Recipe Application built using Rails-4.2.1 with the following features:**
* User Authentication 
* User Roles for  Admin and regular User
* Recipe `#index`, and `#show` routes can return JSON

### Getting Started


Install the dependencies
`bundle install`

Create Database
`rake db:create`

Run Migrations
`rake db:migrate`

Create Admin
To interact as an Admin, first create one in your rails console with the admin boolean set to true. `admin: = true`

Start up your server!
`rails server`

Visit http://localhost:3000

### Testing

**Controller and Model Tests**
*located in the spec directory*

To run tests run 
`$ rspec`

