# Milan

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
          { validates: 'ND.expected_graduation_term', presence: true, inclusion: "ND.expected_graduation_term/options" },
          { validates: 'ND.underclass_level', presence: true, inclusion: "ND.underclass_level/options" },
          { validates: 'ND.major', presence: true },
          { validates: 'ND.primary_college', presence: true, cardinality: 1 }
        ]
      }],
      terms: [
        { term: 'ND.expected_graduation_term', cardinality: 1 },
        { term: 'ND.underclass_level' },
        { term: 'ND.major', cardinality: 'many' },
        { term: 'ND.minor', cardinality: 'many' },
        { term: 'ND.primary_college', cardinality: 1 }
      ]
    }],
    terms: [{
      term: 'ND.primary_college', cardinality: 1,
      label: 'Primary College'
    }]
  }],
  terms: [{
    term: 'ND.underclass_level', options: ['First Year', 'Sophomore', 'Junior', 'Senior', '5th Year'], cardinality: 1
  }]
}
```
