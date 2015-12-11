Feature: Generate password
  In order to generate a password
  As a CLI
  I want to generate a secure password

  Scenario: Generate password
    When I run `bundle exec renuo generate-password`
    Then the output should match /[0-9a-zA-Z]{100}/

