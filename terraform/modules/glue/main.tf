resource "aws_glue_registry" "ngem_glue_registry" {
  registry_name = var.registry_name
  description   = "${var.registry_name} is deployed"
  tags          = var.tags
}

resource "aws_glue_schema" "ngem_glue_schema" {
  schema_name    = var.schema_name
  registry_arn   = aws_glue_registry.ngem_glue_registry.arn
  data_format    = "JSON"
  compatibility  = "NONE"
  schema_definition = <<EOF
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://nextgen.com/schemas/SampleEvent.json",
  "title": "Sample Event",
  "description": "Defines the data contract for the SampleEvent message.",
  "type": "object",
  "properties": {
    "MessageId": {
      "description": "A unique identifier for the message.",
      "type": "string",
      "format": "uuid"
    },
    "CorrelationId": {
      "description": "Identifier used to correlate related messages.",
      "type": "string",
      "format": "uuid"
    },
    "SampleData": {
      "description": "Optional sample data value.",
      "type": "string",
      "maxLength": 1000,
      "nullable": true
    },
    "SampleValue": {
      "description": "A numerical sample value.",
      "type": "integer"
    }
  },
  "required": ["MessageId", "CorrelationId", "SampleValue"],
  "additionalProperties": false
}
EOF
  tags = var.tags
  lifecycle {
    ignore_changes = [schema_definition]
  }
}
