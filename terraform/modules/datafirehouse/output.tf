output "ngem_api_data_firehouse_name" {
  value = [ aws_kinesis_firehose_delivery_stream.dynatrace_stream.name ]
}
