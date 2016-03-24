# Milan

[![Build Status](https://travis-ci.org/jeremyf/milan.png?branch=master)](https://travis-ci.org/jeremyf/milan)
[![Code Climate](https://codeclimate.com/github/jeremyf/milan.png)](https://codeclimate.com/github/jeremyf/milan)
[![Test Coverage](https://codeclimate.com/github/jeremyf/milan/badges/coverage.svg)](https://codeclimate.com/github/jeremyf/milan)
[![Dependency Status](https://gemnasium.com/jeremyf/milan.svg)](https://gemnasium.com/jeremyf/milan)
[![Documentation Status](http://inch-ci.org/github/jeremyf/milan.svg?branch=master)](http://inch-ci.org/github/jeremyf/milan)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)
[![Contributing Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

Modeling through configuration.

## Problems I am Attempting to Address via Milan

As we have been working on workflows and data modeling, we've encountered some problems that keep showing up:

* Consistency and variation of labels for input fields
* The label for input varies from the label for "showing" the object
* Repetitious Form objects that have a very similar structure
* Documenting an API for programatic interaction
* A nuanced conflict with SimpleForm and ActiveRecord translations when breaking apart a single concept into constituent parts

In essence, we've encountered the need for a Data Dictionary; But one that we can leverage in building our applications.

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
      form: "plan_of_study",
      contracts: [{
        contexts: ['submit'],
        validations: [
          { key: 'ND::expected_graduation_term', required: true, inclusion: ["Summer 2016", "Fall 2016"] },
          { key: 'ND::underclass_level', required: true, inclusion: "ND::underclass_level/options" },
          { key: 'ND::major', required: true, inclusion: "https://nd.edu/api/majors.json" },
          { key: 'ND::primary_college', required: true }
        ]
      }],
      predicates: [
        { predicate: 'ND::expected_graduation_term' },
        { predicate: 'ND::underclass_level' },
        { predicate: 'ND::major' },
        { predicate: 'ND::minor' },
        { predicate: 'ND::primary_college' }
      ]
    }, {
      form: "description",
      contracts: [{
        contexts: ['submit'],
        validations: [
          { key: 'DC::title', required: true }
        ]
      }],
      predicates: [
        { predicate: 'DC::title' },
      ]
    }],
    display: [{
      regions: [
        { region: "description", predicates: [ { predicate: 'DC::title' } ] },
        { region: "plan_of_study", using_form: 'plan_of_study' }
      ]
    }]
  }],
  predicates: [
    { predicate: 'DC::title', type: 'String' },
    { predicate: 'ND::underclass_level', options: ['First Year', 'Sophomore', 'Junior', 'Senior', '5th Year'], translation_key_fragment: 'ND::underclass_level' },
    { predicate: 'ND::expected_graduation_term', translation_key_fragment: 'ND::ulra.expected_graduation_term' },
    { predicate: 'ND::major', translation_key_fragment: 'ND::major' },
    { predicate: 'ND::minor', translation_key_fragment: 'ND::minor' },
    { predicate: 'ND::primary_college', translation_key_fragment: 'ND::primary_college', indexing_strategies: ['text'] }
  ]
}
```

Another key consideration is thinking about the translations. It gets rather gnarly but providing proper guidance is vital. I'm looking at what it means to keep things "close"; The translation_key_fragment is one aspect of keeping translations close. The second is contexts for reasonable fallback.

```ruby
en:
  predicates:
    dc_title:
      ulra:
        label:
        hint:
      label:
      hint:
      form:
        label:
        hint:
      display:
        label:
        hint:
```

## Roadmap

### Form concerns

- [ ] Rendering
  - [ ] Render input fields in predictable order
  - [ ] Leverage translations for label and hints
  - [ ] Each field can render via SimpleForm parameters
- [ ] Attributes
  - [x] Existing predicates and corresponding values are accessible
  - [ ] Keep the intersection of user given terms and available predicates
- [ ] Validation
  - [ ] Validate predicate values
    - [x] Required
- [ ] Submission
  - [ ] Pass the resulting data structure to a repository layer

### Display concerns

- [ ] Rendering
  - [ ] Render regions and predicates in predictable order
  - [ ] Leverage translations for label and hints

### Type Coercion

- [ ] Apply coercion to the form and display object when the attributes are loaded from the buffer
