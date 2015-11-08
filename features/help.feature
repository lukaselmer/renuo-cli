Feature: Help
  In order to get help how to use the CLI
  As a CLI
  I want to help the user

  Scenario: General help
    When I run `renuo -h`
    Then the output should contain "renuo"
    Then the output should contain "set-name"
