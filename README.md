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
```
curl --location --request GET 'http://localhost:3000/parse_xml' \
--header 'Content-Type: application/xml' \
--data-raw '<?xml version="1.0" encoding="UTF-8"?>
<Configuration>
    <Creatives>
        <Creative id="Video-1" price="6.4567" currency="EUR"/>
        <Creative id="Video-4" price="1.1234" currency="USD"/>
        <Creative id="Video-7" price="55.123" currency="SEK"/>
        <Creative id="Video-12" price="16.4567" currency="EUR"/>
        <Creative id="Video-25" price="9.4567" currency="USD"/>
    </Creatives>
    <Placements>
        <Placement id="plc-1" floor="1.3456" currency="EUR"/>
        <Placement id="plc-2" floor="90.234" currency="SEK"/>
        <Placement id="plc-3" floor="8.343" currency="TYR"/>
        <Placement id="plc-4" floor="20.56" currency="USD"/>
        <Placement id="plc-5" floor="27.9856" currency="EUR"/>
        <Placement id="plc-6" floor="22.5656" currency="SEK"/>
        <Placement id="plc-7" floor="0" currency="EUR"/>
        <Placement id="plc-8" floor="1.3456" currency="USD"/>
    </Placements>
</Configuration>'
```
