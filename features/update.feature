Feature: Help
  In order to update my PC automatically
  As a CLI
  I want to update the system

  Scenario: Update laptop
    When I run `renuo update-laptop`
    It should update the PC
