# Burner

[![Gem Version](https://badge.fury.io/rb/burner.svg)](https://badge.fury.io/rb/burner) [![Build Status](https://travis-ci.org/bluemarblepayroll/burner.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/burner) [![Maintainability](https://api.codeclimate.com/v1/badges/dbc3757929b67504f6ca/maintainability)](https://codeclimate.com/github/bluemarblepayroll/burner/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/dbc3757929b67504f6ca/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/burner/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This library serves as the skeleton for a processing engine.  It allows you to organize your code into Jobs, then stitch those jobs together as steps.

## Installation

To install through Rubygems:

````bash
gem install burner
````

You can also add this to your Gemfile:

````bash
bundle add burner
````

## Examples

The purpose of this library is to provide a framework for creating highly de-coupled functions (known as jobs), and then allow for the stitching of them back together in any arbitrary order (know as steps.)  Although our example will be somewhat specific and contrived, the only limit to what the jobs and order of jobs are is up to your imagination.

### JSON-to-YAML File Converter

All the jobs for this example are shipped with this library.  In this example, we will write a pipeline that can read a JSON file and convert it to YAML.  Pipelines are data-first so we can represent a pipeline using a hash:

````ruby
pipeline = {
  jobs: [
    {
      name: :read,
      type: 'io/read',
      path: '{input_file}'
    },
    {
      name: :output_id,
      type: :echo,
      message: 'The job id is: {__id}'
    },
    {
      name: :output_value,
      type: :echo,
      message: 'The current value is: {__value}'
    },
    {
      name: :parse,
      type: 'deserialize/json'
    },
    {
      name: :convert,
      type: 'serialize/yaml'
    },
    {
      name: :write,
      type: 'io/write',
      path: '{output_file}'
    }
  ],
  steps: %i[
    read
    output_id
    output_value
    parse
    convert
    output_value
    write
  ]
}

params = {
  input_file: 'input.json',
  output_file: 'output.yaml'
}
````

Assuming we are running this script from a directory where an `input.json` file exists, we can then programatically process the pipeline:

````ruby
Burner::Pipeline.make(pipeline).execute(params: params)
````

We should now see a output.yaml file created.

Some notes:

* Some values are able to be string-interpolated using the provided params.  This allows for the passing runtime configuration/data into pipelines/jobs.
* The job's ID can be accessed using the `__id` key.
* The current job's payload value can be accessed using the `__value` key.
* Jobs can be re-used (just like the output_id and output_value jobs).

### Capturing Feedback / Output

By default, output will be emitted to `$stdout`.  You can add or change listeners by passing in optional values into Pipeline#execute.  For example, say we wanted to capture the output from our json-to-yaml example:

````ruby
class StringOut
  def initialize
    @io = StringIO.new
  end

  def puts(msg)
    tap { io.write("#{msg}\n") }
  end

  def read
    io.rewind
    io.read
  end

  private

  attr_reader :io
end

string_out = StringOut.new
output     = Burner::Output.new(outs: string_out)

Burner::Pipeline.make(pipeline).execute(output: output, params: params)

log = string_out.read
````

The value of `log` should now look similar to:

````bash
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] Pipeline started with 7 step(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] Parameters:
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - input_file: input.json
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - output_file: output.yaml
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] --------------------------------------------------------------------------------
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] [1] Burner::Jobs::IO::Read::read
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Reading: spec/fixtures/input.json
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Completed in: 0.0 second(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] [2] Burner::Jobs::Echo::output_id
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - The job id is:
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Completed in: 0.0 second(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] [3] Burner::Jobs::Echo::output_value
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - The current value is:
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Completed in: 0.0 second(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] [4] Burner::Jobs::Deserialize::Json::parse
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Completed in: 0.0 second(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] [5] Burner::Jobs::Serialize::Yaml::convert
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Completed in: 0.0 second(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] [6] Burner::Jobs::Echo::output_value
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - The current value is:
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Completed in: 0.0 second(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] [7] Burner::Jobs::IO::Write::write
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Writing: output.yaml
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC]   - Completed in: 0.0 second(s)
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] --------------------------------------------------------------------------------
[8bdc394e-7047-4a1a-87ed-6c54ed690ed5 | 2020-10-14 13:49:59 UTC] Pipeline ended, took 0.001 second(s) to complete
````

Notes:

* The Job ID is specified as the leading UUID in each line.
* `outs` can be provided an array of listeners, as long as each listener responds to `puts(msg)`.

### Command Line Pipeline Processing

This library also ships with a built-in script `exe/burner` that illustrates using the `Burner::Cli` API.  This class can take in an array of arguments (similar to a command-line) and execute a pipeline.  The first argument is the path to a YAML file with the pipeline's configuration and each subsequent argument is a param in `key=value` form.  Here is how the json-to-yaml example can utilize this interface:

#### Create YAML Pipeline Configuration File

