@vcr @timecop
Feature: Send diversity sheet data to metrics API

  In order to keep the ODI amazing
  As an ODI personnel person
  I want something to monitor our diversity stats and store them over time

  Scenario: Diversity data should be stored in metrics API
    Given that it's 2015-06-01 14:00
    Then the following data should be stored in the "diversity-gender" metric
    """
    {
      "total": {
        "male": 24,
        "female": 37
      },
      "teams": {
        "board": {
          "male": 6,
          "female": 2
        },
        "spt": {
          "male": 2,
          "female": 2
        },
        "global_network": {
          "male": 6,
          "female": 8
        },
        "core": {
          "male": 5,
          "female": 20
        },
        "innovation_unit": {
          "male": 11,
          "female": 9
        },
        "leadership": {
          "male": 5,
          "female": 7
        }
      }
    }
    """
    When the diversity job runs
