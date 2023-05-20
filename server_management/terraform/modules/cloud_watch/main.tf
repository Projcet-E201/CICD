variable "instance_ids" { type = list(string) }
variable "alarm_name_prefix" { type = string }
variable "sns_topic_arn" { type = string }

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  for_each = { for idx, id in var.instance_ids : idx => id }

  alarm_name = "${var.alarm_name_prefix}-${each.key + 1} CPU 65% OVER!!"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "65"
  alarm_description = "This metric checks cpu usage"
  alarm_actions = [var.sns_topic_arn]
  dimensions = {
    InstanceId = each.value
  }
}