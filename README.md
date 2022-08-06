# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
Request example.

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
