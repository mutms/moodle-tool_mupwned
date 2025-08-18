@tool @tool_mupwned @MuTMS
Feature: Test tool_mpwned compromised password detection
  Background:
    Given the following config values are set as admin:
      | passwordpolicy             | 1 |
      | passwordpolicycheckonlogin | 1 |
    And the following "users" exist:
      | username  | firstname | lastname  | email              | password         |
      | user1     | First     | User      | usser1@example.com | oJHGjgfd15abcd-_ |
      | user2     | Second    | User      | usser2@example.com | 123456           |

  @javascript
  Scenario: Login with compromised password blocked by tool_mupwned
    Given the following config values are set as admin:
      | enabled       | 1 | tool_mupwned |
      | resetpassword | 1 | tool_mupwned |
      | expiretokens  | 1 | tool_mupwned |

    When I follow "Log in"
    And I set the field "Username" to "user1"
    And I set the field "Password" to "oJHGjgfd15abcd-_"
    And I press "Log in"
    Then I should see "Welcome, First!"
    And I log out

    When I follow "Log in"
    And I set the field "Username" to "user2"
    And I set the field "Password" to "123456"
    And I press "Log in"
    Then I should see "Your password has previously appeared in a data breach"

    When I set the field "Username" to "user2"
    And I press "Search"
    And I wait "1" seconds
    And I should see "If you supplied a correct username"
    And I open password reset confirmation for user "user2"
    And I set the field "New password" to "PoPhdsh675-_"
    And I set the field "New password (again)" to "PoPhdsh675-_"
    And I press "Save changes"
    Then I should see "Welcome, Second!"
