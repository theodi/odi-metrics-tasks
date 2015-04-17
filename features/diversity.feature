@vcr @timecop
Feature: Send diversity sheet data to metrics API

  In order to keep the ODI amazing
  As an ODI personnel person
  I want something to monitor our diversity stats and store them over time

  Scenario: Diversity data should be stored in metrics API
    Given that it's 2013-06-01 14:00
    Then the following data should be stored in the "diversity-gender" metric
    """
    {
      "total": {
        "male"  : 20,
        "female": 31
      },
      "teams": {
        "board": {
          "male"  : 6,
          "female": 0
        },
        "smt": {
          "male"  : 2,
          "female": 2
        },
        "leadership": {
          "male": 5,
          "female": 7
        },
        "commercial": {
          "male"  : 4,
          "female": 8
        },
        "international": {
          "male"  : 2,
          "female": 6
        },
        "operations": {
          "male"  : 1,
          "female": 8
        },
        "technical": {
          "male"  : 8,
          "female": 5
        }
      }
    }
    """
    When the diversity job runs
