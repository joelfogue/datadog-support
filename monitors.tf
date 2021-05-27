locals {
  monitors = csvdecode(file("${path.module}/monitors.csv"))
}

# LOG ALERTS

resource "datadog_monitor" "log_alerts" {
  for_each = { for monitor in local.monitors : monitor.local_id => monitor if monitor.alert_type == "log"}
  name               = join("",[each.value.resource_name," ",each.value.monitor_text," (",each.value.env,")"])
  type               = "log alert"
  message            = <<EOF

{{#is_alert}}

To fix, follow these steps:
${each.value.remediation_steps}

${each.value.tier == "1" ? var.tier1_alert_notification : ""}

{{/is_alert}}

{{#is_recovery}}
Error log levels are back to acceptable limits.
${each.value.tier == "1" ? var.tier1_alert_resolve_notification : ""}
{{/is_recovery}}

Notify: ${each.value.notification}

  EOF

  escalation_message = var.escalation_message
  query = tostring(each.value.query)
  
  thresholds = {
    critical          = each.value.critical_threshold
    warning           = each.value.warning_threshold
  }

  renotify_interval = var.renotify_interval
  timeout_h         = var.timeout_h

  notify_no_data    = false
  notify_audit      = false
  include_tags      = true

  silenced = {
    "*" = tonumber(each.value.silenced) # Use 0 to mute, -1 to unmute
  }

  tags = ["qp-team:${each.value.qp_team}","env:${each.value.env}","service:${each.value.service}","tier:${each.value.tier}"]
}


# LATENCY METRIC ALERTS

resource "datadog_monitor" "latency_metric_alerts" {
  for_each = { for monitor in local.monitors : monitor.local_id => monitor if monitor.alert_type == "duration_metric"}
  name               = join("",[each.value.resource_name," ",each.value.monitor_text," (",each.value.env,")"])
  type               = "metric alert"
  message            = <<EOF

{{#is_alert}}
The average duration for {{functionname}} is {{value}}ms which is greater than the {{threshold}}ms alert threshold.

To fix, follow these steps:
${each.value.remediation_steps}

${each.value.tier == "1" ? var.tier1_alert_notification : ""}
{{/is_alert}}

{{#is_warning}}
The average duration for {{functionname}} is {{value}}ms which is greater than the {{warn_threshold}}ms warning threshold.
{{/is_warning}}

{{#is_recovery}}
The average duration for {{functionname}} is back to acceptable limits.
${each.value.tier == "1" ? var.tier1_alert_resolve_notification : ""}
{{/is_recovery}}

Notify: ${each.value.notification}

  EOF

  escalation_message = var.escalation_message
  query = tostring(each.value.query)
  
  thresholds = {
    critical          = each.value.critical_threshold
    warning           = each.value.warning_threshold
    warning_recovery  = each.value.warning_recovery_threshold #only applicable for metric alerts
    critical_recovery = each.value.critical_recovery_threshold #only applicable for metric alerts
  }

  renotify_interval = var.renotify_interval
  timeout_h         = var.timeout_h

  notify_no_data    = false
  notify_audit      = false
  include_tags      = true

  require_full_window = false
  evaluation_delay    = 900

  silenced = {
    "*" = tonumber(each.value.silenced) # Use 0 to mute, -1 to unmute
  }

  tags = ["qp-team:${each.value.qp_team}","env:${each.value.env}","service:${each.value.service}","tier:${each.value.tier}"]
}

# EVENT ALERT

resource "datadog_monitor" "event_alerts" {

  for_each = { for monitor in local.monitors : monitor.local_id => monitor if monitor.alert_type == "event"}
  name               = join("",[each.value.monitor_text," (",each.value.env,")"])

  type               = "event alert"
  message            = <<EOF

{{#is_alert}}
{{event.title}} in Alert

To fix, follow these steps:
${each.value.remediation_steps}

${each.value.tier == "1" ? var.tier1_alert_notification : ""}
{{/is_alert}}

{{#is_warning}}
{{event.title}} in Warning
The number of alerts is {{value}} which is greater than the {{warn_threshold}} warning threshold.
{{/is_warning}}

{{#is_recovery}}
{{event.title}} Recovered
The number of alerts is back within acceptable limits ({{ok_threshold}}).
${each.value.tier == "1" ? var.tier1_alert_resolve_notification : ""}
{{/is_recovery}}

Notify: ${each.value.notification}

  EOF

  escalation_message = var.escalation_message
  query = tostring(each.value.query) 

  renotify_interval = var.renotify_interval
  timeout_h         = var.timeout_h

  notify_no_data    = false
  notify_audit      = false
  include_tags      = true

  silenced = {
    "*" = tonumber(each.value.silenced) # Use 0 to mute, -1 to unmute
  }

  tags = ["qp-team:${each.value.qp_team}","env:${each.value.env}","service:${each.value.service}","tier:${each.value.tier}"]
}