Write the following json_to_yaml_pipeline.yaml file to disk:

````yaml
jobs:
  - name: read
    type: io/read
    path: '{input_file}'

  - name: output_id
    type: echo
    message: 'The job id is: {__id}'

  - name: output_value
    type: echo
    message: 'The current value is: {__value}'

  - name: parse
    type: deserialize/json

  - name: convert
    type: serialize/yaml

  - name: write
    type: io/write
    path: '{output_file}'

steps:
  - read
  - output_id
  - output_value
  - parse
  - convert
  - output_value
  - write
````

#### Run Using Script

From the command-line, run:

````bash
bundle exec burner json_to_yaml_pipeline.yaml input_file=input.json output_file=output.yaml
````

The pipeline should be processed and output.yaml should be created.

#### Run Using Programmatic API

Instead of the script, you can invoke it using code:

````ruby
args = %w[
  json_to_yaml_pipeline.yaml
  input_file=input.json
  output_file=output.yaml
]

Burner::Cli.new(args).invoke
````

### Core Job Library

This library only ships with very basic, rudimentary jobs that are meant to just serve as a baseline:

#### Collection

* **collection/arrays_to_objects** [mappings]: Convert an array of arrays to an array of objects.
* **collection/objects_to_arrays** [mappings]: Convert an array of objects to an array of arrays.
* **collection/shift** [amount]: Remove the first N number of elements from an array.

#### De-serialization

* **deserialize/csv** []: Take a CSV string and de-serialize into object(s).  Currently it will return an array of arrays, with each nested array representing one row.
* **deserialize/json** []: Treat input as a string and de-serialize it to JSON.
* **deserialize/yaml** [safe]: Treat input as a string and de-serialize it to YAML.  By default it will try and (safely de-serialize)[https://ruby-doc.org/stdlib-2.6.1/libdoc/psych/rdoc/Psych.html#method-c-safe_load] it (only using core classes).  If you wish to de-serialize it to any class type, pass in `safe: false`

#### IO

* **io/exist** [path, short_circuit]: Check to see if a file exists. The path parameter can be interpolated using params.  If short_circuit was set to true (defaults to false) and the file does not exist then the pipeline will be short-circuited.
* **io/read** [binary, path]: Read in a local file.  The path parameter can be interpolated using params.  If the contents are binary, pass in `binary: true` to open it up in binary+read mode.
* **io/write** [binary, path]: Write to a local file.  The path parameter can be interpolated using params.  If the contents are binary, pass in `binary: true` to open it up in binary+write mode.

#### Serialization

* **serialize/csv** []: Take an array of arrays and create a CSV.
* **serialize/json** []: Convert value to JSON.
* **serialize/yaml** []: Convert value to YAML.

#### General

* **dummy** []: Do nothing
* **echo** [message]: Write a message to the output.  The message parameter can be interpolated using params.
* **set** [value]: Set the value to any arbitrary value.
* **sleep** [seconds]: Sleep the thread for X number of seconds.


### Adding & Registering Jobs

Where this library shines is when additional jobs are plugged in.  Burner uses its `Burner::Jobs` class as its class-level registry built with (acts_as_hashable)[https://github.com/bluemarblepayroll/acts_as_hashable]'s acts_as_hashable_factory directive.

Let's say we would like to register a job to parse a CSV:

````ruby
class ParseCsv < Burner::Job
  def perform(output, payload, params)
    payload.value = CSV.parse(payload.value, headers: true).map(&:to_h)

    nil
  end
end

Burner::Jobs.register('parse_csv', ParseCsv)
````

`parse_csv` is now recognized as a valid job and we can use it:

````ruby
pipeline = {
  jobs: [
    {
      name: :read,
      type: 'io/read',
      path: '{input_file}'
    },
    {
      name: :output_id,
      type: :echo,
      message: 'The job id is: {__id}'
    },
    {
      name: :output_value,
      type: :echo,
      message: 'The current value is: {__value}'
    },
    {
      name: :parse,
      type: :parse_csv
    },
    {
      name: :convert,
      type: 'serialize/yaml'
    },
    {
      name: :write,
      type: 'io/write',
      path: '{output_file}'
    }
  ],
  steps: %i[
    read
    output_id
    output_value
    parse
    convert
    output_value
    write
  ]
}

params = {
  input_file: File.join('spec', 'fixtures', 'cars.csv'),
  output_file: File.join(TEMP_DIR, "#{SecureRandom.uuid}.yaml")
}

Burner::Pipeline.make(pipeline).execute(output: output, params: params)
````

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check burner.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/burner.git)
4. Navigate to the root folder (cd burner)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````bash
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````bash
bundle exec guard
````

Also, do not forget to run Rubocop:

````bash
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update `lib/burner/version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in this codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bluemarblepayroll/burner/blob/master/CODE_OF_CONDUCT.md).

## License

This project is MIT Licensed.
