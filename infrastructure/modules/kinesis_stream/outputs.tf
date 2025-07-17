output "kinesis_stream_id" {
  value = aws_kinesis_stream.this.id
}

output "kinesis_stream_arn" {
  value = aws_kinesis_stream.this.arn
}

output "kinesis_stream_name" {
  value = aws_kinesis_stream.this.name
}
