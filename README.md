# Ad Parameters
Ad Parameters is a simple API intended for accepting an XML-body with placements and creatives data, figure out which creatives can be put into which placements, depending on a creative price and a placement floor price, and print the result as a Protobuf message to STDOUT.

## Endpoints and features
**GET   /parse _xml** - the endpoint calling which a user can achieve the described above.

# Technical details
* Programming language: Ruby 3.1.2,
* Framework: Rails 6.0.5.1,
* Testing tool: Rspec,
* The Google protocol buffer compiler.

# How to run the app
 1. Clone the repository from GitHub / extract it from the archive.
 2. Navigate to the app folder.
 3. Make sure Ruby 3.1.2 are installed on your machine.
 4. Run in the command line a command 'bundle install'.
 8. Run 'bin/rails server'

## Request example
