# Milan

[![Build Status](https://travis-ci.org/jeremyf/milan.png?branch=master)](https://travis-ci.org/jeremyf/milan)
[![Code Climate](https://codeclimate.com/github/jeremyf/milan.png)](https://codeclimate.com/github/jeremyf/milan)
[![Test Coverage](https://codeclimate.com/github/jeremyf/milan/badges/coverage.svg)](https://codeclimate.com/github/jeremyf/milan)
[![Dependency Status](https://gemnasium.com/jeremyf/milan.svg)](https://gemnasium.com/jeremyf/milan)
[![Documentation Status](http://inch-ci.org/github/jeremyf/milan.svg?branch=master)](http://inch-ci.org/github/jeremyf/milan)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)
[![Contributing Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

A model/form object builder through configuration files.

## Problems I am Attempting to Address via Milan

As we have been working on workflows and data modeling, we've encountered some problems that keep showing up:

* Consistency and variation of labels for input fields
* The label for input varies from the label for "showing" the object
* Repetitious Form objects that have a very similar structure
* Documenting an API for programatic interaction
* A nuanced conflict with SimpleForm and ActiveRecord translations when breaking apart a single concept into constituent parts

Below is a Ruby hash demonstrating how I am proposing declaring Work Types and their constituent forms in a consistent manner.
I have not included, in this demonstration, more complicated concepts such as cardinality based labels, internationalization, nor input vs. display labels.
However, I'm looking to isolate that behavior within a well defined "Term" object.

In the below example I am also skipping consideration for Type (i.e. String, Date, Attachment) as well as Persistence negotiation.
I have a hazy plan for that but it is not yet complete.

```ruby
{
  work_types: [{
    work_type: "ULRA Application",
    contracts: [{
      contexts: "ingest",
      validations: [{ validator: 'Sipity::Contracts::IngestContract' }]
    }],
    forms: [{
      form: "Plan of Study",
      contracts: [{
        contexts: ['submit'],
        validations: [
          { validates: 'ND::expected_graduation_term', presence: true, inclusion: ["Summer 2016", "Fall 2016"] },
          { validates: 'ND::underclass_level', presence: true, inclusion: "ND::underclass_level/options" },
          { validates: 'ND::major', presence: true, inclusion: "https://nd.edu/api/majors.json" },
          { validates: 'ND::primary_college', presence: true }
        ]
      }],
      predicates: [
        { predicate: 'ND::expected_graduation_term' },
        { predicate: 'ND::underclass_level' },
        { predicate: 'ND::major' },
        { predicate: 'ND::minor' },
        { predicate: 'ND::primary_college' }
      ]
    }],
    display: [{
      regions: [{
        region: "description", predicates: [{ predicate: 'DC::title' }],
        region: "plan_of_study", predicates: [
          { predicate: 'ND::expected_graduation_term' },
          { predicate: 'ND::underclass_level' },
          { predicate: 'ND::major' },
          { predicate: 'ND::minor' },
          { predicate: 'ND::primary_college' }
        ]
      }]
    }]
  }],
  predicates: [
    { predicate: 'DC::title' },
    { predicate: 'ND::underclass_level', options: ['First Year', 'Sophomore', 'Junior', 'Senior', '5th Year'], translation_key: 'ND::underclass_level' },
    { predicate: 'ND::expected_graduation_term', translation_key: 'ND::ulra.expected_graduation_term' },
    { predicate: 'ND::major', translation_key: 'ND::major' },
    { predicate: 'ND::minor', translation_key: 'ND::minor' },
    { predicate: 'ND::primary_college', translation_key: 'ND::primary_college', indexing_strategies: ['text'] }
  ]
}
```
